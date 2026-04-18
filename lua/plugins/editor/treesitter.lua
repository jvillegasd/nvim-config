local parsers = { "lua", "javascript", "python", "bash", "java", "c", "markdown", "markdown_inline", "vim", "vimdoc", "query" }

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
        require("nvim-treesitter").setup({
            install_dir = vim.fn.stdpath("data") .. "/site",
        })

        -- Compat shim: telescope's previewer calls master-branch APIs
        -- (parsers.ft_to_lang, configs.is_enabled) that the main branch dropped.
        -- install() below nils package.loaded['nvim-treesitter.parsers'], so the
        -- shim is idempotent and also re-applied on VimEnter + first BufReadPre.
        local function apply_ts_compat_shim()
            local p = require("nvim-treesitter.parsers")
            if not p.ft_to_lang then
                p.ft_to_lang = function(ft)
                    return vim.treesitter.language.get_lang(ft) or ft
                end
            end
            if not p.get_parser then
                p.get_parser = function(bufnr, lang)
                    return vim.treesitter.get_parser(bufnr, lang)
                end
            end
            package.loaded["nvim-treesitter.configs"] = package.loaded["nvim-treesitter.configs"] or {
                is_enabled = function() return true end,
                get_module = function() return {} end,
                setup = function() end,
            }
        end

        apply_ts_compat_shim()
        require("nvim-treesitter").install(parsers)
        apply_ts_compat_shim()

        vim.api.nvim_create_autocmd({ "VimEnter", "BufReadPre" }, {
            once = true,
            callback = apply_ts_compat_shim,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = parsers,
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)
                vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
