local caps = vim.lsp.protocol.make_client_capabilities()
-- mini.completion does not support this
caps.textDocument.completion.completionItem.snippetSupport = false
local client_id = vim.lsp.start({
    name = 'clangd',
    --cmd = { "clangd", "--query-driver=/home/peterw/bin/aarch64-poky-linux-g++", "--all-scopes-completion", "--offset-encoding=utf-16", "--background-index", "--clang-tidy", "--header-insertion=iwyu", "--header-insertion-decorators", "--completion-style=detailed", "--pretty" },
    cmd = { "clangd", "--all-scopes-completion", "--offset-encoding=utf-16", "--background-index", "--clang-tidy", "--header-insertion=iwyu", "--header-insertion-decorators", "--completion-style=detailed", "--pretty" },
    root_dir = vim.fs.root(0, {'.git'}),
    capabilities = caps,
    settings = {},
})
-- Map Clangd specific command to toggle between h/cpp
local bufopts =  {noremap=true, silent=true, buffer=0}
vim.keymap.set('n', ',q', function()
    vim.lsp.buf_request(
        0,
        "textDocument/switchSourceHeader",
        { uri = vim.uri_from_bufnr(0) },
        function(err, uri)
            if err or not uri or uri == "" then return end
            vim.api.nvim_cmd({cmd = "e", args = { vim.uri_to_fname(uri)}}, {})
        end
    )
end, bufopts)
vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
