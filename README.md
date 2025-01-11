# Perigord-Kleisli Dotfiles

# Installation

This configuration requires flakes, to enable add this line to either your `~/.config/nix/nix.conf` or `/etc/nix/nix.conf`
```bash 
experimental-features = nix-command flakes
```
for more info check the [nix flakes page](https://nixos.wiki/wiki/Flakes)

```bash
nix flake clone github:Perigord-Kleisli/dotfiles --dest /etc/nixos 

# REMEMBER: change all mentions of "truff" (my username), to your preferred username

sudo nixos-rebuild switch
```

# Special Thanks to
- [ZaneyOS](https://gitlab.com/Zaney/zaneyos) - Used as config reference
