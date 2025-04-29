return {
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },  -- optional for icon support
        config = function()
            require("fzf-lua").setup({
                defaults = {
                    git_icons = false,
                    file_icons = false,
                    color_icons = false,
                },
            })
        end,
    }
}
