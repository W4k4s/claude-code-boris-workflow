# claude-code-boris-workflow

Workflow global multi-tool basado en la metodologia de Boris Cherny para usar una misma forma de trabajar en Claude Code, Codex y OpenCode:

- **Plan primero** en tareas no triviales.
- **Agentes especializados** (`staff-reviewer`, `code-simplifier`, `code-architect`) para aislar tareas sin ensuciar el contexto principal.
- **Comandos globales** para operaciones recurrentes y consultas cruzadas entre herramientas.
- **Guardrails globales**: no force-push sin confirmacion, no secretos en commits, no acciones externas sin permiso.
- **Auto-mejora**: cuando el agente falla, se actualizan las instrucciones globales o del proyecto con una regla concreta.

Se instala una sola vez y queda disponible para todos tus proyectos:

- Claude Code: `~/.claude/`
- Codex: `~/.codex/`
- OpenCode: `~/.config/opencode/`

## Instalacion

### Opcion 1 - Agentica Recomendada
Abre Claude Code, Codex u OpenCode en cualquier directorio y pega este prompt:

```
Lee https://github.com/W4k4s/claude-code-boris-workflow - especialmente AGENT-INSTALL.md - e instala el workflow Boris multi-tool en mi maquina.
Si ya tengo archivos con el mismo nombre en ~/.claude, ~/.codex o ~/.config/opencode, muestrame el diff antes de sobreescribir.
No toques proyectos especificos, credenciales, plugins ni settings no cubiertos por el instalador.
Al terminar, resume que instalaste y que dejaste intacto.
```

El agente clonara el repo, revisara colisiones y dejara las plantillas en su sitio.

### Opcion 2 - Bash Manual

```bash
curl -fsSL https://raw.githubusercontent.com/W4k4s/claude-code-boris-workflow/main/install.sh | bash
```

El script instala solo archivos globales del workflow y pide confirmacion en conflictos. No toca proyectos especificos.

Para probar una copia local del repo sin clonar `main` de GitHub:

```bash
BORIS_WORKFLOW_SRC="$PWD" ./install.sh
```

### Opcion 3 - Clonar Y Copiar Manualmente

```bash
git clone https://github.com/W4k4s/claude-code-boris-workflow.git
cd claude-code-boris-workflow
cp -i -r global/agents global/commands ~/.claude/
cp -i global/CLAUDE.md ~/.claude/CLAUDE.md
cp -i -r global/codex/agents ~/.codex/
cp -i global/codex/AGENTS.md ~/.codex/AGENTS.md
cp -i -r global/opencode/agents global/opencode/commands ~/.config/opencode/
cp -i global/opencode/AGENTS.md global/opencode/opencode.json ~/.config/opencode/
```

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

```
~/.codex/
├── AGENTS.md
└── agents/
    ├── staff-reviewer.toml
    ├── code-simplifier.toml
    └── code-architect.toml
```

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
    ├── ask-claude.md
    └── ask-codex.md
```

## Guardrails

- El instalador no sobreescribe instrucciones globales existentes sin aviso.
- En conflictos de agents, commands u `opencode.json`, muestra diff y pregunta si sobreescribir, saltar o guardar backup.
- No modifica credenciales, auth files, plugins, historiales, sesiones ni proyectos especificos.
- OpenCode queda con permisos globales conservadores: `edit`, `bash` y `external_directory` en `ask`.
- Los comandos OpenCode `/ask-claude` y `/ask-codex` invocan otras herramientas solo tras confirmacion y con modos read-only/plan por defecto.

## Tras La Instalacion

1. Edita `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md` y `~/.config/opencode/AGENTS.md` para rellenar tu perfil.
2. Anade reglas aprendidas en la seccion de errores conocidos cross-proyecto.
3. Prueba un flujo simple en cada herramienta: planificar una tarea, revisar un diff o pedir una consulta read-only.

## Filosofia

- El contexto es caro: delega tareas pesadas o paralelizables a agentes.
- Plan antes que codigo, especialmente en cambios de 3 o mas pasos.
- Verifica antes de cerrar: typecheck, lint, tests, build o QA manual segun el proyecto.
- Las instrucciones globales son memoria viva: cuando una herramienta se equivoque, fija la regla para que no se repita.

## Licencia

MIT.
