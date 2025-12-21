#WIP. Goal is to have a one-click reinstall for my "DE"
1. Clone into your ~/.config folder (first level). Or replace your .config with this repo (make sure it's named .config)
2. Build nixos with the config `nixos-rebuild switch -I nixos-config=~/.config/nixos/configuration.nix`
`sudo nixos-rebuild switch -I nixos-config=/home/haroonsyed/.config/nixos/configuration-pc.nix`