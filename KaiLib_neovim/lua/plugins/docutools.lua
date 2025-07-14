return {
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = "markdown",
        run = 'cd app && npm install',  -- Make sure to install dependencies
        config = function()
        end
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = { "markdown", "codecompanion" }
    },
    {
        "bullets-vim/bullets.vim",
        config = function()
            vim.g.bullets_enabled_file_types = { "markdown", "text", "gitcommit", "scratch" }
        end,
    },
    {
        "tpope/vim-surround",
    }
}
