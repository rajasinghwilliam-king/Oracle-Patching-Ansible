import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "filter_plugins"))

from oracle_filters import FilterModule, parse_sql_kv


def test_parses_multiple_pipe_fields():
    assert parse_sql_kv(["DB_STATE|READ WRITE|PRIMARY|ARCHIVELOG"]) == {
        "DB_STATE": ["READ WRITE", "PRIMARY", "ARCHIVELOG"]
    }


def test_ignores_banners_and_unrecognized_lines():
    assert parse_sql_kv(["SQL*Plus: Release 19", "not a key", "DB_STATE|OPEN"]) == {
        "DB_STATE": ["OPEN"]
    }


def test_preserves_empty_values():
    assert parse_sql_kv(["INSTANCE|OPEN|"]) == {"INSTANCE": ["OPEN", ""]}


def test_later_duplicate_key_overwrites_earlier_value():
    assert parse_sql_kv(["ACTIVE_SESSIONS|2", "ACTIVE_SESSIONS|4"]) == {
        "ACTIVE_SESSIONS": ["4"]
    }


def test_none_returns_empty_mapping():
    assert parse_sql_kv(None) == {}


def test_filter_module_registers_parser():
    assert FilterModule().filters()["parse_sql_kv"] is parse_sql_kv