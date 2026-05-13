# AGENT-INSTALL

Instrucciones para un agente que este instalando este workflow Boris multi-tool en la maquina del usuario.

## Objetivo

Instalar metodologia, agentes, comandos y guardrails globales para Claude Code, Codex y OpenCode sin pisar configuracion existente sin aviso.

Destinos:

- Claude Code: `~/.claude/`
- Codex: `~/.codex/`
- OpenCode: `~/.config/opencode/`

## Pasos

1. Clonar el repo en un directorio temporal:

```bash
git clone https://github.com/W4k4s/claude-code-boris-workflow.git /tmp/boris-workflow
```

2. Asegurar que existen los directorios globales:

```bash
mkdir -p ~/.claude/agents ~/.claude/commands
mkdir -p ~/.codex/agents
mkdir -p ~/.config/opencode/agents ~/.config/opencode/commands
```

3. Detectar colisiones antes de copiar.

Para cada archivo de agents, commands y config:

- Si no existe en destino, copiar directamente.
- Si existe y es identico, saltar.
- Si existe y es distinto, mostrar `diff -u` y preguntar: sobreescribir, saltar o guardar backup `.bak` y sobreescribir.

4. Instrucciones globales.

Tratar estos ficheros como templates personales:

- `global/CLAUDE.md` -> `~/.claude/CLAUDE.md`
- `global/codex/AGENTS.md` -> `~/.codex/AGENTS.md`
- `global/opencode/AGENTS.md` -> `~/.config/opencode/AGENTS.md`

Si no existen, copiarlos. Si ya existen y son distintos, no sobreescribir automaticamente: mostrar donde esta el template y ofrecer merge guiado dejando intactas las reglas del usuario.

5. Copiar agentes.

- `global/agents/*.md` -> `~/.claude/agents/`
- `global/codex/agents/*.toml` -> `~/.codex/agents/`
- `global/opencode/agents/*.md` -> `~/.config/opencode/agents/`

6. Copiar comandos.

- `global/commands/*.md` -> `~/.claude/commands/`
- `global/opencode/commands/*.md` -> `~/.config/opencode/commands/`

7. Copiar guardrails OpenCode.

- `global/opencode/opencode.json` -> `~/.config/opencode/opencode.json`

Si ya existe, mostrar diff y pedir confirmacion antes de sobreescribir. No modificar modelos, providers, credenciales ni plugins fuera de ese fichero.

8. Ajustar perfil si el usuario lo pide.

Abrir en lectura los ficheros globales instalados y localizar la seccion de perfil. Preguntar nombre, GitHub, email, timezone, idioma y preferencias de modelo. Insertar solo en los ficheros que el usuario apruebe.

9. Resumen final.

Imprimir una tabla con:

- Claude Code: instrucciones, agents y commands instalados, saltados o con conflicto.
- Codex: instrucciones y agents instalados, saltados o con conflicto.
- OpenCode: instrucciones, config, agents y commands instalados, saltados o con conflicto.
- Proximo paso sugerido para probar el workflow.

10. Limpieza.

Borrar el clon temporal salvo que el usuario pida conservarlo.

## Restricciones

- Nunca sobreescribir un archivo distinto sin mostrar diff y recibir confirmacion.
- Nunca modificar credenciales, auth files, histories, caches, sesiones o logs.
- Nunca modificar `~/.claude/settings.json`, `~/.codex/config.toml`, providers, plugins o keys salvo peticion explicita.
- Nunca tocar proyectos especificos, `.claude/projects/`, `.codex/sessions/` ni otros directorios de estado.
- Nunca pushear a ningun repo propio del usuario sin peticion explicita.
- Si una accion puede ser destructiva o externa, preguntar antes.

## Uso Tipico

El usuario pega en Claude Code, Codex u OpenCode:

> Lee https://github.com/W4k4s/claude-code-boris-workflow - especialmente AGENT-INSTALL.md - e instala el workflow Boris multi-tool en mi maquina. Si ya tengo archivos con el mismo nombre en ~/.claude, ~/.codex o ~/.config/opencode, muestrame el diff antes de sobreescribir. No toques proyectos especificos, credenciales, plugins ni settings no cubiertos por el instalador. Al terminar, resume que instalaste y que dejaste intacto.

El agente sigue los pasos de arriba.
