# First-boot checklist

Run through after any fresh install (VM first, then the laptop).
Everything CLI can be done in ghostty (SUPER+Return); GUI items say so explicitly.

## Boot chain
- [ ] GRUB menu shows the outcrop theme (gold logo on near-black, gold selection)
      — first boot after Anaconda may show stock GRUB; the theme lands after
      `outcrop-grub-theme.service` runs and re-runs grub2-mkconfig
- [ ] Plymouth splash: dark ground, gold outcrop mark, 8-dot pulse
- [ ] Multiple boot entries exist (pinned rollback slots appear after upgrades)

## Greeter + session
- [ ] greetd lands on noctalia-greeter with the **outcrop labs logo** (gold), talaria colors
- [ ] Login as the created user → Hyprland session starts, Noctalia bar/shell appears
- [ ] SUPER+Return → ghostty; SUPER+SPACE → Noctalia launcher
- [ ] SUPER+E → Thunar, themed dark (ground `#090A09`, gold accent `#C8B46C`)
- [ ] SUPER+comma → Noctalia settings

## Theming propagation
- [ ] Flip Noctalia light/dark → Thunar, ghostty (`outcrop`/`outcrop-light`), and Qt apps follow
- [ ] hyprlock (SUPER+L or idle): talaria lock screen, gold "outcrop" label

## Laptop plumbing
- [ ] Battery/profile widgets render (upower + power-profiles-daemon)
- [ ] Night light: SUPER+N toggles `hyprsunset -t 3800`
- [ ] kanshi applies the eDP-1 profile (dock/undock test on real hardware)

## Image/update mechanics
- [ ] `bootc status` — image `ghcr.io/joniler/outcropos:latest`, transport registry
- [ ] `rpm-ostree status` / `ostree admin status` — deployments listed, pin script ran:
      `systemctl status outcrop-pin-snapshots.timer` (OnBootSec=3min)
- [ ] `bootc upgrade` → new deployment appears **pinned**; GRUB lists both entries
- [ ] Flatpak: `flatpak remotes` shows flathub; `flatpak install flathub org.mozilla.firefox` works
- [ ] ollama NOT running by default: `systemctl is-active ollama.service` → inactive
      (enable later: `sudo systemctl enable --now ollama.service`)

## Known-cosmetic (not failures)
- Anaconda hub title renders product as "44" ("It's time to install 44.") — installer-only quirk
- Secure Boot must be OFF in BIOS — image is unsigned (laptop only)

## VM-only notes
- VM user: `jon` / `outcropvm`; SSH forward `localhost:50922` (no sshd in image — drive via console)
- VM "GPU" is virtio-gpu; real GPU/fingerprint/hotplug checks are laptop-only
