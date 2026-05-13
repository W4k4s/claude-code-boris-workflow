---
description: Commit, push y abre PR con el cambio actual
agent: build
---

Ejecuta el flujo completo hasta Pull Request, parando ante cualquier problema.

Pasos:

1. Ejecuta `git status` para ver que ha cambiado.
2. Ejecuta `git diff` para revisar cambios.
3. Comprueba rama actual, remoto y si la rama ya existe en origin.
4. Si estas en `main` o `master`, pregunta antes de crear una rama descriptiva.
5. Stagea solo ficheros relevantes y evita secretos o binarios grandes.
6. Crea commit con mensaje conventional commits.
7. Push a remoto con `-u origin <branch>` si hace falta.
8. Crea PR con `gh pr create`, incluyendo summary, testing y notas para reviewers.
9. Devuelve la URL del PR.

No fuerces push. No uses `--no-verify`. Si falla un hook, arregla el problema y crea un commit nuevo, no hagas amend salvo caso seguro y aprobado.
