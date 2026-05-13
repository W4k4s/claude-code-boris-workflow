# Guia De Buen Uso

Esta guia explica como trabajar con el workflow Boris una vez instalado en Claude Code, Codex u OpenCode.

El objetivo no es usar mas herramientas por usar mas herramientas. El objetivo es trabajar con un metodo comun: entender, planificar, ejecutar, verificar y cerrar sin perder seguridad ni contexto.

## Principios Base

- Empieza con plan en tareas no triviales.
- Haz discovery antes de editar, especialmente en cambios cross-project o de nombres.
- Aplica el cambio minimo correcto.
- Verifica antes de cerrar: tests, lint, typecheck, build o QA manual segun el proyecto.
- No commitees sin peticion explicita.
- No fuerces push ni descartes cambios ajenos sin confirmacion clara.
- No metas secretos, tokens, `.env` ni credenciales en commits.
- Si una accion sale fuera del repo, borra datos o contacta servicios externos, pregunta antes.

## Que Herramienta Usar

### Claude Code

Usalo cuando quieras una sesion interactiva fuerte para implementar, refactorizar, revisar y cerrar tareas en un repo local.

Buenas situaciones:

- Implementar una feature completa.
- Refactorizar con varios pasos.
- Usar slash commands globales como `/grill` o `/cierre-sesion`.
- Trabajar con subagents y mantener limpio el contexto principal.

Comandos principales:

- `/grill`: review adversarial antes de shippear.
- `/review-changes`: revisar cambios sin commitear.
- `/quick-commit`: commit rapido cuando ya has confirmado que quieres commit.
- `/commit-push-pr`: commit, push y PR.
- `/techdebt`: limpieza de deuda tecnica.
- `/worktree`: crear worktree paralelo.
- `/cierre-sesion`: cierre completo de sesion.

### Codex

Usalo cuando quieras trabajar con el CLI de Codex, subagentes, sandboxing y skills reutilizables.

Buenas situaciones:

- Analizar o implementar desde terminal con sandbox controlado.
- Delegar revisiones o exploraciones a subagentes.
- Usar skills `$boris-*` como recetas repetibles.
- Hacer reviews locales con `/review` y skills Boris.

Skills Boris:

- `$boris-grill`: review adversarial pre-ship.
- `$boris-review-changes`: revisar working tree.
- `$boris-quick-commit`: commit rapido y seguro.
- `$boris-commit-push-pr`: commit, push y PR.
- `$boris-techdebt`: limpiar deuda tecnica.
- `$boris-worktree`: crear worktree paralelo.
- `$boris-cierre-sesion`: cierre completo.

Nota: Codex no usa custom slash commands globales como Claude/OpenCode. En Codex, el equivalente correcto son skills en `~/.agents/skills`.

### OpenCode

Usalo cuando prefieras el flujo OpenCode, sus agentes `plan/build`, su configuracion por permisos y comandos globales en `~/.config/opencode/commands`.

Buenas situaciones:

- Alternar entre agente `plan` y `build`.
- Revisar o implementar con permisos conservadores.
- Consultar a Claude o Codex desde OpenCode de forma segura.
- Usar comandos equivalentes a Claude.

Comandos principales:

- `/grill`
- `/review-changes`
- `/quick-commit`
- `/commit-push-pr`
- `/techdebt`
- `/worktree`
- `/cierre-sesion`
- `/ask-claude`: consulta Claude Code en modo plan.
- `/ask-codex`: consulta Codex en sandbox read-only.

## Flujo Recomendado Por Tipo De Tarea

### Tarea Simple

Ejemplos: corregir typo, ajustar un texto, cambiar una constante clara.

1. Haz el cambio minimo.
2. Verifica si aplica.
3. Resume lo cambiado.

No hace falta invocar subagentes ni plan largo.

### Tarea Media

Ejemplos: bug con causa localizada, endpoint pequeno, componente nuevo, test nuevo.

1. Lee el codigo relevante.
2. Explica el plan en 3-6 pasos.
3. Implementa el cambio minimo.
4. Ejecuta verificacion relevante.
5. Revisa diff con `/review-changes` o `$boris-review-changes`.

### Tarea Grande

Ejemplos: refactor grande, migracion, feature de varios modulos, cambio de arquitectura.

1. Haz discovery project-wide.
2. Escribe plan con riesgos, orden y verificacion.
3. Pide review de plan con `staff-reviewer`.
4. Ejecuta por chunks pequenos.
5. Verifica despues de cada chunk importante.
6. Usa `/grill` o `$boris-grill` antes de shippear.
7. Cierra con `/cierre-sesion` o `$boris-cierre-sesion`.

## Como Usar Los Agents

### staff-reviewer

Usalo antes de implementar algo no trivial.

Buen prompt:

```text
Revisa este plan como staff-reviewer. Busca riesgos, requisitos ambiguos, sobreingenieria y estrategia de verificacion insuficiente. Termina con APROBAR, PEDIR CAMBIOS o REPLANTEAR.
```

### code-architect

Usalo cuando necesitas diseno antes de tocar codigo.

Buen prompt:

```text
Analiza la arquitectura actual para esta feature. Dame opciones, trade-offs, riesgos y plan de implementacion. No edites codigo todavia.
```

### code-simplifier

Usalo despues de escribir codigo significativo.

Buen prompt:

```text
Simplifica el codigo recien modificado sin cambiar comportamiento. Elimina duplicacion, abstracciones innecesarias e imports muertos. Ejecuta verificaciones relevantes.
```

## Como Trabajar Con Varias Herramientas

No ejecutes varias herramientas editando el mismo working tree a la vez. Es la forma mas rapida de pisar cambios.

Patron seguro:

1. Usa una herramienta principal para editar.
2. Usa otra herramienta solo en modo lectura o plan.
3. Si dos herramientas tienen que editar en paralelo, crea worktrees separados.
4. Sincroniza via commits o patches pequenos, no copiando cambios a mano sin revisar diff.

Ejemplos seguros:

- OpenCode implementa y `/ask-codex` consulta una duda read-only.
- Claude Code implementa y Codex ejecuta `$boris-grill` en modo review.
- Codex trabaja en `.codex/worktrees/feature-a` y Claude en el repo principal.

Ejemplos a evitar:

- Claude y Codex editando el mismo fichero a la vez.
- Un agente haciendo `git reset --hard` para arreglar conflictos sin permiso.
- Ejecutar `commit-push-pr` sin revisar secretos y diff.

## Git Y PRs

Reglas operativas:

- Commits solo cuando el usuario lo pide explicitamente.
- Antes de commit: `git status`, `git diff` y revisar secretos.
- Mensaje claro, preferiblemente conventional commits.
- No `--no-verify` salvo peticion explicita.
- No amend salvo peticion explicita o caso seguro acordado.
- No force-push sin confirmacion explicita.
- Si hay cambios ajenos en el working tree, no los reviertas.

Flujo recomendado:

1. `/review-changes` o `$boris-review-changes`.
2. Ejecutar tests/lint/typecheck.
3. `/quick-commit` o `$boris-quick-commit` si solo quieres commit.
4. `/commit-push-pr` o `$boris-commit-push-pr` si quieres PR.

## Verificacion

La verificacion depende del proyecto. El agente debe detectar comandos disponibles en `package.json`, `pyproject.toml`, `Makefile`, scripts del repo o documentacion.

Orden recomendado:

1. Tests especificos del cambio.
2. Lint o typecheck.
3. Build si afecta empaquetado o frontend.
4. QA manual si afecta UI o comportamiento operativo.

Si no se puede verificar, hay que decir:

- Que no se pudo ejecutar.
- Por que.
- Riesgo residual.
- Que deberia ejecutar el usuario despues.

## Cierre De Sesion

Usa el cierre cuando vayas a cambiar de contexto, terminar el dia o dejar trabajo a medias.

Claude/OpenCode:

```text
/cierre-sesion
```

Codex:

```text
$boris-cierre-sesion
```

El cierre debe dejar claro:

- Errores resueltos y pendientes.
- Estado de tests/lint.
- Cambios sin commitear.
- Deuda tecnica detectada.
- Si hay commit pendiente.
- Proximo paso concreto.

## Auto-Mejora

Cuando el agente se equivoque de una forma repetible, no lo dejes como comentario suelto. Convierte el aprendizaje en regla.

Buen prompt:

```text
Actualiza las instrucciones globales o del proyecto para que no vuelvas a cometer este error: <descripcion concreta>.
```

La regla debe ser concreta y accionable. No guardes resumenes efimeros de actividad ni detalles que ya viven en git o en el codigo.

## Checklist Rapida

Antes de editar:

- Entendi el objetivo.
- Lei los ficheros relevantes.
- Identifique riesgos y alcance.
- Se si necesito plan o puedo hacer cambio directo.

Antes de cerrar:

- Revise diff.
- Ejecute verificaciones relevantes o explique por que no.
- No hay secretos en staged/untracked.
- No reverti cambios ajenos.
- Hay siguiente paso claro.

Antes de PR:

- La rama no es `main`/`master` salvo caso intencional.
- Commit limpio y mensaje claro.
- Tests/lint documentados.
- `/grill` o `$boris-grill` no bloquea el cambio.
