{ pkgs, config, theme, ... }: 
{
  home.packages = [ pkgs.speedtest-cli ];

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
    separator = ""
    separator_bg = "auto"
    separator_fg = "auto"
  '';

  programs.i3status-rust = {
    enable = true;
    bars = {
      primary = {
        settings = {
          theme = {
            file = "${config.home.homeDirectory}/.config/i3status-rust/themes/custom.toml";
            overrides = {
              separator = "";
            };
          };
          icons = {
            name = "awesome6";
            overrides = {
              net_up = "";
              net_down = "";
            };
          };
        };
        blocks = [
          {
            block = "time";
            format = "%a %d/%m %I:%M %p";
          }
          {
            block = "cpu";
            interval = 1;
            format = "{barchart} {utilization}";
          }
          {
            block = "networkmanager";
            on_click = "alacritty -e nmtui";
            device_format = "{icon}{ap} {ips}";
          }
          {
            block = "speedtest";
            interval = 1800;
            format = "{speed_down*_b:3;M} {speed_up*_b:3;M}";
          }
          {
            block = "battery";
            interval = 10;
            format = "{percentage} {time}";
          }
        ];
      };
    };
  };
}
