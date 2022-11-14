{ pkgs, config, theme, ... }: 
{
  services.dunst = {
    enable = true;
    waylandDisplay = "wayland-1";
    settings = {
      global = {

      };
    };
  };
}
