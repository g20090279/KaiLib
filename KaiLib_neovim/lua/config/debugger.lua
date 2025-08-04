require("dapui").setup()

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
    command = '/path/to/gdb',
    args = { "--interpreter=dap" }
}

dap.adapters.cppdbg = {
    type = 'executable',
    command = '/path/to/.vscode-server/extensions/ms-vscode.cpptools-1.26.3-linux-x64/debugAdapters/bin/OpenDebugAD7',
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

dap.configurations.cpp = {
    {
        name = 'Debug Program',
        type = 'cppdbg',
        request = 'launch',
        cwd = get_project_root(),
        program = '/path/to/your/debug/program',
        args = { "your-args" },
        setupCommands = {
            {
                description = "Enable pretty-printing for gdb",
                text = "-enable-pretty-printing",
                ignoreFailures = true,
            }
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
                description = "Enable pretty-printing for gdb",
                text = "-enable-pretty-printing",
                ignoreFailures = true,
            }
        },
        environment = {
            {
                name = "dsp_vec_env_name",
                value = "/pah/to/your/dsp/vector",
            }
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
require("dap-python").setup("python3")
require("dap-python").test_runner = "pytest"
