---
description: Cierre de sesión completo — diagnóstico, memoria, limpieza, commit
argument-hint: (sin argumentos)
---

Ejecuta el protocolo de cierre de sesión siguiendo mi workflow Boris Cherny.
Hazlo en este orden estricto, sin saltarte pasos, y **pidiéndome confirmación**
antes de acciones destructivas o externas (commit, push, borrar archivos).

Responde en español, conciso. No narres tu deliberación interna — solo el estado
de cada paso al terminarlo.

## 1. Diagnóstico de la sesión
- Repasa la conversación actual: ¿qué errores ocurrieron? ¿qué quedó a medias?
- Lista en bullets: (a) errores resueltos, (b) errores pendientes, (c) trabajo
  incompleto. Si no hubo errores, dilo explícitamente.
- Si hay errores pendientes que puedas arreglar en <3 pasos, propón el fix y
  espera mi OK. No fixees sin permiso.

## 2. Verificación del estado
Ejecuta en paralelo cuando aplique:
- `git status` para ver qué hay sin commitear (sin flag `-uall`)
- `git diff --stat` para ver tamaño del cambio
- Si el proyecto tiene typecheck/lint/tests, lánzalos y reporta resultado.
  Detéctalos mirando `package.json` / `pyproject.toml` / `Makefile` / equivalente.
- Si el repo no es git (working dir suelto), salta este paso y dilo.

## 3. Memoria (auto-memory)
Revisa la sesión y guarda SOLO lo que cumple los criterios del sistema de memoria
global. Recuerda los tipos:
- **feedback**: correcciones o validaciones no obvias que di. Incluye **Why:**
  y **How to apply:**.
- **project**: decisiones, bloqueos, deadlines con fecha absoluta (no "mañana"
  ni "la semana que viene" — conviértelas).
- **user**: detalles nuevos sobre mi rol/preferencias/conocimiento.
- **reference**: punteros a sistemas externos que mencioné (Linear, Grafana,
  Slack, etc.).

NO guardes: patrones de código, estructura del repo, fixes de bugs concretos,
resúmenes de actividad, contenido ya en CLAUDE.md, ni estado efímero. Eso lo
da `git log` o el propio código. Si dudas, NO guardes.

Si detectas memorias nuevas, proponlas con una linea indice por memoria (<150 chars)
y pide confirmacion antes de escribirlas. No crees ni actualices `MEMORY.md` si el
proyecto no lo usa ya o si el usuario no lo aprueba explicitamente.

## 4. Tech debt y limpieza
Invoca el skill `techdebt`: detecta código duplicado o muerto introducido en la
sesión. Lista lo encontrado. **No borres sin mi OK.**

## 5. Optimización del proyecto
Solo si detectas algo concreto y de bajo riesgo:
- Archivos temporales/logs que deberían estar en `.gitignore`
- Dependencias añadidas pero no usadas
- Comentarios `TODO`/`FIXME` que dejé y no anoté en memoria
- Imports muertos, variables sin usar

Propón cambios como diff o lista. No los apliques sin confirmación.

## 6. Commit / push
- Si hay cambios sin commitear: muéstrame el resumen (archivos + intención) y
  pregunta si lanzo `/quick-commit` o `/commit-push-pr`. **Nunca commitees sin
  confirmación explícita.**
- Si la rama está limpia: dilo y salta este paso.
- Si detectas archivos sensibles staged (`.env`, `credentials.*`, claves), avisa
  y **no los incluyas** aunque te diga que commitee.

## 7. Resumen final
Una sola línea por punto, en este formato:
- **Errores:** resueltos X / pendientes Y (lista los pendientes)
- **Tests/lint:** OK / fallando / no aplicable
- **Memorias guardadas:** N (nombres)
- **Tech debt:** sí (qué) / no
- **Commit:** hecho (sha) / pendiente / no aplicable
- **Próxima sesión:** una frase con el next step concreto

Sé conciso. No repitas lo que ya dijiste paso a paso — solo el estado final.
