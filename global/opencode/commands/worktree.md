---
description: Crea un git worktree para una sesion paralela
agent: build
---

Crea un nuevo git worktree para ejecutar una sesion paralela.

Pasos:

1. Si no se paso un nombre como argumento, genera uno a partir de fecha y descriptor corto.
2. Comprueba la rama base adecuada (`origin/main` o `origin/master`).
3. Ejecuta `git worktree add .opencode/worktrees/$ARGUMENTS <base>` o propone un nombre si `$ARGUMENTS` esta vacio.
4. Confirma que el worktree se creo correctamente.
5. Imprime el comando de lanzamiento: `opencode .opencode/worktrees/<name>`.
6. Recuerda que se puede listar con `git worktree list` y eliminar con `git worktree remove .opencode/worktrees/<name>`.

No elimines worktrees existentes sin confirmacion explicita.
