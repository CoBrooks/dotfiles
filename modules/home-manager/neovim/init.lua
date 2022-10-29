require('impatient')

local fn = vim.fn
local g = vim.g
local opt = vim.opt

vim.cmd "filetype plugin on"
vim.cmd "set noshowmode"
vim.cmd "set termguicolors"

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
opt.tabstop = 2
opt.smartindent = true
opt.signcolumn = "number"
opt.updatetime = 400
opt.mouse = ""

require('indent_blankline').setup {
  show_current_context = true,
}

require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true;
  }
}

require('lualine').setup {
  options = {
    section_separators = '',
    component_separators = '',
    theme = 'gruvbox-material',
  },
  tabline = {
    lualine_a = {
      {
        'buffers',
        symbols = {
          alternate_file = ''
        },
        filetype_names = {
          TelescopePrompt = '',
        }
      }
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {'branch'},
  },
}

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local luasnip = require('luasnip')

opt.completeopt="menu,menuone,noselect"

local cmp = require('cmp')

local function border(hl_name)
  return {
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { "│", hl_name },
    { "╯", hl_name },
    { "─", hl_name },
    { "╰", hl_name },
    { "│", hl_name },
  }
end

-- Disable Scrolling in Autocomplete Window --
local cmp_window = require("cmp.utils.window")

cmp_window.info_ = cmp_window.info
cmp_window.info = function (self)
  local info = self:info_()
  info.scrollable = false
  return info
end

-- Fix Completion Menu Background --
vim.cmd "hi CmpItemAbbr guibg=None"

local lspkind = require('lspkind')
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = {
      border = border "CmpBorder",
      winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenu,CursorLine:PmenuSel,Search:None",
    },
    documentation = {
      border = border "CmpDocBorder",
    },
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol_text",
      menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[Latex]",
      }),
    }),
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      -- elseif luasnip.expand_or_jumpable() then
      --   luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      -- elseif luasnip.jumpable(-1) then
      --   luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),

    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
  }),
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "buffer" }
    }),
  }),
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" }
    }, {
      { name = "cmdline" }
    }),
  }),
}

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

if capabilities.document_formatting then
  vim.cmd [[augroup Format]]
  vim.cmd [[autocmd! * <buffer>]]
  vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
  vim.cmd [[augroup END]]
end

local lspconfig = require('lspconfig')
lspconfig["rust_analyzer"].setup {
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true
      },
      checkOnSave = {
        command = "clippy"
      }
    }
  }
};
lspconfig["sumneko_lua"].setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = runtime_path,
      },
      diagnostics = {
        globals = { 'vim' },
      }
    }
  }
}
lspconfig["clangd"].setup { }
lspconfig["terraformls"].setup { }

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<Tab>"] = require('telescope.actions').move_selection_next,
        ["<S-Tab>"] = require('telescope.actions').move_selection_previous
      },
      n = {
        ["<Tab>"] = require('telescope.actions').move_selection_next,
        ["<S-Tab>"] = require('telescope.actions').move_selection_previous
      }
    }
  }
}

-- Telescope Highlighting --
vim.cmd "hi TelescopeBorder guibg=None guifg=Foreground"
vim.cmd "hi TelescopePromptBorder guibg=None guifg=Foreground"
vim.cmd "hi TelescopeNormal guibg=None"
vim.cmd "hi TelescopeSelection gui=inverse"
vim.cmd "hi TelescopeSelectionCaret guibg=Foreground"
vim.cmd "hi TelescopePromptNormal guibg=None"
vim.cmd "hi TelescopePromptPrefix guibg=None"

local find_files = function()
  local opts = require('telescope.themes').get_dropdown {
    borderchars = {
      { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
      prompt = { '─', '│', '─', '│', '╭', '╮', '┤', '├'},
      results = { '─', '│', '─', '│', '├', '┤', '╯', '╰'},
      preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
    },
    previewer = false,
    prompt_title = false,
    layout_config = {
      width = 0.5
    }
  };

  require('telescope.builtin').find_files(opts)
end

local live_grep = function()
  local opts = require('telescope.themes').get_dropdown {
    borderchars = {
      { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
      prompt = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
      results = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
      preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
    },
    prompt_title = false,
    layout_strategy = "horizontal",
    layout_config = {
      width = 0.8,
      height = 0.8,
      prompt_position = "top",
      preview_width = 80
    }
  };

  require('telescope.builtin').live_grep(opts)
end

vim.keymap.set('n', '<leader>ff', find_files)
vim.keymap.set('n', '<leader>fw', live_grep)
vim.keymap.set('n', '<leader>fn', ":enew<cr>", { silent = true })

vim.keymap.set('n', '<Tab>', ":bnext<cr>", { silent = true })
vim.keymap.set('n', '<S-Tab>', ":bprev<cr>", { silent = true })
vim.keymap.set('n', '<leader>q', ":bdelete<cr>", { silent = true })
