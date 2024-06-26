local client_id = vim.lsp.start({
    name = 'gopls',
    cmd = { 'gopls', '-remote=auto', '-logfile=auto' },
    root_dir = vim.fs.root(0, {'.git', 'go.mod'}),
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
