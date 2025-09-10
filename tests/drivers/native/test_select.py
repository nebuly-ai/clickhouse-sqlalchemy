from sqlalchemy import Column

from clickhouse_sqlalchemy import Table, engines, types
from tests.session import mocked_engine
from tests.testcase import NativeSessionTestCase


class SanityTestCase(NativeSessionTestCase):
    def test_sanity(self):
        with mocked_engine(self.session) as engine:
            table = Table(
                "t1",
                self.metadata(),
                Column("x", types.Int32, primary_key=True),
                engines.Memory(),
            )
            table.drop(bind=engine.session.bind, if_exists=True)
            self.assertEqual(engine.history, ["DROP TABLE IF EXISTS t1"])
