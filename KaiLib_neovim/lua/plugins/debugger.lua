return {
    -- DAP (Debug Adapter Protocol) for debugging
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "rcarriga/nvim-dap-ui",
        },
    },

    -- DAP UI for better visualization
    { "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} },

    -- DAP for Python
    {
        "mfussenegger/nvim-dap-python",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
    },
}
