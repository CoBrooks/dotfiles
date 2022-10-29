{ pkgs, config, theme, ... }: 
let 
  nvim-base16 = pkgs.vimUtils.buildVimPlugin { name = "nvim-base16"; src = pkgs.fetchFromGitHub {
      owner = "RRethy";
      repo = "nvim-base16";
      rev = "da2a27cbda9b086c201b36778e7cdfd00966627a";
      sha256 = "RkPEcTkrnZDj9Mx2wlKX2VKsk68+/AZsyPQuJ7ezFKg=";
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
      sumneko-lua-language-server 
      clang-tools
      terraform-ls
      # Tree-sitter deps
      tree-sitter nodejs
      # Telescope deps
      ripgrep fd
    ];
    plugins = with pkgs.vimPlugins; [
      # measure startup time
      vim-startuptime
      # speed up startup time
      impatient-nvim
      # color themes
      nvim-base16
      # syntax highlighting
      (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
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
      # File picker / search util
      telescope-nvim
    ];
  };
}
