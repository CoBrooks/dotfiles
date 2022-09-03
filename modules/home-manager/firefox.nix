{ pkgs, config, ... }: 
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    profiles.cbrooks = {
      id = 0;
      isDefault = true;
      settings = {
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "layout.css.devPixelsPerPx" = "1.5";
      };
    };
  };
}
