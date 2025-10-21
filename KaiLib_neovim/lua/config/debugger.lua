local home = os.getenv("HOME") or os.getenv("USERPROFILE")
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"

require("dapui").setup({
    layouts = {
        {
            elements = {
                { id = "scopes", size = 1},
            },
            size = 40,  -- width of Left panel
            position = "left",
        },
        {
            elements = {
                { id = "repl", size = 1 },
                -- { id = "console", size = 0.5 },
            },
            size = 10,   -- hight of bottome panel
            position = "bottom"
        },
    },
})

-- Make REPL nice to read
vim.api.nvim_create_autocmd("FileType", {
    pattern = "dap-repl",
    callback = function()
        vim.opt_local.wrap = true   -- wrap long lines
        vim.opt_local.linebreak = true    -- wrap at word boundaries
        vim.opt_local.breakindent = true  -- indent wrapped lines
        vim.opt_local.scrollback = 10000  -- large scrollback
    end,
})

local dap = require('dap')

local function get_project_root()
    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
    if git_root and vim.fn.isdirectory(git_root) == 1 then
        return git_root
    else
        return vim.fn.expand("%:p:h")  -- directory of current file
    end
end

-- Configure dap for C/C++/Rust
dap.adapters.gdb = {
    type = 'executable',
    command = home .. '/.local/gdb/bin/gdb',
    args = { "--interpreter=dap" }
}

dap.adapters.cppdbg = {
    type = 'executable',
    command = home .. '/.vscode-server/extensions/ms-vscode.cpptools-1.26.3-linux-x64/debugAdapters/bin/OpenDebugAD7',
    id = 'cppdbg',
}

dap.adapters.executable = {
    type = 'executable',
    command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
    name = 'lldb1',
    host = '127.0.0.1',
    port = 13000,
}

dap.adapters.codelldb = {
    name = 'codelldb server',
    type = 'server',
    port = "${port}",
    executable = {
        command = 'codelldb',
        args = { "--port", "${port}" },
        env = {
            RUST_LOG = "debug",
        },
    },
}

local datetime = os.date('%Y%m%d%H%M%S')
local logfile = "gdb.log." .. datetime .. ".txt"

dap.configurations.cpp = {
    {
        name = 'Debug NRSim',
        type = 'cppdbg',
        request = 'launch',
        cwd = get_project_root(),
        program = 'nrs_dbg',
        args = { "config_file" },
        exterminalConsole = true,  -- suppress the warning gdb failed to set controlling terminal
        setupCommands = {
            {
                description = 'Enable pretty-printing for gdb',
                text = '-enable-pretty-printing',
                ignoreFailures = true,
            },
            {
                description = 'Load local .gdbinit',
                text = 'source ' .. home .. '/.gdbinit',
                ignoreFailures = true
            },
            {
                description = 'Set GDB log file',
                text = '-gdb-set logging file ' .. logfile,
                ignoreFailures = true
            },
            {
                description = 'Overwrite log file',
                text = 'set logging overwrite on',
                ignoreFailures = true
            },
            {
                description = 'Disable pagination',
                text = 'set pagination off',
                ignoreFailures = true
            },
            {
                description = 'Show all array elements',
                text = 'set print elements 0',
                ignoreFailures = true
            },
            {
                description = 'Trace commands',
                text = 'set trace-commands on',
                ignoreFailures = true
            },
            {
                description = 'Print current working directory',
                text = 'pwd',
                ignoreFailures = true
            },
            -- {
            --     description = 'Load Additional Setting',
            --     text = 'source ' .. home .. '/path/to/pyprint_mrc_normHSqr.py',
            --     ignoreFailures = true
            -- },
        },
    },
    {
        name = 'Debug fw-top',
        type = 'cppdbg',
        request = 'launch',
        cwd = get_project_root(),
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        setupCommands = {
            {
                description = 'Enable pretty-printing for gdb',
                text = '-enable-pretty-printing',
                ignoreFailures = true,
            }
        },
        environment = {
            {
                name = 'DSP_TEST_VECTOR_DIR',
                value = home .. '/workspace/t-v-s',
            }
        },
    },
    {
        name = 'Debug asip',
        type = 'cppdbg',
        request = 'launch',
        cwd = get_project_root(),
        -- program = function()
        --     return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        -- end,
        program = "/path/to/asip-bin",
        setupCommands = {
            {
                description = 'Enable pretty-printing for gdb',
                text = '-enable-pretty-printing',
                ignoreFailures = true,
            },
            {
                description = 'Add VBit Pretty Printer',
                text = "source ${env:HOME}/opt/ASIP-Pretty-Printer/trv32p5x_chess_pretty_printing.py",
                ignoreFailures = true
            },
            {
                description = 'Load local .gdbinit',
                text = 'source ${env:HOME}/.gdbinit',
                ignoreFailures = true
            },
            {
                description = 'Set GDB log file',
                text = '-gdb-set logging file ' .. logfile,
                ignoreFailures = true
            },
            {
                description = 'Overwrite log file',
                text = 'set logging overwrite on',
                ignoreFailures = true
            },
            {
                description = 'Disable pagination',
                text = 'set pagination off',
                ignoreFailures = true
            },
            {
                description = 'Show all array elements',
                text = 'set print elements 0',
                ignoreFailures = true
            },
            {
                description = 'Trace commands',
                text = 'set trace-commands on',
                ignoreFailures = true
            },
        },
    },
    {
        name = 'Launch GDB',
        type = 'gdb',
        request = 'launch',
        cwd = get_project_root(),
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        stopAtBeginningOfMainSubprogram = false,
    },
    {
        name = 'Launch LLDB',
        type = 'codelldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = "${workspaceFolder}",
        stopAtBeginningOfMainSubprogram = false,
    }
}

-- Configure dap for Python
require("dap-python").setup("~/.virtualenvs/debugpy/bin/python", {
    rocks = {
        enabled = true,
    }
}) -- path to python with debugpy
---
-- mkdir ~/.virtualenvs
-- cd ~/.virtualenvs
-- python3 -m venv debugpy
-- debugpy/bin/python -m pip install debugpy
---

require('dap').configurations.python = {
    {
        name = 'Launch debugpy',
        type = 'python',
        request = 'launch',
        cwd = get_project_root(),
        program = '${file}',
        console = 'integratedTerminal',  -- or 'externalTerminal' if needed
        pythonPath = function()
            return '~/.virtualenvs/debugpy/bin/python'
        end,
    },
    {
        name = 'Debug Autorun',
        type = 'python',
        request = 'launch',
        cwd = get_project_root(),
        program = '${file}',
        args = { '-r', '-b' },  -- ← Your script's arguments
        console = 'integratedTerminal',  -- or 'externalTerminal' if needed
        pythonPath = function()
            return '~/.virtualenvs/debugpy/bin/python'  -- ← Your venv path
        end,
    },
}
