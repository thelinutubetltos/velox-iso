# 🐧 Velox Linux

<div align="center">

**Shape It. Race It. Own It.**

[![GitHub](https://img.shields.io/badge/GitHub-velox--iso-5a8160?style=for-the-badge&logo=github)](https://github.com/thelinutubetltos/velox-iso)
[![YouTube](https://img.shields.io/badge/YouTube-The%20Linux%20Tube-cc3333?style=for-the-badge&logo=youtube)](https://youtube.com/@thelinuxtube)
[![Repo](https://img.shields.io/badge/Package%20Repo-velox__repo-5a8160?style=for-the-badge)](https://thelinutubetltos.github.io/velox_repo)

</div>

---

## 🚀 What is Velox Linux?

Velox Linux is an **Arch Linux-based KDE Plasma distribution** built for creators, gamers, and power users who want a fast, beautiful, and fully-featured system right out of the box. Forked from Kiro, Velox has been heavily customized and rebranded with its own identity, tooling, and package repository.

> **Velox** (Latin) — *swift, fast, rapid*

---

## ✨ What's Included

### 🖥️ Desktop Environment
- **KDE Plasma 6** — modern, powerful, and fully customized
- **Kvantum** dark theme with Velox green accents
- **Custom wallpapers** — dark atmospheric art bundled out of the box
- **Custom SDDM login theme** — Velox branded with wallpaper background

### 📦 Software
- **Firefox** + **Brave** + **Vivaldi** — browsers for every taste
- **Kdenlive** + **OBS Studio** + **GIMP** + **Inkscape** — creative tools
- **VLC** + **MPV** — media players
- **qBittorrent** — torrent client
- **Signal Desktop** — secure messaging
- **Visual Studio Code** + **Sublime Text** — code editors
- **Fastfetch** — custom Velox-branded system info
- **Paru** + **Yay** — AUR helpers pre-installed

### ⚡ Performance
- **linux kernel** — default, with support for zen, lts, cachyos, and more via welcome app
- **Ananicy-cpp** + **CachyOS rules** — automatic process priority management
- **Zram** — compressed RAM swap for better performance
- **irqbalance** — optimized interrupt handling
- **hblock** — ad and malware blocking at the system level

### 🔧 System Tools
- **Calamares installer** — fully themed with Velox branding, wallpaper slideshow, and dark UI
- **Gparted** + **KDE Partition Manager** — disk management
- **Timeshift** support — easy system backups
- **Hardinfo2** + **hw-probe** — hardware diagnostics
- **Btop** + **Resources** + **Glances** — system monitoring

### 🎮 Gaming Ready
- **Steam** pre-configured
- **GameMode** — automatic performance boost for games
- **MangoHud** — in-game performance overlay
- **Wine** + **Lutris** support
- **NVIDIA** open + proprietary driver support
- **AMD** driver support

---

## 🛠️ Velox Tooling

### velox-welcome
A custom KDE welcome application that launches on first boot with:
- System update shortcuts
- One-click app installation (Gaming, Creative, Internet)
- Kernel manager — install zen, lts, cachyos, tkg and more
- NVIDIA/AMD driver installer
- Quick links to support and community

### velox_repo
A custom package repository hosted on GitHub Pages:
- **velox-wallpapers** — official Velox wallpaper pack
- **velox-welcome** — the Velox welcome application
- More tools coming soon

Add the repo to any Arch system:
```ini
[velox_repo]
SigLevel = Never
Server = https://thelinutubetltos.github.io/velox_repo/$arch
```

---

## 🥾 Boot Options

The Velox GRUB menu includes entries for:
- **Velox Linux** — default boot
- **Velox Linux - NVIDIA (proprietary)** — for NVIDIA users
- **Velox Linux - NVIDIA (open source)** — nouveau/open kernel module
- **Velox Linux - AMD** — AMD GPU optimized
- **Velox Linux (fallback)** — fallback initramfs

---

## 🗺️ Roadmap

### ✅ Phase 1 — Complete
- [x] Working Calamares installer
- [x] Custom branding and GRUB entries
- [x] Kernel boots correctly after install
- [x] SDDM login screen after install (no autologin)
- [x] Custom Velox wallpapers
- [x] Custom fastfetch logo
- [x] Custom velox_repo on GitHub Pages
- [x] UEFI + BIOS boot support

### 🚧 Phase 2 — In Progress
- [x] Calamares dark theme with wallpaper slideshow
- [x] Custom SDDM login theme
- [x] Kvantum dark theme
- [x] velox-welcome app
- [ ] velox-update tool
- [ ] velox-tweak system tweaker
- [ ] velox-mirrors mirror manager
- [ ] velox-nvidia driver switcher
- [ ] More wallpaper packs in velox_repo

### 🔮 Phase 3 — Planned
- [ ] Velox website
- [ ] ISO release page with changelogs
- [ ] Community Discord server
- [ ] Velox-specific AUR packages
- [ ] Auto-update notifier
- [ ] Velox theme for Firefox
- [ ] Custom Plasma widgets

---

## 📥 Installation

1. Download the ISO from the [releases page](https://github.com/thelinutubetltos/velox-iso/releases)
2. Flash to USB with [Ventoy](https://www.ventoy.net) or [Balena Etcher](https://etcher.balena.io)
3. Boot from USB
4. Calamares installer launches automatically
5. Follow the installer steps
6. Reboot and log in — the Velox welcome app will guide you through the rest

---

## 🏗️ Building the ISO

```bash
git clone https://github.com/thelinutubetltos/velox-iso.git
cd velox-iso/build-scripts
bash build-the-iso.sh
```

The ISO will be output to `/home/$USER/velox-Out/`.

---

## 🔗 Links

| Resource | Link |
|---|---|
| 📦 Package Repository | [velox_repo](https://github.com/thelinutubetltos/velox_repo) |
| 📺 YouTube | [The Linux Tube](https://youtube.com/@thelinuxtube) |
| 🐛 Bug Reports | [GitHub Issues](https://github.com/thelinutubetltos/velox-iso/issues) |

---

<div align="center">
  <sub>Built with ❤️ by The Linux Tube &nbsp;|&nbsp; Shape It. Race It. Own It.</sub>
</div>
