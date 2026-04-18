vim.g.mapleader = " "

local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { silent = true, noremap = true, desc = desc })
end

local function telescope(name)
    return function() require("telescope.builtin")[name]() end
end

local function dap_call(fn)
    return function() require("dap")[fn]() end
end


-- Core
map("n", "<leader>w", "<CMD>update<CR>", "Save file")
map("n", "<leader>q", "<CMD>q<CR>", "Quit window")


-- Splits — <leader>s*
map("n", "<leader>sv", "<CMD>vsplit<CR>", "Split: vertical")
map("n", "<leader>sh", "<CMD>split<CR>", "Split: horizontal")
map("n", "<leader>sc", "<CMD>close<CR>", "Split: close window")
map("n", "<leader>so", "<CMD>only<CR>", "Split: close others")


-- Window navigation & resize
map("n", "<C-h>", "<C-w>h", "Window: move left")
map("n", "<C-l>", "<C-w>l", "Window: move right")
map("n", "<C-k>", "<C-w>k", "Window: move up")
map("n", "<C-j>", "<C-w>j", "Window: move down")

map("n", "<C-Left>", "<C-w><", "Window: narrower")
map("n", "<C-Right>", "<C-w>>", "Window: wider")
map("n", "<C-Up>", "<C-w>+", "Window: taller")
map("n", "<C-Down>", "<C-w>-", "Window: shorter")


-- NeoTree — <leader>e*
map("n", "<leader>e", "<CMD>Neotree toggle<CR>", "NeoTree: toggle")
map("n", "<leader>E", "<CMD>Neotree focus<CR>", "NeoTree: focus")
map("n", "<leader>eh", function()
    local state = require("neo-tree.sources.manager").get_state("filesystem")
    if state then
        local filters = state.filtered_items
        filters.visible = not filters.visible
        filters.hide_dotfiles = not filters.hide_dotfiles
        filters.hide_gitignored = not filters.hide_gitignored
        require("neo-tree.sources.filesystem")._navigate_internal(state, nil, nil)
    end
end, "NeoTree: toggle hidden files")


-- Telescope — <leader>f* (find)
map("n", "<leader>ff", telescope("find_files"), "Telescope: find files")
map("n", "<leader>fg", telescope("live_grep"), "Telescope: live grep")
map("n", "<leader>fb", telescope("buffers"), "Telescope: buffers")
map("n", "<leader>fh", telescope("help_tags"), "Telescope: help tags")
map("n", "<leader>fr", telescope("oldfiles"), "Telescope: recent files")
map("n", "<leader>fk", telescope("keymaps"), "Telescope: keymaps")
map("n", "<leader>fd", telescope("diagnostics"), "Telescope: diagnostics")
map("n", "<leader>fc", function()
    require("telescope.builtin").colorscheme({ enable_preview = true })
end, "Telescope: colorscheme")


-- Git — <leader>g*
map("n", "<leader>ge", "<CMD>Neotree toggle git_status<CR>", "Git: NeoTree status view")
map("n", "<leader>gf", telescope("git_files"), "Git: files")
map("n", "<leader>gb", telescope("git_branches"), "Git: branches")
map("n", "<leader>gs", telescope("git_status"), "Git: status")
map("n", "<leader>gc", telescope("git_commits"), "Git: commits")


-- LSP — gN / K / <leader>l*
map("n", "gd", vim.lsp.buf.definition, "LSP: go to definition")
map("n", "gD", vim.lsp.buf.declaration, "LSP: go to declaration")
map("n", "gi", vim.lsp.buf.implementation, "LSP: go to implementation")
map("n", "gr", vim.lsp.buf.references, "LSP: references")
map("n", "K", vim.lsp.buf.hover, "LSP: hover docs")
map("n", "<leader>ln", vim.lsp.buf.rename, "LSP: rename symbol")
map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, "LSP: code action")
map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "LSP: format buffer")
map("n", "<leader>ls", vim.lsp.buf.signature_help, "LSP: signature help")
map("n", "<leader>le", vim.diagnostic.open_float, "LSP: line diagnostic")
map("n", "<leader>ld", vim.diagnostic.setloclist, "LSP: diagnostic loclist")
map("n", "[d", vim.diagnostic.goto_prev, "LSP: previous diagnostic")
map("n", "]d", vim.diagnostic.goto_next, "LSP: next diagnostic")


-- DAP — F-keys + <leader>d*
map("n", "<F5>", dap_call("continue"), "DAP: continue")
map("n", "<F10>", dap_call("step_over"), "DAP: step over")
map("n", "<F11>", dap_call("step_into"), "DAP: step into")
map("n", "<F12>", dap_call("step_out"), "DAP: step out")

map("n", "<leader>db", dap_call("toggle_breakpoint"), "DAP: toggle breakpoint")
map("n", "<leader>dB", function()
    require("dap").set_breakpoint(vim.fn.input("Condition: "))
end, "DAP: conditional breakpoint")
map("n", "<leader>dc", dap_call("continue"), "DAP: continue")
map("n", "<leader>do", dap_call("step_over"), "DAP: step over")
map("n", "<leader>di", dap_call("step_into"), "DAP: step into")
map("n", "<leader>dO", dap_call("step_out"), "DAP: step out")
map("n", "<leader>dr", function() require("dap").repl.toggle() end, "DAP: toggle REPL")
map("n", "<leader>dl", dap_call("run_last"), "DAP: run last")
map("n", "<leader>du", function() require("dapui").toggle() end, "DAP: toggle UI")
map("n", "<leader>dt", dap_call("terminate"), "DAP: terminate")


-- Terminal — <F7> handled by toggleterm; <leader>t* for directional variants
map("n", "<leader>tf", "<CMD>ToggleTerm direction=float<CR>", "Terminal: float")
map("n", "<leader>th", "<CMD>ToggleTerm direction=horizontal<CR>", "Terminal: horizontal")
map("n", "<leader>tv", "<CMD>ToggleTerm direction=vertical<CR>", "Terminal: vertical")


-- Luasnip — insert/select mode jumps
map({ "i", "s" }, "<C-k>", function()
    local ls = require("luasnip")
    if ls.expand_or_jumpable() then ls.expand_or_jump() end
end, "Luasnip: expand or jump forward")
map({ "i", "s" }, "<C-j>", function()
    local ls = require("luasnip")
    if ls.jumpable(-1) then ls.jump(-1) end
end, "Luasnip: jump back")
map({ "i", "s" }, "<C-l>", function()
    local ls = require("luasnip")
    if ls.choice_active() then ls.change_choice(1) end
end, "Luasnip: next choice")
