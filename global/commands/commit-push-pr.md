---
description: Commit, push y abre PR con el cambio actual
---

Ejecuta el flujo completo hasta Pull Request, parando ante cualquier problema.

Pasos:

1. Confirma que el usuario ha pedido commit, push y PR explicitamente.
2. Ejecuta `git status` para ver que ha cambiado.
3. Ejecuta `git diff` para revisar cambios.
4. Comprueba rama actual, remoto y si la rama ya existe en origin.
5. Si estas en `main` o `master`, pregunta antes de crear una rama descriptiva.
6. Stagea solo ficheros relevantes y evita secretos o binarios grandes.
7. Crea commit con mensaje conventional commits.
8. Push a remoto con `-u origin <branch>` si hace falta.
9. Crea PR con `gh pr create`, incluyendo summary, testing y notas para reviewers.
10. Devuelve la URL del PR.

No fuerces push. No uses `--no-verify`. Si falla un hook, arregla el problema y crea un commit nuevo; no hagas amend salvo caso seguro y aprobado.
