{ config, lib, pkgs, ... }:

# Enables intel GPU acceleration.
{
  hardware.opengl = {
    enable = true;
    extraPackages = [
      pkgs.intel-ocl
      pkgs.ocl-icd
      pkgs.intel-media-driver
    ];
  };

  # Needed for the intel-ocl package
  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables = {
    # Forces the use of the iHD intel-media-driver instead of trying to use i965
    LIBVA_DRIVER_NAME = "iHD";
  };
}
