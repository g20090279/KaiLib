require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "pyright", "clangd", "texlab", "matlab_ls" }
})

local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, silent = true }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "gk", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gsh", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "gs", vim.lsp.buf.workspace_symbol, opts)

    if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, bufnr)
    end
end

local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")
local util = require("lspconfig.util")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local servers = { "lua_ls", "pyright", "clangd" }

for _, server in ipairs(servers) do
    lspconfig[server].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end

-- Setup Matlab LS
local matlab_ls_bin = vim.fn.stdpath("data") .. "/mason/packages/matlab-language-server/matlab-language-server"
local matlab_root = "/Applications/MATLAB_R2024b.app"

if not configs["matlab_ls"] then
    configs["matlab_ls"] = {
        default_config = {
            cmd = { matlab_ls_bin, "--stdio" },
            filetypes = { "matlab" },
        },
    }
end

lspconfig.matlab_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        MATLAB = {
            indexWorkspace = true,
            installPath = "/Applications/MATLAB_R2024b.app/",
            matlabConnectionTiming = "onStart",
            telemetry = false,
        },
    },
    single_file_support = true,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.m",
  command = "set filetype=matlab",
})
