{ pkgs, config, ... }: 
{
  programs.helix = {
    enable = true;
    settings = {
      theme = "gruvbox";
      editor = {
        mouse = false;
        line-number = "relative";
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "block";
        };
        file-picker.hidden = false;
      };
    };
  };
}
