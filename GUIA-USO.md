# Guia De Buen Uso Del Workflow Boris

Esta guia es para usuarios que quieren trabajar bien con Claude Code, Codex u OpenCode aunque no esten acostumbrados a terminos como branch, diff, PR, agent o worktree.

La idea principal es sencilla: usar asistentes de codigo como companeros de equipo, no como una caja negra que toca archivos sin control.

El workflow Boris tiene cinco pasos:

1. Entender el objetivo.
2. Planificar antes de tocar codigo cuando la tarea no es trivial.
3. Hacer el cambio minimo correcto.
4. Verificar que funciona.
5. Cerrar dejando claro que se hizo y que falta.

## Para Empezar Rapido

Si no sabes que herramienta usar, elige una y sigue este orden:

1. Abre el proyecto con Claude Code, Codex u OpenCode.
2. Pide primero un plan si la tarea tiene mas de 2 o 3 pasos.
3. Deja que implemente solo cuando el plan tenga sentido.
4. Pide que ejecute tests, lint, typecheck o build si existen.
5. Revisa los cambios antes de pedir commit.
6. Solo pide commit o PR cuando estes conforme.

Prompt base recomendado:

```text
Quiero hacer <objetivo>. Primero revisa el repo y propon un plan. No edites codigo hasta que el enfoque este claro. Cuando implementes, haz el cambio minimo correcto y verifica con los comandos relevantes si existen.
```

## Diccionario Minimo

### Repo

El proyecto de codigo. Normalmente es una carpeta gestionada con Git.

### Working tree

El estado actual de tus archivos. Si has cambiado algo pero no lo has commiteado, esta en el working tree.

### Diff

La diferencia entre lo que habia antes y lo que hay ahora. Es lo que debes revisar antes de aceptar cambios.

Ejemplo:

```bash
git diff
```

### Commit

Una foto guardada de cambios en Git. Debe tener un mensaje claro.

### Push

Subir commits al remoto, por ejemplo GitHub.

### Pull Request O PR

Una propuesta de cambios para revisar antes de fusionar en una rama principal.

### Branch O Rama

Una linea de trabajo separada. Lo normal es trabajar en una rama distinta de `main` o `master`.

### Agent O Agente

Un asistente especializado. Por ejemplo, uno revisa planes, otro simplifica codigo y otro ayuda con arquitectura.

### Command O Slash Command

Un comando dentro de Claude Code u OpenCode que ejecuta una receta de trabajo. Ejemplos: `/grill`, `/quick-commit`.

### Skill

La version de Codex para recetas reutilizables. Ejemplos: `$boris-grill`, `$boris-quick-commit`.

### Worktree

Otra copia de trabajo del mismo repo para trabajar en paralelo sin pisar los archivos actuales.

### Guardrail

Una regla de seguridad. Por ejemplo: no hacer force-push sin confirmacion o no commitear secretos.

## La Regla De Oro

No le pidas al asistente que haga algo que tu no revisarias si lo hiciera una persona junior del equipo.

Bien:

```text
Revisa estos cambios y dime si ves riesgos antes de commitear.
```

Mal:

```text
Arreglalo todo, commitea y pushea sin preguntarme.
```

## Que Herramienta Uso

No hay una herramienta universalmente mejor. La decision depende de como quieras trabajar.

| Caso | Herramienta recomendada | Por que |
| --- | --- | --- |
| Quiero una sesion fuerte de implementacion local | Claude Code | Muy buen flujo interactivo, commands y subagents |
| Quiero usar sandbox y skills desde terminal | Codex | Buen control de permisos, subagentes y skills `$boris-*` |
| Quiero alternar plan/build y permisos conservadores | OpenCode | Buen sistema de agentes y comandos globales |
| Quiero consultar otro modelo sin cambiar de herramienta | OpenCode | Tiene `/ask-claude` y `/ask-codex` |
| Quiero trabajar en paralelo sin pisar cambios | Cualquiera con worktree | Cada herramienta trabaja en su propia carpeta |

## Claude Code En La Practica

Claude Code instala instrucciones en `~/.claude/CLAUDE.md`, agentes en `~/.claude/agents` y comandos en `~/.claude/commands`.

Comandos importantes:

| Comando | Para que sirve | Cuando usarlo |
| --- | --- | --- |
| `/grill` | Review adversarial | Antes de dar por bueno un cambio |
| `/review-changes` | Revisa cambios locales | Antes de testear o commitear |
| `/quick-commit` | Commit seguro | Cuando ya decidiste commitear |
| `/commit-push-pr` | Commit, push y PR | Cuando quieres publicar y abrir PR |
| `/techdebt` | Detecta deuda tecnica | Al final de una sesion o tras refactor |
| `/worktree` | Crea trabajo paralelo | Cuando quieres aislar otra tarea |
| `/cierre-sesion` | Cierre ordenado | Antes de terminar o cambiar de contexto |

Ejemplo de uso:

```text
/review-changes
```

Despues:

```text
Corrige los dos riesgos que has encontrado y ejecuta los tests relevantes.
```

## Codex En La Practica

Codex usa `AGENTS.md` para instrucciones, `.toml` para agentes y skills para workflows reutilizables.

Importante: Codex no usa custom slash commands globales como Claude Code u OpenCode. Por eso este workflow instala skills en `~/.agents/skills`.

Skills importantes:

| Skill | Equivale a | Para que sirve |
| --- | --- | --- |
| `$boris-grill` | `/grill` | Review adversarial pre-ship |
| `$boris-review-changes` | `/review-changes` | Revisar cambios locales |
| `$boris-quick-commit` | `/quick-commit` | Commit rapido y seguro |
| `$boris-commit-push-pr` | `/commit-push-pr` | Commit, push y PR |
| `$boris-techdebt` | `/techdebt` | Limpieza de deuda tecnica |
| `$boris-worktree` | `/worktree` | Crear worktree paralelo |
| `$boris-cierre-sesion` | `/cierre-sesion` | Cierre ordenado de sesion |

Ejemplo:

```text
$boris-review-changes
```

Ejemplo con objetivo:

```text
$boris-grill Revisa esta rama contra main. Quiero saber si hay bugs, riesgos de seguridad o tests ausentes antes de abrir PR.
```

## OpenCode En La Practica

OpenCode usa instrucciones en `~/.config/opencode/AGENTS.md`, agentes en `~/.config/opencode/agents`, comandos en `~/.config/opencode/commands` y permisos en `opencode.json`.

Comandos principales:

| Comando | Para que sirve |
| --- | --- |
| `/grill` | Review adversarial |
| `/review-changes` | Revisar cambios sin commitear |
| `/quick-commit` | Commit rapido |
| `/commit-push-pr` | Commit, push y PR |
| `/techdebt` | Limpieza de deuda tecnica |
| `/worktree` | Crear worktree paralelo |
| `/cierre-sesion` | Cierre ordenado |
| `/ask-claude` | Preguntar a Claude Code en modo seguro |
| `/ask-codex` | Preguntar a Codex en modo seguro |

Ejemplo:

```text
/ask-codex Revisa si este plan tiene riesgos de seguridad. No edites archivos.
```

## Los Cinco Pasos Del Workflow

### 1. Entender

Antes de tocar archivos, el asistente debe entender que quieres conseguir y que restricciones tiene el proyecto.

Buen prompt:

```text
Necesito arreglar este bug: <descripcion>. Primero localiza donde puede estar el problema y explicame que archivos son relevantes. No edites todavia.
```

### 2. Planificar

Planificar no significa escribir un documento enorme. Significa evitar cambios a ciegas.

Para una tarea mediana, un buen plan tiene:

- Archivos que se tocaran.
- Riesgos.
- Orden de cambios.
- Como se verificara.

Buen prompt:

```text
Propon un plan corto. Incluye riesgos y comandos de verificacion. Espera mi OK antes de implementar.
```

### 3. Ejecutar

Ejecutar significa hacer el cambio minimo correcto.

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

Segun el proyecto, puede ser:

- Tests.
- Lint.
- Typecheck.
- Build.
- Probar en navegador.
- Reproducir manualmente un bug.

Buen prompt:

```text
Ejecuta la verificacion mas pequena que demuestre que este cambio funciona. Si no existe un test adecuado, explicame el riesgo residual.
```

### 5. Cerrar

Cerrar es dejar la sesion ordenada. No es solo decir "hecho".

Debe quedar claro:

- Que se cambio.
- Que se probo.
- Que queda pendiente.
- Si hay commit o PR.
- Cual es el siguiente paso.

Comandos:

```text
/cierre-sesion
```

En Codex:

```text
$boris-cierre-sesion
```

## Flujos Por Tamano De Tarea

### Tarea Pequena

Ejemplos: typo, texto, comentario, constante clara.

Flujo:

1. Pide el cambio directo.
2. Revisa el diff.
3. Verifica solo si aplica.

Prompt:

```text
Cambia este texto en la documentacion. Haz solo ese cambio y muestrame el diff.
```

### Tarea Mediana

Ejemplos: bug localizado, test nuevo, componente pequeno.

Flujo:

1. Pedir plan corto.
2. Implementar.
3. Verificar.
4. Revisar cambios.
5. Commit si procede.

Prompt:

```text
Arregla este bug. Primero revisa los archivos relevantes y propon un plan corto. Luego implementa el cambio minimo, ejecuta tests relevantes y revisa el diff.
```

### Tarea Grande

Ejemplos: migracion, refactor, feature de varios modulos.

Flujo:

1. Discovery amplio.
2. Plan por fases.
3. Review del plan con `staff-reviewer`.
4. Implementar por chunks.
5. Verificar cada chunk.
6. Review adversarial con `/grill` o `$boris-grill`.
7. Cierre de sesion.

Prompt:

```text
Esta es una tarea grande. Haz discovery project-wide, plantea fases pequenas y pide review del plan con staff-reviewer antes de tocar codigo.
```

## Como Usar Los Agentes

### staff-reviewer

Es el revisor esceptico. Sirve para evitar perder tiempo implementando un mal plan.

Usalo cuando:

- El cambio tiene varios pasos.
- No estas seguro del enfoque.
- Puede haber riesgos de seguridad, datos o arquitectura.

Prompt:

```text
Revisa este plan como staff-reviewer. Busca riesgos, requisitos ambiguos, sobreingenieria y una estrategia de verificacion insuficiente. Termina con APROBAR, PEDIR CAMBIOS o REPLANTEAR.
```

### code-architect

Es el arquitecto. Sirve para pensar estructura antes de escribir codigo.

Usalo cuando:

- Hay que disenar una feature.
- Hay que dividir responsabilidades.
- Hay que valorar varias opciones.

Prompt:

```text
Analiza la arquitectura actual para esta feature. Dame opciones, trade-offs, riesgos y plan de implementacion. No edites codigo todavia.
```

### code-simplifier

Es el simplificador. Sirve despues de implementar.

Usalo cuando:

- El cambio quedo mas complejo de lo esperado.
- Hay duplicacion.
- Hay imports, helpers o abstracciones innecesarias.

Prompt:

```text
Simplifica el codigo recien modificado sin cambiar comportamiento. Elimina duplicacion, abstracciones innecesarias e imports muertos. Ejecuta verificaciones relevantes.
```

## Trabajar Con Varias Herramientas Sin Pisarse

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

## Git Y Pull Requests Explicado Simple

### Antes De Commit

Pregunta al asistente:

```text
Revisa el estado de Git, el diff y comprueba que no hay secretos antes de commitear.
```

El asistente debe mirar:

- `git status`
- `git diff`
- Archivos nuevos no trackeados
- Posibles secretos

### Commit Rapido

Claude/OpenCode:

```text
/quick-commit
```

Codex:

```text
$boris-quick-commit
```

### Pull Request

Claude/OpenCode:

```text
/commit-push-pr
```

Codex:

```text
$boris-commit-push-pr
```

No uses estos flujos si no quieres publicar cambios todavia.

## Seguridad Que Debes Respetar

No hagas estas cosas sin entenderlas:

- `git push --force`: puede sobrescribir trabajo remoto.
- `git reset --hard`: puede borrar cambios locales.
- `git clean -fd`: puede borrar archivos no guardados por Git.
- `rm -rf`: puede borrar carpetas enteras.
- Commitear `.env`, tokens, passwords o credenciales.

Si el asistente propone algo de esto, debe explicar por que y pedir confirmacion clara.

## Verificacion Para No Expertos

No todos los proyectos se verifican igual. El asistente debe buscar como se prueba el proyecto.

Pistas habituales:

- `package.json`: proyectos JavaScript o TypeScript.
- `pyproject.toml`: proyectos Python modernos.
- `requirements.txt`: proyectos Python.
- `Makefile`: comandos comunes del proyecto.
- README del proyecto.

Frase util:

```text
Detecta los comandos de verificacion del proyecto y ejecuta los mas relevantes para este cambio. Si no puedes, explica por que.
```

## Como Saber Si Una Respuesta Es Buena

Una buena respuesta del asistente:

- Dice que ha cambiado y por que.
- Menciona archivos importantes.
- Dice que ha verificado.
- Dice que no pudo verificar si aplica.
- No oculta riesgos.
- No hace commit/push sin permiso.

Una mala respuesta:

- Dice "listo" sin pruebas.
- Cambia muchos archivos sin explicacion.
- Reescribe partes no relacionadas.
- Ignora errores de tests.
- Pide usar comandos destructivos sin justificar.

## Cierre De Sesion

Usa cierre cuando termines una tarea, cambies de proyecto o quieras dejar trabajo para mas tarde.

Claude/OpenCode:

```text
/cierre-sesion
```

Codex:

```text
$boris-cierre-sesion
```

El cierre debe responder:

- Que se hizo.
- Que falta.
- Que tests pasaron o fallaron.
- Si hay cambios sin commitear.
- Si hay deuda tecnica detectada.
- Cual es el siguiente paso.

## Auto-Mejora

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
Portate mejor.
```

## Checklist Para Copiar Y Pegar

Antes de editar:

- Objetivo entendido.
- Archivos relevantes leidos.
- Riesgos identificados.
- Plan claro si la tarea no es trivial.

Antes de cerrar:

- Diff revisado.
- Verificacion ejecutada o razon explicada.
- Sin secretos en cambios.
- Sin cambios ajenos revertidos.
- Siguiente paso claro.

Antes de PR:

- Rama correcta.
- Commit limpio.
- Tests/lint documentados.
- Review adversarial completada con `/grill` o `$boris-grill`.
