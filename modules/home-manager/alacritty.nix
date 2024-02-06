{ pkgs, config, theme, ... }: 
{
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        TERM = "alacritty";
      };
      font = {
        normal = {
          family = "Iosevka Custom Nerd Font";
        };
        size = 9.0;
      };
      window = {
        padding = {
          x = 2;
          y = 2;
        };
      };
      colors = theme;
    };
  };
}
