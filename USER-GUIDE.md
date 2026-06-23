# Boris Workflow User Guide

This guide is for people who want to work well with Claude Code, Codex, or OpenCode, even if they are not used to terms like branch, diff, PR, agent, or worktree.

The main idea is simple: treat coding assistants like teammates, not like a black box that edits files without supervision.

The Boris workflow has five steps:

1. Understand the goal.
2. Plan before changing code when the task is not trivial.
3. Make the smallest correct change.
4. Verify that it works.
5. Close the session with a clear summary of what changed and what remains.

## Quick Start

If you do not know which tool to use, pick one and follow this order:

1. Open the project with Claude Code, Codex, or OpenCode.
2. Ask for a plan first if the task has more than 2 or 3 steps.
3. Let it implement only after the plan makes sense.
4. Ask it to run tests, lint, typecheck, or build if they exist.
5. Review the changes before asking for a commit.
6. Ask for a commit or PR only when you are comfortable with the result.

Recommended base prompt:

```text
I want to do <goal>. First inspect the repo and propose a plan. Do not edit code until the approach is clear. When you implement, make the smallest correct change and verify it with the relevant commands if they exist.
```

## Minimal Dictionary

### Repo

The code project. Usually a folder managed with Git.

### Working tree

The current state of your files. If you changed something but have not committed it, it is in the working tree.

### Diff

The difference between what was there before and what is there now. This is what you should review before accepting changes.

Example:

```bash
git diff
```

### Commit

A saved snapshot of changes in Git. It should have a clear message.

### Push

Uploading commits to the remote, for example GitHub.

### Pull Request Or PR

A proposed set of changes to review before merging into a main branch.

### Branch

A separate line of work. Usually you work on a branch that is not `main` or `master`.

### Agent

A specialized assistant. For example, one reviews plans, another simplifies code, and another helps with architecture.

### Command Or Slash Command

A command inside Claude Code or OpenCode that runs a workflow recipe. Examples: `/grill`, `/quick-commit`.

### Skill

A reusable workflow packaged as a folder with `SKILL.md`. Claude Code invokes them with `/name`. Codex usually invokes them with `$boris-name`.

### Agent Vs Skill

An agent is a specialist you delegate to, such as architecture or plan review. A skill is a workflow you invoke, such as reviewing changes or preparing a commit.

### Worktree

Another working copy of the same repo, useful for working in parallel without touching the current files.

### Guardrail

A safety rule. For example: do not force-push without confirmation, or do not commit secrets.

## The Golden Rule

Do not ask the assistant to do something you would not review if a junior teammate did it.

Good:

```text
Review these changes and tell me if you see risks before committing.
```

Bad:

```text
Fix everything, commit it, and push it without asking me.
```

## Which Tool Should I Use

There is no universally best tool. The decision depends on how you want to work.

| Case | Recommended tool | Why |
| --- | --- | --- |
| I want a strong local implementation session | Claude Code | Great interactive workflow, skills/commands, and subagents |
| I want sandboxing and skills from the terminal | Codex | Good permission control, subagents, and `$boris-*` skills |
| I want to alternate plan/build with conservative permissions | OpenCode | Good agent system and global commands |
| I want to ask another model without switching tools | OpenCode | It includes `/ask-claude` and `/ask-codex` |
| I want to work in parallel without overwriting changes | Any tool with a worktree | Each tool works in its own folder |

## Desktop Apps, CLI, Windows, And WSL

Practical rule: install the workflow in the same environment that runs the agent.

Native Windows and WSL do not automatically share the same `$HOME` or configuration:

| If you use... | Install in... | Expected path |
| --- | --- | --- |
| Claude Code CLI inside WSL | WSL | `/home/<user>/.claude` |
| Claude Desktop, Code tab, on Windows | Native Windows | `C:\Users\<user>\.claude` |
| Codex CLI inside WSL | WSL | `/home/<user>/.codex` and `/home/<user>/.agents/skills` |
| Codex App on Windows with the Windows agent | Native Windows | `C:\Users\<user>\.codex` and `C:\Users\<user>\.agents\skills` |

If you installed inside WSL and then open Claude Desktop on Windows, it is normal not to see the same skills or agents. Do not copy the whole WSL `.claude` directory into Windows blindly: it may contain auth state, Linux paths, MCP config, or shell-specific commands. Run the Windows installer for the native app instead:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Claude
```

For Claude Desktop Code, the workflows are installed as skills in `~/.claude/skills` and also as legacy commands in `~/.claude/commands`. If the `skills` folder did not exist before, restart the app.

The important check is whether the workflows are invocable. In our Windows Desktop validation, Claude Desktop Code loaded the workflows from the `/` menu even though personal filesystem skills did not necessarily appear under **Customize > Skills**.

To verify Claude Desktop:

1. Close and reopen Claude Desktop.
2. Open the Code tab and select a local project.
3. Type `/` and confirm `grill`, `review-changes`, `quick-commit`, and `cierre-sesion` appear.
4. Try `/quick-commit I am testing. Do not commit; tell me what checks you would run and wait for confirmation.` and confirm it does not commit without explicit approval.

Personal filesystem skills may not appear under **Customize > Skills** even when installed correctly. The practical check is that they appear in the `/` menu and behave correctly when invoked.

To verify Codex App on Windows:

1. Open Codex App with the Windows-native agent.
2. Open a local project.
3. Type `$` and confirm `boris-grill`, `boris-review-changes`, and `boris-quick-commit` appear.
4. Try `$boris-quick-commit I am testing. Do not commit; tell me what checks you would run and wait for confirmation.` and confirm it does not commit without explicit approval.

OpenCode does not need a separate desktop/CLI distinction in this repo: it uses its own config under `~/.config/opencode`, agents under `agents/`, commands under `commands/`, and permissions in `opencode.json`. The practical check is that `/grill`, `/review-changes`, and `/quick-commit` work and permissions ask where expected.

## Commands, Skills, And Agents

| Tool | Global instructions | Agents | Invocable workflows | How you invoke them |
| --- | --- | --- | --- | --- |
| Claude Code CLI/Desktop | `~/.claude/CLAUDE.md` | `~/.claude/agents/*.md` | `~/.claude/skills/*` and legacy `~/.claude/commands/*.md` | `/grill`, `/quick-commit` |
| Codex CLI/App | `~/.codex/AGENTS.md` | `~/.codex/agents/*.toml` | `~/.agents/skills/boris-*` | `$boris-grill`, `$boris-quick-commit` |
| OpenCode | `~/.config/opencode/AGENTS.md` | `~/.config/opencode/agents/*.md` | `~/.config/opencode/commands/*.md` | `/grill`, `/quick-commit` |

Limitations and differences:

- Claude Code still supports legacy commands, but the modern format is a skill under `~/.claude/skills`.
- Claude Desktop Code may show workflows in `/` without listing them under **Customize > Skills**.
- Codex does not use global custom slash commands for this workflow; it uses `$boris-*` skills.
- Agents are not workflow buttons. They are specialists for delegated work and do not replace `/grill` or `$boris-grill`.
- Native Windows and WSL are separate installs. If you use both, install the workflow in both.

## Claude Code In Practice

Claude Code installs instructions in `~/.claude/CLAUDE.md`, agents in `~/.claude/agents`, skills in `~/.claude/skills`, and legacy commands in `~/.claude/commands`.

Important skills/commands:

| Command | What it does | When to use it |
| --- | --- | --- |
| `/grill` | Adversarial review | Before considering a change ready |
| `/review-changes` | Reviews local changes | Before testing or committing |
| `/quick-commit` | Safe commit | When you have decided to commit |
| `/commit-push-pr` | Commit, push, and PR | When you want to publish and open a PR |
| `/techdebt` | Finds technical debt | At the end of a session or after a refactor |
| `/worktree` | Creates parallel work | When you want to isolate another task |
| `/cierre-sesion` | Structured session close | Before finishing or switching context |
| `/plan-visual` | Turn a plan into a partitioned HTML artifact, reviewed and ready for parallel execution | After planning, before executing |

`/plan-visual` is Claude Code only for now (Codex/OpenCode parity is a follow-up).

Example:

```text
/review-changes
```

Then:

```text
Fix the two risks you found and run the relevant tests.
```

## Codex In Practice

Codex uses `AGENTS.md` for instructions, `.toml` files for agents, and skills for reusable workflows.

Important: Codex does not use global custom slash commands like Claude Code or OpenCode. That is why this workflow installs skills in `~/.agents/skills`.

Important skills:

| Skill | Equivalent to | What it does |
| --- | --- | --- |
| `$boris-grill` | `/grill` | Adversarial pre-ship review |
| `$boris-review-changes` | `/review-changes` | Reviews local changes |
| `$boris-quick-commit` | `/quick-commit` | Fast and safe commit |
| `$boris-commit-push-pr` | `/commit-push-pr` | Commit, push, and PR |
| `$boris-techdebt` | `/techdebt` | Technical debt cleanup |
| `$boris-worktree` | `/worktree` | Creates a parallel worktree |
| `$boris-cierre-sesion` | `/cierre-sesion` | Structured session close |

Example:

```text
$boris-review-changes
```

Example with a goal:

```text
$boris-grill Review this branch against main. I want to know if there are bugs, security risks, or missing tests before opening a PR.
```

## OpenCode In Practice

OpenCode uses instructions in `~/.config/opencode/AGENTS.md`, agents in `~/.config/opencode/agents`, commands in `~/.config/opencode/commands`, and permissions in `opencode.json`.

Main commands:

| Command | What it does |
| --- | --- |
| `/grill` | Adversarial review |
| `/review-changes` | Reviews uncommitted changes |
| `/quick-commit` | Fast commit |
| `/commit-push-pr` | Commit, push, and PR |
| `/techdebt` | Technical debt cleanup |
| `/worktree` | Creates a parallel worktree |
| `/cierre-sesion` | Structured session close |
| `/ask-claude` | Ask Claude Code in safe mode |
| `/ask-codex` | Ask Codex in safe mode |

Example:

```text
/ask-codex Review whether this plan has security risks. Do not edit files.
```

## The Five Workflow Steps

### 1. Understand

Before touching files, the assistant should understand what you want to achieve and what constraints the project has.

Good prompt:

```text
I need to fix this bug: <description>. First locate where the issue might be and explain which files are relevant. Do not edit yet.
```

### 2. Plan

Planning does not mean writing a huge document. It means avoiding blind changes.

For a medium task, a good plan includes:

- Files that will be touched.
- Risks.
- Order of changes.
- How the change will be verified.

Good prompt:

```text
Propose a short plan. Include risks and verification commands. Wait for my OK before implementing.
```

When you approve a plan, Claude Code can clear the context before executing, leaving the assistant with only the approved plan (without the noise of the exploration phase). This repo enables that option by default. If the plan is large and you want adversarial review, an HTML view, or parallel execution, use `/plan-visual`. It is detailed below, in "The Planning Workflow".

### 3. Execute

Execution means making the smallest correct change.

Do not ask:

```text
Rewrite this whole area so it looks better.
```

Better:

```text
Implement only step 1 of the plan. Do not change behavior outside this bug.
```

### 4. Verify

Verification means checking that nothing important broke.

Depending on the project, this may be:

- Tests.
- Lint.
- Typecheck.
- Build.
- Browser testing.
- Manually reproducing a bug.

Good prompt:

```text
Run the smallest verification that proves this change works. If there is no suitable test, explain the residual risk.
```

### 5. Close

Closing means leaving the session organized. It is not just saying "done".

It should be clear:

- What changed.
- What was tested.
- What remains.
- Whether there is a commit or PR.
- What the next step is.

Commands:

```text
/cierre-sesion
```

In Codex:

```text
$boris-cierre-sesion
```

## The Planning Workflow: Plan Mode + /plan-visual

This is the most important improvement in the workflow. There are two layers, and you almost never need the second one.

### Layer 1: plan mode (the daily driver, no commands)

The normal flow for any non-trivial task:

1. Enter plan mode with `Shift+Tab` twice.
2. Describe the idea in plain language. The assistant explores and proposes a plan, without touching code.
3. When you approve the plan, the option to clear the context appears. Accept it.
4. The assistant starts executing with a clean context, following the plan.

No command needed: plan mode plus your idea plus approve already gives you the "plan, clear, execute" cycle.

That clear-context-on-approve option is controlled by a native Claude Code setting, `showClearContextOnPlanAccept`. It ships disabled by default, which is why the option "had disappeared". This repo distributes it enabled in `~/.claude/settings.json`. If you already had your own settings.json, the installer does not touch it (so it never clobbers your config): add the key by hand, at the root level of the JSON.

```json
{
  "showClearContextOnPlanAccept": true
}
```

Why it matters: planning and executing in the same context floods the window with the noise of the exploration phase. Clearing the context as execution starts leaves the assistant with only the approved plan, which is exactly what it needs. Less noise, less drift, better result.

### Layer 2: /plan-visual (for large plans only)

`/plan-visual` is an optional layer on top of the plan. Use it when the plan is big and you want one or more of these:

- A skeptical reviewer (`staff-reviewer`) to tear the plan apart before any code is written.
- To see it as an HTML page you can review at a glance (work-unit table and dependency graph).
- To partition it for parallel execution by several agents without collisions.

It runs five steps, in order:

0. Checks that the clear-context setting is active.
1. Partitions the plan into Work Units (WU), each with its files (disjoint boundaries, two WU never touch the same file), its dependencies, and its verification criterion.
2. Reviews with `staff-reviewer` until it approves. The reviewer also checks that the partition is genuinely parallelizable.
3. Renders the plan as an HTML artifact and saves the canonical Markdown to `~/.claude/plans/`.
4. Handoff: reminds you to clear context and leaves the plan ready to execute (it does not launch the agents for you yet).

Why it improves the result: it follows Anthropic's planner/evaluator pattern (the one who plans is not the one who validates, so gaps get caught before any code is written) and the idea that a plan in HTML forces a real review, instead of approving a wall of text without reading it. And because it is partitioned along disjoint boundaries, you can launch several agents at once without collisions.

### When to use which

| Situation | What to use |
|---|---|
| Normal task with 3+ steps | Plan mode only (no command) |
| You want adversarial review of the plan | `/plan-visual` |
| The plan is large and you want to see it in HTML | `/plan-visual` |
| You want to execute in parallel with several agents | `/plan-visual` |

`/plan-visual` and the `showClearContextOnPlanAccept` setting are Claude Code only for now. Parity with Codex and OpenCode is a follow-up.

## Workflows By Task Size

### Small Task

Examples: typo, text, comment, clear constant.

Flow:

1. Ask for the direct change.
2. Review the diff.
3. Verify only if needed.

Prompt:

```text
Change this text in the documentation. Make only that change and show me the diff.
```

### Medium Task

Examples: localized bug, new test, small component.

Flow:

1. Ask for a short plan.
2. Implement.
3. Verify.
4. Review changes.
5. Commit if appropriate.

Prompt:

```text
Fix this bug. First inspect the relevant files and propose a short plan. Then implement the smallest change, run relevant tests, and review the diff.
```

### Large Task

Examples: migration, refactor, feature across multiple modules.

Flow:

1. Broad discovery.
2. Plan by phases.
3. `/plan-visual`: partition the plan into work units, review it with `staff-reviewer`, and leave it in HTML, ready to execute in parallel.
4. Clear the context on approval (`/new`) and execute the units, in parallel for the ones that do not depend on each other.
5. Verify each unit.
6. Run adversarial review with `/grill` or `$boris-grill`.
7. Close the session.

On a large task, `/plan-visual` is where it shows the most: the adversarial review catches gaps before any code is written, and the partition along disjoint boundaries lets you launch several agents at once without collisions.

Prompt:

```text
This is a large task. Do project-wide discovery, propose small phases, and run the plan through /plan-visual to review and partition it before editing code.
```

## How To Use The Agents

### staff-reviewer

This is the skeptical reviewer. It helps you avoid wasting time implementing a bad plan.

Use it when:

- The change has several steps.
- You are not sure about the approach.
- There may be security, data, or architecture risks.

Prompt:

```text
Review this plan as staff-reviewer. Look for risks, ambiguous requirements, overengineering, and insufficient verification strategy. End with APROBAR, PEDIR CAMBIOS, or REPLANTEAR.
```

### code-architect

This is the architect. It helps you think about structure before writing code.

Use it when:

- A feature needs design.
- Responsibilities need to be split.
- Several options need to be compared.

Prompt:

```text
Analyze the current architecture for this feature. Give me options, trade-offs, risks, and an implementation plan. Do not edit code yet.
```

### code-simplifier

This is the simplifier. Use it after implementing.

Use it when:

- The change became more complex than expected.
- There is duplication.
- There are unnecessary imports, helpers, or abstractions.

Prompt:

```text
Simplify the recently modified code without changing behavior. Remove duplication, unnecessary abstractions, and dead imports. Run relevant verification.
```

## Working With Multiple Tools Without Overwriting Changes

You can use Claude Code, Codex, and OpenCode in the same project, but multiple tools should not edit the same file at the same time.

Simple rule:

- One tool edits.
- Another tool reviews in read-only mode.
- If two tools must edit, use separate worktrees.

Safe:

- Claude Code implements and Codex reviews with `$boris-grill`.
- OpenCode implements and `/ask-claude` asks a planning question.
- Codex works in `.codex/worktrees/feature-a` and Claude Code works on another branch.

Risky:

- Two tools editing the same file at the same time.
- An assistant discarding changes to "clean up" without asking.
- Committing everything without looking at `git diff`.

## Git And Pull Requests Explained Simply

### Before Commit

Ask the assistant:

```text
Review Git status, the diff, and check that there are no secrets before committing.
```

The assistant should inspect:

- `git status`
- `git diff`
- New untracked files
- Possible secrets

### Fast Commit

Claude/OpenCode:

```text
/quick-commit
```

Codex:

```text
$boris-quick-commit
```

### Pull Request

Claude/OpenCode:

```text
/commit-push-pr
```

Codex:

```text
$boris-commit-push-pr
```

Do not use these workflows if you are not ready to publish changes yet.

## Safety Rules You Should Respect

Do not run these unless you understand them:

- `git push --force`: can overwrite remote work.
- `git reset --hard`: can delete local changes.
- `git clean -fd`: can delete files not tracked by Git.
- `rm -rf`: can delete entire folders.
- Committing `.env`, tokens, passwords, or credentials.

If the assistant proposes one of these, it should explain why and ask for clear confirmation.

## Verification For Non-Experts

Not every project is verified the same way. The assistant should look for how the project is tested.

Common clues:

- `package.json`: JavaScript or TypeScript projects.
- `pyproject.toml`: modern Python projects.
- `requirements.txt`: Python projects.
- `Makefile`: common project commands.
- Project README.

Useful sentence:

```text
Detect the project's verification commands and run the ones that are most relevant to this change. If you cannot, explain why.
```

## How To Tell If An Assistant Response Is Good

A good assistant response:

- Says what changed and why.
- Mentions important files.
- Says what was verified.
- Says when it could not verify something.
- Does not hide risks.
- Does not commit or push without permission.

A bad response:

- Says "done" without evidence.
- Changes many files without explanation.
- Rewrites unrelated areas.
- Ignores failing tests.
- Suggests destructive commands without justification.

## Session Close

Use session close when you finish a task, switch projects, or want to leave work for later.

Claude/OpenCode:

```text
/cierre-sesion
```

Codex:

```text
$boris-cierre-sesion
```

The close should answer:

- What was done.
- What remains.
- Which tests passed or failed.
- Whether there are uncommitted changes.
- Whether technical debt was found.
- What the next step is.

## Self-Improvement

The workflow improves when you turn repeated mistakes into rules.

Example:

```text
Update the global or project instructions so you do not modify generated files without asking first.
```

Good rule:

```text
Before editing generated files, ask whether they are source of truth or build artifacts.
```

Bad rule:

```text
Behave better.
```

## Copy-Paste Checklist

Before editing:

- Goal understood.
- Relevant files read.
- Risks identified.
- Clear plan if the task is not trivial.

Before closing:

- Diff reviewed.
- Verification run or reason explained.
- No secrets in changes.
- No unrelated changes reverted.
- Clear next step.

Before PR:

- Correct branch.
- Clean commit.
- Tests/lint documented.
- Adversarial review completed with `/grill` or `$boris-grill`.
