---
name: cierre-sesion
description: Cierre completo de sesion: diagnostico, verificacion, memoria, limpieza y siguiente paso.
argument-hint: (sin argumentos)
disable-model-invocation: true
---

Ejecuta el protocolo de cierre de sesion siguiendo mi workflow Boris Cherny.
Hazlo en este orden estricto, sin saltarte pasos, y pidiendome confirmacion antes de acciones destructivas o externas: commit, push, borrar archivos.

Responde en espanol, conciso. No narres tu deliberacion interna; solo el estado de cada paso al terminarlo.

## 1. Diagnostico de la sesion

- Repasa la conversacion actual: que errores ocurrieron y que quedo a medias.
- Lista en bullets: errores resueltos, errores pendientes y trabajo incompleto. Si no hubo errores, dilo explicitamente.
- Si hay errores pendientes que puedas arreglar en menos de 3 pasos, propon el fix y espera mi OK. No fixees sin permiso.

## 2. Verificacion del estado

Ejecuta en paralelo cuando aplique:

- `git status` para ver que hay sin commitear, sin flag `-uall`.
- `git diff --stat` para ver tamano del cambio.
- Si el proyecto tiene typecheck/lint/tests, lanzalos y reporta resultado. Detectalos mirando `package.json`, `pyproject.toml`, `Makefile` o equivalente.
- Si el repo no es git, salta este paso y dilo.

## 3. Memoria

Revisa la sesion y guarda solo lo que cumple los criterios del sistema de memoria global.

Tipos validos:

- **feedback**: correcciones o validaciones no obvias que di. Incluye **Why:** y **How to apply:**.
- **project**: decisiones, bloqueos, deadlines con fecha absoluta.
- **user**: detalles nuevos sobre mi rol, preferencias o conocimiento.
- **reference**: punteros a sistemas externos mencionados, como Linear, Grafana o Slack.

No guardes patrones de codigo, estructura del repo, fixes de bugs concretos, resumenes de actividad, contenido ya en CLAUDE.md ni estado efimero.

Si detectas memorias nuevas, proponlas con una linea indice por memoria de menos de 150 caracteres y pide confirmacion antes de escribirlas. No crees ni actualices `MEMORY.md` si el proyecto no lo usa ya o si el usuario no lo aprueba explicitamente.

## 4. Tech debt y limpieza

Invoca el skill `techdebt`: detecta codigo duplicado o muerto introducido en la sesion. Lista lo encontrado. No borres sin mi OK.

## 5. Optimizacion del proyecto

Solo si detectas algo concreto y de bajo riesgo:

- Archivos temporales/logs que deberian estar en `.gitignore`.
- Dependencias anadidas pero no usadas.
- Comentarios `TODO`/`FIXME` que deje y no anote en memoria.
- Imports muertos o variables sin usar.

Propone cambios como diff o lista. No los apliques sin confirmacion.

## 6. Commit / push

- Si hay cambios sin commitear: muestrame el resumen, archivos e intencion, y pregunta si lanzo `/quick-commit` o `/commit-push-pr`. Nunca commitees sin confirmacion explicita.
- Si la rama esta limpia: dilo y salta este paso.
- Si detectas archivos sensibles staged como `.env`, `credentials.*` o claves, avisa y no los incluyas aunque te diga que commitee.

## 7. Resumen final

Una sola linea por punto, en este formato:

- **Errores:** resueltos X / pendientes Y (lista los pendientes)
- **Tests/lint:** OK / fallando / no aplicable
- **Memorias guardadas:** N (nombres)
- **Tech debt:** si (que) / no
- **Commit:** hecho (sha) / pendiente / no aplicable
- **Proxima sesion:** una frase con el next step concreto

Se conciso. No repitas lo que ya dijiste paso a paso; solo el estado final.
