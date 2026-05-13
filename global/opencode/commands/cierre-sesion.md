---
description: Cierre completo de sesion con diagnostico, verificacion y siguiente paso
agent: build
---

Ejecuta el protocolo de cierre de sesion siguiendo el workflow Boris.

Hazlo en orden y pide confirmacion antes de acciones destructivas o externas como commit, push o borrar archivos.

Pasos:

1. Diagnostico: lista errores resueltos, errores pendientes y trabajo incompleto.
2. Verificacion: ejecuta `git status`, `git diff --stat` y tests/lint/typecheck si existen.
3. Memoria: identifica solo reglas o preferencias reutilizables que merezcan persistir en instrucciones globales o del proyecto. No guardes resumen efimero de actividad.
4. Tech debt: detecta duplicacion o codigo muerto introducido en la sesion. No borres sin OK.
5. Optimizacion: propone cambios de bajo riesgo como `.gitignore`, imports muertos o dependencias no usadas. No apliques sin OK.
6. Commit/push: si hay cambios, muestra resumen y pregunta si ejecutar quick commit o PR flow. Nunca commitees sin confirmacion explicita.
7. Resumen final: una linea por errores, tests/lint, memorias, tech debt, commit y proxima sesion.

Responde en espanol y conciso.
