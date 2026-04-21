# Metodología base Boris Cherny (global)

Este archivo se carga en TODAS las sesiones de Claude Code. Los CLAUDE.md de cada proyecto lo extienden con información específica.

Sustituye o amplía la sección "Tu perfil" con tus datos. El resto puedes dejarlo tal cual.

## Tu perfil
<!-- Rellena con tus datos. Ejemplo:
- **Nombre:** Nombre Apellidos ("Alias")
- **GitHub:** handle
- **Email:** tu@email
- **Timezone:** Europe/Madrid (GMT+1)
- **Idioma:** Español (castellano). Directo, sin formalidades.
- **Modelos:** Sonnet día a día, Opus cuando haga falta. `/new` frecuente.
-->

## Convenciones base
- Responder en el idioma que prefiera el usuario (define arriba).
- Priorizar seguridad: nunca force-push sin confirmación, nunca commitear secrets.
- Usar herramientas nativas de Claude Code antes que soluciones third-party.
- `trash` > `rm` — preferir borrado recuperable cuando esté disponible.
- Preguntar antes de enviar emails, mensajes o cualquier acción externa.
- Chunked tasks: planificar → ejecutar → `/new` → continuar.

## Metodología de trabajo

### Plan mode primero
Tareas no triviales (3+ pasos) empiezan en plan mode (`shift+tab` x2). Itera el plan; no codees hasta que quede claro. Si la implementación se tuerce, vuelve a plan mode en vez de insistir.

### Verificar antes de cerrar
Tras escribir código: typecheck/lint/tests si existen. Para UI: arrancar dev server y probar en navegador. No marques tarea completada sin haberlo probado. Cada proyecto puede añadir verificaciones específicas en su propio CLAUDE.md.

### Subagents para limpiar contexto
Agents globales en `~/.claude/agents/`:
- `staff-reviewer` — revisa planes antes de implementar (escéptico, emite APROBAR/PEDIR CAMBIOS/REPLANTEAR)
- `code-simplifier` — simplifica tras escribir, sin cambiar comportamiento
- `code-architect` — diseño y refactors grandes

Usa subagents cuando la tarea pese mucho en el contexto principal, o para paralelizar trabajo independiente.

### Comandos globales (`~/.claude/commands/`)
`/grill` review adversarial pre-ship • `/review-changes` revisar sin commitear • `/quick-commit` commit rápido • `/commit-push-pr` flow completo hasta PR • `/techdebt` limpieza fin sesión • `/worktree` git worktree paralelo

### Auto-mejora
Cuando Claude haga algo mal, actualizar CLAUDE.md (global o del proyecto) con una regla para que no se repita. Frase útil: "ahora actualiza CLAUDE.md para que no vuelvas a cometer ese error".

### Session management
`/branch` fork sesión • `/btw` query paralela sin interrumpir • `/teleport` mover sesión cloud→local • `/remote-control` controlar desde móvil

## Errores conocidos cross-proyecto
<!-- Añade aquí reglas aprendidas que apliquen a todos tus proyectos. Ejemplos:
- **Sub-agentes en el mismo repo:** trabajan secuencialmente o en clones separados, no en paralelo.
-->
