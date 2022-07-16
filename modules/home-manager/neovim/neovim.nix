{ pkgs, config, lib, theme, ... }: 
with builtins; let 
  nvchad = fetchGit {
    url = "https://github.com/NvChad/NvChad";
    rev = "ce027efbe9569711b19f307f40c81e27f79ebb96";

    ref = "main";
  };
in {
  programs.neovim.enable = true;
  programs.neovim.extraPackages = [ 
    pkgs.rust-analyzer 
    pkgs.sumneko-lua-language-server
    pkgs.unzip
    pkgs.ripgrep
  ];

  home.file.".config/nvim" = {
    recursive = true;
    source = nvchad.outPath;
    onChange = "rm .config/nvim/init.vim";
  };

  home.file.".config/nvim/lua/custom/init.lua" = {
    recursive = true;
    text = readFile ./init.lua;
  };
  
  home.file.".config/nvim/lua/custom/chadrc.lua" = {
    recursive = true;
    text = readFile ./chadrc.lua;
  };
}
