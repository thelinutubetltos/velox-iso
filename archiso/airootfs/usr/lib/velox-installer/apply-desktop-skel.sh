#!/bin/bash
# Detect which desktop was installed and copy its skel config into /etc/skel
# Runs in the installed system chroot during Calamares installation

exec > /var/log/velox-desktop-skel.log 2>&1
set -x

DESKTOPS_DIR="/usr/lib/velox-desktops"

detect_desktop() {
    if pacman -Q plasma-desktop &>/dev/null; then
        echo "kde"
    elif pacman -Q cinnamon &>/dev/null; then
        echo "cinnamon"
    elif pacman -Q xfce4 &>/dev/null; then
        echo "xfce"
    else
        echo "unknown"
    fi
}

DESKTOP=$(detect_desktop)
echo "Detected desktop: $DESKTOP"

if [[ "$DESKTOP" == "unknown" ]]; then
    echo "No known desktop detected — skipping skel config"
    exit 0
fi

SKEL_SRC="${DESKTOPS_DIR}/${DESKTOP}/skel"

if [[ ! -d "$SKEL_SRC" ]]; then
    echo "Skel source not found: $SKEL_SRC"
    exit 0
fi

# Copy desktop skel config into /etc/skel
cp -r "${SKEL_SRC}/." /etc/skel/
echo "Copied ${DESKTOP} skel to /etc/skel/"

# Also copy directly to the installed user's home (user is created before this step runs)
INSTALL_USER=$(ls /home | grep -v lost+found | head -1)
if [[ -n "$INSTALL_USER" && -d "/home/$INSTALL_USER" ]]; then
    cp -r "${SKEL_SRC}/." /home/$INSTALL_USER/
    chown -R $INSTALL_USER:$INSTALL_USER /home/$INSTALL_USER/
    echo "Copied ${DESKTOP} skel directly to /home/$INSTALL_USER/"
fi

# Set correct SDDM session and theme for the installed desktop
case "$DESKTOP" in
    kde)
        SESSION="plasma"
        SDDM_THEME="velox"
        ;;
    cinnamon)
        SESSION="cinnamon-wayland"
        SDDM_THEME="velox"
        ;;
    xfce)
        SESSION="xfce"
        SDDM_THEME="velox"
        ;;
esac

sed -i "s/^Session=.*/Session=${SESSION}/" /etc/sddm.conf.d/kde_settings.conf
sed -i "s/^Current=.*/Current=${SDDM_THEME}/" /etc/sddm.conf.d/kde_settings.conf
echo "Set SDDM session to: $SESSION, theme to: $SDDM_THEME"

# KDE Wayland: SDDM must be told to use the Wayland backend so it doesn't hold DRM
# master and block KWin from acquiring the DRM node at session start.
if [[ "$DESKTOP" == "kde" ]]; then
    if ! grep -q "^DisplayServer=" /etc/sddm.conf.d/kde_settings.conf; then
        sed -i "/^\[General\]/a DisplayServer=wayland" /etc/sddm.conf.d/kde_settings.conf
    else
        sed -i "s/^DisplayServer=.*/DisplayServer=wayland/" /etc/sddm.conf.d/kde_settings.conf
    fi
    echo "Set SDDM DisplayServer=wayland for KDE Wayland DRM handoff"

    # kwin_wayland as SDDM compositor — avoids DRM permission errors when Plasma KWin starts
    if ! grep -q "^\[Wayland\]" /etc/sddm.conf.d/kde_settings.conf; then
        printf '\n[Wayland]\nCompositorCommand=/usr/local/bin/velox-sddm-kwin-start\n' >> /etc/sddm.conf.d/kde_settings.conf
    elif ! grep -q "^CompositorCommand=" /etc/sddm.conf.d/kde_settings.conf; then
        sed -i "/^\[Wayland\]/a CompositorCommand=/usr/local/bin/velox-sddm-kwin-start" /etc/sddm.conf.d/kde_settings.conf
    else
        sed -i "s|^CompositorCommand=.*|CompositorCommand=/usr/local/bin/velox-sddm-kwin-start|" /etc/sddm.conf.d/kde_settings.conf
    fi
    echo "Set SDDM CompositorCommand=/usr/local/bin/velox-sddm-kwin-start"

    # Pre-fill SDDM username with the installed user so they don't have to type it
    INSTALL_USER=$(ls /home | grep -v lost+found | head -1)
    if [[ -n "$INSTALL_USER" ]]; then
        mkdir -p /var/lib/sddm
        printf '[Last]\nUser=%s\n' "$INSTALL_USER" > /var/lib/sddm/state.conf
        chown -R sddm:sddm /var/lib/sddm/state.conf 2>/dev/null || true
        echo "Set SDDM last user to: $INSTALL_USER"
    fi
fi

# KDE manages Qt styles via kdeglobals — the live-session qt5ct/kvantum overrides break
# Qt Quick Controls (no QtQuick.Controls.kvantum style exists). Remove them for KDE.
if [[ "$DESKTOP" == "kde" ]]; then
    sed -i '/^QT_QPA_PLATFORMTHEME=/d' /etc/environment
    sed -i '/^QT_STYLE_OVERRIDE=/d' /etc/environment
    echo "Removed QT_QPA_PLATFORMTHEME and QT_STYLE_OVERRIDE from /etc/environment for KDE"
    # Create empty dconf db so xdg-desktop-portal-gtk stops warning on every login
    mkdir -p /etc/dconf/db/local.d
    dconf update 2>/dev/null || true
    # Enable bluetooth — bluedevil needs bluetoothd running or kded6 hangs at login
    systemctl enable bluetooth.service 2>/dev/null || true

    # Write a firstboot autostart that sets the wallpaper via plasma-apply-wallpaperimage.
    # The desktop containment ID is dynamic (Plasma assigns it at first login), so we
    # cannot rely on the ID in the appletsrc skel. This script runs once after the first
    # Plasma session starts and then removes itself.
    WALLPAPER_SCRIPT="/usr/local/bin/velox-kde-firstboot"
    cat > "$WALLPAPER_SCRIPT" << 'SCRIPTEOF'
#!/bin/bash
WALL="/usr/share/wallpapers/Velox-15/contents/images/3840x2160.png"
[ -f "$WALL" ] && plasma-apply-wallpaperimage "$WALL" 2>/dev/null
# Remove this autostart entry after first run
rm -f "${HOME}/.config/autostart/velox-kde-firstboot.desktop" 2>/dev/null
SCRIPTEOF
    chmod +x "$WALLPAPER_SCRIPT"

    INSTALL_USER=$(ls /home | grep -v lost+found | head -1)
    if [[ -n "$INSTALL_USER" ]]; then
        mkdir -p "/home/$INSTALL_USER/.config/autostart"
        cat > "/home/$INSTALL_USER/.config/autostart/velox-kde-firstboot.desktop" << 'DESKEOF'
[Desktop Entry]
Type=Application
Name=Velox KDE Firstboot
Exec=/usr/local/bin/velox-kde-firstboot
Terminal=false
Hidden=false
X-KDE-autostart-phase=2
DESKEOF
        chown -R "$INSTALL_USER:$INSTALL_USER" "/home/$INSTALL_USER/.config/autostart/velox-kde-firstboot.desktop"
    fi
    echo "Installed KDE firstboot wallpaper script"

    # Patch all non-symlink Papirus/Papirus-Dark SVGs (all categories: places, apps, etc.)
    # that contain the Papirus blue shades and replace with Velox green equivalents.
    find /usr/share/icons/Papirus /usr/share/icons/Papirus-Dark \
        -name '*.svg' -not -type l 2>/dev/null \
        | xargs grep -lF '#5294e2' 2>/dev/null \
        | xargs sed -i 's/#5294e2/#8ab87a/g;s/#4877b1/#6a9459/g;s/#1d344f/#1c3318/g' 2>/dev/null || true
    gtk-update-icon-cache -q -t -f /usr/share/icons/Papirus-Dark 2>/dev/null || true
    gtk-update-icon-cache -q -t -f /usr/share/icons/Papirus 2>/dev/null || true
    echo "Applied Velox green colors to Papirus and Papirus-Dark (all icon categories)"

    # Patch app icons with non-Papirus blues that appear in the dock/launcher.
    # org.kde.dolphin uses #127bdc/#1f6394 (KDE dolphin brand blue).
    # desktop-environment-kde.svg (start-here-kde) uses #2c9bff (KDE plasma blue).
    # Both fall through to the user's eye as "KDE Breeze" — convert to Velox green.
    SIZES="16x16 22x22 24x24 32x32 48x48 64x64 96x96 128x128"
    for size in $SIZES; do
        f="/usr/share/icons/Papirus-Dark/${size}/apps/org.kde.dolphin.svg"
        [ -f "$f" ] && sed -i 's/#127bdc/#8ab87a/g;s/#1f6394/#6a9459/g' "$f" || true
        f2="/usr/share/icons/Papirus-Dark/${size}/apps/desktop-environment-kde.svg"
        [ -f "$f2" ] && sed -i 's/#2c9bff/#8ab87a/g' "$f2" || true
    done
    gtk-update-icon-cache -q -t -f /usr/share/icons/Papirus-Dark 2>/dev/null || true
    echo "Patched dolphin and KDE logo icons to Velox green"

    # Kate text editor: #008bff/#3aaaff/#00ccff (KDE blues) -> Velox green shades
    # system-software-install (control center): #03a9f4 (light blue) -> Velox green
    for size in $SIZES; do
        f="/usr/share/icons/Papirus-Dark/${size}/apps/kate.svg"
        [ -f "$f" ] && sed -i 's/#008bff/#6a9459/g;s/#3aaaff/#8ab87a/g;s/#00ccff/#8ab87a/g' "$f" || true
        f2="/usr/share/icons/Papirus-Dark/${size}/apps/system-software-install.svg"
        [ -f "$f2" ] && sed -i 's/#03a9f4/#8ab87a/g;s/#4caf50/#8ab87a/g;s/#f44336/#6a9459/g;s/#ff9107/#8ab87a/g' "$f2" || true
    done
    gtk-update-icon-cache -q -t -f /usr/share/icons/Papirus-Dark 2>/dev/null || true
    echo "Patched kate and control center icons to Velox green"

    # Lock accent color to Velox green so KDE's ColorScheme-Accent icons (Breeze-Dark
    # fallbacks, app launcher UI, ksmoothdock) don't get overridden by wallpaper extraction.
    INSTALL_USER=$(ls /home | grep -v lost+found | head -1)
    for cfg_target in /etc/skel/.config/kdeglobals ${INSTALL_USER:+/home/$INSTALL_USER/.config/kdeglobals}; do
        [[ -f "$cfg_target" ]] || continue
        if grep -q "^AccentColor=" "$cfg_target"; then
            sed -i 's/^AccentColor=.*/AccentColor=138,184,122/' "$cfg_target"
        else
            sed -i '/^\[General\]/a AccentColor=138,184,122' "$cfg_target"
        fi
        if grep -q "^accentColorFromWallpaper=" "$cfg_target"; then
            sed -i 's/^accentColorFromWallpaper=.*/accentColorFromWallpaper=false/' "$cfg_target"
        else
            sed -i '/^\[General\]/a accentColorFromWallpaper=false' "$cfg_target"
        fi
    done
    echo "Set AccentColor=138,184,122 and accentColorFromWallpaper=false in kdeglobals"
fi


if [[ "$DESKTOP" == "cinnamon" ]]; then
    # Fix GTK_THEME so GTK apps use the Velox Fluent theme instead of Adwaita
    sed -i 's/^GTK_THEME=.*/GTK_THEME=Fluent-grey-Dark/' /etc/environment
    echo "Set GTK_THEME=Fluent-grey-Dark in /etc/environment"

    # dconf system defaults — theme applies before first login
    DCONF_SRC="${DESKTOPS_DIR}/cinnamon/dconf/00-velox-cinnamon"
    if [[ -f "$DCONF_SRC" ]]; then
        mkdir -p /etc/dconf/db/local.d
        cp "$DCONF_SRC" /etc/dconf/db/local.d/00-velox-cinnamon
        dconf update 2>/dev/null || true
        echo "Installed Cinnamon dconf system defaults"
    fi

    # System-wide XDG autostart — runs for any user at login, no home dir dependency
    mkdir -p /etc/xdg/autostart
    cat > /etc/xdg/autostart/velox-cinnamon-setup.desktop << 'DESKEOF'
[Desktop Entry]
Type=Application
Name=Velox Cinnamon Setup
Exec=bash /usr/lib/velox-installer/velox-cinnamon-firstboot.sh
Terminal=false
Hidden=false
X-GNOME-Autostart-enabled=true
DESKEOF
    chmod +x /etc/xdg/autostart/velox-cinnamon-setup.desktop
    echo "Wrote system-wide Cinnamon firstboot autostart"

    # GSettings schema override — compiled-in default, no dbus needed
    # Done last so a slow compile doesn't block the autostart write above
    mkdir -p /usr/share/glib-2.0/schemas
    cat > /usr/share/glib-2.0/schemas/99-velox-cinnamon.gschema.override << 'SCHEMAEOF'
[org.cinnamon.theme]
name='Fluent-Velox-Dark'

[org.cinnamon.desktop.interface]
gtk-theme='Fluent-grey-Dark'
icon-theme='Newaita-Velox'
cursor-theme='breeze_cursors'
font-name='Noto Sans 11'

[org.cinnamon.desktop.wm.preferences]
theme='Fluent-Velox-Dark'

[org.gnome.desktop.interface]
gtk-theme='Fluent-grey-Dark'
icon-theme='Newaita-Velox'
cursor-theme='breeze_cursors'
font-name='Noto Sans 11'

[org.cinnamon.desktop.background]
picture-uri='file:///usr/share/wallpapers/Velox-15/contents/images/3840x2160.png'
picture-options='zoom'
SCHEMAEOF
    glib-compile-schemas /usr/share/glib-2.0/schemas/ 2>/dev/null || true
    echo "Installed GSettings schema override for Cinnamon"
fi
