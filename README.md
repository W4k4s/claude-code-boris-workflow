<p align="center">
  <img src="assets/header.svg" alt="Global Boris Workflow banner" width="100%" />
</p>

<h1 align="center">Global Boris Workflow</h1>

<p align="center">
  A portable, safety-first workflow for <strong>Claude Code</strong>, <strong>Codex</strong>, and <strong>OpenCode</strong>.
</p>

<p align="center">
  <a href="USER-GUIDE.md"><strong>User Guide</strong></a>
  ·
  <a href="GUIA-USO.md"><strong>Guía en español</strong></a>
  ·
  <a href="AGENT-INSTALL.md"><strong>Agent Install Guide</strong></a>
</p>

<p align="center">
  <img alt="License: MIT" src="https://img.shields.io/badge/license-MIT-blue.svg" />
  <img alt="Tools" src="https://img.shields.io/badge/tools-Claude%20Code%20%7C%20Codex%20%7C%20OpenCode-7c3aed.svg" />
  <img alt="Installer" src="https://img.shields.io/badge/installer-modular-0ea5e9.svg" />
  <img alt="Guardrails" src="https://img.shields.io/badge/guardrails-enabled-16a34a.svg" />
</p>

<p align="center">
  <a href="USER-GUIDE.md"><img alt="Start here: User Guide" src="https://img.shields.io/badge/start%20here-User%20Guide-0f172a?style=for-the-badge" /></a>
  <a href="GUIA-USO.md"><img alt="Guía en español" src="https://img.shields.io/badge/espa%C3%B1ol-Gu%C3%ADa%20de%20uso-c026d3?style=for-the-badge" /></a>
</p>

<table>
  <tr>
    <td><strong>New to AI coding workflows?</strong><br />Start with the guide before installing anything. It explains the terms, the safe workflow, when to plan, when to verify, and how to avoid losing context or overwriting work.</td>
    <td><strong>Recommended path</strong><br /><a href="USER-GUIDE.md">Read the User Guide</a><br /><a href="GUIA-USO.md">Leer la guía en español</a><br /><a href="AGENT-INSTALL.md">Then install with an agent</a></td>
  </tr>
</table>

---

## What This Is

This repo packages a global development workflow inspired by Boris Cherny's Claude Code methodology and adapts it to three local AI coding tools:

- **Claude Code**: global `CLAUDE.md`, agents, and skills.
- **Codex**: global `AGENTS.md`, custom agents, skills, and command safety rules.
- **OpenCode**: global `AGENTS.md`, agents, commands, and conservative permissions.

The goal is not to install more tooling for the sake of it. The goal is to make every tool follow the same operating rhythm:

1. Understand the goal.
2. Plan before editing when the task is non-trivial.
3. Make the smallest correct change.
4. Verify with the relevant checks.
5. Close with a clear status and next step.

## Why Use It

- **One workflow across tools**: Claude Code skills/commands, Codex skills, and OpenCode commands map to the same routines.
- **Safer defaults**: commits, pushes, destructive shell commands, and external actions require explicit intent.
- **Reusable agents**: planning, architecture, and simplification are handled by focused assistants.
- **Portable setup**: install everything or only the tool you use.
- **Team-friendly docs**: non-expert users can start with the practical guides.

## The Planning Workflow

The headline feature is the planning loop, and it works in two layers:

- **Plan mode (no command):** enter plan mode, describe the idea, and on approval Claude Code offers to clear the context before executing, so the assistant starts with only the approved plan and none of the exploration noise. That clear-context option is the native `showClearContextOnPlanAccept` setting, shipped enabled in `~/.claude/settings.json`. The installer never overwrites an existing settings.json, so if you already have one, add the root-level key by hand: `{ "showClearContextOnPlanAccept": true }`.
- **`/plan-visual` (for large plans):** an optional layer that partitions the plan into work units with disjoint file boundaries, reviews it with `staff-reviewer` until approved, renders it as an HTML artifact, and saves the Markdown to `~/.claude/plans/`. It follows the planner/evaluator pattern (the planner is not the validator, so gaps surface before any code is written) and leaves the plan ready for parallel multi-agent execution.

`/plan-visual` and the setting are Claude Code only for now (Codex/OpenCode parity is a follow-up). Full details and a when-to-use-which table are in [USER-GUIDE.md](USER-GUIDE.md) (English) and [GUIA-USO.md](GUIA-USO.md) (Spanish).

## Quick Install

Install everything:

```bash
curl -fsSL https://raw.githubusercontent.com/W4k4s/claude-code-boris-workflow/main/install.sh | bash
```

Install from Windows PowerShell for native Windows desktop apps:

```powershell
$dir = Join-Path $env:TEMP ("boris-workflow-" + [guid]::NewGuid())
git clone https://github.com/W4k4s/claude-code-boris-workflow.git $dir
powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $dir "install.ps1") -All
```

Install one tool only:

```bash
curl -fsSL https://raw.githubusercontent.com/W4k4s/claude-code-boris-workflow/main/install.sh | bash -s -- --claude
curl -fsSL https://raw.githubusercontent.com/W4k4s/claude-code-boris-workflow/main/install.sh | bash -s -- --codex
curl -fsSL https://raw.githubusercontent.com/W4k4s/claude-code-boris-workflow/main/install.sh | bash -s -- --opencode
```

Available installer options:

```bash
./install.sh --all
./install.sh --claude
./install.sh --codex
./install.sh --opencode
```

Windows PowerShell options:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -All
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Claude
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Codex
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -OpenCode
```

Test a local checkout without cloning `main` from GitHub:

```bash
BORIS_WORKFLOW_SRC="$PWD" ./install.sh --all
```

The installer only copies global workflow files. If an agent, skill, command, or rule destination file already exists and differs, it shows a diff and asks whether to overwrite, skip, or back up and overwrite. Personal instruction files and `opencode.json` are never overwritten automatically; merge the shown diff manually so existing providers and local settings are preserved.

## Agentic Install Prompt

Open Claude Code, Codex, or OpenCode in any directory and paste:

```text
Read https://github.com/W4k4s/claude-code-boris-workflow - especially AGENT-INSTALL.md - and install the Boris workflow for the tools I specify.
If I do not specify a tool, install all of them: Claude Code, Codex, and OpenCode.
If I already have files with the same name under ~/.claude, ~/.claude/skills, ~/.codex, ~/.agents/skills, or ~/.config/opencode, show me the diff before overwriting.
Do not touch project-specific files, credentials, plugins, or settings that are not covered by the installer.
At the end, summarize what you installed and what you left untouched.
```

## What Gets Installed

| Tool | Global instructions | Agents | Workflows | Guardrails |
| --- | --- | --- | --- | --- |
| Claude Code | `~/.claude/CLAUDE.md` | `~/.claude/agents/*.md` | `~/.claude/skills/*` | Existing Claude permission flow |
| Codex | `~/.codex/AGENTS.md` | `~/.codex/agents/*.toml` | `~/.agents/skills/boris-*` | `~/.codex/rules/boris-safety.rules` |
| OpenCode | `~/.config/opencode/AGENTS.md` | `~/.config/opencode/agents/*.md` | `~/.config/opencode/commands/*.md` | `~/.config/opencode/opencode.json` |

## Agents, Commands, And Skills

The workflow uses each tool's native extension model instead of pretending all clients work the same way.

| Concept | Claude Code | Codex | OpenCode | Notes |
| --- | --- | --- | --- | --- |
| Global instructions | `CLAUDE.md` | `AGENTS.md` | `AGENTS.md` | Loaded at session start to set behavior and guardrails. |
| Specialized agents | Markdown agents in `~/.claude/agents` | TOML agents in `~/.codex/agents` | Markdown agents in `~/.config/opencode/agents` | Used for architecture, plan review, and simplification. |
| User-invoked workflows | Skills in `~/.claude/skills` | Skills in `~/.agents/skills` | Commands in `~/.config/opencode/commands` | Same workflow, different packaging. |
| Invocation | `/grill`, `/quick-commit` | `$boris-grill`, `$boris-quick-commit` | `/grill`, `/quick-commit` | Codex skills use the `boris-` prefix to avoid collisions. |

Limitations to know:

- Claude Code workflows are installed as skills under `~/.claude/skills`. On reinstall, any legacy `~/.claude/commands` files for these workflows are moved aside to `.bak` (they are now skills).
- Claude Desktop Code may show these workflows in the `/` menu without listing personal filesystem skills under **Customize > Skills**.
- Codex App and Codex CLI use skills, not global custom slash commands. In the app, invoke them with `$boris-*` or by selecting the matching skill when available.
- Agents are not the same thing as skills. Agents shape delegated specialist behavior; skills and commands are reusable workflows you invoke.
- Desktop apps and WSL do not share config automatically. Install separately in the environment that runs the agent.

## Desktop Apps, CLI, Windows, And WSL

Install the workflow in the same environment that runs the agent. Windows native apps and WSL do not automatically share home directories or tool configuration.

| Environment | Install with | Config location | Notes |
| --- | --- | --- | --- |
| Claude Code CLI in WSL/Linux/macOS | `install.sh --claude` | `~/.claude` | Best fit when your repo and toolchain live in Linux/WSL. |
| Claude Desktop Code on Windows | `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Claude` | `%USERPROFILE%\.claude` | Treat as a separate native Windows install. Restart Desktop after adding a new `skills` directory. |
| Codex CLI in WSL/Linux/macOS | `install.sh --codex` | `~/.codex` and `~/.agents/skills` | Use this when the Codex agent runs inside WSL/Linux. |
| Codex App on Windows | `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Codex` | `%USERPROFILE%\.codex` and `%USERPROFILE%\.agents\skills` | If the app agent is switched to WSL, install inside WSL too or configure `CODEX_HOME` deliberately. |
| OpenCode native config | `install.sh --opencode` or `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -OpenCode` | `~/.config/opencode` or `%USERPROFILE%\.config\opencode` | Keep provider/model settings when merging `opencode.json`. |

If you installed Claude Code in WSL at `/home/<user>/.claude`, Claude Desktop on Windows should not be expected to see those skills automatically. Install the Windows target separately with `install.ps1` instead of copying the whole WSL `.claude` directory, because auth files, MCP paths, shell commands, and secrets may not be portable.

To verify Claude Desktop Code after installation:

1. Restart Claude Desktop completely.
2. Open the Code tab in a local project.
3. Type `/` and confirm `grill`, `review-changes`, `quick-commit`, `cierre-sesion`, and `plan-visual` (Claude Code only) appear.
4. Run `/quick-commit Estoy probando. No hagas commit; dime que checks harias y espera confirmacion.` and confirm it does not commit without explicit approval.

Personal filesystem skills may not appear in the desktop **Customize > Skills** view even when they are installed correctly. Treat the slash menu and actual command behavior as the source of truth.

The validated behavior for Claude Desktop Code on Windows is: files install under `%USERPROFILE%\.claude`, workflows appear in the `/` menu, `/grill` can inspect branch state, `/review-changes` can run a local review, and `/quick-commit` waits for explicit confirmation before committing.

To verify Codex App on Windows after installation:

1. Open Codex App with the Windows-native agent.
2. Open a local project.
3. Type `$` in the composer and confirm `boris-grill`, `boris-review-changes`, and `boris-quick-commit` appear.
4. Run `$boris-quick-commit Estoy probando. No hagas commit; dime que checks harias y espera confirmacion.` and confirm it does not commit without explicit approval.

The validated behavior for Codex App on Windows is: files install under `%USERPROFILE%\.codex` and `%USERPROFILE%\.agents\skills`, `$boris-quick-commit` is recognized, and it waits for explicit confirmation before committing.

## Workflow Parity

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

`/plan-visual` is Claude-Code-only for now: it turns a plan into a partitioned HTML artifact (work units with disjoint file boundaries), reviewed by `staff-reviewer` until APPROVED, then hands off with a clean context. Codex and OpenCode parity is a follow-up.

## Directory Layout

```text
global/
├── CLAUDE.md
├── agents/
├── commands/
├── skills/
├── codex/
│   ├── AGENTS.md
│   ├── agents/
│   ├── rules/
│   └── skills/
└── opencode/
    ├── AGENTS.md
    ├── opencode.json
    ├── agents/
    └── commands/
```

## Safety Guardrails

The workflow is intentionally conservative:

- It never overwrites global instruction files silently.
- It avoids project-specific files, credentials, auth files, histories, caches, sessions, and logs.
- Codex rules require confirmation for force-push, hard reset, `git clean`, and recursive `rm`.
- OpenCode permissions ask before edits, bash, and external directory access; `git push --force*` is denied.
- Commit and PR flows require explicit user intent.

## Documentation

- [User Guide](USER-GUIDE.md): practical guide for users, including glossary, examples, prompts, and safe workflows.
- [Guía de buen uso](GUIA-USO.md): Spanish version of the user guide.
- [AGENT-INSTALL](AGENT-INSTALL.md): installation instructions for AI agents.

## After Installation

1. Fill in your profile in the installed global instructions for the tools you use.
2. Run a simple planning workflow to confirm the tool sees the instructions.
3. Add learned cross-project rules when an assistant makes a repeatable mistake.

## License

MIT.
