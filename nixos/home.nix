{ config, pkgs, inputs, ... }: 
let
  mv = inputs.multiverse.multiverse.${pkgs.system};
in
{
  
  home.username = "haroonsyed";
  home.homeDirectory = "/home/haroonsyed";
  home.stateVersion = "25.05";

  targets.genericLinux.enable = true; # Work on non-nixos
  
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    # TODO: Separate out gaming and dev stuff
    # That way I could clone and use at work

    vscodium
    fzf
    zellij
    git
    tldr
    trash-cli
    btop
    kitty
    wl-clipboard
    cliphist
    fuzzel

    # Gaming
    protonup-ng
    discord
    moonlight-qt
    prismlauncher

    # Neovim setup
    neovim

    # DE
    matugen
    wayle
    awww
    
    # General Applications
    google-chrome
    grimblast
    notepad-next
  ];

  home.shellAliases = {
    code = "codium";
  };
}