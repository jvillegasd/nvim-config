return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
        local p = require("catppuccin.palettes").get_palette("mocha")
        local bar_bg = p.mantle
        local section_bg = p.surface0

        local theme = {
            normal = {
                a = { fg = p.base, bg = p.green, gui = "bold" },
                b = { fg = p.text, bg = section_bg },
                c = { fg = p.text, bg = bar_bg },
            },
            insert = {
                a = { fg = p.base, bg = p.mauve, gui = "bold" },
                b = { fg = p.text, bg = section_bg },
                c = { fg = p.text, bg = bar_bg },
            },
            visual = {
                a = { fg = p.base, bg = p.peach, gui = "bold" },
                b = { fg = p.text, bg = section_bg },
                c = { fg = p.text, bg = bar_bg },
            },
            replace = {
                a = { fg = p.base, bg = p.red, gui = "bold" },
                b = { fg = p.text, bg = section_bg },
                c = { fg = p.text, bg = bar_bg },
            },
            command = {
                a = { fg = p.base, bg = p.yellow, gui = "bold" },
                b = { fg = p.text, bg = section_bg },
                c = { fg = p.text, bg = bar_bg },
            },
            inactive = {
                a = { fg = p.overlay1, bg = bar_bg, gui = "bold" },
                b = { fg = p.overlay1, bg = bar_bg },
                c = { fg = p.overlay1, bg = bar_bg },
            },
        }

        return {
            options = {
                theme = theme,
                icons_enabled = true,
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                globalstatus = true,
                disabled_filetypes = {
                    statusline = { "neo-tree", "dapui_scopes", "dapui_breakpoints",
                        "dapui_stacks", "dapui_watches", "dap-repl" },
                },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    { "branch", icon = "", color = { fg = p.green } },
                    { "diff", colored = true },
                    { "diagnostics", colored = true },
                },
                lualine_c = { { "filename", path = 1 } },
                lualine_x = {
                    {
                        function()
                            local clients = vim.lsp.get_clients({ bufnr = 0 })
                            if #clients == 0 then return "" end
                            local names = {}
                            for _, c in ipairs(clients) do table.insert(names, c.name) end
                            return " " .. table.concat(names, ", ")
                        end,
                        color = { fg = p.sky },
                    },
                    { "encoding", color = { fg = p.subtext1 } },
                    { "filetype", color = { fg = p.teal } },
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
        }
    end,
}
