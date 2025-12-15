local caps = vim.lsp.protocol.make_client_capabilities()
-- Annoying
caps.textDocument.completion.completionItem.snippetSupport = false
local client_id = vim.lsp.start({
    name = 'rust-analyzer',
    cmd = { 'rust-analyzer' },
    capabilities = caps,
})
vim.lsp.buf_attach_client(0, client_id)
vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
