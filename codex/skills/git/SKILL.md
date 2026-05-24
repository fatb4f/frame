---
name: git
description: Use when inspecting or changing Git repository state through the configured Git MCP server, including status, diffs, staging, and commits.
metadata:
  short-description: Git repository work via MCP
---

# Git

Use the configured Git MCP server for repository observations and mutations.

## Required Surface

- Use `mcp__git_mcp_server__` for Git status, diffs, staging, and commits.
- Do not use shell `git` for agent observations or repository mutation when an MCP Git tool covers the operation.
- If the Git MCP surface is unavailable or lacks the required operation, report that blocker instead of falling back to shell Git.

## Workflow

1. Inspect repository state with `mcp__git_mcp_server__.git_status`.
2. Inspect intended changes with `mcp__git_mcp_server__.git_diff`.
3. Stage only requested files with `mcp__git_mcp_server__.git_add`.
4. Re-check staged content when a staged diff tool is available.
5. Commit with `mcp__git_mcp_server__.git_commit` only when explicitly requested.

Keep commits scoped to the requested work and leave unrelated user changes untouched.
