#!/bin/bash
# install-velox-desktop.sh <kde|xfce|cinnamon> <username>
# Installs a full Velox-themed desktop (same setup as Calamares) on a running system.
# Run via pkexec (as root) from Velox Control Center.

set -euo pipefail

DE="${1:-}"
TARGET_USER="${2:-}"

if [[ -z "$DE" ]] || [[ ! "$DE" =~ ^(kde|xfce|cinnamon)$ ]]; then
    echo "Usage: $0 <kde|xfce|cinnamon> <username>"
    exit 1
fi

if [[ -z "$TARGET_USER" ]] || [[ ! -d "/home/$TARGET_USER" ]]; then
    echo "Error: Invalid target user '${TARGET_USER}'"
    exit 1
fi

DESKTOPS_DIR="/usr/lib/velox-desktops"
echo "Installing Velox ${DE} desktop for user: ${TARGET_USER}"

# ── 1. Install packages ────────────────────────────────────────────────────────
case "$DE" in
    kde)
        pacman -S --noconfirm --needed \
            plasma-desktop plasma-nm plasma-pa plasma-systemmonitor \
            kdeplasma-addons kwin kscreen kinfocenter plasma-disks \
            konsole dolphin kate kdialog ark spectacle okular gwenview \
            kcalc polkit-kde-agent ksmoothdock xdg-desktop-portal-kde \
            kvantum plasma6-applets-panel-colorizer candy-icons-git \
            fastfetch-git
        ;;
    cinnamon)
        pacman -S --noconfirm --needed \
            cinnamon cinnamon-control-center cinnamon-desktop cinnamon-menus \
            cinnamon-screensaver cinnamon-session cinnamon-settings-daemon \
            cinnamon-translations muffin nemo nemo-fileroller \
            xfce4-terminal mousepad polkit-gnome xdg-desktop-portal-xapp \
            xdg-desktop-portal-gtk fluent-gtk-theme-git newaita-icons-git \
            fastfetch-git
        ;;
    xfce)
        # xfce4-session and labwc own session files we previously overwrote with
        # Hidden=true. Use --overwrite so pacman can reinstall them cleanly; we
        # re-apply Hidden=true immediately after the transaction completes.
        pacman -S --noconfirm --needed \
            --overwrite '/usr/share/wayland-sessions/*' \
            --overwrite '/usr/share/xsessions/*' \
            xfce4 xfce4-goodies xfwm4 xfce4-session xfce4-panel xfdesktop \
            xfce4-settings xfce4-terminal thunar thunar-volman \
            thunar-archive-plugin tumbler mousepad labwc xorg-xwayland \
            waybar wlr-randr swaybg crystal-dock-git nwg-drawer \
            python-gobject polkit-gnome xdg-desktop-portal-gtk \
            fluent-gtk-theme-git newaita-icons-git fastfetch-git
        ;;
esac

# ── 2. Apply velox skel to user's home ────────────────────────────────────────
SKEL_SRC="${DESKTOPS_DIR}/${DE}/skel"
if [[ -d "$SKEL_SRC" ]]; then
    cp -r "${SKEL_SRC}/." "/home/${TARGET_USER}/"
    chown -R "${TARGET_USER}:${TARGET_USER}" "/home/${TARGET_USER}/"
    echo "Applied ${DE} skel to /home/${TARGET_USER}/"
fi

# ── 3. DE-specific setup (mirrors apply-desktop-skel.sh) ─────────────────────
case "$DE" in
    kde)
        # Remove QT platform overrides — KDE manages styles via kdeglobals
        sed -i '/^QT_QPA_PLATFORMTHEME=/d' /etc/environment
        sed -i '/^QT_STYLE_OVERRIDE=/d' /etc/environment

        # KDE Wayland needs SDDM in Wayland mode so it doesn't hold DRM master
        SDDM_CONF="/etc/sddm.conf.d/kde_settings.conf"
        if [[ -f "$SDDM_CONF" ]]; then
            if grep -q '^DisplayServer=' "$SDDM_CONF"; then
                sed -i 's/^DisplayServer=.*/DisplayServer=wayland/' "$SDDM_CONF"
            else
                sed -i "/^\[General\]/a DisplayServer=wayland" "$SDDM_CONF"
            fi
            if ! grep -q "^\[Wayland\]" "$SDDM_CONF"; then
                printf '\n[Wayland]\nCompositorCommand=/usr/local/bin/velox-sddm-kwin-start\n' >> "$SDDM_CONF"
            elif ! grep -q "^CompositorCommand=" "$SDDM_CONF"; then
                sed -i "/^\[Wayland\]/a CompositorCommand=/usr/local/bin/velox-sddm-kwin-start" "$SDDM_CONF"
            else
                sed -i "s|^CompositorCommand=.*|CompositorCommand=/usr/local/bin/velox-sddm-kwin-start|" "$SDDM_CONF"
            fi
            echo "Set SDDM DisplayServer=wayland + CompositorCommand=kwin for KDE"
        fi

        # Enable bluetooth
        systemctl enable bluetooth.service 2>/dev/null || true

        # Patch Papirus icon theme to Velox green
        find /usr/share/icons/Papirus /usr/share/icons/Papirus-Dark \
            -name '*.svg' -not -type l 2>/dev/null \
            | xargs grep -lF '#5294e2' 2>/dev/null \
            | xargs sed -i 's/#5294e2/#8ab87a/g;s/#4877b1/#6a9459/g;s/#1d344f/#1c3318/g' \
            2>/dev/null || true
        gtk-update-icon-cache -q -t -f /usr/share/icons/Papirus-Dark 2>/dev/null || true
        gtk-update-icon-cache -q -t -f /usr/share/icons/Papirus 2>/dev/null || true

        SIZES="16x16 22x22 24x24 32x32 48x48 64x64 96x96 128x128"
        for size in $SIZES; do
            f="/usr/share/icons/Papirus-Dark/${size}/apps/org.kde.dolphin.svg"
            [ -f "$f" ] && sed -i 's/#127bdc/#8ab87a/g;s/#1f6394/#6a9459/g' "$f" || true
            f2="/usr/share/icons/Papirus-Dark/${size}/apps/desktop-environment-kde.svg"
            [ -f "$f2" ] && sed -i 's/#2c9bff/#8ab87a/g' "$f2" || true
        done
        gtk-update-icon-cache -q -t -f /usr/share/icons/Papirus-Dark 2>/dev/null || true

        # Lock accent color to Velox green in kdeglobals
        for cfg in /etc/skel/.config/kdeglobals "/home/${TARGET_USER}/.config/kdeglobals"; do
            [[ -f "$cfg" ]] || continue
            if grep -q '^AccentColor=' "$cfg"; then
                sed -i 's/^AccentColor=.*/AccentColor=138,184,122/' "$cfg"
            else
                sed -i '/^\[General\]/a AccentColor=138,184,122' "$cfg"
            fi
            if grep -q '^accentColorFromWallpaper=' "$cfg"; then
                sed -i 's/^accentColorFromWallpaper=.*/accentColorFromWallpaper=false/' "$cfg"
            else
                sed -i '/^\[General\]/a accentColorFromWallpaper=false' "$cfg"
            fi
        done

        # KDE firstboot wallpaper script
        WALLPAPER_SCRIPT="/usr/local/bin/velox-kde-firstboot"
        cat > "$WALLPAPER_SCRIPT" << 'SCRIPTEOF'
#!/bin/bash
WALL="/usr/share/wallpapers/Velox-15/contents/images/3840x2160.png"
[ -f "$WALL" ] && plasma-apply-wallpaperimage "$WALL" 2>/dev/null
rm -f "${HOME}/.config/autostart/velox-kde-firstboot.desktop" 2>/dev/null
SCRIPTEOF
        chmod +x "$WALLPAPER_SCRIPT"
        mkdir -p "/home/${TARGET_USER}/.config/autostart"
        cat > "/home/${TARGET_USER}/.config/autostart/velox-kde-firstboot.desktop" << 'DESKEOF'
[Desktop Entry]
Type=Application
Name=Velox KDE Firstboot
Exec=/usr/local/bin/velox-kde-firstboot
Terminal=false
Hidden=false
X-KDE-autostart-phase=2
DESKEOF
        chown -R "${TARGET_USER}:${TARGET_USER}" "/home/${TARGET_USER}/.config/autostart/"
        ;;

    xfce)
        systemctl mask systemd-homed 2>/dev/null || true

        # If this system previously had KDE, SDDM will have DisplayServer=wayland with
        # CompositorCommand=kwin. labwc cannot acquire DRM master nested inside kwin, which
        # causes xfce4-terminal PTY failures. Reset to x11 so labwc starts as the primary
        # Wayland compositor. KDE Wayland sessions still work fine from an x11 SDDM greeter.
        SDDM_CONF="/etc/sddm.conf.d/kde_settings.conf"
        if [[ -f "$SDDM_CONF" ]]; then
            if grep -q '^DisplayServer=' "$SDDM_CONF"; then
                sed -i 's/^DisplayServer=.*/DisplayServer=x11/' "$SDDM_CONF"
            else
                sed -i "/^\[General\]/a DisplayServer=x11" "$SDDM_CONF"
            fi
            echo "Reset SDDM DisplayServer=x11 for XFCE+labwc"
        fi

        # Create velox-xfce session file if not already present
        if [[ ! -f /usr/share/wayland-sessions/velox-xfce.desktop ]]; then
            mkdir -p /usr/share/wayland-sessions
            cat > /usr/share/wayland-sessions/velox-xfce.desktop << 'DESKEOF'
[Desktop Entry]
Version=1.0
Name=Velox XFCE
Comment=Velox XFCE Wayland session with labwc compositor
Exec=/usr/local/bin/velox-xfce-start
Type=Application
DesktopNames=XFCE
Keywords=xfce;wayland;desktop;environment;session;
DESKEOF
            echo "Created /usr/share/wayland-sessions/velox-xfce.desktop"
        fi

        # Point SDDM at velox-xfce session (sets XDG_CURRENT_DESKTOP=XFCE via wrapper)
        sed -i "s/^Session=.*/Session=velox-xfce/" "$SDDM_CONF" 2>/dev/null || true
        SESSION_PATH=$(find /usr/share/wayland-sessions -name "velox-xfce.desktop" 2>/dev/null | head -1)
        if [[ -n "$SESSION_PATH" ]]; then
            mkdir -p /var/lib/sddm
            printf '[Last]\nUser=%s\nSession=%s\n' "$TARGET_USER" "$SESSION_PATH" > /var/lib/sddm/state.conf
            chown -R sddm:sddm /var/lib/sddm/state.conf 2>/dev/null || true
            echo "Set SDDM default session to velox-xfce"
        fi

        if grep -q '^GTK_THEME=' /etc/environment; then
            sed -i 's/^GTK_THEME=.*/GTK_THEME=Fluent-grey-Dark/' /etc/environment
        else
            echo 'GTK_THEME=Fluent-grey-Dark' >> /etc/environment
        fi

        mkdir -p /usr/share/glib-2.0/schemas
        cat > /usr/share/glib-2.0/schemas/99-velox-xfce.gschema.override << 'SCHEMAEOF'
[org.gnome.desktop.interface]
gtk-theme='Fluent-Velox-Dark'
icon-theme='Newaita'
cursor-theme='Adwaita'
font-name='Noto Sans 10'
color-scheme='prefer-dark'
SCHEMAEOF
        glib-compile-schemas /usr/share/glib-2.0/schemas/ 2>/dev/null || true
        ;;

    cinnamon)
        # Same SDDM reset as XFCE — muffin starts as its own compositor from x11 SDDM
        SDDM_CONF="/etc/sddm.conf.d/kde_settings.conf"
        if [[ -f "$SDDM_CONF" ]]; then
            if grep -q '^DisplayServer=' "$SDDM_CONF"; then
                sed -i 's/^DisplayServer=.*/DisplayServer=x11/' "$SDDM_CONF"
            else
                sed -i "/^\[General\]/a DisplayServer=x11" "$SDDM_CONF"
            fi
            echo "Reset SDDM DisplayServer=x11 for Cinnamon+muffin"
        fi

        # Point SDDM at the stable X11 cinnamon session (cinnamon-wayland segfaults)
        sed -i "s/^Session=.*/Session=cinnamon/" "$SDDM_CONF" 2>/dev/null || true
        SESSION_PATH=$(find /usr/share/xsessions -name "cinnamon.desktop" 2>/dev/null | head -1)
        if [[ -n "$SESSION_PATH" ]]; then
            mkdir -p /var/lib/sddm
            printf '[Last]\nUser=%s\nSession=%s\n' "$TARGET_USER" "$SESSION_PATH" > /var/lib/sddm/state.conf
            chown -R sddm:sddm /var/lib/sddm/state.conf 2>/dev/null || true
            echo "Set SDDM default session to cinnamon (X11)"
        fi

        if grep -q '^GTK_THEME=' /etc/environment; then
            sed -i 's/^GTK_THEME=.*/GTK_THEME=Fluent-Velox-Dark/' /etc/environment
        else
            echo 'GTK_THEME=Fluent-Velox-Dark' >> /etc/environment
        fi
        grep -q '^XCURSOR_THEME=' /etc/environment \
            && sed -i 's/^XCURSOR_THEME=.*/XCURSOR_THEME=Adwaita/' /etc/environment \
            || echo 'XCURSOR_THEME=Adwaita' >> /etc/environment
        grep -q '^XCURSOR_SIZE=' /etc/environment || echo 'XCURSOR_SIZE=24' >> /etc/environment

        # dconf system defaults
        DCONF_SRC="${DESKTOPS_DIR}/cinnamon/dconf/00-velox-cinnamon"
        if [[ -f "$DCONF_SRC" ]]; then
            mkdir -p /etc/dconf/db/local.d
            cp "$DCONF_SRC" /etc/dconf/db/local.d/00-velox-cinnamon
            dconf update 2>/dev/null || true
        fi

        # System-wide firstboot autostart
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

        mkdir -p /usr/share/glib-2.0/schemas
        cat > /usr/share/glib-2.0/schemas/99-velox-cinnamon.gschema.override << 'SCHEMAEOF'
[org.cinnamon.theme]
name='Fluent-Velox-Dark'

[org.cinnamon.desktop.interface]
gtk-theme='Fluent-Velox-Dark'
icon-theme='Newaita-Velox'
cursor-theme='Adwaita'
font-name='Noto Sans 11'

[org.cinnamon.desktop.wm.preferences]
theme='Fluent-Velox-Dark'

[org.gnome.desktop.interface]
gtk-theme='Fluent-Velox-Dark'
icon-theme='Newaita-Velox'
cursor-theme='Adwaita'
font-name='Noto Sans 11'

[org.cinnamon.desktop.background]
picture-uri='file:///usr/share/wallpapers/Velox-15/contents/images/3840x2160.png'
picture-options='zoom'
SCHEMAEOF
        glib-compile-schemas /usr/share/glib-2.0/schemas/ 2>/dev/null || true
        ;;
esac

# Hide extra session files so SDDM only shows the Velox session for this DE.
# Runs for every DE — harmless if a file doesn't exist.
for _session in \
    /usr/share/xsessions/openbox.desktop \
    /usr/share/xsessions/xfce.desktop \
    /usr/share/xsessions/cinnamon2d.desktop \
    /usr/share/wayland-sessions/xfce-wayland.desktop \
    /usr/share/wayland-sessions/labwc.desktop \
    /usr/share/wayland-sessions/cinnamon-wayland.desktop; do
    mkdir -p "$(dirname "$_session")"
    printf '[Desktop Entry]\nHidden=true\n' > "$_session"
done
echo "Hidden extra SDDM session files"

# Ensure the pacman hook is in place for future package upgrades
mkdir -p /etc/pacman.d/hooks
cp /usr/lib/velox-installer/velox-hide-sessions.hook /etc/pacman.d/hooks/ 2>/dev/null || true

echo ""
echo "==> Velox ${DE} desktop installed. Log out and select the ${DE} session."
