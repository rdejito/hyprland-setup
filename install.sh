#!/usr/bin/env bash
#
# hyprland-setup — apply this Hyprland rice to a fresh system.
#
# The tracked dotfiles are *symlinked* from this repo into $HOME, so editing
# ~/.config/... edits the repo and `git status` shows your changes. Anything
# already in the way is moved to a timestamped backup directory first, so
# nothing is overwritten destructively.
#
set -euo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.hyprland-setup-backup-$(date +%Y%m%d-%H%M%S)"

DRY_RUN=0
DO_PACKAGES=0
DO_SHELL=0
DO_SDDM=0

log()  { printf '\033[1;34m::\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31mxx\033[0m %s\n' "$*" >&2; exit 1; }

usage() {
    cat <<EOF
Usage: ./install.sh [options]

  -n, --dry-run    Show what would happen without changing anything
  -p, --packages   Install package lists (pacman + AUR via paru)
  -s, --shell      Also link .zshrc/.bashrc and install oh-my-zsh
      --sddm       Install the SDDM theme (runs: sudo sddm/install.sh)
  -h, --help       Show this help

With no options it links the Hyprland/Waybar/etc. configs, helper scripts,
the cursor theme and the wallpapers.
EOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        -n|--dry-run) DRY_RUN=1 ;;
        -p|--packages) DO_PACKAGES=1 ;;
        -s|--shell) DO_SHELL=1 ;;
        --sddm) DO_SDDM=1 ;;
        -h|--help) usage; exit 0 ;;
        *) die "Unknown option: $1 (try --help)" ;;
    esac
    shift
done

# Back up $dst inside $BACKUP_DIR, preserving its path relative to $HOME.
backup_path() {
    printf '%s/%s' "$BACKUP_DIR" "${1#"$HOME"/}"
}

# link <src> <dst> — symlink src at dst, backing up whatever was there.
link() {
    local src=$1 dst=$2
    if [ ! -e "$src" ] && [ ! -L "$src" ]; then
        warn "missing source, skipping: $src"
        return 0
    fi
    mkdir -p "$(dirname "$dst")"

    if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; then
        log "ok      $dst"
        return 0
    fi

    if [ -e "$dst" ] || [ -L "$dst" ]; then
        local b; b="$(backup_path "$dst")"
        if [ "$DRY_RUN" = 1 ]; then
            log "backup  $dst -> $b"
        else
            mkdir -p "$(dirname "$b")"
            mv "$dst" "$b"
        fi
    fi

    if [ "$DRY_RUN" = 1 ]; then
        log "link    $dst -> $src"
    else
        ln -s "$src" "$dst"
        log "link    $dst"
    fi
}

log "Repo:   $REPO_DIR"
log "Target: $HOME"
[ "$DRY_RUN" = 1 ] && warn "dry run: nothing will be changed"

# --- ~/.config/<name> -------------------------------------------------------
for src in "$REPO_DIR"/config/*; do
    link "$src" "$HOME/.config/$(basename "$src")"
done

# --- ~/.local/bin/<script> --------------------------------------------------
for src in "$REPO_DIR"/local/bin/*; do
    link "$src" "$HOME/.local/bin/$(basename "$src")"
done

# --- cursor theme -----------------------------------------------------------
link "$REPO_DIR/share/icons/mavuika-cursor" \
     "$HOME/.local/share/icons/mavuika-cursor"

# --- wallpapers (link each entry so your own wallpapers survive) ------------
mkdir -p "$HOME/Pictures/Wallpapers"
for src in "$REPO_DIR"/pictures/Wallpapers/*; do
    link "$src" "$HOME/Pictures/Wallpapers/$(basename "$src")"
done

# --- shell files (opt-in) ---------------------------------------------------
if [ "$DO_SHELL" = 1 ]; then
    link "$REPO_DIR/shell/zshrc"  "$HOME/.zshrc"
    link "$REPO_DIR/shell/bashrc" "$HOME/.bashrc"
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log "Installing oh-my-zsh"
        if [ "$DRY_RUN" = 1 ]; then
            echo "   git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh"
        else
            git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
        fi
    fi
fi

# --- packages (opt-in) ------------------------------------------------------
read_list() { grep -vE '^[[:space:]]*(#|$)' "$1" || true; }

if [ "$DO_PACKAGES" = 1 ]; then
    command -v pacman >/dev/null 2>&1 || die "pacman not found (this setup targets Arch Linux)"

    mapfile -t pkgs < <(read_list "$REPO_DIR/packages/pacman.txt")
    if [ "${#pkgs[@]}" -gt 0 ]; then
        log "Installing official packages (pacman)"
        if [ "$DRY_RUN" = 1 ]; then
            printf '   sudo pacman -S --needed %s\n' "${pkgs[*]}"
        else
            sudo pacman -S --needed --noconfirm "${pkgs[@]}"
        fi
    fi

    mapfile -t aur < <(read_list "$REPO_DIR/packages/aur.txt")
    if [ "${#aur[@]}" -gt 0 ]; then
        if command -v paru >/dev/null 2>&1; then
            log "Installing AUR packages (paru)"
            if [ "$DRY_RUN" = 1 ]; then
                printf '   paru -S --needed %s\n' "${aur[*]}"
            else
                paru -S --needed --noconfirm "${aur[@]}"
            fi
        else
            warn "paru not found; skipping AUR packages (see packages/aur.txt)"
        fi
    fi
fi

# --- SDDM theme (opt-in, needs root) ----------------------------------------
if [ "$DO_SDDM" = 1 ]; then
    log "Installing SDDM theme (requires sudo)"
    if [ "$DRY_RUN" = 1 ]; then
        echo "   sudo bash $REPO_DIR/sddm/install.sh"
    else
        sudo bash "$REPO_DIR/sddm/install.sh"
    fi
fi

cat <<EOF

Done.

Next steps
  * Log out and back in (or reboot) to start the new session.
  * Reload Hyprland after config edits:  hyprctl reload
  * Install packages:   ./install.sh --packages
  * Link shell files:   ./install.sh --shell
  * Install SDDM theme: ./install.sh --sddm

Keybindings cheat sheet: docs/hyprland-keybindings.md
EOF

if [ -d "$BACKUP_DIR" ]; then
    echo "Existing files were backed up to: $BACKUP_DIR"
fi
