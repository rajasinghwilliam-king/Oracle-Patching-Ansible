import re


_SQL_KV_PATTERN = re.compile(r"^([A-Z][A-Z0-9_]*)\|(.*)$")


def parse_sql_kv(lines):
    parsed = {}
    if lines is None:
        return parsed
    for line in lines:
        match = _SQL_KV_PATTERN.match(str(line).strip())
        if match:
            parsed[match.group(1)] = match.group(2).split("|")
    return parsed


class FilterModule:
    def filters(self):
        return {"parse_sql_kv": parse_sql_kv}