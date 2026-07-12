#!/bin/bash
# Patch all non-symlink SVGs in Papirus and Papirus-Dark (all categories).
# Three blue shades used across folder-blue.svg and named variants (folder-blue-*.svg):
#   #5294e2 (body light) -> #8ab87a (Velox green)
#   #4877b1 (body shadow) -> #6a9459 (Velox green dark)
#   #1d344f (emblem dark) -> #1c3318 (Velox green darkest)
find /usr/share/icons/Papirus /usr/share/icons/Papirus-Dark \
    -name '*.svg' -not -type l 2>/dev/null \
    | xargs grep -lF '#5294e2' 2>/dev/null \
    | xargs sed -i 's/#5294e2/#8ab87a/g;s/#4877b1/#6a9459/g;s/#1d344f/#1c3318/g' 2>/dev/null || true
gtk-update-icon-cache -q -t -f /usr/share/icons/Papirus-Dark 2>/dev/null || true
gtk-update-icon-cache -q -t -f /usr/share/icons/Papirus 2>/dev/null || true
