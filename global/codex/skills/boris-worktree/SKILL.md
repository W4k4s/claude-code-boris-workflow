---
name: boris-worktree
description: Crea un git worktree para una sesion paralela. Usalo cuando el usuario quiera aislar una tarea en otra copia del repo.
---

Crea un nuevo git worktree para ejecutar una sesion Codex o de otra herramienta en paralelo.

Pasos:

1. Si no se paso un nombre, genera uno a partir de fecha y descriptor corto.
2. Comprueba la rama base adecuada (`origin/main` o `origin/master`).
3. Ejecuta `git worktree add .codex/worktrees/<name> <base>`.
4. Confirma que el worktree se creo correctamente.
5. Imprime el comando de lanzamiento: `codex -C .codex/worktrees/<name>`.
6. Recuerda que se puede listar con `git worktree list` y eliminar con `git worktree remove .codex/worktrees/<name>`.

No elimines worktrees existentes sin confirmacion explicita.
