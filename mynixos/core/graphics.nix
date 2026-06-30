{ config, pkgs, ... }:

{
#  hardware.graphics = {
 #   enable = true;
 #   enable32Bit = true;
 #};

 # services.xserver.videoDrivers = [ "nouveau" ];

   #nvidia driver 470x
 # hardware.graphics = {
   # enable = true;
  #  enable32Bit = true;
 # };

  #services.xserver.videoDrivers = [ "nvidia" ];

 # nixpkgs.config = {
   # allowUnfree = true;
  #  nvidia.acceptLicense = true;
 # };

 # hardware.nvidia = {
   # modesetting.enable = true;

  #  powerManagement.enable = false;
 #   powerManagement.finegrained = false;

   # open = false;

   # nvidiaSettings = true;

  #  package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
 # };
 # environment.sessionVariables = {
  #  GBM_BACKEND = "nvidia-drm";
    #__GLX_VENDOR_LIBRARY_NAME = "nvidia";
   # WLR_NO_HARDWARE_CURSORS = "1";
  #  XDG_SESSION_TYPE = "wayland";
 # };
 
}