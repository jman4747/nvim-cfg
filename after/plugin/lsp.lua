local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
	lsp_zero.default_keymaps({buffer = bufnr})

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

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {},
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end,
	typst_lsp = function ()
		require('lspconfig').typst_lsp.setup {
			settings = {
				-- Using typst watch <file name> so this can be never.
				exportPdf = "never" -- Choose onType, onSave or never.
			}
		}
	end
  }
})

lsp_zero.set_sign_icons({
  error = '🤬',
  warn = '🤢',
  hint = '⚑',
  info = '»'
})

vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = {
    style = 'minimal',
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

local cmp = require('cmp')
local cmp_action = lsp_zero.cmp_action()
local cmp_format = lsp_zero.cmp_format()

require('luasnip.loaders.from_vscode').lazy_load()

vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

cmp.setup({
  formatting = cmp_format,
  preselect = 'item',
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  window = {
    documentation = cmp.config.window.bordered(),
  },
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp'},
    {name = 'nvim_lua'},
    {name = 'buffer', keyword_length = 3},
    {name = 'luasnip', keyword_length = 2},
  },
  mapping = cmp.mapping.preset.insert({
    -- confirm completion item
    ['<CR>'] = cmp.mapping.confirm({select = false}),

    -- toggle completion menu
    ['<C-e>'] = cmp_action.toggle_completion(),

    -- tab complete disabled to get literal tabs
    --['<Tab>'] = cmp_action.tab_complete(),
    --['<S-Tab>'] = cmp.mapping.select_prev_item(),

    -- navigate between snippet placeholder
    ['<C-d>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),

    -- scroll documentation window
    ['<C-f>'] = cmp.mapping.scroll_docs(5),
    ['<C-u>'] = cmp.mapping.scroll_docs(-5),
  }),
})

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
