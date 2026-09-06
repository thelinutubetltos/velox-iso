#!/bin/sh
# Kvantum has no QtQuick Controls style plugin; QT_STYLE_OVERRIDE=kvantum
# (set globally in /etc/environment for GTK/Qt widget theming) breaks QML
# components that try to resolve it as a QQC2 style, e.g. kwin's overview
# effect ("module kvantum is not installed"). widgetStyle=kvantum-dark in
# kdeglobals already handles Plasma's own Qt widget styling, so unset it
# for this session only.
unset QT_STYLE_OVERRIDE
