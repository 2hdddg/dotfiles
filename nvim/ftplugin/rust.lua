local caps = vim.lsp.protocol.make_client_capabilities()
-- mini.completion does not support this
caps.textDocument.completion.completionItem.snippetSupport = false
local client_id = vim.lsp.start({
    name = 'rust-analyzer',
    cmd = { 'rust-analyzer' },
    capabilities = caps,
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
              allFeatures = true,
              autoReload = true,
              loadOutDirsFromCheck = true,
            },
            procMacro = {
                enable = true,
            },
            assist = {
                importGranularity = "module",
                importPrefix = "by_self",
                importGroup = false,
            },
            completion = {
                addCallArgumentSnippets = true,
                addCallParenthesis = true,
                enableExperimental = true,
                autoimport = { enable = true },
                postfix = { enable = false },
            },
            lens = {
                enable = true,
            },
            workspace = {
                symbol = {
                  search = {
                    kind = "all_symbols",
                  },
                },
            },
        },
    },
})
vim.lsp.buf_attach_client(0, client_id)
vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
