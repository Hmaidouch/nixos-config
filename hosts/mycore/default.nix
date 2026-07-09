{ config, pkgs, ... }:

{
  imports = [
    ./fonts.nix
    ./graphics.nix
    ./configurationuser.nix
  ];
}