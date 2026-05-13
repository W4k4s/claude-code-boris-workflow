# claude-code-boris-workflow

A global multi-tool workflow based on Boris Cherny's Claude Code methodology, adapted for Claude Code, Codex, and OpenCode.

**Start here if you are a user:** [User Guide](USER-GUIDE.md) | **Español:** [Guia de buen uso](GUIA-USO.md)

The user guide explains the workflow from scratch: what the main terms mean, how to choose a tool, and how to work safely without breaking your repo or losing context.

- **Plan first** for non-trivial tasks.
- **Specialized agents** (`staff-reviewer`, `code-simplifier`, `code-architect`) to isolate work without polluting the main context.
- **Reusable workflows** adapted to each tool: commands in Claude Code/OpenCode and skills in Codex.
- **Global guardrails**: no force-push without confirmation, no secrets in commits, no external actions without permission.
- **Self-improvement**: when an agent makes a repeatable mistake, add a concrete rule to the global or project instructions.

You can install it for one tool or for all of them.

## Documentation

- [User Guide](USER-GUIDE.md): practical user guide with examples, glossary, and recommended workflows.
- [Guia de buen uso](GUIA-USO.md): Spanish version of the practical user guide.
- [AGENT-INSTALL](AGENT-INSTALL.md): instructions for an agent that installs the workflow safely.

## Installation

### Option 1 - Agentic Install Recommended

Open Claude Code, Codex, or OpenCode in any directory and paste this prompt:

```text
Read https://github.com/W4k4s/claude-code-boris-workflow - especially AGENT-INSTALL.md - and install the Boris workflow for the tools I specify.
If I do not specify a tool, install all of them: Claude Code, Codex, and OpenCode.
If I already have files with the same name under ~/.claude, ~/.codex, ~/.agents/skills, or ~/.config/opencode, show me the diff before overwriting.
Do not touch project-specific files, credentials, plugins, or settings that are not covered by the installer.
At the end, summarize what you installed and what you left untouched.
```

### Option 2 - Manual Bash Install

Install everything:

```bash
curl -fsSL https://raw.githubusercontent.com/W4k4s/claude-code-boris-workflow/main/install.sh | bash
```

Install only one tool:

```bash
curl -fsSL https://raw.githubusercontent.com/W4k4s/claude-code-boris-workflow/main/install.sh | bash -s -- --claude
curl -fsSL https://raw.githubusercontent.com/W4k4s/claude-code-boris-workflow/main/install.sh | bash -s -- --codex
curl -fsSL https://raw.githubusercontent.com/W4k4s/claude-code-boris-workflow/main/install.sh | bash -s -- --opencode
```

Available options:

```bash
./install.sh --all
./install.sh --claude
./install.sh --codex
./install.sh --opencode
```

To test a local checkout without cloning `main` from GitHub:

```bash
BORIS_WORKFLOW_SRC="$PWD" ./install.sh --all
```

The installer only copies global workflow files and asks for confirmation when conflicts exist. It does not touch project-specific files.

## What It Installs

### Claude Code

```text
~/.claude/
├── CLAUDE.md
├── agents/
│   ├── staff-reviewer.md
│   ├── code-simplifier.md
│   └── code-architect.md
└── commands/
    ├── grill.md
    ├── review-changes.md
    ├── quick-commit.md
    ├── commit-push-pr.md
    ├── techdebt.md
    ├── worktree.md
    └── cierre-sesion.md
```

### Codex

Codex does not use global custom slash commands like Claude Code or OpenCode. Its native equivalent for reusable workflows is skills installed under `~/.agents/skills`.

```text
~/.codex/
├── AGENTS.md
├── agents/
│   ├── staff-reviewer.toml
│   ├── code-simplifier.toml
│   └── code-architect.toml
└── rules/
    └── boris-safety.rules

~/.agents/skills/
├── boris-grill/
├── boris-review-changes/
├── boris-quick-commit/
├── boris-commit-push-pr/
├── boris-techdebt/
├── boris-worktree/
└── boris-cierre-sesion/
```

Use in Codex: invoke the skills with `$boris-grill`, `$boris-review-changes`, `$boris-quick-commit`, `$boris-commit-push-pr`, `$boris-techdebt`, `$boris-worktree`, or `$boris-cierre-sesion`.

### OpenCode

```text
~/.config/opencode/
├── AGENTS.md
├── opencode.json
├── agents/
│   ├── staff-reviewer.md
│   ├── code-simplifier.md
│   └── code-architect.md
└── commands/
    ├── grill.md
    ├── review-changes.md
    ├── quick-commit.md
    ├── commit-push-pr.md
    ├── techdebt.md
    ├── worktree.md
    ├── cierre-sesion.md
    ├── ask-claude.md
    └── ask-codex.md
```

## Workflow Parity

| Workflow | Claude Code | Codex | OpenCode |
| --- | --- | --- | --- |
| Global methodology | `CLAUDE.md` | `AGENTS.md` | `AGENTS.md` |
| Agents | `agents/*.md` | `agents/*.toml` | `agents/*.md` |
| Adversarial review | `/grill` | `$boris-grill` | `/grill` |
| Review local changes | `/review-changes` | `$boris-review-changes` | `/review-changes` |
| Quick commit | `/quick-commit` | `$boris-quick-commit` | `/quick-commit` |
| Commit + push + PR | `/commit-push-pr` | `$boris-commit-push-pr` | `/commit-push-pr` |
| Tech debt cleanup | `/techdebt` | `$boris-techdebt` | `/techdebt` |
| Parallel worktree | `/worktree` | `$boris-worktree` | `/worktree` |
| Session close | `/cierre-sesion` | `$boris-cierre-sesion` | `/cierre-sesion` |

## Guardrails

- The installer never overwrites existing global instruction files without notice.
- For conflicts in agents, commands, skills, rules, or `opencode.json`, it shows a diff and asks whether to overwrite, skip, or back up and overwrite.
- It does not modify credentials, auth files, plugins, histories, sessions, or project-specific files.
- Codex installs `boris-safety.rules` to require confirmation for destructive actions such as force-push, hard reset, git clean, or recursive rm.
- OpenCode uses conservative global permissions: `edit` and `external_directory` are set to `ask`, bash asks by default, and `git push --force*` is denied.
- OpenCode commands `/ask-claude` and `/ask-codex` invoke other tools only after confirmation and with read-only/plan modes by default.

## After Installation

1. Edit `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, or `~/.config/opencode/AGENTS.md` to fill in your profile if you installed that tool.
2. Add learned cross-project rules to the known-errors or self-improvement section.
3. Try a simple workflow: plan a task, review a diff, or ask a read-only question.

## Philosophy

- Context is expensive: delegate heavy or parallelizable work to agents.
- Plan before code, especially for changes with 3 or more steps.
- Verify before closing: typecheck, lint, tests, build, or manual QA depending on the project.
- Global instructions are living memory: when a tool makes a repeatable mistake, add a rule so it does not happen again.

## License

MIT.
