#!/bin/bash
# Runs via Calamares finished module — target is fully written at this point
INSTALL_USER=$(ls /mnt/home | grep -v lost+found | head -1)
if [ -n "$INSTALL_USER" ]; then
    AUTOSTART_DIR="/mnt/home/${INSTALL_USER}/.config/autostart"
    mkdir -p "$AUTOSTART_DIR"
    cat > "$AUTOSTART_DIR/velox-welcome.desktop" << DESKTOPEOF
[Desktop Entry]
Type=Application
Name=Velox Welcome
Exec=velox-welcome
Terminal=false
Hidden=false
X-KDE-autostart-phase=2
DESKTOPEOF
    chown -R "${INSTALL_USER}:${INSTALL_USER}" "/mnt/home/${INSTALL_USER}/.config/"
    echo "[velox] autostart copied for $INSTALL_USER"
fi
