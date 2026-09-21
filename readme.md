#WIP. Goal is to have a one-click reinstall for my "DE"
1. Clone into your ~/.config folder (first level). Or replace your .config with this repo (make sure it's named .config)
2. Update channel with `nix flake update --flake ~/.config/nixos`
3. Build nixos with the config `sudo nixos-rebuild boot --flake ~/.config/nixos#desktop` or `sudo nixos-rebuild boot --flake ~/.config/nixos#laptop`
4. Restart