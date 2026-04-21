---
description: Stagea todos los cambios y crea commit con mensaje descriptivo
---

1. `git status` para ver el estado actual
2. `git diff` para entender los cambios
3. Stagea todo con `git add -A` (pero revisa antes que no se cuelen secrets ni binarios no deseados)
4. Crea un commit con mensaje claro que:
   - Empiece con un tipo (feat:, fix:, refactor:, docs:, test:, chore:)
   - Describa brevemente qué cambió
   - Use modo imperativo ("Add feature", no "Added feature")
   - En español cuando el repo esté en español

Ejemplo: `feat: añadir busqueda por EAN en blog TCG`
