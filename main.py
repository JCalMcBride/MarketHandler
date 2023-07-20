import argparse
import asyncio
import json
import os

from market_engine import common
from market_engine.modules import MarketAPI, MarketDB


async def main(args, config):
    if args.clear:
        await common.clear_cache()

    items, item_ids, item_info, manifest_dict = None, None, None, None
    if args.fetch is not None:
        manifest_dict = await MarketAPI.get_manifest()
        if args.fetch == "NEW":
            items, item_ids = await MarketAPI.fetch_and_save_items_and_ids()
            price_history_dict, item_info = await MarketAPI.fetch_and_save_statistics(items, item_ids)
        else:
            items, item_ids, item_info = await MarketAPI.fetch_premade_item_data()
            await MarketAPI.fetch_premade_statistics(item_ids)

    connection = MarketDB.connect_to_database(
        user=config['user'],
        password=config['password'],
        host=config['host'],
        database=config['database']
    )

    if args.build:
        with open("build.sql", "r") as f:
            sql = f.read()

        for sql in sql.split(";"):
            if sql.strip() != "":
                connection.cursor().execute(sql)

    if args.database is not None:
        MarketDB.save_items(connection, items, item_ids, item_info)
        MarketDB.save_items_in_set(connection, item_info)
        MarketDB.save_item_tags(connection, item_info)
        MarketDB.save_item_subtypes(connection, item_info)
        MarketDB.build_and_save_category_info(connection, manifest_dict)

        last_save_date = MarketDB.get_last_saved_date(connection, args.database)

        MarketDB.insert_item_statistics(connection, last_save_date)

        MarketDB.commit_data(connection)


def parse_handler():
    parser = argparse.ArgumentParser(description="Fetch and process Warframe Market price history.")
    parser.add_argument("-l", "--log-level", choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"],
                        help="Set the log level.")
    parser.add_argument("-f", "--fetch", choices=["PREMADE", "NEW"],
                        help="Fetch and process price history from the API."
                             "\nPREMADE: Fetch premade data from relics.run."
                             "\nNEW: Fetch data directly from warframe.market.")
    parser.add_argument("-d", "--database", choices=["ALL", "NEW"],
                        help="Save all price history to the database.\n"
                             "ALL: Save all price history to the database.\n"
                             "NEW: Save only new price history to the database.")
    parser.add_argument("-b", "--build", action="store_true",
                        help="Build the database.")
    parser.add_argument("-c", "--clear", action="store_true",
                        help="Clears the cache.")

    args = parser.parse_args()

    if os.path.exists("config.json"):
        with open("config.json", "r") as f:
            config = json.load(f)
    else:
        print("No config file found.")
        return

    if args.log_level:
        common.logger.setLevel(args.log_level)

    asyncio.run(main(args, config))


if __name__ == "__main__":
    parse_handler()
