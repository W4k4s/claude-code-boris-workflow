#!/usr/bin/env bash
# claude-code-boris-workflow — installer
# Copies global workflow files into Claude Code, Codex and OpenCode homes with conflict detection.

set -euo pipefail

REPO_URL="https://github.com/W4k4s/claude-code-boris-workflow.git"
CLAUDE_DEST="${CLAUDE_HOME:-$HOME/.claude}"
CODEX_DEST="${CODEX_HOME:-$HOME/.codex}"
OPENCODE_DEST="${OPENCODE_CONFIG_DIR:-$HOME/.config/opencode}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

bold=$(tput bold 2>/dev/null || printf '')
dim=$(tput dim 2>/dev/null || printf '')
reset=$(tput sgr0 2>/dev/null || printf '')

echo "${bold}claude-code-boris-workflow installer${reset}"
echo "Claude Code: $CLAUDE_DEST"
echo "Codex:       $CODEX_DEST"
echo "OpenCode:    $OPENCODE_DEST"
echo

mkdir -p \
    "$CLAUDE_DEST/agents" "$CLAUDE_DEST/commands" \
    "$CODEX_DEST/agents" \
    "$OPENCODE_DEST/agents" "$OPENCODE_DEST/commands"

if [[ -n "${BORIS_WORKFLOW_SRC:-}" ]]; then
    echo "${dim}Usando repo local en $BORIS_WORKFLOW_SRC...${reset}"
    SRC="$BORIS_WORKFLOW_SRC/global"
else
    echo "${dim}Clonando repo en $TMP...${reset}"
    git clone --depth=1 "$REPO_URL" "$TMP/boris-workflow" >/dev/null 2>&1
    SRC="$TMP/boris-workflow/global"
fi

if [[ ! -d "$SRC" ]]; then
    echo "No encuentro global/ en $SRC" >&2
    exit 1
fi

copy_template_only() {
    local src_file="$1"
    local dest_file="$2"
    local label="$3"

    if [[ ! -e "$dest_file" ]]; then
        cp "$src_file" "$dest_file"
        echo "  + instalado: $label"
        return
    fi

    if diff -q "$src_file" "$dest_file" >/dev/null 2>&1; then
        echo "  = ya al día: $label"
        return
    fi

    echo "  ! ya existe: $label. No lo toco."
    echo "  Diff (actual → template):"
    diff -u "$dest_file" "$src_file" || true
    echo "  → copia manualmente las secciones que te falten."
}

copy_one() {
    local src_file="$1"
    local dest_file="$2"
    local label="$3"

    if [[ ! -e "$dest_file" ]]; then
        cp "$src_file" "$dest_file"
        echo "  + instalado: $label"
        return
    fi

    if diff -q "$src_file" "$dest_file" >/dev/null 2>&1; then
        echo "  = ya al día: $label"
        return
    fi

    echo
    echo "${bold}CONFLICTO${reset}: $label ya existe y es distinto."
    echo "Diff (actual → entrante):"
    diff -u "$dest_file" "$src_file" || true
    echo
    read -r -p "[o]verwrite / [s]kip / [b]ackup (.bak) y sobreescribir ? " choice
    case "$choice" in
        o|O) cp "$src_file" "$dest_file"; echo "  ! sobrescrito: $label" ;;
        b|B) cp "$dest_file" "$dest_file.bak"; cp "$src_file" "$dest_file"; echo "  ! sobrescrito con backup: $label (.bak guardado)" ;;
        *)   echo "  . saltado: $label" ;;
    esac
}

echo
echo "${bold}Claude Code agents${reset}"
for f in "$SRC"/agents/*.md; do
    copy_one "$f" "$CLAUDE_DEST/agents/$(basename "$f")" "~/.claude/agents/$(basename "$f")"
done

echo
echo "${bold}Claude Code commands${reset}"
for f in "$SRC"/commands/*.md; do
    copy_one "$f" "$CLAUDE_DEST/commands/$(basename "$f")" "~/.claude/commands/$(basename "$f")"
done

echo
echo "${bold}CLAUDE.md global${reset}"
copy_template_only "$SRC/CLAUDE.md" "$CLAUDE_DEST/CLAUDE.md" "~/.claude/CLAUDE.md"

echo
echo "${bold}Codex agents${reset}"
for f in "$SRC"/codex/agents/*.toml; do
    copy_one "$f" "$CODEX_DEST/agents/$(basename "$f")" "~/.codex/agents/$(basename "$f")"
done

echo
echo "${bold}Codex AGENTS.md global${reset}"
copy_template_only "$SRC/codex/AGENTS.md" "$CODEX_DEST/AGENTS.md" "~/.codex/AGENTS.md"

echo
echo "${bold}OpenCode agents${reset}"
for f in "$SRC"/opencode/agents/*.md; do
    copy_one "$f" "$OPENCODE_DEST/agents/$(basename "$f")" "~/.config/opencode/agents/$(basename "$f")"
done

echo
echo "${bold}OpenCode commands${reset}"
for f in "$SRC"/opencode/commands/*.md; do
    copy_one "$f" "$OPENCODE_DEST/commands/$(basename "$f")" "~/.config/opencode/commands/$(basename "$f")"
done

echo
echo "${bold}OpenCode config${reset}"
copy_one "$SRC/opencode/opencode.json" "$OPENCODE_DEST/opencode.json" "~/.config/opencode/opencode.json"

echo
echo "${bold}OpenCode AGENTS.md global${reset}"
copy_template_only "$SRC/opencode/AGENTS.md" "$OPENCODE_DEST/AGENTS.md" "~/.config/opencode/AGENTS.md"

echo
echo "${bold}Listo.${reset}"
echo "Siguiente paso: abre Claude Code, Codex u OpenCode en cualquier proyecto y prueba un flujo de planificacion."
