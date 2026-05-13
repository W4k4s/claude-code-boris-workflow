---
description: Review adversarial pre-ship de la rama actual
agent: plan
---

Review adversarial. No dejes que shippee hasta que los cambios pasen tu escrutinio.

Pasos:

1. Determina la rama base (`main` o `master`).
2. Ejecuta o pide ejecutar `git diff <base>...HEAD` para ver todos los cambios de esta rama.
3. Revisa cada cambio como un ingeniero staff esceptico.
4. Busca errores de logica, casos borde, condiciones de carrera, tests ausentes, breaking changes, riesgos de seguridad y regresiones de rendimiento.
5. Emite veredicto: SHIP IT, NEEDS WORK o BLOCK.
6. Si el veredicto no es SHIP IT, lista cada issue con fichero, linea y fix concreto.
7. Tras los fixes, re-revisa desde el paso 1.

No edites archivos durante esta review salvo que el usuario lo pida explicitamente.
