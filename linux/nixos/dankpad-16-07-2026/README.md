# NixOS — dankpad (ASUS VivoBook Pro 15 X580VD)

## Restauración desde cero

1. Instalar NixOS 26.05 con Calamares (mismo particionado BTRFS, sin desktop).
2. Copiar flake.nix, configuration.nix, home.nix a /etc/nixos/
   (NO copiar hardware-configuration.nix — generar uno nuevo con
   `nixos-generate-config`, luego fusionar el bloque `imports` con el existente).
3. sudo nixos-rebuild switch --flake /etc/nixos#dankpad
4. Ejecutar `dms setup` manualmente (compositor: Niri, terminal: Ghostty,
   systemd: sí) — esto NO se gestiona por Nix a propósito.
5. Regenerar llave SSH (ver sección abajo) y añadirla a GitHub.
6. Configurar Ajustes de DMS manualmente vía GUI (barra, monitores, tema) —
   esto vive en ~/.config/DankMaterialShell/, fuera de Nix.

## Llave SSH
La llave SSH NO se respalda en este repo por seguridad. Generar una nueva:
ssh-keygen -t ed25519 -C "amata@dankpad" -f ~/.ssh/id_ed25519
Y añadirla en GitHub → Settings → SSH and GPG keys.

## Notas
- GPU: NVIDIA GTX 1050 fijada a legacy_580 (Pascal, EOL ~2028).
- Firefox Developer Edition: idioma es-MX se configura manualmente
  desde Ajustes → General → Idioma (no es declarativo).
