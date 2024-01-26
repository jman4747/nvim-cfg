-- [[General Settings]]
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

-- Relative line numbers w/absolute at cursor
vim.cmd("set nu rnu")

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({ timeout = 500 })
    end,
    group = highlight_group,
    pattern = '*',
})

-- for tabs instead of spaces
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufNew", "BufAdd" }, {
    pattern = "*",
    callback = function()
        if vim.o.modifiable then
            vim.opt.tabstop = 4
            vim.opt.shiftwidth = 4
            vim.opt.expandtab = true
            vim.opt.smartindent = true
            vim.opt.wrap = false
            vim.opt.fileformat = "unix"
            vim.opt.fixendofline = true
        end
    end,
})

-- I want LF not CRLF even on Windows
vim.opt.fileformats = "unix,dos"
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 100

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Enable underline, use default values
        underline = true,
        -- Enable virtual text, override spacing to 4
        virtual_text = {
            spacing = 2,
        },
        -- Use a function to dynamically turn signs off
        -- and on, using buffer local variables
        signs = true,
        update_in_insert = true,
    }
)

-- This is adapted from from lsp-zero
local function set_sign_icons(opts)
    opts = opts or {}
--[[ Won't do anything until nvim 0.10.x
    if vim.diagnostic.count then
        local ds = vim.diagnostic.severity
        local levels = {
            [ds.ERROR] = 'error',
            [ds.WARN] = 'warn',
            [ds.INFO] = 'info',
            [ds.HINT] = 'hint'
        }

        local text = {}

        for k, v in pairs(levels) do
            if type(opts[v]) == 'string' then
                text[k] = opts[v]
            end
        end

        vim.diagnostic.config({ signs = { text = text } })
        return
    end
]]
    local sign = function(args)
        if args.text == nil then
            return
        end

        vim.fn.sign_define(args.hl, {
            texthl = args.hl,
            text = args.text,
            numhl = ''
        })
    end

    sign({ text = opts['error'], hl = 'DiagnosticSignError' })
    sign({ text = opts['warn'], hl = 'DiagnosticSignWarn' })
    sign({ text = opts['hint'], hl = 'DiagnosticSignHint' })
    sign({ text = opts['info'], hl = 'DiagnosticSignInfo' })
end

set_sign_icons({
    error = '🤬',
    warn = '🤢',
    hint = '🤨',
    info = '💬'
})

vim.opt.guifont = "CaskaydiaCove Nerd Font Mono:13"
