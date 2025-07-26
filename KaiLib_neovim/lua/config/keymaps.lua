local km = vim.keymap

-----------------------------------------------------------
--  Keymaps for copying file name and path to clipboard  --
-----------------------------------------------------------
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

--------------------------
--  Keymaps for FzfLua  --
--------------------------
km.set("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "Fuzzy find files" })
km.set("n", "<leader>fg", "<cmd>FzfLua live_grep_native<CR>", { desc = "Fuzzy find text" })
km.set("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", { desc = "Fuzzy find buffers" })
km.set("n", "<leader>fk", "<cmd>FzfLua keymaps<CR>", { desc = "Fuzzy find keymaps" })
km.set("n", "<leader>fls", "<cmd>FzfLua lsp_document_symbols<CR>", { desc = "Fuzzy find document symbols from LSP" })
km.set("n", "<leader>flS", "<cmd>FzfLua lsp_workspace_symbols<CR>", { desc = "Fuzzy find worksapce symbols from LSP" })
km.set("n", "<leader>fli", "<cmd>FzfLua lsp_implementations<CR>", { desc = "Fuzzy find implementations from LSP" })
km.set("n", "<leader>flr", "<cmd>FzfLua lsp_references<CR>", { desc = "Fuzzy find references from LSP" })
km.set("n", "<leader>fgf", "<cmd>FzfLua git_files<CR>", { desc = "Fuzzy find git list files" })
km.set("n", "<leader>fgd", "<cmd>FzfLua git_diff<CR>", { desc = "Fuzzy find git diff {ref}" })
km.set("n", "<leader>fgc", "<cmd>FzfLua git_commits<CR>", { desc = "Fuzzy find git commit log of the project" })
km.set("n", "<leader>fgv", "<cmd>FzfLua git_bcommits<CR>", { desc = "Fuzzy find git commit log of the buffer" })
km.set("n", "<leader>fgb", "<cmd>FzfLua git_blame<CR>", { desc = "Fuzzy find git blame of the buffer" })
km.set("n", "<leader>fgs", "<cmd>FzfLua git_stash<CR>", { desc = "Fuzzy find git stash" })
km.set("n", "<leader>fgt", "<cmd>FzfLua git_tags<CR>", { desc = "Fuzzy find git tags" })
km.set("n", "<leader>fga", "<cmd>FzfLua git_branches<CR>", { desc = "Fuzzy find git branches" })

----------------------------
--  Keymaps for NERDTree  --
----------------------------
km.set("n", "<leader>ee", ":NERDTreeToggle<CR>", { noremap = true, silent = true, desc = "Toggle NvimTree" })
km.set("n", "<leader>ef", ":NERDTreeFind<CR>", { noremap = true, silent = true, desc = "Toggle NvimTree" })

-----------------------------------------
--  Keymaps for .c/.cpp/.h/.hpp files  --
-----------------------------------------
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "objc", "objcpp", "h", "hpp" },
    callback = function(args)
        vim.api.nvim_buf_set_keymap(args.buf, "n", "gH", "<cmd>ClangdSwitchSourceHeader<CR>", { noremap = true, silent = true })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition)
        vim.keymap.set("n", "gy", vim.lsp.buf.type_definition)
        vim.keymap.set("n", "gs", vim.lsp.buf.workspace_symbol)
    end,
})

-----------------------------
--  Keymaps for undo tree  --
-----------------------------
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

---------------------------
--  NVIM System Keymaps  --
---------------------------
--  Keymaps for open nvim setting files
km.set('n', '<leader>nvim', ':tabnew $MYVIMRC<CR>', { noremap = true, silent = true })

-- Keymaps for toggle line number and relative line number
vim.keymap.set('n', '<leader>nn', function()
    if vim.wo.number == true and vim.wo.relativenumber == true then
        vim.wo.relativenumber = false
    else
        vim.wo.relativenumber = true
    end
end, { desc = "Toggle line number and relative line number" })

------------------------------------------------
--  Keymaps for DAP (Debug Adapter Protocol)  --
------------------------------------------------
-- Continue debugging (F5)
km.set('n', '<F5>', function() require('dap').continue() end, { noremap = true, silent = true })
-- Pause debugging (F6)
km.set('n', '<F6>', function() require('dap').pause() end, { noremap = true, silent = true })
-- Step into (F7)
km.set('n', '<F11>', function() require('dap').step_into() end, { noremap = true, silent = true })
-- Step over (F8)
km.set('n', '<F10>', function() require('dap').step_over() end, { noremap = true, silent = true })
-- Step out (F9)
km.set('n', '<F9>', function() require('dap').step_out() end, { noremap = true, silent = true })
-- Toggle breakpoint (F10)
km.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end, { noremap = true, silent = true })
-- Toggle conditional breakpoint (Leader + b)
km.set('n', '<Leader>B', function() require('dap').set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { noremap = true, silent = true })
-- Run to cursor (Leader + rc)
km.set('n', '<F7>', function() require('dap').run_to_cursor() end, { noremap = true, silent = true })
-- Terminate debugging
km.set('n', '<Leader>de', function() require('dap').terminate() end, { noremap = true, silent = true })
-- Open DAP REPL
km.set('n', '<Leader>dp', function() require('dap').repl.open() end, { noremap = true, silent = true })
-- Open DAP UI
km.set('n', '<Leader>du', function() require('dapui').toggle() end, { noremap = true, silent = true })


