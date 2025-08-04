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
km.set("n", "<leader>fdf", "<cmd>FzfLua dap_frames<CR>", { desc = "Fuzzy find frames in DAP" })
km.set("n", "<leader>fdv", "<cmd>FzfLua dap_variables<CR>", { desc = "Fuzzy find variables in DAP" })
km.set("n", "<leader>fdb", "<cmd>FzfLua dap_breakpoints<CR>", { desc = "Fuzzy find breakpoints in DAP" })
km.set("n", "<leader>fdc", "<cmd>FzfLua dap_commands<CR>", { desc = "Fuzzy find commands in DAP" })

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
        km.set("n", "gd", vim.lsp.buf.definition)
        km.set("n", "gy", vim.lsp.buf.type_definition)
        km.set("n", "gs", vim.lsp.buf.workspace_symbol)
    end,
})

-----------------------------
--  Keymaps for undo tree  --
-----------------------------
km.set('n', '<leader>u', vim.cmd.UndotreeToggle)

---------------------------
--  NVIM System Keymaps  --
---------------------------
--  Keymaps for open nvim setting files
km.set('n', '<leader>nvim', ':tabnew $MYVIMRC<CR>', { noremap = true, silent = true })

-- Keymaps for toggle line number and relative line number
km.set('n', '<leader>nn', function()
    if vim.wo.number == true and vim.wo.relativenumber == true then
        vim.wo.relativenumber = false
    else
        vim.wo.relativenumber = true
    end
end, { desc = "Toggle line number and relative line number" })

------------------------------------------------
--  Keymaps for DAP (Debug Adapter Protocol)  --
------------------------------------------------
local dap = require('dap')
local dapui = require("dapui")

--dap.listeners.before.attach.dapui_config = function()
--  dapui.open()
--end
--dap.listeners.before.launch.dapui_config = function()
--  dapui.open()
--end
--dap.listeners.before.event_terminated.dapui_config = function()
--  dapui.close()
--end
--dap.listeners.before.event_exited.dapui_config = function()
--  dapui.close()
--end

local function set_dap_keymaps()
  km.set('n', '<Down>', dap.step_over, { silent = true, desc = 'DAP Step Over' })
  km.set('n', '<Right>', dap.step_into, { silent = true, desc = 'DAP Step Into' })
  km.set('n', '<Left>', dap.step_out, { silent = true, desc = 'DAP Step Out' })
  km.set('n', '<Up>', dap.restart_frame, { silent = true, desc = 'DAP Restart Frame' })
end

-- Remove keymaps when debug session ends
local function clear_dap_keymaps()
  km.del('n', '<Down>')
  km.del('n', '<Right>')
  km.del('n', '<Left>')
  km.del('n', '<Up>')
end

-- Set up listeners to set/clear keymaps during DAP sessions
dap.listeners.after.event_initialized["dap_keymaps"] = function()
  set_dap_keymaps()
end

dap.listeners.before.event_terminated["dap_keymaps"] = function()
  clear_dap_keymaps()
end

dap.listeners.before.event_exited["dap_keymaps"] = function()
  clear_dap_keymaps()
end

km.set('n', '<Leader>b', function() dap.toggle_breakpoint() end, { noremap = true, silent = true })
km.set('n', '<Leader>B', function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { noremap = true, silent = true })
km.set('n', '<Leader>dr', function() dap.continue() end, { desc = "Continue debugging", noremap = true, silent = true })
km.set('n', '<Leader>dt', function() dap.run_to_cursor() end, { desc="Run to cursor", noremap = true, silent = true })
km.set('n', '<Leader>de', function() dap.terminate() end, { noremap = true, silent = true })
km.set('n', '<Leader>dp', function() dap.repl.open() end, { noremap = true, silent = true })
km.set('n', '<Leader>du', function() dapui.toggle() end, { noremap = true, silent = true, desc = "Open DAP View" })
km.set('n', '<leader>d1', function() require("dapui").float_element("repl", { enter = true }) end)
km.set('n', '<leader>d2', function() require("dapui").float_element("scopes", { enter = true }) end)
km.set('n', '<leader>d3', function() require("dapui").float_element("stacks", { enter = true }) end)
km.set('n', '<leader>d4', function() require("dapui").float_element("console", { enter = true }) end)
km.set('n', '<leader>d5', function() require("dapui").float_element("breakpoints", { enter = true }) end)
km.set('n', '<leader>d6', function() require("dapui").float_element("watches", { enter = true }) end)


km.set("n", "<leader>ncd", function()
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  local target_dir

  if git_root and vim.fn.isdirectory(git_root) == 1 then
    target_dir = git_root
  else
    target_dir = vim.fn.expand("%:p:h")
  end

  vim.cmd("cd " .. target_dir)
  print("Working directory changed to: " .. target_dir)
end, { desc = "Change cwd to Git root or current file directory" })
