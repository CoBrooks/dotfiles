{ pkgs, config, theme, ... }: 
let 
  nvim-base16 = pkgs.vimUtils.buildVimPlugin { name = "nvim-base16"; src = pkgs.fetchFromGitHub {
      owner   = "RRethy";
      repo    = "nvim-base16";
      rev     = "010bedf0b7c01ab4d4e4e896a8527d97c222351d";
      sha256  = "sha256-e1jf7HyP9nu/HQHZ0QK+o7Aljk7Hu2iK+LNw3166wn8=";
    };
  };
in {
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.neovim = {
    enable = true;
    extraConfig = ''
      lua << EOF
      vim.cmd "colorscheme base16-${theme.name}"
      ${builtins.readFile ./init.lua}
      EOF
    '';
    extraPackages = with pkgs; [
      # LSPs
      rust-analyzer 
      lua-language-server 
      clang-tools
      terraform-ls
      nil
      # Tree-sitter deps
      tree-sitter nodejs
      # So that markdown-preview-nvim can open a browser tab
      xdg-utils
      # LaTeX
      texlive.combined.scheme-full
    ];
    plugins = with pkgs.vimPlugins; [
      # measure startup time
      vim-startuptime
      # color themes
      nvim-base16
      gruvbox-material
      # syntax highlighting
      nvim-treesitter.withAllGrammars
      # nix syntax defs
      vim-nix
      # status and tab line
      lualine-nvim
      # indent line
      indent-blankline-nvim
      # LSP
      nvim-lspconfig
      # autocompletion
      nvim-cmp
      ## sources
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      ## snippet engine
      luasnip
      cmp_luasnip
      ## menu icons
      lspkind-nvim
      # Markdown preview
      markdown-preview-nvim
      # LaTeX preview
      vimtex
      # "Surround" modifier
      vim-surround
      # Treesitter debugging
      playground
      # Git gutter
      vim-gitgutter
      # Floating terminal
      vim-floaterm
    ];
  };
}
