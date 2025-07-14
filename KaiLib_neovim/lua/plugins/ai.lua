return {
    -- Copilot
    { "github/copilot.vim" },

    -- Gemini
    -- Uncomment the lines below to enable Gemini support.
    -- Note: Ensure you have the necessary setup for Gemini.
    -- {
    --   'kiddos/gemini.nvim',
    --   dependencies = { 'nvim-lua/plenary.nvim' },
    --   opts = {},
    --  },

    {
      "olimorris/codecompanion.nvim",
      opts = {},
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
    },
}
