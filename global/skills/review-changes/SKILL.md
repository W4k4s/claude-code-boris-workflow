---
name: review-changes
description: Revisa cambios locales sin commitear y sugiere mejoras.
disable-model-invocation: true
---

1. Ejecuta `git status` para ver que ha cambiado.
2. Ejecuta `git diff` para ver los cambios reales.
3. Para cada fichero modificado, analiza:
   - Si el cambio es correcto y completo.
   - Si hay bugs potenciales.
   - Si sigue las convenciones del proyecto.
   - Si hay preocupaciones de seguridad.
   - Si el manejo de errores es adecuado.
4. Entrega un resumen con:
   - Que esta bien.
   - Cualquier preocupacion o sugerencia.
   - Siguientes pasos recomendados: testear, commitear o hacer cambios.
