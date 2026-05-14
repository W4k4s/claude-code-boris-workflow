---
description: Stagea cambios relevantes y crea commit descriptivo
---

1. Confirma que el usuario ha pedido commitear explicitamente.
2. `git status` para ver el estado actual, incluidos untracked.
3. `git diff` para entender los cambios.
4. Revisa que no se cuelen secretos, credenciales, `.env`, tokens ni binarios no deseados.
5. Stagea solo los ficheros relevantes. Usa `git add -A` solo si todos los cambios son intencionales.
6. Crea un commit con mensaje claro que:
   - Empiece con un tipo (feat:, fix:, refactor:, docs:, test:, chore:)
   - Describa brevemente qué cambió
   - Use modo imperativo ("Add feature", no "Added feature")
   - En español cuando el repo esté en español
7. Ejecuta `git status` al final para verificar que el commit se creo correctamente.

Ejemplo: `feat: añadir busqueda por EAN en blog TCG`

No hagas push. No uses `--no-verify`. No hagas amend salvo peticion explicita.
