#!/usr/bin/env bash
# Install the custom Catppuccin Mocha SDDM greeter.
# Run with: sudo bash ~/sddm-customization/install.sh
set -euo pipefail

if [[ $(id -u) -ne 0 ]]; then
  echo "This script must be run as root: sudo bash $0" >&2
  exit 1
fi

src_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
theme_name=catppuccin-mocha-custom
theme_src="$src_dir/$theme_name"
theme_dst="/usr/share/sddm/themes/$theme_name"
conf_dst="/etc/sddm.conf.d/50-custom.conf"

if [[ ! -f "$theme_src/Main.qml" ]]; then
  echo "Missing theme files at $theme_src" >&2
  exit 1
fi

# Remove any previous install of this theme, then copy the staged version.
rm -rf -- "$theme_dst"
cp -a -- "$theme_src" "$theme_dst"
chmod -R a+rX -- "$theme_dst"

install -D -m 0644 -- "$src_dir/50-custom.conf" "$conf_dst"

cat <<EOF

Installed:
  Theme:  $theme_dst
  Config: $conf_dst

SDDM was NOT restarted, so your current session is untouched.
Log out (or reboot) to see the new login screen.

Rollback:
  sudo rm -rf "$theme_dst" "$conf_dst"
EOF
