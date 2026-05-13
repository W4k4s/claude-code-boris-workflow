---
name: boris-quick-commit
description: Commit rapido y seguro. Usalo cuando el usuario pida crear un commit con los cambios actuales.
---

Crea un commit rapido con mensaje descriptivo.

Pasos:

1. Confirma que el usuario ha pedido commitear explicitamente.
2. Ejecuta `git status` para ver cambios y untracked.
3. Ejecuta `git diff` para entender los cambios.
4. Revisa que no se incluyan secretos, credenciales, `.env`, tokens ni binarios no deseados.
5. Stagea solo ficheros relevantes. Usa `git add -A` solo si todos los cambios son intencionales.
6. Crea un commit con mensaje claro en conventional commits.
7. Usa espanol si el repo esta en espanol.
8. Ejecuta `git status` al final para verificar exito.

No hagas push. No uses `--no-verify`. No hagas amend salvo peticion explicita o caso seguro acordado.
