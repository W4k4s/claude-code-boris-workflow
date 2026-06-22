#!/usr/bin/env bash
# claude-code-boris-workflow — installer
# Installs Boris workflow files for Claude Code, Codex and OpenCode with conflict detection.

set -euo pipefail

REPO_URL="https://github.com/W4k4s/claude-code-boris-workflow.git"
CLAUDE_DEST="${CLAUDE_HOME:-$HOME/.claude}"
CLAUDE_SKILLS_DEST="${CLAUDE_SKILLS_HOME:-$CLAUDE_DEST/skills}"
CODEX_DEST="${CODEX_HOME:-$HOME/.codex}"
CODEX_SKILLS_DEST="${CODEX_SKILLS_HOME:-$HOME/.agents/skills}"
OPENCODE_DEST="${OPENCODE_CONFIG_DIR:-$HOME/.config/opencode}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

bold=$(tput bold 2>/dev/null || printf '')
dim=$(tput dim 2>/dev/null || printf '')
reset=$(tput sgr0 2>/dev/null || printf '')

install_claude=false
install_codex=false
install_opencode=false

usage() {
    cat <<'USAGE'
Usage: ./install.sh [--all] [--claude] [--codex] [--opencode]

Options:
  --all       Install Claude Code, Codex and OpenCode workflow files (default)
  --claude    Install only Claude Code files under ~/.claude, including ~/.claude/skills
  --codex     Install only Codex files under ~/.codex and ~/.agents/skills
  --opencode  Install only OpenCode files under ~/.config/opencode
  -h, --help  Show this help
USAGE
}

if [[ $# -eq 0 ]]; then
    install_claude=true
    install_codex=true
    install_opencode=true
else
    for arg in "$@"; do
        case "$arg" in
            --all)
                install_claude=true
                install_codex=true
                install_opencode=true
                ;;
            --claude) install_claude=true ;;
            --codex) install_codex=true ;;
            --opencode) install_opencode=true ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                echo "Opcion desconocida: $arg" >&2
                usage >&2
                exit 1
                ;;
        esac
    done
fi

echo "${bold}claude-code-boris-workflow installer${reset}"
echo "Claude Code:  $CLAUDE_DEST"
echo "Claude skills: $CLAUDE_SKILLS_DEST"
echo "Codex:        $CODEX_DEST"
echo "Codex skills: $CODEX_SKILLS_DEST"
echo "OpenCode:     $OPENCODE_DEST"
echo

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

    mkdir -p "$(dirname "$dest_file")"

    if [[ ! -e "$dest_file" ]]; then
        cp "$src_file" "$dest_file"
        echo "  + instalado: $label"
        return
    fi

    if diff -q "$src_file" "$dest_file" >/dev/null 2>&1; then
        echo "  = ya al dia: $label"
        return
    fi

    echo "  ! ya existe: $label. No lo toco."
    echo "  Diff (actual -> template):"
    diff -u "$dest_file" "$src_file" || true
    echo "  -> copia manualmente las secciones que te falten."
}

copy_one() {
    local src_file="$1"
    local dest_file="$2"
    local label="$3"

    mkdir -p "$(dirname "$dest_file")"

    if [[ ! -e "$dest_file" ]]; then
        cp "$src_file" "$dest_file"
        echo "  + instalado: $label"
        return
    fi

    if diff -q "$src_file" "$dest_file" >/dev/null 2>&1; then
        echo "  = ya al dia: $label"
        return
    fi

    echo
    echo "${bold}CONFLICTO${reset}: $label ya existe y es distinto."
    echo "Diff (actual -> entrante):"
    diff -u "$dest_file" "$src_file" || true
    echo
    read -r -p "[o]verwrite / [s]kip / [b]ackup (.bak) y sobreescribir ? " choice
    case "$choice" in
        o|O) cp "$src_file" "$dest_file"; echo "  ! sobrescrito: $label" ;;
        b|B) backup="$dest_file.$(date +%Y%m%d-%H%M%S).bak"; cp "$dest_file" "$backup"; cp "$src_file" "$dest_file"; echo "  ! sobrescrito con backup: $label ($backup guardado)" ;;
        *)   echo "  . saltado: $label" ;;
    esac
}

copy_tree_files() {
    local src_dir="$1"
    local dest_dir="$2"
    local label_prefix="$3"

    mkdir -p "$dest_dir"
    for f in "$src_dir"/*; do
        [[ -f "$f" ]] || continue
        copy_one "$f" "$dest_dir/$(basename "$f")" "$label_prefix/$(basename "$f")"
    done
}

copy_tree_recursive_files() {
    local src_dir="$1"
    local dest_dir="$2"
    local label_prefix="$3"
    local f rel

    mkdir -p "$dest_dir"
    shopt -s globstar nullglob
    for f in "$src_dir"/**/*; do
        [[ -f "$f" ]] || continue
        rel="${f#"$src_dir"/}"
        copy_one "$f" "$dest_dir/$rel" "$label_prefix/$rel"
    done
    shopt -u globstar nullglob
}

copy_skill_dir() {
    local src_dir="$1"
    local dest_dir="$2"
    local label="$3"

    copy_tree_recursive_files "$src_dir" "$dest_dir" "$label"
}

install_claude_files() {
    mkdir -p "$CLAUDE_DEST/agents" "$CLAUDE_DEST/commands" "$CLAUDE_SKILLS_DEST"

    echo
    echo "${bold}Claude Code agents${reset}"
    copy_tree_files "$SRC/agents" "$CLAUDE_DEST/agents" "~/.claude/agents"

    echo
    echo "${bold}Claude Code commands${reset}"
    copy_tree_files "$SRC/commands" "$CLAUDE_DEST/commands" "~/.claude/commands"

    echo
    echo "${bold}Claude Code skills${reset}"
    for d in "$SRC"/skills/*; do
        [[ -d "$d" ]] || continue
        copy_skill_dir "$d" "$CLAUDE_SKILLS_DEST/$(basename "$d")" "~/.claude/skills/$(basename "$d")"
    done

    echo
    echo "${bold}CLAUDE.md global${reset}"
    copy_template_only "$SRC/CLAUDE.md" "$CLAUDE_DEST/CLAUDE.md" "~/.claude/CLAUDE.md"

    echo
    echo "${bold}settings.json global${reset}"
    copy_template_only "$SRC/settings.json" "$CLAUDE_DEST/settings.json" "~/.claude/settings.json"
}

install_codex_files() {
    mkdir -p "$CODEX_DEST/agents" "$CODEX_DEST/rules" "$CODEX_SKILLS_DEST"

    echo
    echo "${bold}Codex agents${reset}"
    copy_tree_files "$SRC/codex/agents" "$CODEX_DEST/agents" "~/.codex/agents"

    echo
    echo "${bold}Codex skills${reset}"
    for d in "$SRC"/codex/skills/*; do
        [[ -d "$d" ]] || continue
        copy_skill_dir "$d" "$CODEX_SKILLS_DEST/$(basename "$d")" "~/.agents/skills/$(basename "$d")"
    done

    echo
    echo "${bold}Codex rules${reset}"
    copy_tree_files "$SRC/codex/rules" "$CODEX_DEST/rules" "~/.codex/rules"

    echo
    echo "${bold}Codex AGENTS.md global${reset}"
    copy_template_only "$SRC/codex/AGENTS.md" "$CODEX_DEST/AGENTS.md" "~/.codex/AGENTS.md"
}

install_opencode_files() {
    mkdir -p "$OPENCODE_DEST/agents" "$OPENCODE_DEST/commands"

    echo
    echo "${bold}OpenCode agents${reset}"
    copy_tree_files "$SRC/opencode/agents" "$OPENCODE_DEST/agents" "~/.config/opencode/agents"

    echo
    echo "${bold}OpenCode commands${reset}"
    copy_tree_files "$SRC/opencode/commands" "$OPENCODE_DEST/commands" "~/.config/opencode/commands"

    echo
    echo "${bold}OpenCode config${reset}"
    copy_template_only "$SRC/opencode/opencode.json" "$OPENCODE_DEST/opencode.json" "~/.config/opencode/opencode.json"

    echo
    echo "${bold}OpenCode AGENTS.md global${reset}"
    copy_template_only "$SRC/opencode/AGENTS.md" "$OPENCODE_DEST/AGENTS.md" "~/.config/opencode/AGENTS.md"
}

if [[ "$install_claude" == true ]]; then
    install_claude_files
fi

if [[ "$install_codex" == true ]]; then
    install_codex_files
fi

if [[ "$install_opencode" == true ]]; then
    install_opencode_files
fi

echo
echo "${bold}Listo.${reset}"
echo "Siguiente paso: abre la herramienta instalada y prueba un flujo de planificacion."
