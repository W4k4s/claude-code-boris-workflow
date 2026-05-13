# Metodologia base Boris Cherny para OpenCode

Este archivo se carga en todas las sesiones de OpenCode. Los `AGENTS.md` de cada proyecto lo extienden con informacion especifica.

Sustituye o amplia la seccion "Perfil" con tus datos. El resto puedes dejarlo tal cual.

## Perfil
<!-- Rellena con tus datos. Ejemplo:
- Nombre: Nombre Apellidos ("Alias").
- GitHub: handle.
- Email: tu@email.
- Timezone: Europe/Madrid.
- Idioma: espanol castellano, directo y sin formalidades.
- Modelos: GPT/Claude segun tarea; razonamiento alto cuando haga falta.
-->

## Convenciones Base
- Responde en el idioma preferido por el usuario.
- Prioriza seguridad: nunca hagas force-push sin confirmacion, nunca commitees secretos.
- Usa herramientas nativas de OpenCode antes que soluciones third-party.
- Prefiere borrado recuperable sobre borrado destructivo cuando este disponible.
- Pregunta antes de enviar emails, mensajes o realizar acciones externas.
- Para tareas largas, trabaja por chunks: planificar, ejecutar, verificar y cerrar.

## Metodologia De Trabajo
- En tareas no triviales de 3 o mas pasos, empieza con discovery y plan. No implementes hasta que el enfoque sea claro.
- Si la implementacion se tuerce, vuelve a planificar en vez de insistir con parches acumulados.
- Tras escribir codigo, verifica con typecheck, lint, tests o build si existen.
- Para UI, arranca el servidor de desarrollo y valida en navegador cuando sea posible.
- No marques una tarea como completada sin haberla probado o sin explicar por que no se pudo verificar.

## Agentes
- Usa el agente `plan` de OpenCode para analizar sin editar.
- Usa subagentes cuando la tarea pese mucho en el contexto principal o sea paralelizable.
- `staff-reviewer`: revisa planes antes de implementar; busca riesgos, sobreingenieria y requisitos ambiguos; emite APROBAR, PEDIR CAMBIOS o REPLANTEAR.
- `code-simplifier`: simplifica codigo recien escrito sin cambiar comportamiento.
- `code-architect`: disena features complejas, refactors grandes y analiza trade-offs.
- No ejecutes subagentes en paralelo sobre el mismo working tree si van a editar archivos; usa worktrees separados.

## Comandos Multi-Tool
- `/grill`: review adversarial pre-ship.
- `/review-changes`: revisar cambios sin commitear.
- `/quick-commit`: commit rapido con mensaje descriptivo.
- `/commit-push-pr`: commit, push y PR.
- `/techdebt`: limpieza fin de sesion.
- `/worktree`: worktree paralelo.
- `/cierre-sesion`: cierre completo de sesion.
- `/ask-claude`: consulta Claude Code en modo plan/read-only. Requiere confirmar antes de ejecutar.
- `/ask-codex`: consulta Codex en sandbox read-only. Requiere confirmar antes de ejecutar.
- No uses flags de bypass, danger o skip permissions al invocar otras herramientas salvo peticion explicita y sandbox externo.

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
