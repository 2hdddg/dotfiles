-- Options
vim.o.number = true
vim.o.hidden = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.o.colorcolumn = "80"
vim.o.wrap = false
vim.o.modeline = false
vim.o.swapfile = false
vim.o.signcolumn = "yes:1"
vim.o.clipboard = "unnamed,unnamedplus"
vim.o.gdefault = false -- Otherwise substitution doesn't work multiple times per line
vim.o.cmdheight = 0 -- Gives one more line of core. Requires nvim >= 0.8
vim.o.completeopt = "menuone,noinsert,popup"
vim.o.relativenumber = true
vim.o.pumheight = 10 -- Size of completion pop
vim.o.pumwidth = 80
vim.opt.termguicolors = false -- Rely on terminal palette
vim.opt.listchars = { tab = "»·", trail = "·", extends="#"}
vim.opt.list = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.showmatch = true -- Highlight matching brackets
vim.opt.matchtime = 1
-- Set leader before any plugins
vim.g.mapleader = " "
vim.lsp.set_log_level("off")

-- For TODO highlight to work: TSInstall comment

local plugins = {
    -- LSP configuration support
    'neovim/nvim-lspconfig',
    -- Completion
    'echasnovski/mini.completion',
    -- Git
    'tpope/vim-fugitive',
    -- For telescope
    'nvim-lua/plenary.nvim',
    -- Native fzf
    { 'nvim-telescope/telescope-fzf-native.nvim', build = "make" },
    -- Fuzzy finder over lists
    { 'nvim-telescope/telescope.nvim', branch = '0.1.x'  },
    -- Syntax highlight and more
    { 'nvim-treesitter/nvim-treesitter' },
    -- Status line
    'nvim-lualine/lualine.nvim',
    -- For looks
    'nvim-tree/nvim-web-devicons',
    -- Toggle terminal
    '2hdddg/toggleTerm.nvim',
    -- File explorer
    'stevearc/oil.nvim',
}

-- Bootstrap plugin manager
local ensure_paq = function()
    local path = vim.fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
    if vim.fn.empty(vim.fn.glob(path)) > 0 then
        vim.fn.system { 'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', path }
        vim.cmd [[packadd paq-nvim]]
        return true
    end
    return false
end
local install_plugins = ensure_paq()
local paq = require('paq')
paq(plugins)
if install_plugins then
    paq.install()
    -- Wait for install to complete before proceeding to quit
    vim.cmd('autocmd User PaqDoneInstall quit')
    -- Can not continue to setup plugins here since they are being installed async
    return
end

require('mini.completion').setup({
    window = {
        info = { height = 25, width = 80, border= "rounded" },
        signature = { height = 25, width = 80, border="rounded" },
    },
    set_vim_settings = false,
})
require('finder')
require('highlights')
require('statusline') -- Must be after highlights

local term_clear = function()
    --vim.fn.feedkeys("^L", 'n')
    local sb = vim.bo.scrollback
    vim.bo.scrollback = 1
    vim.bo.scrollback = sb
end

-- ==========================
-- Keymaps
-- ==========================
local keymap_options = { noremap = true, silent = true }
local replace_keycodes = { expr = true }
local key_if_pum_visible = function(key_if, key_if_not)
    if vim.fn.pumvisible() == 1 then
        return key_if
    end
    if key_if_not then
        return key_if_not
    end
end
-- UNCATEGORIZED
-- jk is escape from insert
vim.keymap.set("i", "jk", "<esc>", keymap_options)
vim.keymap.set("t", "jk", "<C-\\><C-n>", keymap_options)
-- Disable space in normal mode as long as it is the leader
vim.keymap.set("n", "<space>", "<nop>", keymap_options)
-- LEADER
vim.keymap.set("n", "<leader>n", "<cmd>nohl<cr>", keymap_options)                                                   -- Clear highlight
vim.keymap.set("n", "<leader>b", "<cmd>lua require('telescope.builtin').buffers()<cr>", keymap_options)             -- List of buffers
vim.keymap.set("n", "<leader>c", "<cmd>lua require('telescope.builtin').git_bcommits()<cr>", keymap_options)
vim.keymap.set("n", "<leader>C", "<cmd>lua require('telescope.builtin').git_commits()<cr>", keymap_options)
vim.keymap.set("n", "<leader>d", "<cmd>Telescope diagnostics bufnr=0<cr>", keymap_options)                          -- Show diagnostics for current buffer
vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics<cr>", keymap_options)                                  -- Show all diagnostics
vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>", keymap_options)
vim.keymap.set("n", "<leader>E", "<cmd>Oil .<cr>", keymap_options)
vim.keymap.set("n", "<leader>f", function()
  local opts = {}
  vim.fn.system('git rev-parse --is-inside-work-tree')
  if vim.v.shell_error == 0 then
    require"telescope.builtin".git_files(opts)
  else
    require"telescope.builtin".find_files(opts)
  end
end)
vim.keymap.set("n", "<leader>r", function()
    require "telescope.builtin".resume()
end, keymap_options)
vim.keymap.set("n", "<leader>F", "<cmd>lua require('telescope.builtin').find_files()<cr>", keymap_options)          -- Fuzzy find among all files
vim.keymap.set("n", "<leader>g", "<cmd>lua require('telescope.builtin').grep_string()<cr>", keymap_options)         -- Grep under cursor
vim.keymap.set("n", "<leader>G", "<cmd>lua require('telescope.builtin').live_grep()<cr>", keymap_options)           -- Live grep
vim.keymap.set("n", "<leader>m", "<cmd>Telescope marks<cr>", keymap_options)
vim.keymap.set("n", "<leader>q", "<cmd>lua require('telescope.builtin').quickfix()<cr>", keymap_options)            -- List of quick fixes
vim.keymap.set("n", "<leader>s", "<cmd>Telescope lsp_document_symbols<cr>", keymap_options)
vim.keymap.set("n", "<leader>S", "<cmd>Telescope lsp_workspace_symbols<cr>", keymap_options)
vim.keymap.set("n", "<leader>1", "<cmd>lua vim.o.relativenumber = not vim.o.relativenumber<cr>", keymap_options)
vim.keymap.set("n", "<leader>?", "<cmd>lua require('telescope.builtin').live_grep({cwd='~/Documents'})<cr>", keymap_options)
-- COMMA
vim.keymap.set("n", ",a", "<cmd>lua vim.lsp.buf.code_action()<cr>", keymap_options)
vim.keymap.set("n", ",b", "<cmd>Git blame<CR>", keymap_options)
vim.keymap.set("n", ",d", "<cmd>lua require('telescope.builtin').lsp_definitions({show_line=false})<CR>", keymap_options)
vim.keymap.set("n", ",i", "<cmd>lua require('telescope.builtin').lsp_implementations({show_line=false})<CR>", keymap_options)
vim.keymap.set("n", ",h", "<cmd>lua vim.lsp.buf.signature_help()<CR>", keymap_options)
vim.keymap.set("n", ",H", "<cmd>lua vim.lsp.buf.hover()<CR>", keymap_options)
vim.keymap.set("n", ",r", "<cmd>lua require('telescope.builtin').lsp_references({show_line=false})<CR>", keymap_options)
vim.keymap.set("n", ",n", "<cmd>lua vim.lsp.buf.rename()<CR>", keymap_options)
vim.keymap.set("n", ",w", "<cmd>w<CR>", keymap_options)
vim.keymap.set("n", ",W", "<cmd>noautocmd w<CR>", keymap_options)
-- Terminal
-- Toggle to terminal from normal mode and back again. Hard coded for 4 active terminals
vim.keymap.set("t", "<C-z>", "<cmd>lua require('toggleTerm').from_terminal()<cr>", keymap_options)
vim.keymap.set("n", "<C-z>", "<cmd>lua require('toggleTerm').from_terminal()<cr>", keymap_options)
vim.keymap.set("n", ",1", "<cmd>lua require('toggleTerm').to_terminal(1)<cr>", keymap_options)
vim.keymap.set("n", ",2", "<cmd>lua require('toggleTerm').to_terminal(2)<cr>", keymap_options)
vim.keymap.set("n", ",3", "<cmd>lua require('toggleTerm').to_terminal(3)<cr>", keymap_options)
vim.keymap.set("n", ",4", "<cmd>lua require('toggleTerm').to_terminal(4)<cr>", keymap_options)
vim.keymap.set("t", '<C-l>', term_clear)
-- Window navigation
-- C-w+ and C-w- resizes height
-- C-w< and C-w> resizes width (C-w10< reduces with 10 columns)
-- C-w| and C-w_ maximizes width and height
vim.keymap.set("n", "<C-h>", "<C-w>h", keymap_options)
vim.keymap.set("n", "<C-j>", "<C-w>j", keymap_options)
vim.keymap.set("n", "<C-k>", "<C-w>k", keymap_options)
vim.keymap.set("n", "<C-l>", "<C-w>l", keymap_options)
-- Open link. Standard keymap but hack due to netrw disabled
vim.keymap.set("n", "gx", "<cmd>silent execute '!xdg-open ' . shellescape(expand('<cfile>'), 1)<cr>", keymap_options)
-- Popup menu (used by for instance mini completion)
-- ctrl+j next item
vim.keymap.set({'i','c'}, '<C-j>', function() return key_if_pum_visible('<C-n>') end, replace_keycodes)
-- ctrl+k next item
vim.keymap.set({'i','c'}, '<C-k>', function() return key_if_pum_visible('<C-p>') end, replace_keycodes)
-- Select menu item with enter
vim.keymap.set({'i','c'}, '<CR>', function() return key_if_pum_visible('<C-y>', '<CR>') end, replace_keycodes)
-- Special select with (
vim.keymap.set('i', '(', function() return key_if_pum_visible('<C-y>(', '(') end, replace_keycodes)
-- Close popup menu with esc
vim.keymap.set({'i','c'}, '<esc>', function() return key_if_pum_visible('<C-e>', '<esc>') end, replace_keycodes)

-- Setup treesitter to use highlighting
require('nvim-treesitter.configs').setup({
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn", -- set to `false` to disable one of the mappings
        node_incremental = "gni",
        node_decremental = "gnd",
        scope_incremental = "grc",
      },
    },
})
-- LSP UI
-- Help popup on ,h
-- ctr-w w to move cursor to it
vim.lsp.handlers["textDocument/hover"] =
  vim.lsp.with(
  vim.lsp.handlers.hover,
  {
    border = "single"
  }
)
-- Smaller box
vim.lsp.handlers["textDocument/signatureHelp"] =
  vim.lsp.with(
  vim.lsp.handlers.signature_help,
  {
    border = "single"
  }
)

-- Oil
require('oil').setup({
    columns = {
        "permissions", "size", "mtime", "icon",
    },
    buf_options = {
        buflisted = true,
    },
    view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
            return name == ".."
        end,
    },
    keymaps = {
        ["<CR>"] = "actions.select",
        ["<BS>"] = "actions.parent",
        ["Y"] = "actions.copy_entry_path",
        ["<C-z>"] = "actions.open_terminal",
        ["<C-c>"] = "actions.open_cmdline_dir",
    },
})

