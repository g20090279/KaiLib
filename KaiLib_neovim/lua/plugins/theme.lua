return {
    { "junegunn/seoul256.vim" },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = 'master',
        lazy = false,
    },
    -- {
    --     "folke/snacks.nvim",
    --     priority = 1000,
    --     lazy = false,
    --     ---@type snacks.Config
    --     opts = {
    --         -- your configuration comes here
    --         -- or leave it empty to use the default settings
    --         -- refer to the configuration section below
    --         bigfile = { enabled = true },
    --         explorer = { enabled = true },
    --         indent = { enabled = true },
    --         input = { enabled = true },
    --         picker = { enabled = true },
    --         notifier = { enabled = true },
    --         quickfile = { enabled = true },
    --         scope = { enabled = true },
    --         scroll = { enabled = true },
    --         statuscolumn = { enabled = true },
    --         words = { enabled = true },
    --     },
    -- },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
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
    }
}
