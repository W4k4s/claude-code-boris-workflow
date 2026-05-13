---
description: Stagea cambios relevantes y crea commit descriptivo
agent: build
---

Crea un commit rapido con mensaje descriptivo, solo si el usuario confirma que quiere commitear.

Pasos:

1. Ejecuta `git status` para ver el estado actual.
2. Ejecuta `git diff` para entender los cambios.
3. Revisa que no se cuelen secretos, credenciales, `.env`, tokens ni binarios no deseados.
4. Stagea solo los ficheros relevantes. Usa `git add -A` solo si todos los cambios son intencionales.
5. Crea un commit con mensaje claro en conventional commits.
6. Usa espanol si el repo esta en espanol.
7. Ejecuta `git status` al final para verificar que el commit se creo correctamente.

No hagas push. No uses `--no-verify`. No hagas amend salvo peticion explicita.
