---
description: Limpieza fin de sesion; detecta codigo duplicado y muerto
agent: build
---

Limpieza fin de sesion del codebase. Encuentra y elimina solo lo aprobado.

Pasos:

1. Escanea el codebase buscando bloques duplicados, exports no usados, funciones no usadas, variables no usadas y codigo muerto.
2. Presenta findings agrupados por fichero con numeros de linea.
3. Pregunta cuales arreglar ahora.
4. Aplica solo los fixes aprobados, uno a uno.
5. Ejecuta tests, lint o typecheck relevantes tras los cambios si existen.
6. Pregunta antes de commitear la limpieza.

No borres archivos ni cambies comportamiento sin confirmacion explicita.
