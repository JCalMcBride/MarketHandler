import asyncio
from asyncio import sleep

from market_engine.modules import MarketDB, MarketData, MarketAPI
from market_engine.modules.MarketData import MarketItem


async def main():
    market_db = MarketData.MarketDatabase(
        user='market',
        password='38NwWvkvZXiWV3',
        host='localhost',
        database='market'
    )

    for item in market_db.all_items:
        await market_db.get_item(item['item_name'])
        market_db.update_usernames()

if __name__ == "__main__":
    asyncio.run(main())
