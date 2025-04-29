return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", },
        config = function()
            require('lualine').setup({
                options = {
                    theme = 'auto',
                    component_separators = '|',
                    section_separators = '',
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = {
                        { 'filename', path = 1 }, -- 0 = just name, 1 = relative path, 2 = full path
                        { 
                            'navic', 
                            cond = function()
                                return package.loaded['nvim-navic'] and require('nvim-navic').is_available()
                            end
                        },
                    },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' },
                },
            })
        end
    },
    {
        "SmiteshP/nvim-navic",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            require('nvim-navic').setup({
                highlight = true,
                separator = " > ",
                depth_limit = 5,
            })
        end
    }
}
