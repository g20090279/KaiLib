return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", },
    },
    {
        "SmiteshP/nvim-navic",
        dependencies = { "neovim/nvim-lspconfig" },
        -- config = function()
        --     require('nvim-navic').setup({
        --         highlight = true,
        --         separator = " > ",
        --         depth_limit = 5,
        --     })
        -- end
    }
}
