# dotfiles

## init
WIP
### linux
1. install nix
```bash
curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --extra-conf "extra-trusted-users = $(id -un)"
```

2. run cmd on repo root
```bash
nix run .#switch
```
