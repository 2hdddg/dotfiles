local caps = vim.lsp.protocol.make_client_capabilities()
-- mini.completion does not support this
caps.textDocument.completion.completionItem.snippetSupport = false
local client_id = vim.lsp.start({
    name = 'gopls',
    cmd = { 'gopls', '-remote=auto', '-logfile=auto' },
    root_dir = vim.fs.root(0, {'.git', 'go.mod'}),
    capabilities = caps,
    settings = {
        gopls = {
            analyses = {
                unusedparam = true,
            },
            staticcheck = true,
            semanticTokens = true,
        },
    },
})
vim.lsp.buf_attach_client(0, client_id)
-- Auto format on write
vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
