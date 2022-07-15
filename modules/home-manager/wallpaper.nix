{ pkgs, config, ... }: 
let 
  getWallpaper = { name  }: 
  with builtins; {
    source = fetchGit { 
      url = "https://codeberg.org/exorcist/wallpapers";
      ref = "master";
      rev = "4e0a72a8d67264e58fa0424693fd93cb24bc527c";
    } + "/" + name;
  };
in {
  home.file."Pictures/wallpaper" = getWallpaper { 
    name =  "gruvbox/forest-2.jpg"; 
  };
}
