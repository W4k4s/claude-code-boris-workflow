#!/usr/bin/env bash
# claude-code-boris-workflow — installer
# Copies global/* into ~/.claude/ with conflict detection.

set -euo pipefail

REPO_URL="https://github.com/W4k4s/claude-code-boris-workflow.git"
DEST="${CLAUDE_HOME:-$HOME/.claude}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

bold=$(tput bold 2>/dev/null || printf '')
dim=$(tput dim 2>/dev/null || printf '')
reset=$(tput sgr0 2>/dev/null || printf '')

echo "${bold}claude-code-boris-workflow installer${reset}"
echo "Destino: $DEST"
echo

mkdir -p "$DEST/agents" "$DEST/commands"

echo "${dim}Clonando repo en $TMP...${reset}"
git clone --depth=1 "$REPO_URL" "$TMP/boris-workflow" >/dev/null 2>&1

SRC="$TMP/boris-workflow/global"

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
echo "${bold}Agents${reset}"
for f in "$SRC"/agents/*.md; do
    copy_one "$f" "$DEST/agents/$(basename "$f")" "agents/$(basename "$f")"
done

echo
echo "${bold}Commands${reset}"
for f in "$SRC"/commands/*.md; do
    copy_one "$f" "$DEST/commands/$(basename "$f")" "commands/$(basename "$f")"
done

echo
echo "${bold}CLAUDE.md global${reset}"
if [[ ! -e "$DEST/CLAUDE.md" ]]; then
    cp "$SRC/CLAUDE.md" "$DEST/CLAUDE.md"
    echo "  + instalado: CLAUDE.md"
    echo "  → abre $DEST/CLAUDE.md y rellena la sección 'Tu perfil'."
else
    echo "  ! ya tienes $DEST/CLAUDE.md. No lo toco."
    echo "  → template disponible en: $SRC/CLAUDE.md"
    echo "  → copia las secciones que te falten manualmente."
fi

echo
echo "${bold}Listo.${reset}"
echo "Siguiente paso: abre Claude Code en cualquier proyecto y prueba /grill o pide 'planifica X'."
