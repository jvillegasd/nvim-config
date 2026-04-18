return {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local ctp_theme = require("catppuccin.special.bufferline").get_theme()
        ---@diagnostic disable-next-line: different-requires
        require("bufferline").setup({
            options = {
                mode = "buffers",
                diagnostics = "nvim_lsp",
                show_buffer_close_icons = false,
                show_close_icon = false,
                always_show_bufferline = true,
                offsets = {
                    {
                        filetype = "snacks_layout_box",
                        text = "Explorer",
                        text_align = "left",
                        separator = true,
                    },
                },
            },
            highlights = ctp_theme,
        })
    end,
}
