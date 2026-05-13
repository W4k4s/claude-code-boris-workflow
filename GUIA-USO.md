# Guía de buen uso del workflow Boris

Esta guía es para usuarios que quieren trabajar bien con Claude Code, Codex u OpenCode, aunque no estén acostumbrados a términos como branch, diff, PR, agent o worktree.

La idea principal es sencilla: usar asistentes de código como compañeros de equipo, no como una caja negra que toca archivos sin control.

El workflow Boris tiene cinco pasos:

1. Entender el objetivo.
2. Planificar antes de tocar código cuando la tarea no es trivial.
3. Hacer el cambio mínimo correcto.
4. Verificar que funciona.
5. Cerrar dejando claro qué se hizo y qué falta.

## Para empezar rápido

Si no sabes qué herramienta usar, elige una y sigue este orden:

1. Abre el proyecto con Claude Code, Codex u OpenCode.
2. Pide primero un plan si la tarea tiene más de 2 o 3 pasos.
3. Deja que implemente solo cuando el plan tenga sentido.
4. Pide que ejecute tests, lint, typecheck o build si existen.
5. Revisa los cambios antes de pedir commit.
6. Solo pide commit o PR cuando estés conforme.

Prompt base recomendado:

```text
Quiero hacer <objetivo>. Primero revisa el repo y propón un plan. No edites código hasta que el enfoque esté claro. Cuando implementes, haz el cambio mínimo correcto y verifica con los comandos relevantes si existen.
```

## Diccionario mínimo

### Repo

El proyecto de código. Normalmente es una carpeta gestionada con Git.

### Working tree

El estado actual de tus archivos. Si has cambiado algo pero no lo has commiteado, está en el working tree.

### Diff

La diferencia entre lo que había antes y lo que hay ahora. Es lo que debes revisar antes de aceptar cambios.

Ejemplo:

```bash
git diff
```

### Commit

Una foto guardada de cambios en Git. Debe tener un mensaje claro.

### Push

Subir commits al remoto, por ejemplo GitHub.

### Pull request o PR

Una propuesta de cambios para revisar antes de fusionar en una rama principal.

### Branch o rama

Una línea de trabajo separada. Lo normal es trabajar en una rama distinta de `main` o `master`.

### Agent o agente

Un asistente especializado. Por ejemplo, uno revisa planes, otro simplifica código y otro ayuda con arquitectura.

### Command o slash command

Un comando dentro de Claude Code u OpenCode que ejecuta una receta de trabajo. Ejemplos: `/grill`, `/quick-commit`.

### Skill

La versión de Codex para recetas reutilizables. Ejemplos: `$boris-grill`, `$boris-quick-commit`.

### Worktree

Otra copia de trabajo del mismo repo para trabajar en paralelo sin pisar los archivos actuales.

### Guardrail

Una regla de seguridad. Por ejemplo: no hacer force-push sin confirmación o no commitear secretos.

## La regla de oro

No le pidas al asistente que haga algo que tú no revisarías si lo hiciera una persona junior del equipo.

Bien:

```text
Revisa estos cambios y dime si ves riesgos antes de commitear.
```

Mal:

```text
Arréglalo todo, commitea y pushea sin preguntarme.
```

## Qué herramienta uso

No hay una herramienta universalmente mejor. La decisión depende de cómo quieras trabajar.

| Caso | Herramienta recomendada | Por qué |
| --- | --- | --- |
| Quiero una sesión fuerte de implementación local | Claude Code | Muy buen flujo interactivo, commands y subagents |
| Quiero usar sandbox y skills desde terminal | Codex | Buen control de permisos, subagentes y skills `$boris-*` |
| Quiero alternar plan/build y permisos conservadores | OpenCode | Buen sistema de agentes y comandos globales |
| Quiero consultar otro modelo sin cambiar de herramienta | OpenCode | Tiene `/ask-claude` y `/ask-codex` |
| Quiero trabajar en paralelo sin pisar cambios | Cualquiera con worktree | Cada herramienta trabaja en su propia carpeta |

## Claude Code en la práctica

Claude Code instala instrucciones en `~/.claude/CLAUDE.md`, agentes en `~/.claude/agents` y comandos en `~/.claude/commands`.

Comandos importantes:

| Comando | Para qué sirve | Cuándo usarlo |
| --- | --- | --- |
| `/grill` | Review adversarial | Antes de dar por bueno un cambio |
| `/review-changes` | Revisa cambios locales | Antes de testear o commitear |
| `/quick-commit` | Commit seguro | Cuando ya decidiste commitear |
| `/commit-push-pr` | Commit, push y PR | Cuando quieres publicar y abrir PR |
| `/techdebt` | Detecta deuda técnica | Al final de una sesión o tras refactor |
| `/worktree` | Crea trabajo paralelo | Cuando quieres aislar otra tarea |
| `/cierre-sesion` | Cierre ordenado | Antes de terminar o cambiar de contexto |

Ejemplo de uso:

```text
/review-changes
```

Después:

```text
Corrige los dos riesgos que has encontrado y ejecuta los tests relevantes.
```

## Codex en la práctica

Codex usa `AGENTS.md` para instrucciones, `.toml` para agentes y skills para workflows reutilizables.

Importante: Codex no usa custom slash commands globales como Claude Code u OpenCode. Por eso este workflow instala skills en `~/.agents/skills`.

Skills importantes:

| Skill | Equivale a | Para qué sirve |
| --- | --- | --- |
| `$boris-grill` | `/grill` | Review adversarial pre-ship |
| `$boris-review-changes` | `/review-changes` | Revisar cambios locales |
| `$boris-quick-commit` | `/quick-commit` | Commit rápido y seguro |
| `$boris-commit-push-pr` | `/commit-push-pr` | Commit, push y PR |
| `$boris-techdebt` | `/techdebt` | Limpieza de deuda técnica |
| `$boris-worktree` | `/worktree` | Crear worktree paralelo |
| `$boris-cierre-sesion` | `/cierre-sesion` | Cierre ordenado de sesión |

Ejemplo:

```text
$boris-review-changes
```

Ejemplo con objetivo:

```text
$boris-grill Revisa esta rama contra main. Quiero saber si hay bugs, riesgos de seguridad o tests ausentes antes de abrir PR.
```

## OpenCode en la práctica

OpenCode usa instrucciones en `~/.config/opencode/AGENTS.md`, agentes en `~/.config/opencode/agents`, comandos en `~/.config/opencode/commands` y permisos en `opencode.json`.

Comandos principales:

| Comando | Para qué sirve |
| --- | --- |
| `/grill` | Review adversarial |
| `/review-changes` | Revisar cambios sin commitear |
| `/quick-commit` | Commit rápido |
| `/commit-push-pr` | Commit, push y PR |
| `/techdebt` | Limpieza de deuda técnica |
| `/worktree` | Crear worktree paralelo |
| `/cierre-sesion` | Cierre ordenado |
| `/ask-claude` | Preguntar a Claude Code en modo seguro |
| `/ask-codex` | Preguntar a Codex en modo seguro |

Ejemplo:

```text
/ask-codex Revisa si este plan tiene riesgos de seguridad. No edites archivos.
```

## Los cinco pasos del workflow

### 1. Entender

Antes de tocar archivos, el asistente debe entender qué quieres conseguir y qué restricciones tiene el proyecto.

Buen prompt:

```text
Necesito arreglar este bug: <descripción>. Primero localiza dónde puede estar el problema y explícame qué archivos son relevantes. No edites todavía.
```

### 2. Planificar

Planificar no significa escribir un documento enorme. Significa evitar cambios a ciegas.

Para una tarea mediana, un buen plan tiene:

- Archivos que se tocarán.
- Riesgos.
- Orden de cambios.
- Cómo se verificará.

Buen prompt:

```text
Propón un plan corto. Incluye riesgos y comandos de verificación. Espera mi OK antes de implementar.
```

### 3. Ejecutar

Ejecutar significa hacer el cambio mínimo correcto.

No pidas:

```text
Rehaz toda esta parte para que quede mejor.
```

Mejor:

```text
Implementa solo el paso 1 del plan. No cambies comportamiento fuera de este bug.
```

### 4. Verificar

Verificar es comprobar que no se ha roto nada importante.

Según el proyecto, puede ser:

- Tests.
- Lint.
- Typecheck.
- Build.
- Probar en navegador.
- Reproducir manualmente un bug.

Buen prompt:

```text
Ejecuta la verificación más pequeña que demuestre que este cambio funciona. Si no existe un test adecuado, explícame el riesgo residual.
```

### 5. Cerrar

Cerrar es dejar la sesión ordenada. No es solo decir "hecho".

Debe quedar claro:

- Qué se cambió.
- Qué se probó.
- Qué queda pendiente.
- Si hay commit o PR.
- Cuál es el siguiente paso.

Comandos:

```text
/cierre-sesion
```

En Codex:

```text
$boris-cierre-sesion
```

## Flujos por tamaño de tarea

### Tarea pequeña

Ejemplos: typo, texto, comentario, constante clara.

Flujo:

1. Pide el cambio directo.
2. Revisa el diff.
3. Verifica solo si aplica.

Prompt:

```text
Cambia este texto en la documentación. Haz solo ese cambio y muéstrame el diff.
```

### Tarea mediana

Ejemplos: bug localizado, test nuevo, componente pequeño.

Flujo:

1. Pedir plan corto.
2. Implementar.
3. Verificar.
4. Revisar cambios.
5. Commit si procede.

Prompt:

```text
Arregla este bug. Primero revisa los archivos relevantes y propón un plan corto. Luego implementa el cambio mínimo, ejecuta tests relevantes y revisa el diff.
```

### Tarea grande

Ejemplos: migración, refactor, feature de varios módulos.

Flujo:

1. Discovery amplio.
2. Plan por fases.
3. Review del plan con `staff-reviewer`.
4. Implementar por chunks.
5. Verificar cada chunk.
6. Review adversarial con `/grill` o `$boris-grill`.
7. Cierre de sesión.

Prompt:

```text
Esta es una tarea grande. Haz discovery project-wide, plantea fases pequeñas y pide review del plan con staff-reviewer antes de tocar código.
```

## Cómo usar los agentes

### staff-reviewer

Es el revisor escéptico. Sirve para evitar perder tiempo implementando un mal plan.

Úsalo cuando:

- El cambio tiene varios pasos.
- No estás seguro del enfoque.
- Puede haber riesgos de seguridad, datos o arquitectura.

Prompt:

```text
Revisa este plan como staff-reviewer. Busca riesgos, requisitos ambiguos, sobreingeniería y una estrategia de verificación insuficiente. Termina con APROBAR, PEDIR CAMBIOS o REPLANTEAR.
```

### code-architect

Es el arquitecto. Sirve para pensar estructura antes de escribir código.

Úsalo cuando:

- Hay que diseñar una feature.
- Hay que dividir responsabilidades.
- Hay que valorar varias opciones.

Prompt:

```text
Analiza la arquitectura actual para esta feature. Dame opciones, trade-offs, riesgos y plan de implementación. No edites código todavía.
```

### code-simplifier

Es el simplificador. Sirve después de implementar.

Úsalo cuando:

- El cambio quedó más complejo de lo esperado.
- Hay duplicación.
- Hay imports, helpers o abstracciones innecesarias.

Prompt:

```text
Simplifica el código recién modificado sin cambiar comportamiento. Elimina duplicación, abstracciones innecesarias e imports muertos. Ejecuta verificaciones relevantes.
```

## Trabajar con varias herramientas sin pisarse

Puedes usar Claude Code, Codex y OpenCode en el mismo proyecto, pero no conviene que varias herramientas editen el mismo archivo a la vez.

Regla sencilla:

- Una herramienta edita.
- Otra herramienta revisa en modo lectura.
- Si dos herramientas tienen que editar, usa worktrees separados.

Seguro:

- Claude Code implementa y Codex revisa con `$boris-grill`.
- OpenCode implementa y `/ask-claude` consulta una duda en modo plan.
- Codex trabaja en `.codex/worktrees/feature-a` y Claude Code en otra rama.

Peligroso:

- Dos herramientas editando el mismo fichero a la vez.
- Un asistente descartando cambios para "limpiar" sin preguntar.
- Hacer commit de todo sin mirar `git diff`.

## Git y pull requests explicados de forma sencilla

### Antes de commit

Pregunta al asistente:

```text
Revisa el estado de Git, el diff y comprueba que no hay secretos antes de commitear.
```

El asistente debe mirar:

- `git status`
- `git diff`
- Archivos nuevos no trackeados
- Posibles secretos

### Commit rápido

Claude/OpenCode:

```text
/quick-commit
```

Codex:

```text
$boris-quick-commit
```

### Pull request

Claude/OpenCode:

```text
/commit-push-pr
```

Codex:

```text
$boris-commit-push-pr
```

No uses estos flujos si no quieres publicar cambios todavía.

## Seguridad que debes respetar

No hagas estas cosas sin entenderlas:

- `git push --force`: puede sobrescribir trabajo remoto.
- `git reset --hard`: puede borrar cambios locales.
- `git clean -fd`: puede borrar archivos no guardados por Git.
- `rm -rf`: puede borrar carpetas enteras.
- Commitear `.env`, tokens, passwords o credenciales.

Si el asistente propone algo de esto, debe explicar por qué y pedir confirmación clara.

## Verificación para no expertos

No todos los proyectos se verifican igual. El asistente debe buscar cómo se prueba el proyecto.

Pistas habituales:

- `package.json`: proyectos JavaScript o TypeScript.
- `pyproject.toml`: proyectos Python modernos.
- `requirements.txt`: proyectos Python.
- `Makefile`: comandos comunes del proyecto.
- README del proyecto.

Frase útil:

```text
Detecta los comandos de verificación del proyecto y ejecuta los más relevantes para este cambio. Si no puedes, explica por qué.
```

## Cómo saber si una respuesta es buena

Una buena respuesta del asistente:

- Dice qué ha cambiado y por qué.
- Menciona archivos importantes.
- Dice qué ha verificado.
- Dice qué no pudo verificar si aplica.
- No oculta riesgos.
- No hace commit/push sin permiso.

Una mala respuesta:

- Dice "listo" sin pruebas.
- Cambia muchos archivos sin explicación.
- Reescribe partes no relacionadas.
- Ignora errores de tests.
- Pide usar comandos destructivos sin justificar.

## Cierre de sesión

Usa cierre cuando termines una tarea, cambies de proyecto o quieras dejar trabajo para más tarde.

Claude/OpenCode:

```text
/cierre-sesion
```

Codex:

```text
$boris-cierre-sesion
```

El cierre debe responder:

- Qué se hizo.
- Qué falta.
- Qué tests pasaron o fallaron.
- Si hay cambios sin commitear.
- Si hay deuda técnica detectada.
- Cuál es el siguiente paso.

## Auto-mejora

El workflow mejora cuando conviertes errores repetibles en reglas.

Ejemplo:

```text
Actualiza las instrucciones globales o del proyecto para que no vuelvas a modificar archivos generados sin preguntar antes.
```

Buena regla:

```text
Antes de editar archivos generados, preguntar si son fuente de verdad o artefactos de build.
```

Mala regla:

```text
Pórtate mejor.
```

## Checklist para copiar y pegar

Antes de editar:

- Objetivo entendido.
- Archivos relevantes leídos.
- Riesgos identificados.
- Plan claro si la tarea no es trivial.

Antes de cerrar:

- Diff revisado.
- Verificación ejecutada o razón explicada.
- Sin secretos en cambios.
- Sin cambios ajenos revertidos.
- Siguiente paso claro.

Antes de PR:

- Rama correcta.
- Commit limpio.
- Tests/lint documentados.
- Review adversarial completada con `/grill` o `$boris-grill`.
