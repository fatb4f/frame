---
name: repo-search
description: Use repo-rg for bounded repository text search. Trigger when exact code, config, symbols, strings, or filenames are needed. Do not use ad hoc find/grep crawling.
---

# Repo Search Skill

## Contract

Use `repo-rg` as the text-search adapter.

Default to literal search.
Use regex only when explicitly useful.
Keep output bounded.

## Commands

```sh
repo-rg 'literal text' . literal 80
repo-rg 'regex_pattern' . regex 80
```

## Policy

1. Prefer current git root.
2. Do not search from `$HOME`.
3. Do not search `/`.
4. Stop after relevant hits.
5. Emit JSON when feeding CUE.
6. Use search evidence as observation, not policy.
