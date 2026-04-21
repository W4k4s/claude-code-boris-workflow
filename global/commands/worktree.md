---
description: Crea un git worktree para sesión Claude Code paralela
---

Crea un nuevo git worktree para ejecutar una sesión Claude Code en paralelo.

Pasos:

1. Si no se pasó un nombre como argumento, genera uno a partir de la fecha de hoy y un descriptor corto (ej. `2026-04-18-feature`)
2. Ejecuta: `git worktree add .claude/worktrees/$name origin/main`
3. Confirma que el worktree se creó correctamente
4. Imprime el comando de lanzamiento: `cd .claude/worktrees/$name && claude`
5. Recuerda al usuario que también puede usar `claude -w` para arrancar directamente en un worktree
6. Recuerda al usuario que puede listar con `git worktree list` y eliminar con `git worktree remove .claude/worktrees/$name`
