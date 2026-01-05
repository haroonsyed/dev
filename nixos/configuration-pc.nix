# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };

  # NVIDIA GPU CONFIGURATION: https://nixos.wiki/wiki/Nvidia
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    open = true;

    # Enable the Nvidia settings menu,
	  # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  environment.localBinInPath = true;
  programs.nix-ld.enable = true;
  users.users.haroonsyed = {
    isNormalUser = true;
    description = "haroonsyed";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      pkgs.discord
      pkgs.moonlight-qt
      pkgs.prismlauncher
      pkgs.vscode
      pkgs.fzf
      pkgs.zellij

      # Gaming
      pkgs.protonup-ng

      # Neovim setup
      pkgs.neovim
    ];
  };
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  environment.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/haroonsyed/.steam/root/compatibilitytools.d";

  # Game stream
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allow flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.direnv.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Base
    pkgs.google-chrome

    # Dev
    git
    pkgs.tldr
    pkgs.trash-cli
    pkgs.btop
    pkgs.grimblast
    pkgs.cudaPackages.cudatoolkit
    pkgs.nixos-generators
    notepad-next
    filezilla

    # Hyprland
    pkgs.kitty
    pkgs.matugen
    pkgs.swww
    pkgs.fuzzel
    pkgs.wl-clipboard
    pkgs.cliphist
    pkgs.hyprpanel
    pkgs.power-profiles-daemon
    pkgs.hyprlock
    pkgs.hypridle
    pkgs.hyprpolkitagent

    # Virtualization
    pkgs.kubectl
  ];
  environment.sessionVariables = {
    HYPR_PLUGIN_DIR = pkgs.symlinkJoin {
      name = "hyprland-plugins";
      paths = with pkgs.hyprlandPlugins; [
        hyprscrolling
        #...plugins
      ];
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.jetbrains-mono
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?


  # Haroon Configurations
  # Wayland/Hyprland setup
  programs.hyprland.enable = true;


  # Virtualization (Dedicated VM setups)
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["haroonsyed"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # Docker
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "haroonsyed" ];

  # Kubernetes
  environment.etc."rancher/k3s/server/psa.yaml".text = ''
    apiVersion: apiserver.config.k8s.io/v1
    kind: AdmissionConfiguration
    plugins:
    - name: PodSecurity
      configuration:
        apiVersion: pod-security.admission.config.k8s.io/v1
        kind: PodSecurityConfiguration
        defaults:
          enforce: "restricted"
          enforce-version: "latest"
          warn: "restricted"
          warn-version: "latest"
        exemptions:
          usernames: []
          runtimeClasses: []
          namespaces: [kube-system]
  '';
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = [
      "--write-kubeconfig-mode=600"
      "--secrets-encryption"
      "--kube-apiserver-arg=admission-control-config-file=/etc/rancher/k3s/server/psa.yaml"
      "--kubelet-arg=pod-max-pids=2048"
      "--kube-apiserver-arg=enable-admission-plugins=NodeRestriction"
      "--kubelet-arg=authentication-token-webhook=true"
      "--kubelet-arg=authorization-mode=Webhook"

      # CILIUM stuff
      "--disable=traefik,flannel,servicelb"
      "--flannel-backend=none"
      "--disable-network-policy"
      "--disable-kube-proxy"
    ];
    
    # TODO: Add manifest for helm charts of argocd
  };
  networking.firewall = {
    enable = true;
    # allowedTCPPorts = [ 6443 4244 10250 ]; # K3s API server and metrics. NEVER PORT FORWARD THESE THROUGH ROUTER
    # allowedUDPPorts = [ 8472 ]; # Cilium VXLAN port

    # Enable cilium overlay network for self communication
    extraCommands = ''
      iptables -A INPUT -s 10.42.0.0/16 -j ACCEPT # Overlay network
    '';
    checkReversePath = false; # needed for cilium
  };
  environment.variables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
}
