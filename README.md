# claude-code-boris-workflow

Workflow global para Claude Code basado en la metodología de Boris Cherny (creador de Claude Code):

- **Plan mode primero** en tareas no triviales.
- **Subagents** (`staff-reviewer`, `code-simplifier`, `code-architect`) para aislar tareas sin ensuciar el contexto principal.
- **Commands globales** (`/grill`, `/techdebt`, `/commit-push-pr`, etc.) para operaciones recurrentes.
- **Auto-mejora**: cuando el agente falla, se actualiza `CLAUDE.md` con una regla para que no vuelva a pasar.

Se instala una sola vez en `~/.claude/` y queda disponible para **todos** tus proyectos Claude Code (abras donde abras).

## Instalación

### Opción 1 · Agéntica (recomendada)
Abre Claude Code en cualquier directorio y pega este prompt:

```
Lee https://github.com/W4k4s/claude-code-boris-workflow — especialmente AGENT-INSTALL.md — y aplícalo en mi Claude Code.
Si ya tengo archivos en ~/.claude/agents/ o ~/.claude/commands/ con el mismo nombre, muéstramelos antes de sobreescribir.
Al terminar, haz un resumen de qué instalaste y qué dejaste intacto.
```

Claude Code clonará el repo, revisará colisiones y te dejará los agents, commands y CLAUDE.md en su sitio.

### Opción 2 · Bash (manual)

```bash
curl -fsSL https://raw.githubusercontent.com/W4k4s/claude-code-boris-workflow/main/install.sh | bash
```

El script copia `global/*` a `~/.claude/` respetando lo que ya exista (pide confirmación en conflictos).

### Opción 3 · Clonar y copiar manualmente

```bash
git clone https://github.com/W4k4s/claude-code-boris-workflow.git
cd claude-code-boris-workflow
cp -i -r global/agents   ~/.claude/
cp -i -r global/commands ~/.claude/
cp -i    global/CLAUDE.md ~/.claude/CLAUDE.md
```

## Qué instala

```
~/.claude/
├── CLAUDE.md                  # metodología + placeholder para tu perfil
├── agents/
│   ├── staff-reviewer.md      # revisor escéptico pre-implementación
│   ├── code-simplifier.md     # simplifica sin cambiar comportamiento
│   └── code-architect.md      # diseño y refactors grandes
└── commands/
    ├── grill.md               # review adversarial pre-ship
    ├── review-changes.md      # diff review sin commit
    ├── quick-commit.md        # commit rápido con mensaje auto
    ├── commit-push-pr.md      # flujo completo hasta PR
    ├── techdebt.md            # limpieza fin de sesión
    ├── worktree.md            # git worktree paralelo
    └── cierre-sesion.md       # cierre completo de sesión
```

Tras la instalación:
1. Edita `~/.claude/CLAUDE.md` y rellena la sección "Tu perfil" con tus datos.
2. Opcional: añade en "Errores conocidos cross-proyecto" reglas que hayas aprendido.

## Filosofía

- **El contexto es caro.** Delega tareas pesadas o paralelizables a subagents.
- **Plan antes que código.** Especialmente cuando la tarea tiene 3+ pasos.
- **Verifica antes de cerrar.** Typecheck/lint/tests, dev server para UI. Si no lo has probado, no está hecho.
- **El CLAUDE.md es memoria viva.** Cuando Claude se equivoque, fija la regla para que no se repita.

Más detalle sobre la metodología en el canal de YouTube y blogs de Boris Cherny.

## Licencia

MIT.
