#!/bin/bash
[ -f ~/.config/velox-wallpaper-set ] && exit 0
plasma-apply-wallpaperimage /usr/share/wallpapers/Velox-4/contents/images/3840x2160.png
touch ~/.config/velox-wallpaper-set
