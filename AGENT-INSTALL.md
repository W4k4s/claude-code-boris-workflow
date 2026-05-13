# AGENT-INSTALL

Instrucciones para un agente que este instalando este workflow Boris multi-tool en la maquina del usuario.

## Objetivo

Instalar metodologia, agentes, workflows reutilizables y guardrails globales para Claude Code, Codex y OpenCode sin pisar configuracion existente sin aviso.

El usuario puede pedir una sola herramienta o todas:

- `--claude`: Claude Code en `~/.claude/`
- `--codex`: Codex en `~/.codex/` y skills en `~/.agents/skills/`
- `--opencode`: OpenCode en `~/.config/opencode/`
- `--all`: todas las anteriores, comportamiento por defecto

## Instalacion Recomendada

Clona el repo y ejecuta el instalador con la seleccion adecuada:

```bash
git clone https://github.com/W4k4s/claude-code-boris-workflow.git /tmp/boris-workflow
/tmp/boris-workflow/install.sh --all
```

Para instalar solo una herramienta:

```bash
/tmp/boris-workflow/install.sh --claude
/tmp/boris-workflow/install.sh --codex
/tmp/boris-workflow/install.sh --opencode
```

## Politica De Colisiones

Para cada archivo que el instalador quiera copiar:

- Si no existe en destino, copiar directamente.
- Si existe y es identico, saltar.
- Si existe y es distinto, mostrar `diff -u` y preguntar: sobreescribir, saltar o guardar backup `.bak` y sobreescribir.

Para instrucciones globales personales (`CLAUDE.md`, `AGENTS.md`), si ya existen y son distintas, no sobreescribir automaticamente. Mostrar diff y recomendar merge manual dejando intactas las reglas del usuario.

## Que Copiar Por Herramienta

Claude Code:

- `global/CLAUDE.md` -> `~/.claude/CLAUDE.md`
- `global/agents/*.md` -> `~/.claude/agents/`
- `global/commands/*.md` -> `~/.claude/commands/`

Codex:

- `global/codex/AGENTS.md` -> `~/.codex/AGENTS.md`
- `global/codex/agents/*.toml` -> `~/.codex/agents/`
- `global/codex/rules/*.rules` -> `~/.codex/rules/`
- `global/codex/skills/*/SKILL.md` -> `~/.agents/skills/*/SKILL.md`

OpenCode:

- `global/opencode/AGENTS.md` -> `~/.config/opencode/AGENTS.md`
- `global/opencode/opencode.json` -> `~/.config/opencode/opencode.json`
- `global/opencode/agents/*.md` -> `~/.config/opencode/agents/`
- `global/opencode/commands/*.md` -> `~/.config/opencode/commands/`

## Paridad Esperada

| Workflow | Claude Code | Codex | OpenCode |
| --- | --- | --- | --- |
| Review adversarial | `/grill` | `$boris-grill` | `/grill` |
| Review cambios locales | `/review-changes` | `$boris-review-changes` | `/review-changes` |
| Commit rapido | `/quick-commit` | `$boris-quick-commit` | `/quick-commit` |
| Commit + push + PR | `/commit-push-pr` | `$boris-commit-push-pr` | `/commit-push-pr` |
| Tech debt | `/techdebt` | `$boris-techdebt` | `/techdebt` |
| Worktree paralelo | `/worktree` | `$boris-worktree` | `/worktree` |
| Cierre sesion | `/cierre-sesion` | `$boris-cierre-sesion` | `/cierre-sesion` |

## Restricciones

- Nunca sobreescribir un archivo distinto sin mostrar diff y recibir confirmacion.
- Nunca modificar credenciales, auth files, histories, caches, sesiones o logs.
- Nunca modificar `~/.claude/settings.json`, `~/.codex/config.toml`, providers, plugins o keys salvo peticion explicita.
- Nunca tocar proyectos especificos, `.claude/projects/`, `.codex/sessions/` ni otros directorios de estado.
- Nunca pushear a ningun repo propio del usuario sin peticion explicita.
- Si una accion puede ser destructiva o externa, preguntar antes.

## Resumen Final Esperado

Al terminar, imprime una tabla con:

- Claude Code: instrucciones, agents y commands instalados, saltados o con conflicto.
- Codex: instrucciones, agents, skills y rules instalados, saltados o con conflicto.
- OpenCode: instrucciones, config, agents y commands instalados, saltados o con conflicto.
- Proximo paso sugerido para probar el workflow.
