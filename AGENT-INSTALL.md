# AGENT-INSTALL

Instrucciones para un agente Claude Code que esté instalando este workflow en la máquina del usuario.

## Objetivo
Dejar los 3 agents, 6 commands y el CLAUDE.md global en `~/.claude/` sin pisar configuración existente sin aviso.

## Pasos

1. **Clonar el repo en un directorio temporal**:
   ```bash
   git clone https://github.com/W4k4s/claude-code-boris-workflow.git /tmp/boris-workflow
   ```

2. **Asegurar que existe `~/.claude/`** (normalmente ya existe si el usuario tiene Claude Code):
   ```bash
   mkdir -p ~/.claude/agents ~/.claude/commands
   ```

3. **Detectar colisiones** antes de copiar. Para cada archivo en `/tmp/boris-workflow/global/agents/*.md` y `/tmp/boris-workflow/global/commands/*.md`, comprobar si existe un archivo con el mismo nombre en el destino (`~/.claude/agents/` o `~/.claude/commands/`).
   - Si NO existe → copiar directamente.
   - Si existe y es idéntico (`diff` sin salida) → saltar.
   - Si existe y es distinto → mostrar al usuario el diff y preguntar: sobreescribir / saltar / renombrar el entrante con sufijo `.boris.md`.

4. **CLAUDE.md global** (`~/.claude/CLAUDE.md`):
   - Si NO existe → copiar `global/CLAUDE.md` entero.
   - Si existe → NO sobreescribir. Mostrar el contenido del template al usuario y ofrecer merge guiado (añadir secciones que le falten, dejando las suyas intactas).

5. **Ajustar perfil**: abrir `~/.claude/CLAUDE.md` en modo lectura, localizar la sección "## Tu perfil" y preguntar al usuario los datos (nombre, GitHub, email, timezone, idioma preferido, preferencias de modelo). Insertarlos como bullets dentro de esa sección.

6. **Resumen final**: imprimir una tabla con:
   - Agents instalados / saltados
   - Commands instalados / saltados
   - Estado del CLAUDE.md (creado nuevo / ya existía / mergeado)
   - Próximo paso sugerido: "abre Claude Code en cualquier proyecto y prueba `/grill` o pide `planifica X` para ver el plan mode"

7. **Limpieza**: borrar `/tmp/boris-workflow` (preguntar antes si el usuario prefiere guardarlo).

## Restricciones

- **Nunca** sobreescribir un archivo sin mostrar el diff al usuario y recibir confirmación.
- **Nunca** modificar `~/.claude/settings.json` ni plugins ni keys sin que el usuario lo pida explícitamente.
- **Nunca** pushear a ningún repo propio del usuario.
- **Nunca** tocar `~/.claude/projects/`, `~/.claude/channels/` ni otros directorios de estado.

## Uso típico

El usuario pega en Claude Code:

> Lee https://github.com/W4k4s/claude-code-boris-workflow — especialmente AGENT-INSTALL.md — y aplícalo en mi Claude Code. Si ya tengo archivos en ~/.claude/agents/ o ~/.claude/commands/ con el mismo nombre, muéstramelos antes de sobreescribir. Al terminar, haz un resumen de qué instalaste y qué dejaste intacto.

El agente sigue los pasos de arriba.
