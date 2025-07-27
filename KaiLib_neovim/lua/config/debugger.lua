local dap = require('dap')

-- Configure dap for C/C++/Rust
dap.adapters.gdb = {
    type = 'executable',
    command = 'gdb', -- Path to gdb (or lldb on macOS)
    args = { "--interpreter=dap" }
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

dap.configurations.cpp = {
    {
        name = 'Debug NRSim',
        type = 'gdb',
        request = 'launch',
        cwd = '${workspaceFolder}',
        args = { "-x", "~/opt/runNrsim/lauch_debug.gdb" },
    },
    {
        name = 'Launch GDB',
        type = 'gdb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = "${workspaceFolder}",
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
require("dap-python").setup("python3")
require("dap-python").test_runner = "pytest"
