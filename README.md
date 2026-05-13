# claude-code-boris-workflow

Workflow global multi-tool basado en la metodologia de Boris Cherny para usar una misma forma de trabajar en Claude Code, Codex y OpenCode.

- **Plan primero** en tareas no triviales.
- **Agentes especializados** (`staff-reviewer`, `code-simplifier`, `code-architect`) para aislar tareas sin ensuciar el contexto principal.
- **Workflows reutilizables** adaptados a cada herramienta: commands en Claude/OpenCode y skills en Codex.
- **Guardrails globales**: no force-push sin confirmacion, no secretos en commits, no acciones externas sin permiso.
- **Auto-mejora**: cuando el agente falla, se actualizan las instrucciones globales o del proyecto con una regla concreta.

Puedes instalarlo para una sola herramienta o para todas.

## Instalacion

### Opcion 1 - Agentica Recomendada

Abre Claude Code, Codex u OpenCode en cualquier directorio y pega este prompt:

```
Lee https://github.com/W4k4s/claude-code-boris-workflow - especialmente AGENT-INSTALL.md - e instala el workflow Boris para las herramientas que te indique.
Si no indico herramienta, instala todas: Claude Code, Codex y OpenCode.
Si ya tengo archivos con el mismo nombre en ~/.claude, ~/.codex, ~/.agents/skills o ~/.config/opencode, muestrame el diff antes de sobreescribir.
No toques proyectos especificos, credenciales, plugins ni settings no cubiertos por el instalador.
Al terminar, resume que instalaste y que dejaste intacto.
```

### Opcion 2 - Bash Manual

Instalar todo:

```bash
curl -fsSL https://raw.githubusercontent.com/W4k4s/claude-code-boris-workflow/main/install.sh | bash
```

Instalar solo una herramienta:

```bash
curl -fsSL https://raw.githubusercontent.com/W4k4s/claude-code-boris-workflow/main/install.sh | bash -s -- --claude
curl -fsSL https://raw.githubusercontent.com/W4k4s/claude-code-boris-workflow/main/install.sh | bash -s -- --codex
curl -fsSL https://raw.githubusercontent.com/W4k4s/claude-code-boris-workflow/main/install.sh | bash -s -- --opencode
```

Opciones disponibles:

```bash
./install.sh --all
./install.sh --claude
./install.sh --codex
./install.sh --opencode
```

Para probar una copia local del repo sin clonar `main` de GitHub:

```bash
BORIS_WORKFLOW_SRC="$PWD" ./install.sh --all
```

El script instala solo archivos globales del workflow y pide confirmacion en conflictos. No toca proyectos especificos.

## Que Instala

### Claude Code

```
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

Codex no usa custom slash commands globales como Claude/OpenCode. El equivalente nativo para workflows reutilizables son skills instaladas en `~/.agents/skills`.

```
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

Uso en Codex: invoca las skills con `$boris-grill`, `$boris-review-changes`, `$boris-quick-commit`, `$boris-commit-push-pr`, `$boris-techdebt`, `$boris-worktree` o `$boris-cierre-sesion`.

### OpenCode

```
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

## Paridad De Workflow

| Workflow | Claude Code | Codex | OpenCode |
| --- | --- | --- | --- |
| Metodologia global | `CLAUDE.md` | `AGENTS.md` | `AGENTS.md` |
| Agents | `agents/*.md` | `agents/*.toml` | `agents/*.md` |
| Review adversarial | `/grill` | `$boris-grill` | `/grill` |
| Review cambios locales | `/review-changes` | `$boris-review-changes` | `/review-changes` |
| Commit rapido | `/quick-commit` | `$boris-quick-commit` | `/quick-commit` |
| Commit + push + PR | `/commit-push-pr` | `$boris-commit-push-pr` | `/commit-push-pr` |
| Tech debt | `/techdebt` | `$boris-techdebt` | `/techdebt` |
| Worktree paralelo | `/worktree` | `$boris-worktree` | `/worktree` |
| Cierre sesion | `/cierre-sesion` | `$boris-cierre-sesion` | `/cierre-sesion` |

## Guardrails

- El instalador no sobreescribe instrucciones globales existentes sin aviso.
- En conflictos de agents, commands, skills, rules u `opencode.json`, muestra diff y pregunta si sobreescribir, saltar o guardar backup.
- No modifica credenciales, auth files, plugins, historiales, sesiones ni proyectos especificos.
- Codex instala reglas `boris-safety.rules` para pedir confirmacion ante acciones destructivas como force-push, reset hard, git clean o rm recursivo.
- OpenCode queda con permisos globales conservadores: `edit` y `external_directory` en `ask`, bash en `ask` por defecto y deny para `git push --force*`.
- Los comandos OpenCode `/ask-claude` y `/ask-codex` invocan otras herramientas solo tras confirmacion y con modos read-only/plan por defecto.

## Tras La Instalacion

1. Edita `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md` o `~/.config/opencode/AGENTS.md` para rellenar tu perfil si instalaste esa herramienta.
2. Anade reglas aprendidas en la seccion de errores conocidos cross-proyecto.
3. Prueba un flujo simple: planificar una tarea, revisar un diff o pedir una consulta read-only.

## Filosofia

- El contexto es caro: delega tareas pesadas o paralelizables a agentes.
- Plan antes que codigo, especialmente en cambios de 3 o mas pasos.
- Verifica antes de cerrar: typecheck, lint, tests, build o QA manual segun el proyecto.
- Las instrucciones globales son memoria viva: cuando una herramienta se equivoque, fija la regla para que no se repita.

## Licencia

MIT.
