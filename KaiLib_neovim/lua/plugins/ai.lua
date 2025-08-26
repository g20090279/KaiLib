return {
    -- ### Copilot Settings ###
    { "github/copilot.vim" },

    -- ### Gemini Settings ###
    -- Uncomment the lines below to enable Gemini support.
    -- Note: Ensure you have the necessary setup for Gemini.
    --{
    --    'kiddos/gemini.nvim',
    --    dependencies = { 'nvim-lua/plenary.nvim' },
    --    opts = {},
    --},

    -- ### avante.nvim Settings ###
    {
        "yetone/avante.nvim",
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        -- ⚠️ must add this setting! ! !
        build = vim.fn.has("win32") ~= 0
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or "make",
        event = "VeryLazy",
        version = false, -- Never set this value to "*"! Never!
        opts = {
            provider = "gemini",
            providers = {
                gemini = {
                    endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
                    model = "gemini-2.0-flash",
                    timeout = 3000,  -- timeout in milliseconds
                    temperature = 0,
                    max_tokens = 4096,
                },
            },
            hints = {
                enabled = true,
                debounce = 300,  --delay between keystrokes and suggestion call
            },
        },
        dependencies = {
            -- "nvim-lua/plenary.nvim",
            -- "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            -- "echasnovski/mini.pick", -- for file_selector provider mini.pick
            -- "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
            -- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
            -- "ibhagwan/fzf-lua", -- for file_selector provider fzf
            -- "stevearc/dressing.nvim", -- for input provider dressing
            -- "folke/snacks.nvim", -- for input provider snacks
            -- "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            -- "zbirenbaum/copilot.lua", -- for providers='copilot'
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
            {
                -- Make sure to set this up properly if you have lazy=true
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    },

}
