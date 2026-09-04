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
      (run once: `sudo systemctl start ollama.service`;
       persist: `sudo ln -s ollama.service /etc/systemd/system/multi-user.target.wants/`
       — the quadlet has no [Install], so plain `systemctl enable` can't be used)
- [ ] First login reaches the compositor immediately — no 60s countdown
      (uwsm removed from the session launcher; if a wait ever returns,
      `journalctl --user -b | grep uwsm` shows what it's waiting on)

## Known-cosmetic (not failures)
- Anaconda hub title renders product as "44" ("It's time to install 44.") — installer-only quirk
- Secure Boot must be OFF in BIOS — image is unsigned (laptop only)

## VM-only notes
- VM user/password: whatever you type into Anaconda's Users screen — the
  kickstart sets no credentials. Note it during install if SSH access is wanted.
- sshd is disabled by the kickstart (`services --disabled`); the port-50922
  forward only works if you re-enable it (`sudo systemctl enable --now sshd`).
  Driving the VM via the QEMU monitor/console works without it.
- Repeated wrong passwords trigger pam_faillock (deny=3, 10 min lockout) —
  if logins suddenly stop accepting a correct password, wait it out.
- VM "GPU" is virtio-gpu; real GPU/fingerprint/hotplug checks are laptop-only
