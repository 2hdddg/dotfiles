-- Options
vim.o.number = true
vim.o.hidden = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.o.colorcolumn = 80
vim.o.wrap = false
vim.o.modeline = false
vim.o.swapfile = false
vim.o.signcolumn = "yes:1"
vim.o.clipboard = "unnamed,unnamedplus"
vim.o.gdefault = false -- Otherwise substitution doesn't work multiple times per line
vim.o.cmdheight = 0 -- Gives one more line of core. Requires nvim >= 0.8
vim.o.completeopt = "menu,menuone,noselect" -- As requested by nvim-cmp
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
--vim.g.loaded_netrw = 1
--vim.g.loaded_netrwPlugin = 1
-- Set leader before any plugins
vim.g.mapleader = " "
vim.lsp.set_log_level("off")

local plugins = {
    -- LSP configuration support
    'neovim/nvim-lspconfig',
    -- Enhanced C++
    'p00f/clangd_extensions.nvim',
    -- Enhanced Java LSP support
    --'mfussenegger/nvim-jdtls',
    -- Debugger support
    --'mfussenegger/nvim-dap',
    -- Auto completion sources
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-vsnip',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    -- Snippets
    'hrsh7th/vim-vsnip',
    'hrsh7th/vim-vsnip-integ',
    -- And some actual snippets
    'rafamadriz/friendly-snippets',
    -- Completion itself
    'hrsh7th/nvim-cmp',
    -- Git
    'tpope/vim-fugitive',
    -- For telescope
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    -- Native fzf
    { 'nvim-telescope/telescope-fzf-native.nvim', run = "make" },
    -- Fuzzy finder over lists
    { 'nvim-telescope/telescope.nvim', branch = '0.1.x'  },
    -- Syntax highlight and more
    { 'nvim-treesitter/nvim-treesitter' },
    -- Resize windows with Ctrl-E
    'simeji/winresizer',
    -- Status line
    'nvim-lualine/lualine.nvim',
    -- For looks
    'nvim-tree/nvim-web-devicons',
    -- For marks in gutter
    'chentoast/marks.nvim',
    -- Toggle terminal
    '2hdddg/toggleTerm.nvim',
    -- File explorer
    { 'nvim-neo-tree/neo-tree.nvim', branch = 'v3.x' },
    'MunifTanjim/nui.nvim' -- Needed by neo-tree
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

require("marks").setup({})
require('completion')
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
local set_keymap = vim.api.nvim_set_keymap
-- UNCATEGORIZED
-- jk is escape from insert
set_keymap("i", "jk", "<esc>", keymap_options)
set_keymap("t", "jk", "<C-\\><C-n>", keymap_options)
-- Disable space in normal mode as long as it is the leader
set_keymap("n", "<space>", "<nop>", keymap_options)
-- LEADER
set_keymap("n", "<leader>n", "<cmd>nohl<cr>", keymap_options)                                                   -- Clear highlight
set_keymap("n", "<leader>b", "<cmd>lua require('telescope.builtin').buffers()<cr>", keymap_options)             -- List of buffers
set_keymap("n", "<leader>c", "<cmd>lua require('telescope.builtin').git_bcommits()<cr>", keymap_options)
set_keymap("n", "<leader>C", "<cmd>lua require('telescope.builtin').git_commits()<cr>", keymap_options)
set_keymap("n", "<leader>d", "<cmd>Telescope diagnostics bufnr=0<cr>", keymap_options)                          -- Show diagnostics for current buffer
set_keymap("n", "<leader>D", "<cmd>Telescope diagnostics<cr>", keymap_options)                                  -- Show all diagnostics
set_keymap("n", "<leader>e", "<cmd>Neotree position=current reveal=true<cr>", keymap_options)
set_keymap("n", "<leader>E", "<cmd>Neotree position=current<cr>", keymap_options)
vim.keymap.set("n", "<leader>f", function()
  local opts = {}
  vim.fn.system('git rev-parse --is-inside-work-tree')
  if vim.v.shell_error == 0 then
    require"telescope.builtin".git_files(opts)
  else
    require"telescope.builtin".find_files(opts)
  end
end)
set_keymap("n", "<leader>F", "<cmd>lua require('telescope.builtin').find_files()<cr>", keymap_options)          -- Fuzzy find among all files
set_keymap("n", "<leader>g", "<cmd>lua require('telescope.builtin').grep_string()<cr>", keymap_options)         -- Grep under cursor
set_keymap("n", "<leader>G", "<cmd>lua require('telescope.builtin').live_grep()<cr>", keymap_options)           -- Live grep
set_keymap("n", "<leader>q", "<cmd>lua require('telescope.builtin').quickfix()<cr>", keymap_options)            -- List of quick fixes
set_keymap("n", "<leader>s", "<cmd>Telescope lsp_document_symbols<cr>", keymap_options)
set_keymap("n", "<leader>S", "<cmd>Telescope lsp_workspace_symbols<cr>", keymap_options)
set_keymap("n", "<leader>1", "<cmd>lua vim.o.relativenumber = not vim.o.relativenumber<cr>", keymap_options)
-- COMMA
set_keymap("n", ",a", "<cmd>lua vim.lsp.buf.code_action()<cr>", keymap_options)
set_keymap("n", ",b", "<cmd>Git blame<CR>", keymap_options)
set_keymap("n", ",d", "<cmd>lua require('telescope.builtin').lsp_definitions({show_line=false})<CR>", keymap_options)
set_keymap("n", ",i", "<cmd>lua require('telescope.builtin').lsp_implementations({show_line=false})<CR>", keymap_options)
set_keymap("n", ",h", "<cmd>lua vim.lsp.buf.signature_help()<CR>", keymap_options)
set_keymap("n", ",H", "<cmd>lua vim.lsp.buf.hover()<CR>", keymap_options)
set_keymap("n", ",r", "<cmd>lua require('telescope.builtin').lsp_references({show_line=false})<CR>", keymap_options)
set_keymap("n", ",n", "<cmd>lua vim.lsp.buf.rename()<CR>", keymap_options)
set_keymap("n", ",w", "<cmd>w<CR>", keymap_options)
set_keymap("n", ",W", "<cmd>noautocmd w<CR>", keymap_options)
-- Terminal
-- Toggle to terminal from normal mode and back again. Hard coded for 4 active terminals
set_keymap("t", "<C-z>", "<cmd>lua require('toggleTerm').from_terminal()<cr>", keymap_options)
set_keymap("n", "<C-z>", "<cmd>lua require('toggleTerm').from_terminal()<cr>", keymap_options)
set_keymap("n", ",1", "<cmd>lua require('toggleTerm').to_terminal(1)<cr>", keymap_options)
set_keymap("n", ",2", "<cmd>lua require('toggleTerm').to_terminal(2)<cr>", keymap_options)
set_keymap("n", ",3", "<cmd>lua require('toggleTerm').to_terminal(3)<cr>", keymap_options)
set_keymap("n", ",4", "<cmd>lua require('toggleTerm').to_terminal(4)<cr>", keymap_options)
vim.keymap.set("t", '<C-l>', term_clear)
-- Window navigation
set_keymap("n", "<C-h>", "<C-w>h", keymap_options)
set_keymap("n", "<C-j>", "<C-w>j", keymap_options)
set_keymap("n", "<C-k>", "<C-w>k", keymap_options)
set_keymap("n", "<C-l>", "<C-w>l", keymap_options)

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

-- Vsnip
-- Jump forward or backward
vim.cmd[[imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>']]
vim.cmd[[smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>']]
vim.cmd[[imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>']]
vim.cmd[[smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>']]

-- Neo-tree
require('neo-tree').setup({
    window = {
        -- Disable a bunch of key mappings. Especially those related to
        -- fuzzy find. Prefer to use / for buffer like search and use
        -- telescope for fuzzy find instead.
        mappings = {
            ["/"] = "noop",
            ["D"] = "noop",
            ["#"] = "noop",
            ["<"] = "noop",
            [">"] = "noop",
            ["w"] = "noop",
            ["t"] = "noop",
            ["C"] = "noop",
            ["<left>"] = "close_node",
            ["<right>"] = "open",
        },
    },
    popup_border_style = "rounded",
    enable_git_status = false,
    default_component_configs = {
        indent = {
            indent_size = 4,
            with_markers = false,
        },
        symlink_target = {
            enabled = true,
        },
    },
    filesystem = {
        filtered_items = {
            visible = true,
        },
    },
    event_handlers = {
        {
            event = "neo_tree_buffer_enter",
            handler = function(arg)
                vim.cmd("setlocal relativenumber")
            end,
        },
    },
})