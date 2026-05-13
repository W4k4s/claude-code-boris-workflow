---
description: Revisa cambios sin commitear y sugiere mejoras
agent: plan
---

Revisa los cambios pendientes sin commitear.

Pasos:

1. Ejecuta `git status` para ver que ha cambiado.
2. Ejecuta `git diff` para ver los cambios reales.
3. Para cada fichero modificado, analiza correccion, completitud, bugs potenciales, convenciones del proyecto, seguridad y manejo de errores.
4. Entrega findings primero, ordenados por severidad, con referencias de fichero y linea.
5. Si no hay findings, dilo explicitamente y menciona riesgos residuales o tests que faltan.
6. Cierra con siguientes pasos recomendados: testear, cambiar algo o commitear.

No modifiques archivos durante esta review salvo peticion explicita.
