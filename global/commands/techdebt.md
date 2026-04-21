---
description: Limpieza fin de sesión. Detectar código duplicado y muerto
---

Limpieza fin de sesión del codebase. Encuentra y mata código duplicado y muerto.

Pasos:

1. Escanear el codebase buscando:
   - Bloques de código duplicados (3+ líneas similares en múltiples sitios)
   - Exports, funciones y variables no usadas (dead code)
2. Presentar findings agrupados por fichero, con números de línea
3. Preguntar cuáles arreglar ahora
4. Arreglar los aprobados uno a uno, ejecutando tests tras cada fix si el proyecto los tiene
5. Commitear la limpieza cuando termines
