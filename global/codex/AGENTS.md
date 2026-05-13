# Metodologia base Boris Cherny para Codex

Este archivo se carga en todas las sesiones de Codex. Los `AGENTS.md` de cada proyecto lo extienden con informacion especifica.

Sustituye o amplia la seccion "Perfil" con tus datos. El resto puedes dejarlo tal cual.

## Perfil
<!-- Rellena con tus datos. Ejemplo:
- Nombre: Nombre Apellidos ("Alias").
- GitHub: handle.
- Email: tu@email.
- Timezone: Europe/Madrid.
- Idioma: espanol castellano, directo y sin formalidades.
- Modelos: GPT para trabajo diario; razonamiento alto cuando haga falta.
-->

## Convenciones Base
- Responde en el idioma preferido por el usuario.
- Prioriza seguridad: nunca hagas force-push sin confirmacion, nunca commitees secretos.
- Usa herramientas nativas del entorno antes que soluciones third-party.
- Prefiere borrado recuperable sobre borrado destructivo cuando este disponible.
- Pregunta antes de enviar emails, mensajes o realizar acciones externas.
- Para tareas largas, trabaja por chunks: planificar, ejecutar, verificar y cerrar.

## Metodologia De Trabajo
- En tareas no triviales de 3 o mas pasos, empieza en modo plan: entiende el repo, propone plan, identifica riesgos y no implementes hasta que el enfoque sea claro.
- Si la implementacion se tuerce, vuelve a planificar en vez de insistir con parches acumulados.
- Tras escribir codigo, verifica con typecheck, lint, tests o build si existen.
- Para UI, arranca el servidor de desarrollo y valida en navegador cuando sea posible.
- No marques una tarea como completada sin haberla probado o sin explicar por que no se pudo verificar.

## Subagentes
- Usa subagentes cuando la tarea pese mucho en el contexto principal o sea paralelizable.
- `staff-reviewer`: revisa planes antes de implementar; busca riesgos, sobreingenieria y requisitos ambiguos; emite APROBAR, PEDIR CAMBIOS o REPLANTEAR.
- `code-simplifier`: simplifica codigo recien escrito sin cambiar comportamiento.
- `code-architect`: disena features complejas, refactors grandes y analiza trade-offs.
- No ejecutes subagentes en paralelo sobre el mismo working tree si van a editar archivos; usa worktrees separados.

## Skills Boris
- Usa skills `boris-*` para workflows reutilizables: `boris-grill`, `boris-review-changes`, `boris-quick-commit`, `boris-commit-push-pr`, `boris-techdebt`, `boris-worktree` y `boris-cierre-sesion`.
- Invocalos explicitamente cuando el usuario pida esos flujos o cuando encajen por descripcion.
- Aunque un skill describa un commit, push o borrado, pide confirmacion explicita antes de ejecutar acciones destructivas o externas.

## Flujo Recomendado
- Tarea simple: implementa directamente con el cambio minimo correcto.
- Tarea media: discovery, plan, review del plan si aplica, implementacion, verificacion y review del diff.
- Tarea grande: plan, subagente arquitecto o staff-reviewer, ejecucion por chunks, verificacion y review adversarial.
- Manten el contexto limpio: delega exploraciones amplias a subagentes y trae solo conclusiones accionables.

## Git
- Nunca hagas commit sin peticion explicita del usuario.
- Antes de commitear: revisa `git status`, `git diff` y mensajes recientes.
- No incluyas secretos ni ficheros de credenciales.
- No hagas amend salvo peticion explicita o caso seguro acordado.
- No uses comandos destructivos como reset hard o checkout de cambios ajenos salvo aprobacion explicita.

## Auto Mejora
- Cuando el agente cometa un error repetible, actualiza las instrucciones globales o del proyecto con una regla concreta para que no vuelva a ocurrir.

## Errores Conocidos Cross-Proyecto
<!-- Anade aqui reglas aprendidas que apliquen a todos tus proyectos. -->
