return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
        local p = require("catppuccin.palettes").get_palette("mocha")
        local bar_bg = p.base
        local muted = p.overlay1

        local base_mode = {
            b = { fg = muted, bg = bar_bg },
            c = { fg = p.text, bg = bar_bg },
            x = { fg = muted, bg = bar_bg },
            y = { fg = muted, bg = bar_bg },
            z = { fg = muted, bg = bar_bg },
        }
        local function mode_section(accent)
            return vim.tbl_extend("force", base_mode, {
                a = { fg = accent, bg = bar_bg, gui = "bold" },
            })
        end

        local theme = {
            normal = mode_section(p.mauve),
            insert = mode_section(p.green),
            visual = mode_section(p.peach),
            replace = mode_section(p.red),
            command = mode_section(p.sky),
            inactive = {
                a = { fg = muted, bg = bar_bg },
                b = { fg = muted, bg = bar_bg },
                c = { fg = muted, bg = bar_bg },
                x = { fg = muted, bg = bar_bg },
                y = { fg = muted, bg = bar_bg },
                z = { fg = muted, bg = bar_bg },
            },
        }

        local function cwd()
            return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        end

        local function lsp_names()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then return "" end
            local names = {}
            for _, c in ipairs(clients) do table.insert(names, c.name) end
            return table.concat(names, ", ")
        end

        return {
            options = {
                theme = theme,
                icons_enabled = true,
                component_separators = "",
                section_separators = "",
                globalstatus = true,
                disabled_filetypes = {
                    statusline = { "neo-tree", "dapui_scopes", "dapui_breakpoints",
                        "dapui_stacks", "dapui_watches", "dap-repl" },
                },
            },
            sections = {
                lualine_a = { { "mode", icon = "" } },
                lualine_b = {
                    { "progress", color = { fg = muted } },
                    { "location", color = { fg = muted } },
                },
                lualine_c = {
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic" },
                        symbols = { error = "● ", warn = "● ", info = "● ", hint = "● " },
                        colored = true,
                    },
                },
                lualine_x = {
                    {
                        lsp_names,
                        icon = { "", color = { fg = muted } },
                        color = { fg = muted },
                    },
                },
                lualine_y = {
                    { "filename", path = 0, color = { fg = p.text } },
                },
                lualine_z = {
                    { cwd, icon = { "", color = { fg = muted } }, color = { fg = muted } },
                },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { { "filename", path = 1, color = { fg = muted } } },
                lualine_x = { { "location", color = { fg = muted } } },
                lualine_y = {},
                lualine_z = {},
            },
        }
    end,
}
