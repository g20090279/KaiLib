return {
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
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
    },
    {
        "lervag/vimtex",
        lazy = false,     -- we don't want to lazy load VimTeX
        init = function()
            local sysname = vim.loop.os_uname().sysname
            if sysname == "Darwin" then  -- macOS
                vim.g.vimtex_view_method = "skim"
            elseif sysname == "Linux" then  -- Linux
                vim.g.vimtex_view_method = "zathura"
            elseif sysname == "Windows_NT" then  -- Windows
                vim.g.vimtex_view_method = "SumatraPDF"
            else  -- Fallback or unsupported OS
                vim.g.vimtex_view_method = ""
            end
        end
    },
    -- {
    --     "3rd/image.nvim",
    --     build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    --     opts = {
    --         backend = "ueberzug",  -- Switch to 'ueberzug backend'
    --         processor = "magick_cli",
    --     }
    -- },
}
