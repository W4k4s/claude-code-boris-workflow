---
name: quick-commit
description: Stagea cambios relevantes y crea un commit descriptivo cuando el usuario lo pide explicitamente.
disable-model-invocation: true
---

1. Confirma que el usuario ha pedido commitear explicitamente.
2. Ejecuta `git status` para ver el estado actual, incluidos untracked.
3. Ejecuta `git diff` para entender los cambios.
4. Revisa que no se cuelen secretos, credenciales, `.env`, tokens ni binarios no deseados.
5. Stagea solo los ficheros relevantes. Usa `git add -A` solo si todos los cambios son intencionales.
6. Crea un commit con mensaje claro que:
   - Empiece con un tipo: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`.
   - Describa brevemente que cambio.
   - Use modo imperativo: "Add feature", no "Added feature".
   - Use espanol cuando el repo este en espanol.
7. Ejecuta `git status` al final para verificar que el commit se creo correctamente.

Ejemplo: `feat: anadir busqueda por EAN en blog TCG`

No hagas push. No uses `--no-verify`. No hagas amend salvo peticion explicita.
