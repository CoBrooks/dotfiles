{ pkgs, config, ... }: 
{
  programs.helix = {
    enable = true;
    settings = {
      theme = "base16_transparent";
      editor = {
        mouse = false;
        line-number = "relative";
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "block";
        };
        file-picker.hidden = false;
        indent-guides.render = true;
      };
    };
  };
}
