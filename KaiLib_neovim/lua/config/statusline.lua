local function maximize_status()
    return vim.t.maximized and  '   ' or ''
end

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
            { maximize_status },
            { 'filename', path = 1 }, -- 0 = just name, 1 = relative path, 2 = full path
        },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
    },
})

vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
