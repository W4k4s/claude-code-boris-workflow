---
description: Crea un git worktree para sesión Claude Code paralela
---

Crea un nuevo git worktree para ejecutar una sesión Claude Code en paralelo.

Pasos:

1. Si no se paso un nombre como argumento, genera uno a partir de fecha y descriptor corto, por ejemplo `2026-04-18-feature`.
2. Normaliza el nombre a slug seguro: minusculas, numeros y guiones. Rechaza rutas absolutas, `..`, espacios y separadores `/`.
3. Comprueba la rama base adecuada (`origin/main` o `origin/master`).
4. Comprueba que `.claude/worktrees/<name>` no existe y que la rama `worktree/<name>` no existe.
5. Ejecuta: `git worktree add -b worktree/<name> .claude/worktrees/<name> <base>`.
6. Confirma que el worktree se creo correctamente.
7. Imprime el comando de lanzamiento: `cd .claude/worktrees/<name> && claude`.
8. Recuerda al usuario que tambien puede usar `claude -w` para arrancar directamente en un worktree.
9. Recuerda que se puede listar con `git worktree list` y eliminar con `git worktree remove .claude/worktrees/<name>`.

No crees worktrees en detached HEAD. No elimines worktrees existentes sin confirmacion explicita.
