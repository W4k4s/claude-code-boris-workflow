---
name: boris-review-changes
description: Revisa cambios sin commitear. Usalo para revisar working tree local antes de testear o commitear.
---

Revisa cambios pendientes sin commitear.

Pasos:

1. Ejecuta `git status` para ver el estado.
2. Ejecuta `git diff` para revisar cambios reales.
3. Analiza correccion, completitud, bugs potenciales, convenciones del proyecto, seguridad y manejo de errores.
4. Entrega findings primero, ordenados por severidad, con fichero y linea.
5. Si no hay findings, dilo explicitamente y menciona riesgos residuales o tests pendientes.
6. Cierra con siguientes pasos recomendados.

No modifiques archivos salvo peticion explicita.
