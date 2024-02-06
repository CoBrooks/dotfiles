vim.loader.enable();

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

vim.filetype.add {
  extension = {
    tf  = 'terraform',
    tex = 'latex',
    h = 'c',
    frag = 'glsl',
    vert = 'glsl',
    zon = 'zig',
  }
}

g.surround_99 = "\\\1command\1{\r}"

require('ibl').setup {
  scope = { enabled = true }
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

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.document_formatting = false

-- if capabilities.document_formatting then
--   vim.cmd [[augroup Format]]
--   vim.cmd [[autocmd! * <buffer>]]
--   vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
--   vim.cmd [[augroup END]]
-- end

local lspconfig = require('lspconfig')
lspconfig["rust_analyzer"].setup {
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true
      },
      checkOnSave = {
        command = "clippy",
        allTargets = false
      }
    }
  }
};
lspconfig["lua_ls"].setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
        }
      },
      diagnostics = {
        globals = { 'vim' },
      }
    }
  }
};
lspconfig["tsserver"].setup { }
lspconfig["clangd"].setup { }
lspconfig["terraformls"].setup { }
lspconfig["ocamllsp"].setup { }
lspconfig["zls"].setup {
  capabilities = capabilities,
  settings = {
    semantic_tokens = "none",
    warn_style = true,
  }
}
lspconfig["nil_ls"].setup {
  capabilities = capabilities,
  settings = {
    rootPatterns = {"flake.nix", ".git", "shell.nix"}
  }
}

vim.keymap.set('n', '<leader>fn', ":enew<cr>", { silent = true })

vim.keymap.set('n', '<Tab>', ":bnext<cr>", { silent = true })
vim.keymap.set('n', '<S-Tab>', ":bprev<cr>", { silent = true })
vim.keymap.set('n', '<leader>q', ":bdelete<cr>", { silent = true })

local floaterm_open_file = function ()
  local word = fn.expand('<cWORD>');

  local parse_filepath = function (input)
    local filename, suffix = input:match('^([^:]+):([0-9:]+)$');

    if not filename then
      return input;
    end

    if suffix:match('^%d+$') then
      return filename, tonumber(suffix);
    end

    local line, col = suffix:match('^(%d+):(%d+)');
    return filename, tonumber(line), tonumber(col);
  end

  local file, line, col = parse_filepath(word);

  if file ~= nil and file ~= "" then
    vim.cmd('FloatermHide');
    vim.cmd.edit{ fn.fnameescape(file) };

    if line then
      vim.api.nvim_win_set_cursor(0, { line, col and col - 1 or 0 });
    end
  end
end

vim.keymap.set('t', '<Esc>', "<C-\\><C-n>", { silent = true })
vim.keymap.set('n', '<leader>t', ":FloatermToggle<CR>", { silent = true })

local group = vim.api.nvim_create_augroup("user_defined", { clear = true });

vim.api.nvim_create_autocmd("User", {
  pattern = "FloatermOpen",
  group = group,
  nested = true,
  callback = function ()
    vim.keymap.set('n', 'gf', floaterm_open_file, { buffer = true });
  end,
})

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { silent = true })
