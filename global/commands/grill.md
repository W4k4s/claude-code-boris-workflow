---
description: Review adversarial de los cambios pendientes — no dejes que shippee si no pasa
---

Review adversarial. No me dejes shippear hasta que los cambios pasen tu escrutinio.

Pasos:

1. Determina la rama base (main o master)
2. Ejecuta `git diff <base>...HEAD` para ver todos los cambios de esta rama
3. Revisa cada cambio como un ingeniero staff escéptico:
   - Errores de lógica, casos borde, condiciones de carrera
   - Tests ausentes para comportamiento nuevo o cambiado
   - Cambios breaking en APIs públicas
   - Preocupaciones de seguridad (inyección, auth, exposición de datos)
   - Regresiones de rendimiento
4. Emite veredicto: **SHIP IT** / **NEEDS WORK** / **BLOCK**
5. Si NEEDS WORK o BLOCK: lista cada issue con fichero, línea y cómo arreglarlo
6. Tras mis fixes, re-revisa desde el paso 1
7. Solo da SHIP IT cuando cada issue esté resuelto
