#!/usr/bin/env python3
"""Validate tree-sitter query files against the pinned grammar.

Every named node type referenced in languages/**/*.scm must exist in the
grammar's node-types.json at the revision pinned in extension.toml. A query
that references a non-existent node type (e.g. `simple_command` when the bash
grammar calls it `command`) fails to compile in Zed and silently disables the
entire query file — this check catches that before release.

No third-party dependencies; uses only the standard library.

Exit codes: 0 = all references valid, 1 = unknown node type(s) found.
"""

from __future__ import annotations

import json
import re
import sys
import tomllib
import urllib.request
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
EXTENSION_TOML = REPO_ROOT / "extension.toml"
QUERY_DIR = REPO_ROOT / "languages"

# Node patterns are `(node_type ...)`; named node types start lowercase or `_`.
_NODE_REF_RE = re.compile(r"\(\s*([a-z_][A-Za-z0-9_]*)")
# Double-quoted anonymous nodes / predicate strings — stripped before scanning
# so regex alternations like "^(Describe|...)" are not mistaken for node types.
_DQ_STRING_RE = re.compile(r'"(?:\\.|[^"\\])*"')


def grammar_node_types() -> set[str]:
    with EXTENSION_TOML.open("rb") as fh:
        manifest = tomllib.load(fh)
    grammars = manifest.get("grammars", {})
    if not grammars:
        sys.exit("error: no [grammars.*] table in extension.toml")
    # This extension ships a single grammar; take the first.
    name, spec = next(iter(grammars.items()))
    repo = spec["repository"].rstrip("/").removesuffix(".git")
    rev = spec["rev"]
    owner_repo = "/".join(repo.split("/")[-2:])
    url = f"https://raw.githubusercontent.com/{owner_repo}/{rev}/src/node-types.json"
    print(f"grammar '{name}': {owner_repo}@{rev[:12]}")
    with urllib.request.urlopen(url, timeout=30) as resp:  # noqa: S310 (pinned host)
        data = json.load(resp)

    types: set[str] = {"_"}  # `(_)` wildcard matches any node

    def walk(obj: object) -> None:
        if isinstance(obj, dict):
            t = obj.get("type")
            if isinstance(t, str):
                types.add(t)
            for value in obj.values():
                walk(value)
        elif isinstance(obj, list):
            for item in obj:
                walk(item)

    walk(data)
    return types


def referenced_node_types(text: str) -> set[str]:
    refs: set[str] = set()
    for raw_line in text.splitlines():
        line = _DQ_STRING_RE.sub('""', raw_line)
        line = line.split(";", 1)[0]  # strip line comments
        refs.update(_NODE_REF_RE.findall(line))
    return refs


def main() -> int:
    valid = grammar_node_types()
    query_files = sorted(QUERY_DIR.rglob("*.scm"))
    if not query_files:
        print("no .scm files found")
        return 0

    errors = 0
    for qf in query_files:
        unknown = sorted(referenced_node_types(qf.read_text()) - valid)
        rel = qf.relative_to(REPO_ROOT)
        if unknown:
            errors += len(unknown)
            for name in unknown:
                print(f"  ERROR  {rel}: unknown node type '{name}'")
        else:
            print(f"  OK     {rel}")

    if errors:
        print(f"\n{errors} unknown node type reference(s).")
        return 1
    print(f"\nAll {len(query_files)} query file(s) reference valid node types.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
