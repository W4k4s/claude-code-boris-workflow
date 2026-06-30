# AGENT-INSTALL

Instructions for an agent installing this multi-tool Boris workflow on a user's machine.

## Goal

Install global methodology, agents, reusable workflows, and guardrails for Claude Code, Codex, and OpenCode without overwriting existing configuration without notice.

The user may request one tool or all of them:

- `--claude`: Claude Code under `~/.claude/`, including skills under `~/.claude/skills/`
- `--codex`: Codex under `~/.codex/` and skills under `~/.agents/skills/`
- `--opencode`: OpenCode under `~/.config/opencode/`
- `--all`: all of the above, default behavior

PowerShell equivalents are `-Claude`, `-Codex`, `-OpenCode`, and `-All`.

## Recommended Installation

Clone the repo and run the installer with the right selection:

```bash
git clone https://github.com/W4k4s/claude-code-boris-workflow.git /tmp/boris-workflow
/tmp/boris-workflow/install.sh --all
```

On native Windows, use PowerShell so desktop apps get files under the Windows user profile instead of WSL:

```powershell
$dir = Join-Path $env:TEMP ("boris-workflow-" + [guid]::NewGuid())
git clone https://github.com/W4k4s/claude-code-boris-workflow.git $dir
powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $dir "install.ps1") -All
```

To install only one tool:

```bash
/tmp/boris-workflow/install.sh --claude
/tmp/boris-workflow/install.sh --codex
/tmp/boris-workflow/install.sh --opencode
```

On native Windows:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Claude
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Codex
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -OpenCode
```

## Windows Native Vs WSL

Install into the environment that runs the agent:

- Claude Code CLI in WSL reads the WSL home, for example `/home/<user>/.claude`.
- Claude Desktop Code on Windows is a native Windows app and should be treated as a separate install under `%USERPROFILE%\.claude`.
- Codex CLI in WSL reads WSL `~/.codex` and `~/.agents/skills`.
- Codex App on Windows reads native Windows config unless its agent is explicitly configured to run inside WSL.
- OpenCode uses its own config directory and has been validated through normal `~/.config/opencode` command usage.

Do not copy whole config directories between WSL and Windows blindly. They can contain auth state, MCP paths, shell-specific commands, and non-portable absolute paths. Prefer running the installer separately in each target environment.

## Surface Differences

Do not describe agents, commands, and skills as the same thing:

| Concept | Claude Code | Codex | OpenCode |
| --- | --- | --- | --- |
| Global instructions | `CLAUDE.md` | `AGENTS.md` | `AGENTS.md` |
| Agents | `~/.claude/agents/*.md` | `~/.codex/agents/*.toml` | `~/.config/opencode/agents/*.md` |
| Workflows | `~/.claude/skills/*` | `~/.agents/skills/boris-*` | `~/.config/opencode/commands/*.md` |
| User invocation | `/grill` | `$boris-grill` | `/grill` |

Important limitations:

- Claude Desktop Code may expose installed filesystem workflows through the `/` menu even when they do not appear under **Customize > Skills**.
- Claude workflows ship as skills under `~/.claude/skills`. On reinstall, any legacy `~/.claude/commands/<slug>.md` for these workflows is moved aside to `.bak` (they are now skills).
- Codex App and CLI use `$boris-*` skills rather than global custom slash commands.
- OpenCode commands are native OpenCode commands and are configured separately from Claude and Codex.
- Agents are specialist assistants, not workflow launchers.

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
- `global/skills/*` -> `~/.claude/skills/*`
- On reinstall, legacy `~/.claude/commands/<slug>.md` for these workflows is moved aside to `.bak` (they are now skills).

Codex:

- `global/codex/AGENTS.md` -> `~/.codex/AGENTS.md`
- `global/codex/agents/*.toml` -> `~/.codex/agents/`
- `global/codex/rules/*.rules` -> `~/.codex/rules/`
- `global/codex/skills/*` -> `~/.agents/skills/*`

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
| Plan to partitioned HTML | `/plan-visual` | `— (follow-up)` | `— (follow-up)` |

`/plan-visual` is Claude-Code-only in this iteration; Codex and OpenCode parity is a follow-up.

## Expected Verification

After installing Claude on native Windows:

- Check `%USERPROFILE%\.claude\skills\grill\SKILL.md` exists.
- Restart Claude Desktop.
- In the Code tab, type `/` and confirm `grill`, `review-changes`, `quick-commit`, `cierre-sesion`, and `plan-visual` (Claude Code only) appear.
- Confirm `~/.claude/settings.json` is installed with the root-level `showClearContextOnPlanAccept` setting (never overwriting an existing user settings.json).
- Run `/quick-commit Estoy probando. No hagas commit; dime que checks harias y espera confirmacion.` and confirm it waits for explicit approval.

After installing Codex on native Windows:

- Check `%USERPROFILE%\.agents\skills\boris-grill\SKILL.md` exists.
- Open Codex App with the Windows-native agent.
- Type `$` and confirm `boris-grill`, `boris-review-changes`, and `boris-quick-commit` appear or are accepted.
- Run `$boris-quick-commit Estoy probando. No hagas commit; dime que checks harias y espera confirmacion.` and confirm it waits for explicit approval.

After installing OpenCode:

- Confirm `~/.config/opencode/commands/grill.md` or `%USERPROFILE%\.config\opencode\commands\grill.md` exists.
- Open OpenCode and invoke `/grill` or `/review-changes` in a test project.
- Confirm permissions still ask before edits and shell commands according to `opencode.json`.

## Restrictions

- Never overwrite a different existing file without showing a diff and receiving confirmation.
- Never modify credentials, auth files, histories, caches, sessions, or logs.
- Never modify `~/.claude/settings.json`, `~/.codex/config.toml`, existing `~/.config/opencode/opencode.json` providers/models, plugins, or keys unless explicitly requested.
- Never copy WSL config directories into Windows native config directories, or the reverse, without explicitly reviewing secrets, auth state, MCP paths, and shell-specific commands.
- Never touch project-specific files, `.claude/projects/`, `.codex/sessions/`, or other state directories.
- Never push to any user-owned repo unless explicitly requested.
- If an action can be destructive or external, ask first.

## Expected Final Summary

At the end, print a table with:

- Claude Code: instructions, agents, skills, and commands installed, skipped, or conflicted.
- Codex: instructions, agents, skills, and rules installed, skipped, or conflicted.
- OpenCode: instructions, config, agents, and commands installed, skipped, or conflicted.
- Suggested next step to test the workflow.
