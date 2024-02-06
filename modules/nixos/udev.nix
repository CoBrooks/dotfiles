{ pkgs, config, ... }: 
{
  services.udev.extraRules = ''
ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="0003", MODE:="0666"
  '';
}
