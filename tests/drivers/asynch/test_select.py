from sqlalchemy import Column

from clickhouse_sqlalchemy import Table, engines, types
from tests.session import mocked_engine
from tests.testcase import AsynchSessionTestCase


class SanityTestCase(AsynchSessionTestCase):
    async def test_sanity(self):
        with mocked_engine(self.session) as engine:
            metadata = self.metadata()
            Table(
                "t1",
                metadata,
                Column("x", types.Int32, primary_key=True),
                engines.Memory(),
            )

            prev_has_table = engine.dialect_cls.has_table
            engine.dialect_cls.has_table = lambda *args, **kwargs: True

            await self.run_sync(metadata.drop_all)

            self.assertEqual(engine.history, ["DROP TABLE t1"])

            engine.dialect_cls.has_table = prev_has_table
