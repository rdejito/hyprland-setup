# Hyprland Keybindings (i3-style)

Source: `~/.config/hypr/hyprland.lua` (Hyprland 0.57.2)
`mainMod` = **SUPER** (Windows key), matching the current setup.
The layout follows the i3 default config with a few Hyprland-specific
approximations, noted below.

## Windows
| Keys | Action |
|---|---|
| `SUPER + Return` | Open terminal (kitty) |
| `SUPER + D` | App launcher (wofi --show drun) |
| `SUPER + SHIFT + Q` | Close focused window |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + SHIFT + Space` | Toggle floating |

## Focus
| Keys | Action |
|---|---|
| `SUPER + J` | Focus left |
| `SUPER + K` | Focus down |
| `SUPER + L` | Focus up |
| `SUPER + ;` | Focus right |
| `SUPER + Left / Down / Up / Right` | Same as above |

## Move windows
| Keys | Action |
|---|---|
| `SUPER + SHIFT + J` | Move window left |
| `SUPER + SHIFT + K` | Move window down |
| `SUPER + SHIFT + L` | Move window up |
| `SUPER + SHIFT + ;` | Move window right |
| `SUPER + SHIFT + Left / Down / Up / Right` | Same as above |

## Layout
| Keys | Action |
|---|---|
| `SUPER + H` | Split horizontally (preselect right for the next window) |
| `SUPER + V` | Split vertically (preselect down for the next window) |
| `SUPER + E` | Toggle split orientation |

## Workspaces
| Keys | Action |
|---|---|
| `SUPER + 1...9, 0` | Switch to workspace 1-10 |
| `SUPER + SHIFT + 1...9, 0` | Move window to workspace 1-10 |

## Resize mode
Press `SUPER + R` to enter resize mode.

| Keys | Action |
|---|---|
| `J` | Shrink width |
| `K` | Grow height |
| `L` | Shrink height |
| `;` | Grow width |
| `Left` | Shrink width |
| `Down` | Grow height |
| `Up` | Shrink height |
| `Right` | Grow width |
| `Return` / `Escape` / `SUPER + R` | Leave resize mode |

## System / Tools
| Keys | Action |
|---|---|
| `SUPER + SHIFT + C` | Reload Hyprland config |
| `SUPER + SHIFT + E` | Exit prompt (existing power menu) |
| `SUPER + Escape` | Lock (hyprlock, if not already running) |
| `Print` | Screenshot with Flameshot |

Lock uses `SUPER + Escape` because i3 already uses both `SUPER + L` (focus up)
and `SUPER + SHIFT + L` (move window up).

## Mouse
| Keys | Action |
|---|---|
| `SUPER + LMB drag` | Move window |
| `SUPER + RMB drag` | Resize window |

## Media & Hardware keys
| Keys | Action |
|---|---|
| `XF86AudioRaiseVolume` / `LowerVolume` | Volume +/-5% (max 100%) |
| `XF86AudioMute` | Mute output |
| `XF86AudioMicMute` | Mute mic |
| `XF86MonBrightnessUp` / `Down` | Brightness +/-5% |
| `XF86AudioPlay` / `XF86AudioPause` | Play/pause (playerctl) |
| `XF86AudioNext` / `XF86AudioPrev` | Next / previous track |

Note: volume, brightness, and media keys use `locked = true` (work on the
lock screen); volume/brightness keys repeat when held.

## i3 bindings without a Hyprland equivalent

These are intentionally unbound rather than mapped to something misleading:

| Keys | i3 action | Why |
|---|---|---|
| `SUPER + S` | Stacking layout | Hyprland's dwindle layout has no stacking mode |
| `SUPER + W` | Tabbed layout | Groups are not a drop-in tabbed layout |
| `SUPER + A` | Focus parent | No parent-container focus in dwindle |
| `SUPER + Space` | Focus tiling/floating mode | No equivalent focus-mode toggle |
| `SUPER + SHIFT + R` | Restart i3 in place | Hyprland cannot restart without ending the session |

## Removed custom bindings

The previous custom bindings for the file manager, screenshots, clipboard
history, and scratchpad were removed to keep this an i3-style layout. They can
be added back on non-conflicting keys later. The existing power-menu script is
still used for i3's exit prompt (`SUPER + SHIFT + E`).
