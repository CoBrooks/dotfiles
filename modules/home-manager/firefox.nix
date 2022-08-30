{ pkgs, config, ... }: 
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      darkreader
      ublock-origin
      onepassword-password-manager
    ];
    profiles = [
      "cbrooks" = {
        id = 0;
        isDefault = true;
        settings = {
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        };
      };
    ];
  };
}
