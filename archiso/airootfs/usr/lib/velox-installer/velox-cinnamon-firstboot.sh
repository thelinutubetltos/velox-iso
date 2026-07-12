#!/bin/bash
# Runs once on first Cinnamon login to reinforce Velox theme settings.
# Primary mechanisms are GSettings schema override + dconf system profile;
# this is a belt-and-suspenders layer that removes itself after running.

FLAG="$HOME/.local/share/velox-cinnamon-setup-done"
[ -f "$FLAG" ] && exit 0

mkdir -p "$HOME/.local/share"
exec >> "$HOME/.local/share/velox-cinnamon-firstboot.log" 2>&1
echo "$(date): Starting Velox Cinnamon firstboot"

# Wait for the Cinnamon session and dbus to be ready
sleep 8

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

apply_settings() {
    gsettings set org.cinnamon.theme name 'Fluent-Velox-Dark'
    gsettings set org.cinnamon.desktop.wm.preferences theme 'Fluent-Velox-Dark'
    gsettings set org.cinnamon.desktop.interface gtk-theme 'Fluent-grey-Dark'
    gsettings set org.cinnamon.desktop.interface icon-theme 'Newaita-Velox'
    gsettings set org.cinnamon.desktop.interface cursor-theme 'breeze_cursors'
    gsettings set org.cinnamon.desktop.interface font-name 'Noto Sans 11'
    gsettings set org.gnome.desktop.interface gtk-theme 'Fluent-grey-Dark'
    gsettings set org.gnome.desktop.interface icon-theme 'Newaita-Velox'
    gsettings set org.gnome.desktop.interface cursor-theme 'breeze_cursors'
    gsettings set org.gnome.desktop.interface font-name 'Noto Sans 11'
    gsettings set org.cinnamon favorite-apps \
        "['velox-control-center.desktop', 'nemo.desktop', 'xfce4-terminal.desktop', 'firefox.desktop']"
    gsettings set org.cinnamon.desktop.background picture-uri \
        'file:///usr/share/wallpapers/Velox-15/contents/images/3840x2160.png'
    gsettings set org.cinnamon.desktop.background picture-options 'zoom'
}

apply_settings
echo "$(date): Applied gsettings"

# Verify and retry once if theme didn't take
sleep 3
CURRENT_THEME=$(gsettings get org.cinnamon.theme name 2>/dev/null)
if [[ "$CURRENT_THEME" != "'Fluent-Velox-Dark'" ]]; then
    echo "$(date): Theme check failed ($CURRENT_THEME), retrying"
    sleep 5
    apply_settings
fi

gtk-update-icon-cache -f ~/.local/share/icons/Newaita-Velox/ 2>/dev/null || true

# Mark done and disable the system-wide autostart entry
mkdir -p ~/.local/share
touch "$FLAG"
# Disable the XDG autostart entry for this user (Hidden=true in user override)
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/velox-cinnamon-setup.desktop << 'EOF'
[Desktop Entry]
Hidden=true
EOF

echo "$(date): Velox Cinnamon firstboot complete"
