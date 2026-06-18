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
    cat > /home/$INSTALL_USER/.config/autostart/set-resolution.desktop << DESKTOPEOF
[Desktop Entry]
Type=Application
Name=Set Resolution
Exec=/usr/bin/velox-set-resolution
Hidden=false
NoDisplay=true
X-KDE-StartupNotify=false
DESKTOPEOF
    chown -R ${INSTALL_USER}:${INSTALL_USER} /home/${INSTALL_USER}/.config/
fi

# Set breeze-velox SDDM theme on installed system
sed -i 's/Current=.*/Current=breeze-velox/' /etc/sddm.conf.d/kde_settings.conf

# Remove liveuser from installed system
userdel -r liveuser 2>/dev/null || true
