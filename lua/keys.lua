-- Key Remap
local function nremap(old, new, opts)
    vim.keymap.set("n", old, new, opts)
end
local function vremap(old, new, opts)
    vim.keymap.set("v", old, new, opts)
end
local function nvremap(old, new, opts)
    vim.keymap.set({ 'n', 'v' }, old, new, opts)
end
-- [[ General Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vremap("J", ":m '>+1<CR>gv=gv", { desc = "Move selected down one line" })
vremap("K", ":m '<-2<CR>gv=gv", { desc = "Move selected up one line " })
nremap("Y", "yg$", { desc = "[Y]ank from cursor to EOL" })
nremap("J", "mzJ`z", { desc = "Move line below to end of current line" })
nremap("<C-d>", "<C-d>zz", { desc = "Move [d]own to line at window bottom" })
nremap("<C-u>", "<C-u>zz", { desc = "Move [u]p to line at window top" })
nremap("n", "nzzzv", { desc = "[n]ext found and center on window" })
nremap("N", "Nzzzv", { desc = "Previous found and center on window" })

-- Diagnostic keymaps
nremap('[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
nremap(']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
nremap('<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
nremap('<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Setups ]]
-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
-- Setup neovim lua configuration
require('neodev').setup()

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto'
    }
}
require('Comment').setup()


-- [[ Context Jump ]]
-- via nvim-treesitter-context
vim.keymap.set("n", "[c", function()
    require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true, desc = 'Jump to [c]ontext' })

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
            },
        },
    },
}

-- See `:help telescope.builtin`
nremap('<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
nremap('<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
nremap('<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = '[/] Fuzzily search in current buffer' })

nremap('<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
nremap('<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
nremap('<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
nremap('<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
nremap('<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
nremap('<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
nremap('<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

-- [[ Netrw ]]
nremap("gpv", vim.cmd.Ex, { desc = "[g]o to [p]roject [v]iew (Netrw)" })

-- [[ Undo Tree ]]
nremap("<leader>u", ":UndotreeShow<CR>", { desc = 'Open [U]ndo tree' })

-- document existing key chains
require('which-key').register {
    ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
    ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
    ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
    ['<leader>h'] = { name = 'More git', _ = 'which_key_ignore' },
    ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
    ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
    ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
    ['<leader>f'] = { name = '[F]ormat', _ = 'which_key_ignore' },
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
}

-- [[ Windows vs Unix Stuff ]]
if string.match(vim.loop.os_uname().sysname, "Windows") then
    -- The following will set up powershell as the default shell if running windows.
    -- See: https://www.reddit.com/r/neovim/comments/vpnhrl/how_do_i_make_neovim_use_powershell_for_external/
    nremap('<leader>t', "i<C-q>	<Esc>", { desc = 'Insert [t]ab literal' })
    vim.cmd([[
	set shell=powershell.exe
	set shellxquote=
	let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command '
	let &shellquote   = ''
	let &shellpipe    = '| Out-File -Encoding UTF8 %s'
	let &shellredir   = '| Out-File -Encoding UTF8 %s'
	]])
else
    nremap('<leader>t', "i<C-v>	<Esc>", { desc = 'Insert [t]ab literal' })
end

-- [[ Configure LSP keys ]]
--  This function gets run when an LSP connects to a particular buffer.
--
On_attach = function(_, bufnr)
    require('fidget').notify("Setting up LSP keys")
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        nremap(keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')
    -- [[Format]]
    -- LSP format whole file
    nvremap('<leader>ff', vim.lsp.buf.format, { desc = '[F]ormat buffer' })
    -- LSP format whole file & write
    nvremap('<leader>fw',
        function()
            vim.lsp.buf.format()
            vim.cmd.write()
        end,
        { desc = '[F]ormat & [W]rite buffer' })
    -- LSP format whole file, write, & quit
    nvremap('<leader>fq',
        function()
            vim.lsp.buf.format()
            vim.cmd.write()
            vim.cmd.quit()
        end,
        { desc = '[F]ormat, write, & [Q]uit buffer' })
end
