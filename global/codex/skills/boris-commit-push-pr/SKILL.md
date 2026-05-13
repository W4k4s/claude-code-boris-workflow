---
name: boris-commit-push-pr
description: Flujo completo commit, push y PR. Usalo cuando el usuario pida publicar los cambios y abrir Pull Request.
---

Ejecuta el flujo completo hasta Pull Request, parando ante cualquier problema.

Pasos:

1. Confirma que el usuario ha pedido commit/push/PR explicitamente.
2. Ejecuta `git status` y `git diff`.
3. Comprueba rama actual, remoto y si la rama ya existe en origin.
4. Si estas en `main` o `master`, pregunta antes de crear una rama descriptiva.
5. Stagea solo ficheros relevantes y evita secretos o binarios grandes.
6. Crea commit con mensaje conventional commits.
7. Push a remoto con `-u origin <branch>` si hace falta.
8. Crea PR con `gh pr create`, incluyendo summary, testing y notas para reviewers.
9. Devuelve la URL del PR.

No fuerces push. No uses `--no-verify`. Si falla un hook, arregla el problema y crea un commit nuevo; no hagas amend salvo caso seguro y aprobado.
