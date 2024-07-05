import argparse
import asyncio
import json
import os

import pymysql
from market_engine import Common, ManifestParser
from market_engine.API import MarketAPI, RelicsRunAPI
from market_engine.API.ManifestAPI import get_manifest
from market_engine.Common import session_manager, cache_manager, logger
from market_engine.Models.MarketDatabase import MarketDatabase
from pymysql import OperationalError


async def main(args, config):
    if args.platform == "all":
        args.platform = ["pc", "ps4", "xbox", "switch"]
    else:
        args.platform = [args.platform]

    for platform in args.platform:
        logger.info(f"Fetching data for {platform}.")
        async with session_manager() as session, cache_manager() as cache:
            if args.clear:
                logger.info("Clearing cache.")
                cache.flushall()

            # Stores data from the API, whether fetched or prefetched from relics.run
            items, item_ids, item_info, manifest_dict = None, None, None, None
            if args.fetch is not None:
                manifest_dict = await get_manifest(cache=cache, session=session)
                items = await MarketAPI.fetch_items_from_warframe_market(cache=cache,
                                                                         session=session)
                item_ids = MarketAPI.build_item_ids(items)
                if args.fetch == "MARKET":
                    statistic_history_dict, item_info = \
                        await MarketAPI.fetch_statistics_from_warframe_market(cache=cache,
                                                                              session=session,
                                                                              platform=platform,
                                                                              items=items,
                                                                              item_ids=item_ids)
                    MarketAPI.save_statistic_history(statistic_history_dict, platform=platform)

                    MarketAPI.save_item_data(items, item_ids, item_info)
                elif args.fetch == "RELICSRUN":
                    fetch = True
                    while fetch:
                        date_list = await RelicsRunAPI.get_dates_to_fetch(cache=cache,
                                                                          session=session,
                                                                          platform=platform)

                        if len(date_list) == 0:
                            fetch = False
                            continue

                        await RelicsRunAPI.fetch_statistics_from_relics_run(cache=cache,
                                                                            session=session,
                                                                            item_ids=item_ids,
                                                                            date_list=date_list,
                                                                            platform=platform)

                    items, item_ids, item_info, _ = await RelicsRunAPI.fetch_item_data_from_relics_run(cache=cache,
                                                                                                       session=session)

        market_db = None
        if args.build or args.database is not None:
            # Connects to the database
            try:
                market_db = MarketDatabase(user=config['user'],
                                           password=config['password'],
                                           host=config['host'],
                                           database=config['database'])
            except OperationalError:
                with pymysql.connect(user=config['user'],
                                     password=config['password'],
                                     host=config['host']) as connection:
                    with connection.cursor() as cursor:
                        cursor.execute(f"create database if not exists market;")

                market_db = MarketDatabase(user=config['user'],
                                           password=config['password'],
                                           host=config['host'],
                                           database=config['database'])

        # Builds the database if specified
        if args.build:
            with open("build.sql", "r") as f:
                sql = f.read()

            for sql in sql.split(";"):
                if sql.strip() != "":
                    market_db.execute_query(sql)

        if args.database is not None or args.manfiest:
            if manifest_dict is None:
                manifest_dict = await get_manifest(cache=cache, session=session)

            wf_parser = await ManifestParser.build_parser(manifest_dict)

            if args.manfiest:
                os.makedirs(config['manifest_dir'], exist_ok=True)

                for key in manifest_dict:
                    with open(f"{config['manifest_dir']}/{key}.json", "w") as f:
                        json.dump(manifest_dict[key], f, indent=4)

                with open(f"{config['manifest_dir']}/parser.json", "w") as f:
                    json.dump(wf_parser, f, indent=4)

            if args.database is not None:
                market_db.save_items(items, item_ids, item_info)
                market_db.save_items_in_set(item_info)
                market_db.save_item_tags(item_info)
                market_db.save_item_subtypes(item_info)

                item_categories = ManifestParser.get_wfm_item_categorized(item_ids, manifest_dict, wf_parser)
                market_db.save_item_categories(item_categories)

                # Set to either the most recent date in the database or set to None if args.database == "ALL"
                last_save_date = None
                if args.database == "NEW":
                    last_save_date = market_db.get_most_recent_statistic_date(platform=platform)

                market_db.insert_item_statistics(last_save_date, platform=platform)


def parse_handler():
    parser = argparse.ArgumentParser(description="Fetch and process Warframe Market price history.")
    parser.add_argument("-l", "--log-level", choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"],
                        help="Set the log level.")
    parser.add_argument("-f", "--fetch", choices=["MARKET", "RELICSRUN"],
                        help="Fetch and process price history from the API."
                             "\nRELICSRUN: Fetch cached data from relics.run."
                             "\nMARKET: Fetch data directly from warframe.market.")
    parser.add_argument("-d", "--database", choices=["ALL", "NEW"],
                        help="Save all price history to the database.\n"
                             "ALL: Save all price history to the database.\n"
                             "NEW: Save only new price history to the database.")
    parser.add_argument("-b", "--build", action="store_true",
                        help="Build the database.")
    parser.add_argument("-c", "--clear", action="store_true",
                        help="Clears the cache.")
    parser.add_argument("-p", "--platform", choices=["pc", "ps4", "xbox", "switch", "all"],
                        help="Set the platform to fetch data from.",
                        default="pc")
    parser.add_argument("-m", "--manfiest", action="store_true",
                        help="Whether to save the manifest related files.")

    args = parser.parse_args()

    if os.path.exists("config.json"):
        with open("config.json", "r") as f:
            config = json.load(f)
    else:
        print("No config file found.")
        return

    if args.log_level:
        Common.logger.setLevel(args.log_level)

    asyncio.run(main(args, config))


if __name__ == "__main__":
    parse_handler()
