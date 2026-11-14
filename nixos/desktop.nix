{ pkgs, ... }:

{
  networking.hostName = "desktop";

  services.openssh.enable = true;

  # Sleep settings
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Game stream
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = false;

    # NVENC Encoder
    package = pkgs.sunshine.override {
      cudaSupport = true;
      cudaPackages = pkgs.cudaPackages;
    };
  };

  # Virtualization
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "haroonsyed" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # K3s Kubernetes
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
  };
  networking.firewall = {
    allowedTCPPorts = [
      25565 # Minecraft
      47984 47989 48010 # Sunshine
    ];
    allowedUDPPorts = [
      41641 # Tailscale
      47998 47999 48000 48002 48010 # Sunshine
    ];
    enable = true;
    trustedInterfaces = [ "tailscale0" ];

    # allowedTCPPorts = [ 6443 4244 10250 ]; # K3s API server and metrics. NEVER PORT FORWARD THESE THROUGH ROUTER
    # allowedUDPPorts = [ 8472 ]; # Cilium VXLAN port

    # Enable cilium overlay network for self communication
    extraCommands = ''
      iptables -A INPUT -s 10.42.0.0/16 -j ACCEPT # Overlay network
    '';
    checkReversePath = false; # needed for cilium
  };
  environment.variables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";

  environment.systemPackages = with pkgs; [
    kubectl
    nixos-generators
  ];
}