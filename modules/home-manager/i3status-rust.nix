{ pkgs, config, theme, ... }: 
{
  home.file."${config.home.homeDirectory}/.config/i3status-rust/themes/custom.toml".text = ''
    idle_bg = "${theme.background}"
    idle_fg = "${theme.foreground}"
    info_bg = "${theme.normal.blue}"
    info_fg = "${theme.background}"
    good_bg = "${theme.normal.green}"
    good_fg = "${theme.background}"
    warning_bg = "${theme.normal.yellow}"
    warning_fg = "${theme.background}"
    critical_bg = "${theme.normal.red}"
    critical_fg = "${theme.background}"
    separator_bg = "auto"
    separator_fg = "auto"
  '';

  programs.i3status-rust = {
    enable = true;
    bars = {
      primary = {
        settings = {
          theme = {
            theme = "${config.home.homeDirectory}/.config/i3status-rust/themes/custom.toml";
          };
          icons = {
            icons = "awesome6";
            overrides = {
              net_up = "";
              net_down = "";
            };
          };
        };
        blocks = [
          {
            block = "time"; 
            format = " $timestamp.datetime(f:'%a %m/%d %I:%M %p') ";
            interval = 60;
          }
          {
            block = "cpu";
            interval = 1;
            format = " $icon $barchart $utilization ";
          }
          {
            block = "disk_space";
            info_type = "available";
            interval = 60;
            path = "/";
            warning = 20;
            alert = 10;
          }
          {
            block = "net";
            device = "wlan0";
            interval = 10;
            format = " $icon $ssid ";
          }
          {
            block = "sound";
          }
          {
            block = "backlight";
          }
          {
            block = "battery";
            interval = 10;
            format = " $icon $percentage $time ";
          }
        ];
      };
    };
  };
}
