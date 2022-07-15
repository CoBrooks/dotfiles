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

  programs.neovim = {
    enable = true;
    extraConfig = ''
      lua << EOF
      ${builtins.readFile ./init.lua}
      cmd[[colorscheme base16-${theme.name}]]
    '';
    plugins = with pkgs.vimPlugins; [
      nvim-base16
      (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
      vim-nix
      lualine-nvim
    ];
    coc = {
      enable = true;
      settings = {
        suggest.enablePreview = true;
        languageserver = {
          rust = {
            command = "rust-analyzer";
            rootPatterns = [ "Cargo.toml" ];
            filetypes = [ "rust" ];
          };
        };
      };
    };
  };
}
