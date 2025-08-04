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
        },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
    },
})
