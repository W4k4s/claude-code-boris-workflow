---
description: Crea un git worktree para una sesion paralela
agent: build
---

Crea un nuevo git worktree para ejecutar una sesion paralela.

Pasos:

1. Si no se paso un nombre como argumento, genera uno a partir de fecha y descriptor corto.
2. Normaliza el nombre a slug seguro: minusculas, numeros y guiones. Rechaza rutas absolutas, `..`, espacios y separadores `/`.
3. Comprueba la rama base adecuada (`origin/main` o `origin/master`).
4. Comprueba que `.opencode/worktrees/<name>` no existe y que la rama `worktree/<name>` no existe.
5. Ejecuta `git worktree add -b worktree/<name> .opencode/worktrees/<name> <base>`.
6. Confirma que el worktree se creo correctamente.
7. Imprime el comando de lanzamiento: `opencode .opencode/worktrees/<name>`.
8. Recuerda que se puede listar con `git worktree list` y eliminar con `git worktree remove .opencode/worktrees/<name>`.

No crees worktrees en detached HEAD. No elimines worktrees existentes sin confirmacion explicita.
