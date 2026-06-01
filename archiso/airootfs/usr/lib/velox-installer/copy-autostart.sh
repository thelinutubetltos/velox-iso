#!/bin/bash
INSTALL_USER=$(ls /home | grep -v lost+found | head -1)
if [ -n "$INSTALL_USER" ]; then
    mkdir -p /home/$INSTALL_USER/.config/autostart
    cat > /home/$INSTALL_USER/.config/autostart/velox-welcome.desktop << DESKTOPEOF
[Desktop Entry]
Type=Application
Name=Velox Welcome
Exec=velox-welcome
Terminal=false
Hidden=false
X-KDE-autostart-phase=2
DESKTOPEOF
    chown -R ${INSTALL_USER}:${INSTALL_USER} /home/${INSTALL_USER}/.config/
fi
