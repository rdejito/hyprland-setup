# hyprland-setup

My personal Hyprland rice (Arch Linux), packaged so it can be re-applied on a
fresh install or a different machine. Theme is **Catppuccin Mocha** throughout.

The installer **symlinks** the tracked files into `$HOME`, so editing
`~/.config/...` edits the repo and `git status` shows your changes. Anything
already in the way is moved to a timestamped backup first.

## Contents

| Path | What it is |
|---|---|
| `config/hypr/` | Hyprland (`hyprland.lua`), `hyprlock`, `hypridle`, `hyprpaper`, `hyprsunset` |
| `config/waybar/` | Waybar bar (`config.jsonc`, `style.css`) |
| `config/wofi/` | App launcher / dmenu |
| `config/dunst/` | Notification daemon |
| `config/kitty/` | Terminal |
| `config/gtk-3.0`, `config/gtk-4.0` | GTK theme / cursor settings |
| `config/qt6ct/` | Qt6 theming + Catppuccin colour scheme |
| `config/mimeapps.list` | Default applications |
| `local/bin/` | Helper scripts: `power-menu`, `network-menu`, `network-status`, `clipboard-menu`, `screenshot` |
| `share/icons/mavuika-cursor/` | Cursor theme |
| `pictures/Wallpapers/` | Wallpapers used by `hyprpaper` and `hyprlock` |
| `sddm/` | Custom Catppuccin SDDM login theme + installer |
| `shell/` | `.zshrc` / `.bashrc` (linked only with `--shell`) |
| `packages/` | Package lists for a fresh install |
| `docs/hyprland-keybindings.md` | Full keybinding cheat sheet |

## Requirements

Arch Linux (or an Arch-based distro). A working `pacman` and, for the AUR
packages, `paru`. Internet access for packages and fonts.

## Quick start

```sh
git clone <this-repo-url> ~/hyprland-setup
cd ~/hyprland-setup
./install.sh --dry-run     # see exactly what will happen
./install.sh               # link configs, scripts, cursor, wallpapers
```

Then, as desired:

```sh
./install.sh --packages    # install pacman + AUR package lists
./install.sh --shell       # link .zshrc/.bashrc and install oh-my-zsh
./install.sh --sddm        # install the SDDM login theme (needs sudo)
```

Log out and back in (or reboot) to start the new session.

## Installer options

| Option | Effect |
|---|---|
| `-n`, `--dry-run` | Show what would happen, change nothing |
| `-p`, `--packages` | Install `packages/pacman.txt` then `packages/aur.txt` |
| `-s`, `--shell` | Link `.zshrc`/`.bashrc` and install oh-my-zsh if missing |
| `--sddm` | Run `sudo sddm/install.sh` to install the login theme |
| `-h`, `--help` | Usage |

## What gets linked where

```
repo/config/<name>            ->  ~/.config/<name>
repo/local/bin/<script>       ->  ~/.local/bin/<script>
repo/share/icons/mavuika-cursor -> ~/.local/share/icons/mavuika-cursor
repo/pictures/Wallpapers/<x>  ->  ~/Pictures/Wallpapers/<x>
repo/shell/zshrc              ->  ~/.zshrc      (with --shell)
repo/shell/bashrc             ->  ~/.bashrc     (with --shell)
```

Existing files are moved to `~/.hyprland-setup-backup-<timestamp>/` before being
replaced. To restore one, move it back from there.

## Portability

All machine-specific paths are expressed portably, so the same repo works under
a different username:

- `hyprland.lua` uses `os.getenv("HOME")` (it is a Lua config).
- `hyprlock.conf` / `hyprpaper.conf` use `$HOME` (hyprlang expands it).
- `waybar/config.jsonc` uses `$HOME` (Waybar runs commands through `/bin/sh`).
- `qt6ct.conf` uses `~/` (qt6ct resolves it against your home directory).
- `wofi` uses its default cache location (no hard-coded path).

## Installing paru (AUR helper)

`paru` is itself an AUR package, so bootstrap it once before using
`--packages`:

```sh
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/paru.git /tmp/paru
cd /tmp/paru && makepkg -si
```

Then `./install.sh --packages` can install the rest of the AUR packages.

## SDDM login theme

`sddm/` contains a custom Catppuccin Mocha greeter. Install it with:

```sh
./install.sh --sddm
```

or directly:

```sh
sudo bash ~/hyprland-setup/sddm/install.sh
```

It installs the theme to `/usr/share/sddm/themes/catppuccin-mocha-custom` and
config to `/etc/sddm.conf.d/50-custom.conf`, without restarting SDDM. Rollback
instructions are printed at the end.

## Cursor theme

`mavuika-cursor` ships in this repo. `install.sh` links it into
`~/.local/share/icons/`. The cursor is selected in `hyprland.lua` and in the
GTK settings.

## Keybindings

`mainMod` is **SUPER** (Windows key), with an i3-style layout. See
[`docs/hyprland-keybindings.md`](docs/hyprland-keybindings.md) for the full
table. Highlights:

| Keys | Action |
|---|---|
| `SUPER + Return` | Terminal (kitty) |
| `SUPER + D` | App launcher (wofi) |
| `SUPER + SHIFT + Q` | Close window |
| `SUPER + J/K/L/;` | Focus left/down/up/right |
| `SUPER + SHIFT + J/K/L/;` | Move window |
| `SUPER + 1..0` | Switch workspace |
| `SUPER + R` | Resize mode |
| `SUPER + Escape` | Lock |
| `Print` | Screenshot (flameshot) |

## Editing and keeping the repo in sync

Because files are symlinked, just edit them normally:

```sh
vim ~/.config/hypr/hyprland.lua      # edits the repo file
cd ~/hyprland-setup && git add -A && git commit -m "tweak gaps"
hyprctl reload
```

## Publishing to GitHub

This repo is already committed locally on branch `main`. To publish it:

```sh
# once, if GitHub CLI is missing
sudo pacman -S github-cli
gh auth login

# create the remote and push
cd ~/hyprland-setup
gh repo create hyprland-setup --public --source=. --remote=origin --push
```

The commit author was set to a placeholder. If that is not you, fix it before
pushing:

```sh
git config user.name  "Your Name"
git config user.email "you@example.com"
git commit --amend --reset-author --no-edit
```

## Notes

- `packages/system-pacman.txt` and `packages/system-aur.txt` are full snapshots
  of the machine this was captured from, kept for reference. The curated
  `pacman.txt` / `aur.txt` are what `--packages` actually installs.
- GPU drivers (NVIDIA/Intel/AMD) are intentionally left out of the curated
  lists since they are hardware-specific; the AUR file has a commented NVIDIA
  section.
