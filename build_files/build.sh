#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Third-party repos
## Terra (Fyra Labs) — noctalia, noctalia-greeter, ghostty, nerd fonts, satty,
## gpu-screen-recorder. Repo file ships via system_files/etc/yum.repos.d/terra.repo.
## Kept ENABLED in the final image so CI rebuilds ride Terra updates.
## The Hyprland compositor suite is not in Fedora 43/44 official repos nor in Terra,
## so it comes from the one COPR we depend on (all hyprland packages, freshly built
## for fc44). Also left enabled: the suite must keep receiving updates.
dnf5 -y copr enable dtutila/hyprland

### Install packages

# -- Session: compositor, greeter, shell -------------------------------------------------
dnf5 -y install \
    hyprland \
    hyprland-qt-support \
    hyprlock \
    hypridle \
    hyprpolkitagent \
    xdg-desktop-portal-hyprland \
    hyprsunset \
    greetd \
    noctalia \
    noctalia-greeter

# -- Desktop support: audio, network, portals, Wayland tooling ---------------------------
dnf5 -y install \
    pipewire \
    pipewire-pulseaudio \
    pipewire-alsa \
    wireplumber \
    xdg-desktop-portal-gtk \
    xdg-desktop-portal-wlr \
    gsettings-desktop-schemas \
    qt6-qtwayland \
    grim \
    slurp \
    wl-clipboard \
    cliphist \
    brightnessctl \
    playerctl \
    xdg-user-dirs \
    xdg-utils \
    wlr-randr \
    google-noto-sans-fonts \
    google-noto-emoji-fonts \
    jetbrainsmono-nerd-fonts

# -- Laptop plumbing ---------------------------------------------------------------------
dnf5 -y install \
    upower \
    power-profiles-daemon \
    thermald \
    fprintd \
    fprintd-pam \
    bluez

# -- Terminal / file manager / desktop apps ----------------------------------------------
dnf5 -y install \
    ghostty \
    Thunar \
    thunar-archive-plugin \
    thunar-media-tags-plugin \
    tumbler \
    xarchiver \
    gvfs \
    gvfs-mtp \
    gvfs-smb \
    pavucontrol \
    kanshi \
    nwg-look \
    satty \
    gpu-screen-recorder \
    plymouth-plugin-script

# -- Gaming-readiness base (no storefronts/launchers: those arrive as Flatpaks) -----------
dnf5 -y install \
    gamemode \
    steam-devices \
    xorg-x11-server-Xwayland \
    mesa-vulkan-drivers \
    vulkan-loader

# -- Dev tooling -------------------------------------------------------------------------
dnf5 -y install \
    git \
    gh \
    neovim \
    helix \
    just \
    fzf \
    ripgrep \
    fd-find \
    jq \
    yq \
    tmux \
    unzip \
    7zip \
    distrobox \
    podman \
    podman-compose \
    python3 \
    python3-pip \
    nodejs20 \
    nodejs20-npm

### Branding: outcrop labs logo replaces Noctalia's
## Runs AFTER dnf so package updates can't win; every CI rebuild reapplies it.
## Ink SVGs ship via system_files/usr/share/outcrop/. Upstream's own asset is a
## white-fill glyph, so gold ink matches how the shell renders the logo asset.
install -Dm0644 /usr/share/outcrop/noctalia-logo.svg /usr/share/noctalia/assets/noctalia.svg
install -Dm0644 /usr/share/outcrop/noctalia-logo.svg /usr/share/noctalia-greeter/assets/noctalia.svg
install -Dm0644 /usr/share/outcrop/noctalia-logo.svg /usr/share/icons/hicolor/scalable/apps/noctalia.svg

### noctalia-greeter system setup
## The RPM ships no scriptlets; upstream's setup script creates the greeter user
## runtime bits (PAM patch, state dir, appearance template). The user itself is
## declared in /usr/lib/sysusers.d/noctalia-greeter.conf; create it here too so
## the setup script can chown during build instead of waiting for first boot.
useradd -r -s /usr/sbin/nologin -d /var/lib/noctalia-greeter greeter 2>/dev/null || true
/usr/share/noctalia-greeter/setup_greeter_system.sh

### Services
systemctl enable podman.socket
systemctl enable greetd
systemctl enable thermald
systemctl enable power-profiles-daemon
systemctl enable outcrop-pin-snapshots.timer
systemctl enable outcrop-grub-theme.service
# ollama.container quadlet is present but deliberately NOT enabled;
# `systemctl enable --now ollama.service` when local AI is wanted.
