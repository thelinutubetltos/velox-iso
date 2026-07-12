#!/bin/bash
# Runs during ISO build (pacman hook) and in the installed system chroot (Calamares shellprocess@post).
# Cleans up junk backgrounds and populates /usr/share/backgrounds/Velox/ from the wallpapers package.

# Remove unbranded Velox wallpapers (1-7)
for i in $(seq 1 7); do
    rm -rf "/usr/share/wallpapers/Velox-${i}"
done

# Remove non-Velox dirs from /usr/share/wallpapers
find /usr/share/wallpapers -mindepth 1 -maxdepth 1 -type d | grep -v '/Velox-' | xargs rm -rf 2>/dev/null || true

# Nuke all of /usr/share/backgrounds/ and repopulate with only Velox images
rm -rf /usr/share/backgrounds/
mkdir -p /usr/share/backgrounds/Velox
for i in $(seq 8 15); do
    src="/usr/share/wallpapers/Velox-${i}/contents/images/3840x2160.png"
    if [[ -f "$src" ]]; then
        cp "$src" "/usr/share/backgrounds/Velox/velox-${i}.png"
        echo "backgrounds: added velox-${i}.png"
    else
        echo "WARNING: $src not found, skipping"
    fi
done

# Remove all GNOME background XML descriptors except the Velox one
find /usr/share/gnome-background-properties -mindepth 1 -maxdepth 1 ! -name 'velox.xml' | xargs rm -rf 2>/dev/null || true

echo "Wallpaper cleanup done."
