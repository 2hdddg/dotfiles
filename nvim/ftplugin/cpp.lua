if vim.g.clangdSetup == 1 then
    return
end
local clangd = require('lspconfig').clangd
local on_attach = function(client, bufnr)
    -- Map Clangd specific command to toggle between h/cpp
    local bufopts =  {noremap=true, silent=true, buffer=bufnr}
    vim.keymap.set('n', ',q', function()
        vim.cmd('ClangdSwitchSourceHeader')
    end, bufopts)
    vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
end

require('lspconfig').clangd.setup{
    on_attach = on_attach,
    -- Clangd specific settings
    cmd = { "clangd", "--all-scopes-completion", "--offset-encoding=utf-16", "--background-index", "--clang-tidy", "--header-insertion=iwyu", "--header-insertion-decorators", "--completion-style=detailed", "--pretty" },
}
require("clangd_extensions").setup({})
vim.cmd('packadd termdebug')
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.g.clangdSetup = 1
