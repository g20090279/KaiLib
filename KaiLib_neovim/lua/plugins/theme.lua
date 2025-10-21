return {
    { "junegunn/seoul256.vim" },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = 'master',
        lazy = false,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
    },
    { "MunifTanjim/nui.nvim" },
    { "mhinz/vim-startify" },
    {
        "karb94/neoscroll.nvim",
        opts = {},
    },
    { "rcarriga/nvim-notify" },
    { "RRethy/vim-illuminate" },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        }
    },
    {
        -- amongst your other plugins
        {'akinsho/toggleterm.nvim', version = "*", config = true}
    },
    { "m4xshen/hardtime.nvim" },
}
