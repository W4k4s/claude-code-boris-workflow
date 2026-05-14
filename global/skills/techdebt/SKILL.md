---
name: techdebt
description: Limpieza fin de sesion para detectar codigo duplicado, muerto y deuda tecnica de bajo riesgo.
disable-model-invocation: true
---

Limpieza fin de sesion del codebase. Encuentra codigo duplicado y muerto.

Pasos:

1. Escanea el codebase buscando:
   - Bloques de codigo duplicados: 3+ lineas similares en multiples sitios.
   - Exports, funciones y variables no usadas.
2. Presenta findings agrupados por fichero, con numeros de linea.
3. Pregunta cuales arreglar ahora.
4. Arregla los aprobados uno a uno, ejecutando tests tras cada fix si el proyecto los tiene.
5. No commitees la limpieza salvo confirmacion explicita del usuario.
