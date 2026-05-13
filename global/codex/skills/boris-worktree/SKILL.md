---
name: boris-worktree
description: Crea un git worktree para una sesion paralela. Usalo cuando el usuario quiera aislar una tarea en otra copia del repo.
---

Crea un nuevo git worktree para ejecutar una sesion Codex o de otra herramienta en paralelo.

Pasos:

1. Si no se paso un nombre, genera uno a partir de fecha y descriptor corto.
2. Normaliza el nombre a slug seguro: minusculas, numeros y guiones. Rechaza rutas absolutas, `..`, espacios y separadores `/`.
3. Comprueba la rama base adecuada (`origin/main` o `origin/master`).
4. Comprueba que `.codex/worktrees/<name>` no existe y que la rama `worktree/<name>` no existe.
5. Ejecuta `git worktree add -b worktree/<name> .codex/worktrees/<name> <base>`.
6. Confirma que el worktree se creo correctamente.
7. Imprime el comando de lanzamiento: `codex -C .codex/worktrees/<name>`.
8. Recuerda que se puede listar con `git worktree list` y eliminar con `git worktree remove .codex/worktrees/<name>`.

No crees worktrees en detached HEAD. No elimines worktrees existentes sin confirmacion explicita.
