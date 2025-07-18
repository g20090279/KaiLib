local cmp = require('cmp')
local luasnip = require("luasnip")

-- Extend markdown snippets with LaTeX snippets.
luasnip.filetype_extend("markdown", { "tex" })

-- Load snippets from friendly-snippets (if you have it installed).
require("luasnip.loaders.from_vscode").lazy_load()

-- Setup nvim-cmp.
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'luasnip' }, -- For luasnip users.
        { name = 'path' },
    },
})

-- Optional: super useful for seeing what snippets exist
luasnip.config.set_config({
    history = true,
    updateevents = "TextChanged,TextChangedI",
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
            {
                name = 'cmdline',
                option = {
                    ignore_cmds = { 'Man', '!' } -- Disable for these commands
                }
            }
        }),
    matching = { disallow_symbol_nonprefix_matching = false }
})
