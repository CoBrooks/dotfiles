local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local opt = vim.opt

cmd[[filetype plugin on]]
cmd[[set noshowmode]]
cmd[[set termguicolors]]

g.mapleader = ' '
g.maplocalleader = ','

opt.clipboard = 'unnamedplus'
opt.cursorline = true
opt.encoding = "utf-8"
opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.hidden = true
opt.shiftwidth = 2
opt.smartindent = true
opt.signcolumn = "number"
opt.updatetime = 400

require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true;
  }
}

require('indent_blankline').setup {
  show_current_context = true,
}

require('lualine').setup {
  options = {
    theme = 'gruvbox-material',
  },
  tabline = {
    lualine_a = {'buffers'},
    lualine_b = {'branch'}, 
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {'tabs'},
  },
}
