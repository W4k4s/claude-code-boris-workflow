# AGENT-INSTALL

Instructions for an agent installing this multi-tool Boris workflow on a user's machine.

## Goal

Install global methodology, agents, reusable workflows, and guardrails for Claude Code, Codex, and OpenCode without overwriting existing configuration without notice.

The user may request one tool or all of them:

- `--claude`: Claude Code under `~/.claude/`
- `--codex`: Codex under `~/.codex/` and skills under `~/.agents/skills/`
- `--opencode`: OpenCode under `~/.config/opencode/`
- `--all`: all of the above, default behavior

## Recommended Installation

Clone the repo and run the installer with the right selection:

```bash
git clone https://github.com/W4k4s/claude-code-boris-workflow.git /tmp/boris-workflow
/tmp/boris-workflow/install.sh --all
```

To install only one tool:

```bash
/tmp/boris-workflow/install.sh --claude
/tmp/boris-workflow/install.sh --codex
/tmp/boris-workflow/install.sh --opencode
```

## Conflict Policy

For every file the installer wants to copy:

- If it does not exist in the destination, copy it directly.
- If it exists and is identical, skip it.
- If it exists and is different, show `diff -u` and ask whether to overwrite, skip, or create a `.bak` backup and overwrite.

For personal global instruction files (`CLAUDE.md`, `AGENTS.md`) and OpenCode config (`opencode.json`), if they already exist and differ, do not overwrite automatically. Show the diff and recommend a manual merge while preserving the user's existing rules, providers, models, and local settings.

## What To Copy Per Tool

Claude Code:

- `global/CLAUDE.md` -> `~/.claude/CLAUDE.md`
- `global/agents/*.md` -> `~/.claude/agents/`
- `global/commands/*.md` -> `~/.claude/commands/`

Codex:

- `global/codex/AGENTS.md` -> `~/.codex/AGENTS.md`
- `global/codex/agents/*.toml` -> `~/.codex/agents/`
- `global/codex/rules/*.rules` -> `~/.codex/rules/`
- `global/codex/skills/*/SKILL.md` -> `~/.agents/skills/*/SKILL.md`

OpenCode:

- `global/opencode/AGENTS.md` -> `~/.config/opencode/AGENTS.md`
- `global/opencode/opencode.json` -> `~/.config/opencode/opencode.json`
- `global/opencode/agents/*.md` -> `~/.config/opencode/agents/`
- `global/opencode/commands/*.md` -> `~/.config/opencode/commands/`

## Expected Parity

| Workflow | Claude Code | Codex | OpenCode |
| --- | --- | --- | --- |
| Adversarial review | `/grill` | `$boris-grill` | `/grill` |
| Review local changes | `/review-changes` | `$boris-review-changes` | `/review-changes` |
| Quick commit | `/quick-commit` | `$boris-quick-commit` | `/quick-commit` |
| Commit + push + PR | `/commit-push-pr` | `$boris-commit-push-pr` | `/commit-push-pr` |
| Tech debt cleanup | `/techdebt` | `$boris-techdebt` | `/techdebt` |
| Parallel worktree | `/worktree` | `$boris-worktree` | `/worktree` |
| Session close | `/cierre-sesion` | `$boris-cierre-sesion` | `/cierre-sesion` |

## Restrictions

- Never overwrite a different existing file without showing a diff and receiving confirmation.
- Never modify credentials, auth files, histories, caches, sessions, or logs.
- Never modify `~/.claude/settings.json`, `~/.codex/config.toml`, existing `~/.config/opencode/opencode.json` providers/models, plugins, or keys unless explicitly requested.
- Never touch project-specific files, `.claude/projects/`, `.codex/sessions/`, or other state directories.
- Never push to any user-owned repo unless explicitly requested.
- If an action can be destructive or external, ask first.

## Expected Final Summary

At the end, print a table with:

- Claude Code: instructions, agents, and commands installed, skipped, or conflicted.
- Codex: instructions, agents, skills, and rules installed, skipped, or conflicted.
- OpenCode: instructions, config, agents, and commands installed, skipped, or conflicted.
- Suggested next step to test the workflow.
