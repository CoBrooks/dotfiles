{ pkgs, config, theme, ... }: 
{
  home.packages = [ pkgs.bemenu ];

  wayland.windowManager.sway = {
    enable = true;
    config = {
      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          xkb_options = "caps:swapescape";
        };
      };
      modifier = "Mod4";
      left = "h";
      down = "j";
      up = "k";
      right = "l";
      terminal = "alacritty";
      menu = "bemenu-run | xargs swaymsg exec --";
      fonts = {
        names = [ "JetBrainsMono" ];
        style = "Regular";
        size = 9.0;
      };
      gaps = {
        inner = 5;
        outer = 2;
        smartGaps = true;
      };
      output = {
        "*" = { 
          bg = "~/Pictures/wallpaper fill";
        };
      };
      bars = [
        {
          position = "top";
          statusCommand = "$(which i3status-rs) ~/.config/i3status-rust/config-primary.toml";
          fonts = {
            names = [ "Iosevka Aile" "Font Awesome 6 Free" ];
            style = "Regular";
            size = 8.0;
          };
          colors = {
            background = theme.background;
            statusline = theme.foreground;
            focusedWorkspace = {
              border = theme.foreground;
              background = theme.foreground;
              text = theme.background;
            };
            inactiveWorkspace = {
              border = theme.background;
              background = theme.background;
              text = theme.foreground;
            };
            activeWorkspace = {
              border = theme.background;
              background = theme.normal.blue;
              text = theme.background;
            };
            urgentWorkspace = {
              border = theme.normal.red;
              background = theme.normal.red;
              text = theme.foreground;
            };
          };
        }
      ];
      colors = {
        focused = {
          border = theme.foreground;
          background = theme.background;
          text = theme.background;
          indicator = theme.foreground;
          childBorder = theme.foreground;
        };
        focusedInactive = {
          border = theme.normal.cyan;
          background = theme.normal.cyan;
          text = theme.background;
          indicator = theme.normal.cyan;
          childBorder = theme.normal.cyan;
        };
        unfocused = {
          border = theme.background;
          background = theme.background;
          text = theme.background;
          indicator = theme.background;
          childBorder = theme.background;
        };
        urgent = {
          border = theme.normal.red;
          background = theme.normal.red;
          text = theme.background;
          indicator = theme.normal.red;
          childBorder = theme.normal.red;
        };
        placeholder = {
          border = theme.background;
          background = theme.background;
          text = theme.background;
          indicator = theme.background;
          childBorder = theme.background;
        };
        background = theme.background;
      };
    };
  };
}
