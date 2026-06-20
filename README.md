# Velox Linux

<div align="center">

**Shape It. Race It. Own It.**

[![GitHub](https://img.shields.io/badge/GitHub-velox--iso-5a8160?style=for-the-badge&logo=github)](https://github.com/thelinutubetltos/velox-iso)
[![YouTube](https://img.shields.io/badge/YouTube-The%20Linux%20Tube-cc3333?style=for-the-badge&logo=youtube)](https://youtube.com/@thelinuxtube)
[![SourceForge](https://img.shields.io/badge/Download-SourceForge-ff6600?style=for-the-badge&logo=sourceforge)](https://sourceforge.net/projects/velox-linux/)
[![Repo](https://img.shields.io/badge/Package%20Repo-velox__repo-5a8160?style=for-the-badge)](https://thelinutubetltos.github.io/velox_repo)

</div>

---

## What is Velox Linux?

Velox Linux is an **Arch Linux-based KDE Plasma distribution** built for creators, gamers, and power users who want a fast, beautiful, and fully-featured system right out of the box.

> **Velox** (Latin) — *swift, fast, rapid*

---

## Velox Control Center

The heart of Velox Linux — a single app for everything.

![Velox Control Center - Home](screenshots/Control%20center1.png)

![Velox Control Center - Updates with Arch News Feed](screenshots/control%20center2.png)

![Velox Control Center - GPU Drivers](screenshots/control%20center3.png)

- **Install apps** — search pacman, Chaotic-AUR, AUR, and Flatpak in one place
- **GPU Drivers** — install NVIDIA, AMD, and Intel drivers with one click
- **Kernels** — switch between linux-velox, linux, linux-lts, linux-zen, linux-hardened, and linux-rt
- **Desktop Environments** — add GNOME, XFCE, Cinnamon, Hyprland, and more alongside KDE
- **BTRFS Snapshots** — manage Snapper snapshots with a GUI
- **One-click System Updates** — pacman + Flatpak in one button
- **Arch Linux News Feed** — live feed from archlinux.org shown before every update, with recent items flagged so you never miss a required manual step
- **AUR Security Scanner** — every AUR package is scanned by `velox-pkgcheck` before installation
- **Auto Keyring Refresh** — checks `archlinux-keyring` age on every launch; silently refreshes it in the background if older than 7 days so pacman GPG errors never happen. This has been a known Arch pain point since 2015 — Velox fixes it automatically
- **Fix Keyrings** — one-click full keyring repair as a fallback
- **Partial Update Protection** — checks the package database age before every install; if it's over 1 hour old a warning dialog offers to run a full `pacman -Syu` first, preventing the most common cause of broken Arch systems

---

## The Arch Problems We Fixed

Velox isn't opinionated for the sake of it. These four features were built because the same problems have surfaced in Arch forums, community discussions, and Linux press for years — and they all have clean solutions that users shouldn't need to figure out on their own.

### The Research

Before designing the Velox Control Center we reviewed the most common reasons people abandon or avoid Arch Linux:

- **[5 reasons I've never used Arch Linux as a daily driver — XDA Developers](https://www.xda-developers.com/reasons-never-used-arch-linux-daily-driver/)**: update-related breakage and AUR safety were the top concerns raised
- **[Why you probably shouldn't install Arch Linux — Framework Community](https://community.frame.work/t/why-you-probably-shouldnt-install-arch-linux/74613)**: partial upgrades and keyring errors listed among the leading causes of broken systems
- **[Common Problems and Issues — Arch Linux Forums](https://bbs.archlinux.org/viewtopic.php?id=130138)**: keyring errors are one of the most frequently recurring support topics
- **[Pacman update issues — Arch Linux Forums](https://bbs.archlinux.org/viewtopic.php?id=306427)**: dependency conflicts from partial upgrades filling the support threads year after year
- **[System Maintenance — ArchWiki](https://wiki.archlinux.org/title/System_maintenance)**: Arch's own wiki explicitly states you must read the news feed before upgrading and warns that partial upgrades are unsupported — but nothing in the default tooling enforces either rule

### Fix #1 — Arch Linux News Feed

**Problem:** Arch is a rolling release. Occasionally an update requires a manual step before running `pacman -Syu` — migrating a config file, running a one-off command, or handling a renamed package. The Arch news feed at [archlinux.org/news](https://archlinux.org/news/) is where these are announced. The ArchWiki System Maintenance page explicitly states: *"Before upgrading, users are expected to visit the Arch Linux home page to check the latest news."* But there's no enforcement, and the overwhelming majority of users never check.

**Fix:** The Velox Control Center fetches the live feed from `archlinux.org/feeds/news/` every time you open the Updates tab. Items less than 14 days old are flagged **RECENT** in orange. If there are recent items when you click **Update All**, a warning dialog lists them before the update proceeds — so required manual steps are never missed.

### Fix #2 — Auto Keyring Refresh

**Problem:** GPG keyring errors have been one of the top recurring support topics on the Arch Linux forums since at least 2015 ([Arch Forums — Common Problems](https://bbs.archlinux.org/viewtopic.php?id=130138)). The `archlinux-keyring` package holds the signing keys for all official packages. When it goes stale — because maintainers rotate, new keys are added, or old ones expire — pacman throws `invalid or corrupted package (PGP signature)` errors and refuses to update. This is a design gap that has never been addressed upstream: pacman depends on a keyring it doesn't automatically keep fresh.

Cited as a primary reason new users give up on Arch in both [XDA Developers](https://www.xda-developers.com/reasons-never-used-arch-linux-daily-driver/) and the [Framework Community forums](https://community.frame.work/t/why-you-probably-shouldnt-install-arch-linux/74613).

**Fix:** On every launch, the Control Center silently checks the age of `archlinux-keyring`. If it's older than 7 days it refreshes it in the background via `pkexec` — no user action needed. The **Update All** button also always refreshes the keyring first before running `pacman -Syu`, so updates can never fail on expired keys.

### Fix #3 — AUR Security Scanner

**Problem:** The AUR is unmoderated. Anyone can publish a package, and malicious actors use it to distribute malware. In July 2025, three AUR packages — `librewolf-fix-bin`, `firefox-patch-bin`, and `zen-browser-patched-bin` — were found to be actively malicious, running cryptocurrency miners and exfiltrating credentials. AUR helpers like `paru` and `yay` have no built-in scanning — they download and run whatever PKGBUILD is published.

**Fix:** Every AUR package installed through the Velox Control Center is scanned by `velox-pkgcheck` before installation. It reviews the PKGBUILD for suspicious patterns, outbound network calls, eval/exec usage, and obfuscated code. A severity rating is shown and you can cancel or proceed.

### Fix #4 — Partial Update Protection

**Problem:** Installing a package without first running a full system update is one of the most reliable ways to break Arch Linux. Arch is a rolling release that uses the latest library versions — installing a new package that expects `libfoo.so.6` when your system has `libfoo.so.5` can silently break other software or cause immediate crashes.

The [ArchWiki System Maintenance page](https://wiki.archlinux.org/title/System_maintenance) explicitly states: *"Partial upgrades are unsupported on Arch Linux."* Yet nothing in the default tooling prevents it. This exact failure mode is discussed repeatedly in [Arch Forums — Concerned about updates breaking Arch](https://bbs.archlinux.org/viewtopic.php?id=298177) and [Arch Forums — Pacman update issues](https://bbs.archlinux.org/viewtopic.php?id=306427), and is cited in [XDA Developers](https://www.xda-developers.com/reasons-never-used-arch-linux-daily-driver/) as a primary reason Arch breaks for everyday users.

**Fix:** Every time you install a pacman package through the Control Center it checks when the package database was last synced. If it's been over 1 hour, a warning dialog appears with the option to run a full `pacman -Syu` first — preventing the most common cause of broken Arch installations.

---

## What's Included

### Desktop Environment
- **KDE Plasma 6** — modern, powerful, and fully customized
- **Kvantum** dark theme with Velox green accents
- **Custom wallpapers** — Velox-1 through Velox-15, dark atmospheric art
- **Custom SDDM login theme** — Velox branded with wallpaper background
- **KDE lock screen** — Velox wallpaper set via skel

### Software
- **Firefox** — browser pre-installed
- **Kdenlive** + **OBS Studio** + **GIMP** + **Inkscape** + **Krita** — creative tools
- **VLC** — media player
- **qBittorrent** — torrent client
- **Visual Studio Code** + **Sublime Text** — code editors
- **Fastfetch** — custom Velox-branded system info (VL monogram logo)
- **Paru** + **Yay** — AUR helpers pre-installed
- **Flatpak** — pre-installed and ready

### Performance
- **linux-velox** — custom performance-tuned kernel based on CachyOS
- **CPU governor locked to `performance`** on boot — faster response, better benchmark scores
- **Ananicy-cpp** + **CachyOS rules** — automatic process priority management
- **Zram** — compressed RAM swap for better performance
- **irqbalance** — optimized interrupt handling
- **hblock** — ad and malware blocking at the system level
- **ParallelDownloads = 25** — faster package installs out of the box

### System Tools
- **Calamares installer** — fully themed with Velox branding, wallpaper slideshow, and dark UI
- **Gparted** + **KDE Partition Manager** — disk management
- **Hardinfo2** + **hw-probe** — hardware diagnostics
- **Btop** + **Resources** + **Glances** — system monitoring
- **Snapper** support — BTRFS snapshots via Velox Control Center

### Gaming Ready
- **Steam** pre-configured
- **Lutris** + **Heroic** + **Bottles** — game launchers
- **MangoHud** — in-game performance overlay
- **NVIDIA drivers** installed automatically post-install on NVIDIA hardware
- **AMD** driver support via mesa (included)

---

## NVIDIA Driver Handling

Velox does **not** bundle NVIDIA proprietary drivers in the live ISO. Instead:

- The **live environment** runs on open source mesa/nouveau drivers
- During installation, Calamares **auto-detects your GPU** via `lspci`
- If an NVIDIA GPU is found, `nvidia-open-dkms`, `nvidia-utils`, and `nvidia-settings` are installed automatically into the installed system
- NVIDIA GRUB boot entries are only added when NVIDIA hardware is detected

This keeps the ISO lean and avoids carrying DKMS-compiled modules for hardware that may not be present.

---

## Custom Repositories

**velox_repo** — small packages hosted on GitHub Pages:
```ini
[velox_repo]
SigLevel = Never
Server = https://thelinutubetltos.github.io/velox_repo/$arch
```

**velox-packages** — large packages (kernel, calamares) hosted on GitHub Releases:
```ini
[velox-packages]
SigLevel = Never
Server = https://github.com/thelinutubetltos/velox_repo/releases/download/velox-packages
```

---

## Boot Options

After installation, the GRUB menu includes:
- **Velox Linux** — default boot
- **Velox Linux - NVIDIA (proprietary)** — only on NVIDIA hardware
- **Velox Linux - NVIDIA (open source)** — only on NVIDIA hardware
- **Velox Linux - AMD** — AMD GPU optimized
- **Velox Linux (fallback)** — fallback initramfs

---

## Roadmap

### Complete
- [x] Working Calamares installer
- [x] Custom branding and GRUB entries
- [x] Kernel boots correctly after install
- [x] SDDM login screen after install (no autologin)
- [x] Custom Velox wallpapers (Velox-1 through Velox-15)
- [x] Custom fastfetch logo
- [x] Custom velox_repo on GitHub Pages
- [x] UEFI + BIOS boot support
- [x] Calamares dark theme with wallpaper slideshow
- [x] Custom SDDM login theme (breeze-velox)
- [x] Kvantum dark theme
- [x] linux-velox custom kernel
- [x] velox-packages repo on GitHub Releases
- [x] CPU performance governor on boot
- [x] NVIDIA auto-detection and post-install driver setup
- [x] ISO under 4 GB (SourceForge compatible)
- [x] **Velox Control Center** — software, drivers, kernels, desktops, snapshots, updates
- [x] **Arch Linux news feed** in update flow — flags recent items before updating
- [x] **AUR security scanner** (velox-pkgcheck) — scans every AUR package before install
- [x] **Auto keyring refresh** — silently fixes expired keys on launch and before every update
- [x] **Partial update protection** — warns before installing into a stale package database
- [x] **ParallelDownloads = 25** — faster installs on live and installed system

### Planned
- [ ] velox-mirrors mirror manager
- [ ] Velox website
- [ ] ISO release page with changelogs
- [ ] Community Discord server
- [ ] Auto-update notifier
- [ ] Velox theme for Firefox
- [ ] Custom Plasma widgets

---

## Installation

1. Download the ISO from [SourceForge](https://sourceforge.net/projects/velox-linux/)
2. Flash to USB with [Ventoy](https://www.ventoy.net) or [Balena Etcher](https://etcher.balena.io)
3. Boot from USB
4. Calamares installer launches automatically
5. Follow the installer steps — NVIDIA drivers install automatically if detected
6. Reboot and log in — Velox Control Center launches on first boot

---

## Building the ISO

```bash
git clone https://github.com/thelinutubetltos/velox-iso.git
cd velox-iso/build-scripts
bash build-the-iso.sh
```

The ISO will be output to `~/velox-Out/`.

---

## Links

| Resource | Link |
|---|---|
| Download | [SourceForge](https://sourceforge.net/projects/velox-linux/) |
| Package Repository | [velox_repo](https://github.com/thelinutubetltos/velox_repo) |
| YouTube | [The Linux Tube](https://youtube.com/@thelinuxtube) |
| Bug Reports | [GitHub Issues](https://github.com/thelinutubetltos/velox-iso/issues) |

---

<div align="center">
  <sub>Built by The Linux Tube &nbsp;|&nbsp; Shape It. Race It. Own It.</sub>
</div>
