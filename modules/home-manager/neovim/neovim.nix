{ pkgs, config, theme, ... }: 
let 
  nvim-base16 = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-base16";
    src = pkgs.fetchFromGitHub {
      owner = "RRethy";
      repo = "nvim-base16";
      rev = "da2a27cbda9b086c201b36778e7cdfd00966627a";
      sha256 = "RkPEcTkrnZDj9Mx2wlKX2VKsk68+/AZsyPQuJ7ezFKg=";
    };
  };
in {
  home.packages = [ pkgs.rust-analyzer ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.neovim = {
    enable = true;
    extraConfig = ''
      lua << EOF
      ${builtins.readFile ./config/init.lua}
      cmd[[colorscheme base16-${theme.name}]]
    '';
    plugins = with pkgs.vimPlugins; [
      nvim-base16
      (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
      vim-nix
      lualine-nvim
      nvim-cmp
      indent-blankline-nvim
    ];
  };

  home.file.".config/nvim/plugins" = {
    recursive = true;
    source = ./config/plugins;
  };
}
