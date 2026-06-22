---
description: Convierte un plan en artefacto HTML particionado por unidades de trabajo, revisado por staff-reviewer y listo para ejecución multi-agente con contexto limpio
---

Cierra el ciclo Boris de planificación: planner -> evaluator -> artefacto HTML -> handoff con contexto limpio. Asume que ya hay un plan (o vienes de plan mode). Reutiliza lo existente: `staff-reviewer`, la skill `artifact-design`, la tool `Artifact` y `~/.claude/plans/`.

Pasos:

0. **Check del setting.** Mira si `~/.claude/settings.json` tiene la clave `showClearContextOnPlanAccept` a NIVEL RAÍZ (no bajo `permissions`). Si falta el fichero o la clave, OFRECE activarlo (merge sin pisar otras claves) pero solo con permiso explícito del usuario.
1. **Particionar (planner).** Reescribe el plan en **Unidades de Trabajo (WU)** con ficheros de fronteras DISJUNTAS, dependencias explícitas y verificación por WU. Tabla: `| WU | Qué | Ficheros (disjuntos) | Depende de | Verificación |`.
2. **Revisar (evaluator).** Lanza `staff-reviewer` sobre el plan particionado; itera hasta **APROBAR**. Evalúa también la paralelizabilidad (fronteras disjuntas, deps declaradas, verificación concreta).
3. **Renderizar (HTML).** Invoca `artifact-design` y luego la tool `Artifact` para publicar página autocontenida: resumen ejecutivo, código/mockups si aplican, tabla de WU y grafo de dependencias (paralelo vs. serie). Pide confirmación antes de publicar. Guarda SIEMPRE el Markdown canónico en `~/.claude/plans/<slug>.md`. Si `Artifact` no está disponible (requiere Team/Enterprise), degrada a `~/.claude/plans/<slug>.html` y explica cómo abrirlo.
4. **Handoff (contexto limpio).** Recuerda o dispara `/new` apoyándote en `showClearContextOnPlanAccept`. NO lances ejecutores: explica cómo ejecutar las WU (a mano, vía tool `Workflow`, o N subagentes con una WU por agente respetando el grafo de dependencias).

**Fuera de alcance:** el ejecutor multi-agente (`generator`) es follow-up. Esta skill deja el plan listo, no lo dispara.
