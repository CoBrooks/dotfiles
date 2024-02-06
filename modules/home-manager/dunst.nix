{ pkgs, config, theme, ... }: 
{
  services.dunst = {
    enable = true;
    waylandDisplay = "wayland-1";
    settings = {
      global = {
        font = "Font Awesome 6 Free 10.5, Iosevka Aile 10.5";
        frame_width = 2;
        scale = 2;
        gap_size = 2;

        origin = "top-right";
        offset = "4x3";
        width = "200";

        foreground = theme.foreground;
        background = theme.normal.black;
        frame_color = theme.foreground;
      };
      
      urgency_low = {
        frame_color = theme.bright.black;
        
        format = "<b>%s</b>\\n%b";
      };

      urgency_normal = {
        format = "<b>  %s</b>\\n%b";
      };
      
      urgency_critical = {
        frame_color = theme.normal.red;
        
        format = "<b>  %s</b>\\n%b";
      };
    };
  };
}
