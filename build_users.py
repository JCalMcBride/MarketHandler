import asyncio

from market_engine.modules import MarketData


# Used to build user table in database for use in MarketUser class allowing for non case-sensitive usernames
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
