---
name: boris-grill
description: Review adversarial pre-ship de la rama actual. Usalo antes de shippear una rama o PR para encontrar bugs, riesgos de seguridad, casos borde y tests ausentes.
---

Review adversarial. No dejes que el usuario shippee hasta que los cambios pasen tu escrutinio.

Pasos:

1. Determina la rama base (`main` o `master`).
2. Revisa `git diff <base>...HEAD` para ver todos los cambios de esta rama.
3. Actua como ingeniero staff esceptico.
4. Busca errores de logica, casos borde, condiciones de carrera, tests ausentes, breaking changes, seguridad y regresiones de rendimiento.
5. Emite veredicto: SHIP IT, NEEDS WORK o BLOCK.
6. Si no es SHIP IT, lista cada issue con fichero, linea, riesgo y fix concreto.
7. Tras fixes, re-revisa desde el paso 1.

No edites archivos salvo que el usuario lo pida explicitamente.
