return {
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = "markdown",
        run = 'cd app && npm install',  -- Make sure to install dependencies
        ft = { "markdown" },
    },
    {
        "dhruvasagar/vim-table-mode",
        ft = { "rst", "markdown", "text" },
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {},
    },
    {
        "bullets-vim/bullets.vim",
        config = function()
            vim.g.bullets_enabled_file_types = { "markdown", "text", "gitcommit", "scratch" }
        end,
    },
    { "tpope/vim-surround", },
    { "mbbill/undotree", },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        --build = "make install_jsregexp"
    }
}
