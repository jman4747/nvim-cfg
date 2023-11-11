local lsp = require('lsp-zero').preset({
    name = 'minimal',
    set_lsp_keymaps = true,
    manage_nvim_cmp = true,
    suggest_lsp_servers = false,
})


lsp.ensure_installed({
    'rust_analyzer',
    'bashls',
    'marksman',
    'lua_ls'
})

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()

local function virtual_text_on()
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = false,
        })
    vim.g.diagnostic_virtual_txt = true
    vim.diagnostic.show(nil, 0, nil, { virtual_text = true })
end

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>ws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>gh", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.set_sign_icons({
  error = '🤬',
  warn = '🤢',
  hint = '⚑',
  info = '»'
})

lsp.setup()


-- for typst lsp
require'lspconfig'.typst_lsp.setup{
	settings = {
        -- Using typst watch <file name> so this can be never.
		exportPdf = "never" -- Choose onType, onSave or never.
	}
}

-- for formatting files manually
vim.api.nvim_create_user_command('Fmt',
    function()
        vim.lsp.buf.format()
        print('File formatted')
    end,
    {})

vim.api.nvim_create_user_command('Format',
    function()
        vim.lsp.buf.format()
        print('File formatted')
    end,
    {})

-- for toggling the diagnostic virtual text to reduce clutter
vim.g.diagnostic_virtual_txt = true
virtual_text_on()
function _G.toggle_virtual_txt()
    if vim.g.diagnostic_virtual_txt then
        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = false,
                signs = true,
                underline = true,
                update_in_insert = false,
            })
        vim.g.diagnostic_virtual_txt = false
        vim.diagnostic.show(nil, 0, nil, { virtual_text = false })
        print('Diagnostics hidden')
    else
        virtual_text_on()
        print('Diagnostics visible')
    end
end

vim.keymap.set('n', '<leader>tt', ':call v:lua.toggle_virtual_txt()<CR>', { silent = true, noremap = true })

-- manual Zig ZLS setup
local lspconfig = require('lspconfig')

lspconfig.zls.setup { on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    require('completion').on_attach()
    vim.cmd [[set completeopt=menuone,noinsert,noselect]]
    vim.cmd [[let g:completion_enable_auto_popup = 1]]
end
}
