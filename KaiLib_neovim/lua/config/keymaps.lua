local km = vim.keymap

-- Keymaps for copying file name and path to clipboard
km.set("n", "<leader>cf", function()
        vim.fn.setreg('+', vim.fn.expand('%'))
        print('Copied file name to clipboard: ' .. vim.fn.expand('%'))
    end, { desc = "Copy relative path file to clipboard" })
km.set("n", "<leader>cF", function()
        vim.fn.setreg('+', vim.fn.expand('%:p'))
        print('Copied absolute path file to clipboard: ' .. vim.fn.expand('%:p'))
    end, { desc = "Copy absolute path file to clipboard" })
km.set("n", "<leader>cfn", function()
        vim.fn.setreg('+', vim.fn.expand('%:t'))
        print('Copied only file name to clipboard: ' .. vim.fn.expand('%:t'))
    end, { desc = "Copy only file name to clipboard" })
km.set("n", "<leader>cp", function()
        vim.fn.setreg('+', vim.fn.expand('%:h'))
        print('Copied relative path to clipboard: ' .. vim.fn.expand('%:h'))
    end, { desc = "Copy relative path to clipboard" })
km.set("n", "<leader>cP", function()
        vim.fn.setreg('+', vim.fn.expand('%:p:h'))
        print('Copied absolute path to clipboard: ' .. vim.fn.expand('%:p:h'))
    end, { desc = "Copy absolute path to clipboard" })

-- Keymaps for FzfLua
km.set("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "Fuzzy find files" })
km.set("n", "<leader>fg", "<cmd>FzfLua live_grep_native<CR>", { desc = "Fuzzy find text" })
km.set("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", { desc = "Fuzzy find buffers" })
km.set("n", "<leader>fh", "<cmd>FzfLua help_tags<CR>", { desc = "Fuzzy find help tags" })
km.set("n", "<leader>ft", "<cmd>FzfLua btags<CR>", { desc = "Fuzzy search buffer tags" })
km.set("n", "<leader>fk", "<cmd>FzfLua keymaps<CR>", { desc = "Fuzzy find keymaps" })
km.set("n", "<leader>fr", "<cmd>FzfLua buffers<CR>", { desc = "Fuzzy find recent files" })
km.set("n", "<leader>fgf", "<cmd>FzfLua git_files<CR>", { desc = "Fuzzy find git list files" })
km.set("n", "<leader>fgd", "<cmd>FzfLua git_diff<CR>", { desc = "Fuzzy find git diff {ref}" })
km.set("n", "<leader>fgc", "<cmd>FzfLua git_commits<CR>", { desc = "Fuzzy find git commit log of the project" })
km.set("n", "<leader>fgv", "<cmd>FzfLua git_bcommits<CR>", { desc = "Fuzzy find git commit log of the buffer" })
km.set("n", "<leader>fgb", "<cmd>FzfLua git_blame<CR>", { desc = "Fuzzy find git blame of the buffer" })
km.set("n", "<leader>fgs", "<cmd>FzfLua git_stash<CR>", { desc = "Fuzzy find git stash" })
km.set("n", "<leader>fgt", "<cmd>FzfLua git_tags<CR>", { desc = "Fuzzy find git tags" })
km.set("n", "<leader>fga", "<cmd>FzfLua git_branches<CR>", { desc = "Fuzzy find git branches" })

-- Keymaps for NERDTree
km.set("n", "<leader>ee", ":NERDTreeToggle<CR>", { noremap = true, silent = true, desc = "Toggle NvimTree" })
km.set("n", "<leader>ef", ":NERDTreeFind<CR>", { noremap = true, silent = true, desc = "Toggle NvimTree" })

-- Keymaps for maximize.nvim
km.set("n", "<leader>m", ":Maximize<CR>", { noremap = true, silent = true, desc = "Maximize current window" })

-- Keymaps for open nvim setting files
km.set('n', '<leader>nvim', ':tabnew $MYVIMRC<CR>', { noremap = true, silent = true })

-- Keymaps for .c/.cpp/.h/.hpp files
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "objc", "objcpp", "h", "hpp" },
    callback = function(args)
        vim.api.nvim_buf_set_keymap(args.buf, "n", "gH", "<cmd>ClangdSwitchSourceHeader<CR>", { noremap = true, silent = true })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition)
        vim.keymap.set("n", "gy", vim.lsp.buf.type_definition)
        vim.keymap.set("n", "gs", vim.lsp.buf.workspace_symbol)
    end,
})

-- Keymaps for undo tree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

---------------------------
--- NVIM System Keymaps ---
---------------------------
-- Keymaps for toggle line number and relative line number
vim.keymap.set('n', '<leader>nn', function()
    if vim.wo.number == true and vim.wo.relativenumber == true then
        vim.wo.relativenumber = false
    else
        vim.wo.relativenumber = true
    end
end, { desc = "Toggle line number and relative line number" })
