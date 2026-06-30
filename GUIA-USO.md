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

Una receta reutilizable empaquetada como carpeta con `SKILL.md`. Claude Code las invoca con `/nombre`. Codex las invoca normalmente con `$boris-nombre`.

### Agent o agente vs skill

Un agente es un especialista al que delegas trabajo, por ejemplo arquitectura o review de plan. Una skill es un workflow que invocas, por ejemplo revisar cambios o preparar commit.

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
| Quiero una sesión fuerte de implementación local | Claude Code | Muy buen flujo interactivo, skills/comandos y subagents |
| Quiero usar sandbox y skills desde terminal | Codex | Buen control de permisos, subagentes y skills `$boris-*` |
| Quiero alternar plan/build y permisos conservadores | OpenCode | Buen sistema de agentes y comandos globales |
| Quiero consultar otro modelo sin cambiar de herramienta | OpenCode | Tiene `/ask-claude` y `/ask-codex` |
| Quiero trabajar en paralelo sin pisar cambios | Cualquiera con worktree | Cada herramienta trabaja en su propia carpeta |

## Apps desktop, CLI, Windows y WSL

La regla practica: instala el workflow en el mismo entorno donde corre el agente.

Windows nativo y WSL no comparten automaticamente el mismo `$HOME` ni la misma configuracion:

| Si trabajas con... | Instala en... | Ruta esperada |
| --- | --- | --- |
| Claude Code CLI dentro de WSL | WSL | `/home/<usuario>/.claude` |
| Claude Desktop, pestaña Code, en Windows | Windows nativo | `C:\Users\<usuario>\.claude` |
| Codex CLI dentro de WSL | WSL | `/home/<usuario>/.codex` y `/home/<usuario>/.agents/skills` |
| Codex App en Windows con agente Windows | Windows nativo | `C:\Users\<usuario>\.codex` y `C:\Users\<usuario>\.agents\skills` |

Si instalaste en WSL y luego abres Claude Desktop en Windows, es normal que no veas los mismos skills o agentes. No copies toda la carpeta `.claude` de WSL a Windows a ciegas: puede contener auth, rutas Linux, MCPs o comandos no portables. Ejecuta el instalador de Windows para configurar la app nativa:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Claude
```

Para Claude Desktop Code, los workflows se instalan como skills en `~/.claude/skills`. Si la carpeta `skills` no existia antes, reinicia la app.

Lo importante no es que aparezcan en todas las pantallas de personalizacion, sino que sean invocables. En nuestras pruebas, Claude Desktop Code en Windows carga los workflows desde el menu `/`, aunque las skills personales no siempre aparezcan en **Personalizar > Skills**.

Para verificarlo en Claude Desktop:

1. Cierra y vuelve a abrir Claude Desktop.
2. Entra en la pestana Code y abre un proyecto local.
3. Escribe `/` y comprueba que aparecen `grill`, `review-changes`, `quick-commit` y `cierre-sesion`.
4. Prueba `/quick-commit Estoy probando. No hagas commit; dime que checks harias y espera confirmacion.` y confirma que no commitea sin permiso explicito.

Puede que las skills personales no aparezcan en **Personalizar > Skills** aunque esten bien instaladas. El criterio practico es que aparezcan en el menu `/` y funcionen al invocarlas.

Para verificar Codex App en Windows:

1. Abre Codex App con agente Windows nativo.
2. Abre un proyecto local.
3. Escribe `$` y comprueba que aparecen `boris-grill`, `boris-review-changes` y `boris-quick-commit`.
4. Prueba `$boris-quick-commit Estoy probando. No hagas commit; dime que checks harias y espera confirmacion.` y confirma que no commitea sin permiso explicito.

OpenCode no necesita esta separacion desktop/CLI en este repo: se usa con su configuracion propia en `~/.config/opencode`, agentes en `agents/`, comandos en `commands/` y permisos en `opencode.json`. El criterio practico es que funcionen `/grill`, `/review-changes`, `/quick-commit` y los permisos pidan confirmacion donde toca.

## Diferencias entre comandos, skills y agentes

| Herramienta | Instrucciones globales | Agentes | Workflows invocables | Como se invocan |
| --- | --- | --- | --- | --- |
| Claude Code CLI/Desktop | `~/.claude/CLAUDE.md` | `~/.claude/agents/*.md` | `~/.claude/skills/*` | `/grill`, `/quick-commit` |
| Codex CLI/App | `~/.codex/AGENTS.md` | `~/.codex/agents/*.toml` | `~/.agents/skills/boris-*` | `$boris-grill`, `$boris-quick-commit` |
| OpenCode | `~/.config/opencode/AGENTS.md` | `~/.config/opencode/agents/*.md` | `~/.config/opencode/commands/*.md` | `/grill`, `/quick-commit` |

Limitaciones y matices:

- Los workflows de Claude Code se instalan como skills en `~/.claude/skills`. Al reinstalar, los comandos legacy de `~/.claude/commands` de estos workflows se retiran a `.bak` (ahora son skills).
- Claude Desktop Code puede mostrar los workflows en `/` aunque no los liste en **Personalizar > Skills**.
- Codex no usa custom slash commands globales para este flujo; usa skills `$boris-*`.
- Los agentes no son botones de workflow. Sirven para delegar tareas especializadas y no sustituyen a `/grill` o `$boris-grill`.
- Windows nativo y WSL son instalaciones separadas. Si usas ambos, instala el workflow en ambos.

## Claude Code en la práctica

Claude Code instala instrucciones en `~/.claude/CLAUDE.md`, agentes en `~/.claude/agents` y skills en `~/.claude/skills`.

Skills/comandos importantes:

| Comando | Para qué sirve | Cuándo usarlo |
| --- | --- | --- |
| `/grill` | Review adversarial | Antes de dar por bueno un cambio |
| `/review-changes` | Revisa cambios locales | Antes de testear o commitear |
| `/quick-commit` | Commit seguro | Cuando ya decidiste commitear |
| `/commit-push-pr` | Commit, push y PR | Cuando quieres publicar y abrir PR |
| `/techdebt` | Detecta deuda técnica | Al final de una sesión o tras refactor |
| `/worktree` | Crea trabajo paralelo | Cuando quieres aislar otra tarea |
| `/cierre-sesion` | Cierre ordenado | Antes de terminar o cambiar de contexto |
| `/plan-visual` | Convierte un plan en artefacto HTML particionado, revisado y listo para ejecución paralela | Después de planificar, antes de ejecutar |

`/plan-visual` es solo Claude Code por ahora (la paridad con Codex/OpenCode es follow-up).

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

Cuando apruebas un plan, Claude Code puede limpiar el contexto antes de ejecutar, dejando al asistente solo con el plan aprobado (sin el ruido de la fase de exploración). Este repo activa esa opción por defecto. Si el plan es grande y quieres revisión adversarial, vista en HTML o ejecución en paralelo, usa `/plan-visual`. Lo tienes detallado más abajo, en "El flujo de planificación".

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

## El flujo de planificación: plan mode + /plan-visual

Esta es la mejora más importante del workflow. Hay dos capas y casi nunca necesitas la segunda.

### Capa 1: plan mode (el día a día, sin comandos)

El flujo normal de cualquier tarea no trivial:

1. Entra en plan mode con `Shift+Tab` dos veces.
2. Describe la idea en lenguaje normal. El asistente explora y propone un plan, sin tocar código.
3. Al aprobar el plan, aparece la opción de limpiar el contexto. Acéptala.
4. El asistente arranca la ejecución con el contexto limpio, siguiendo el plan.

No hace falta ningún comando: plan mode más tu idea más aprobar ya te da el ciclo "planificar, limpiar, ejecutar".

Esa opción de limpiar contexto al aprobar la controla un ajuste nativo de Claude Code, `showClearContextOnPlanAccept`. Viene desactivada por defecto, así que la opción "había desaparecido". Este repo la distribuye activada en `~/.claude/settings.json`. Si ya tenías un settings.json propio, el instalador no lo toca (para no pisar tu config): añade la clave a mano, a nivel raíz del JSON.

```json
{
  "showClearContextOnPlanAccept": true
}
```

Por qué importa: planificar y ejecutar en el mismo contexto satura la ventana con el ruido de la fase de exploración. Limpiar el contexto al empezar a ejecutar deja al asistente solo con el plan aprobado, que es justo lo que necesita. Menos ruido, menos deriva, mejor resultado.

### Capa 2: /plan-visual (solo para planes grandes)

`/plan-visual` es una capa opcional encima del plan. Úsalo cuando el plan es gordo y quieres una o varias de estas cosas:

- Que un revisor escéptico (`staff-reviewer`) destroce el plan antes de tocar código.
- Verlo como página HTML para revisarlo de un vistazo (tabla de unidades de trabajo y grafo de dependencias).
- Partirlo para ejecutarlo en paralelo con varios agentes sin que se pisen.

Hace cinco pasos, en orden:

0. Comprueba que el setting de limpiar contexto está activo.
1. Particiona el plan en Unidades de Trabajo (WU), cada una con sus ficheros (fronteras disjuntas, dos WU no tocan el mismo fichero), sus dependencias y su criterio de verificación.
2. Revisa con `staff-reviewer` hasta que apruebe. El revisor evalúa también que la partición sea paralelizable de verdad.
3. Renderiza el plan como artefacto HTML y guarda el Markdown canónico en `~/.claude/plans/`.
4. Handoff: te recuerda limpiar contexto y deja el plan listo para ejecutar (no lanza los agentes por ti todavía).

Por qué mejora el resultado: sigue el patrón planner/evaluator de Anthropic (quien planifica no es quien valida, así se cazan los huecos antes de escribir código) y la idea de que un plan en HTML obliga a revisarlo de verdad, en vez de aprobar un muro de texto sin leerlo. Y al estar particionado en fronteras disjuntas, puedes lanzar varios agentes a la vez sin colisiones.

### Cuándo usar qué

| Situación | Qué usar |
|---|---|
| Tarea normal de 3+ pasos | Solo plan mode (sin comando) |
| Quieres revisión adversarial del plan | `/plan-visual` |
| El plan es grande y lo quieres ver en HTML | `/plan-visual` |
| Quieres ejecutar en paralelo con varios agentes | `/plan-visual` |

`/plan-visual` y el setting `showClearContextOnPlanAccept` son de momento solo para Claude Code. La paridad con Codex y OpenCode es un follow-up.

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
3. `/plan-visual`: particiona el plan en unidades de trabajo, lo revisa con `staff-reviewer` y lo deja en HTML, listo para ejecutar en paralelo.
4. Limpiar contexto al aprobar (`/new`) y ejecutar las unidades, en paralelo las que no dependan entre sí.
5. Verificar cada unidad.
6. Review adversarial con `/grill` o `$boris-grill`.
7. Cierre de sesión.

En una tarea grande, `/plan-visual` es donde más se nota: la revisión adversarial caza huecos antes de escribir código, y la partición en fronteras disjuntas te deja lanzar varios agentes a la vez sin que se pisen.

Prompt:

```text
Esta es una tarea grande. Haz discovery project-wide, plantea fases pequeñas y pasa el plan por /plan-visual para revisarlo y particionarlo antes de tocar código.
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
