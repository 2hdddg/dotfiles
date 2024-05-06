if vim.g.goplsSetup == 1 then
    return
end
local on_attach = function(client, bufnr)
    vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
end
local lspconfig = require'lspconfig'
local capabilities = require('cmp_nvim_lsp').default_capabilities()
lspconfig.gopls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        gopls = {
            analyses = {
                unusedparam = true,
            },
            staticcheck = true,
            semanticTokens = true,
        },
    },
}
vim.g.goplsSetup = 1
