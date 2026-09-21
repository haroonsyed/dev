{ pkgs, ... }:

{
  networking.hostName = "laptop";

  # NVIDIA Prime hybrid graphics offloading
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    # Make sure to use the correct Bus ID values for your system!
    nvidiaBusId = "PCI:1:0:0";
    amdgpuBusId = "PCI:7:0:0";
  };

  environment.systemPackages = with pkgs; [
    heroic
  ];
}