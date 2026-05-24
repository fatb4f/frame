---
name: rg
description: Use when searching source files or listing searchable files through the configured ripgrep MCP server.
metadata:
  short-description: Source search via ripgrep MCP
---

# Rg

Use the configured ripgrep MCP server for source search and file listing.

## Required Surface

- Use `mcp__mcp_ripgrep__` for source search and searchable file listing.
- Use `mcp__ripgrep__` only when the primary ripgrep MCP surface is unavailable or lacks the needed list operation.
- Do not use shell `rg` for agent source observations when an MCP ripgrep tool covers the operation.
- If the ripgrep MCP surface is unavailable or insufficient, report that blocker instead of falling back to shell search.

## Workflow

1. List candidate files with `mcp__mcp_ripgrep__.list_files` when file shape matters.
2. Search with `mcp__mcp_ripgrep__.search`, keeping `path`, `pattern`, and `filePattern` scoped to the task.
3. Use small context windows and targeted follow-up reads after locating relevant files.

Prefer structured, narrow searches over broad scans.
