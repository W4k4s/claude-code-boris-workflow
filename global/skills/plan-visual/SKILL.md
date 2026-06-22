---
name: plan-visual
description: Convierte un plan en artefacto HTML particionado por unidades de trabajo, revisado por staff-reviewer y listo para ejecución multi-agente con contexto limpio.
disable-model-invocation: true
---

Cierra el ciclo Boris de planificación: planner -> evaluator -> artefacto HTML -> handoff con contexto limpio. Asume que YA hay un plan (o que vienes de plan mode). Reutiliza piezas que ya existen: el subagente `staff-reviewer`, la skill `artifact-design`, la tool `Artifact` y el directorio `~/.claude/plans/`.

Pasos:

0. **Check del setting.** Comprueba si `~/.claude/settings.json` tiene activo `showClearContextOnPlanAccept` (clave a NIVEL RAÍZ del JSON, NO anidada bajo `permissions`). Casos:
   - No existe el fichero, o no existe la clave: OFRECE activarlo, pero NO toques nada sin permiso explícito del usuario. Si dice que sí, haz MERGE preservando todo lo demás (lee el JSON, añade la clave raíz `"showClearContextOnPlanAccept": true` sin pisar ninguna otra clave del fichero; si el fichero no existe, créalo con solo esa clave).
   - Ya está activo: sigue.
   Esto cubre el caso "el usuario ya tenía settings.json y el instalador no lo tocó". Nunca sobreescribas otras claves.

1. **Particionar (planner).** Reescribe el plan en **Unidades de Trabajo (WU)**. Cada WU debe tener:
   - (a) los ficheros que toca, con fronteras DISJUNTAS entre WU (dos WU no comparten fichero; si lo comparten, repártelo de otra forma o fusiónalas).
   - (b) dependencias explícitas entre WU (qué WU debe terminar antes de empezar esta).
   - (c) criterio de verificación por WU (qué comprobar para darla por buena).
   Presenta una tabla:
   `| WU | Qué | Ficheros (disjuntos) | Depende de | Verificación |`
   Esto es lo que hace el plan ejecutable en paralelo sin que dos agentes se pisen.

2. **Revisar (evaluator).** Lanza el subagente `staff-reviewer` (vía la tool Agent / Task) sobre el plan particionado. Itera aplicando su feedback hasta que emita **APROBAR**. El reviewer evalúa además la *paralelizabilidad*: fronteras de ficheros realmente disjuntas, dependencias declaradas y completas, y verificación concreta por WU. No pases del paso 2 sin APROBAR.

3. **Renderizar (HTML).** Invoca la skill `artifact-design` para el diseño y luego la tool `Artifact` para publicar el plan como página HTML autocontenida. La página debe incluir: resumen ejecutivo, mockups o fragmentos de código si aplican, la **tabla de WU**, y un **grafo/diagrama de dependencias** que deje claro qué corre en paralelo y qué en serie. Pide confirmación antes de publicar (publicar es una acción externa). El Markdown canónico del plan se guarda SIEMPRE en `~/.claude/plans/<slug>.md`.
   - **Degradación documentada:** la tool `Artifact` requiere plan de cuenta Team/Enterprise. Si no está disponible, degrada a guardar el HTML como fichero local en `~/.claude/plans/<slug>.html` y dile al usuario cómo abrirlo en el navegador (`file://` o `xdg-open`).

4. **Handoff (contexto limpio).** Recuerda o dispara el flujo `/new` para ejecutar con el contexto limpio, apoyándote en el setting `showClearContextOnPlanAccept` del paso 0. Como el alcance de esta iteración es SOLO planner, NO lances subagentes ejecutores: explica cómo ejecutar las WU:
   - a mano, WU por WU respetando el grafo de dependencias,
   - o pasando las WU a la tool `Workflow`,
   - o repartiéndolas a N subagentes (una WU por agente), lanzando en paralelo solo las que no dependan entre sí.

**Fuera de alcance:** el ejecutor multi-agente (`generator`) es un follow-up. Esta skill deja el plan LISTO para ejecutarse; no lo dispara.
