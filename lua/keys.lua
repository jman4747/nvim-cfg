-- Key Remap
local function nremap(old, new, opts)
	vim.keymap.set("n", old, new, opts)
end
-- local function vremap(old, new, opts)
-- 	vim.keymap.set("v", old, new, opts)
-- end
local function nvremap(old, new, opts)
	vim.keymap.set({ 'n', 'v' }, old, new, opts)
end
-- [[ General Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
nvremap('<Space>', '<Nop>', { silent = true })
local wk = require("which-key")

-- vremap("J", ":m '>+1<CR>gv=gv", { desc = "Move selected down one line" })
-- vremap("K", ":m '<-2<CR>gv=gv", { desc = "Move selected up one line " })

--- Call 'func' then center the line at the cursor vertically "zz"
---@param func function
local function then_center(func)
	func()
	vim.cmd.normal("zz")
end

local tab_literal = {}

-- [[ Windows vs Unix Stuff ]]
if string.match(vim.loop.os_uname().sysname, "Windows") then
	tab_literal = {'<leader>t', "i<C-q>	<Esc>", desc = 'Insert [t]ab literal' }
else
	tab_literal	= {'<leader>t', "i<C-v>	<Esc>", desc = 'Insert [t]ab literal' }
end

wk.add({
	{'<leader>s', group = '[S]earch' },
	{'<leader>w', group = '[W]orkspace' },
	{'<leader>f', group = '[F]ormat' },
	{'<leader>g', group = '[G]oto' },
	{
		mode = { "v" },
		{ "J", ":m '>+1<CR>gv=gv", desc = "Move selected down one line" },
		{ "K", ":m '<-2<CR>gv=gv", desc = "Move selected up one line" }
	},
	{
		mode = { "n" },
		tab_literal,
		{ "Y",     "yg$",     desc = "[Y]ank from cursor to EOL" },
		{ "J",     "mzJ`z",   desc = "Move line below to end of current line" },
		{ "<C-d>", "<C-d>zz", desc = "Move [d]own to line at window bottom" },
		{ "<C-u>", "<C-u>zz", desc = "Move [u]p to line at window top" },
		{ "n",     "nzzzv",   desc = "[n]ext found and center on window" },
		{ "N",     "Nzzzv",   desc = "Previous found and center on window" },
		-- Diagnostic keymaps
		{
			'[d',
			function() then_center(vim.diagnostic.goto_prev) end,
			desc = 'Go to previous diagnostic message'
		},
		{
			']d',
			function() then_center(vim.diagnostic.goto_next) end,
			desc = 'Go to next diagnostic message'
		},
		{ '<leader>e', vim.diagnostic.open_float, desc = 'Open floating diagnostic message' },
		{ '<leader>q', vim.diagnostic.setloclist, desc = 'Open diagnostics list' },
		-- [[ Context Jump ]]
		-- via nvim-treesitter-context
		{
			"[c",
			function()
				require("treesitter-context").go_to_context(vim.v.count1)
			end,
			silent = true,
			desc = "Jump to [c]ontext"
		},
		-- See `:help telescope.builtin`
		{ '<leader>?', require('telescope.builtin').oldfiles, desc = '[?] Find recently opened files' },
		{ '<leader><space>', require('telescope.builtin').buffers, desc = '[ ] Find existing buffers' },
		{
			'<leader>/',
			function()
				-- You can pass additional configuration to telescope to change theme, layout, etc.
				require('telescope.builtin')
				.current_buffer_fuzzy_find(require('telescope.themes')
				.get_dropdown {
					winblend = 10,
					previewer = false,
				})
			end,
			desc = '[/] Fuzzily search in current buffer'
		},
		{ '<leader>sv', require('telescope.builtin').git_files, desc = '[S]earch vcs (git)' },
		{ '<leader>sf', require('telescope.builtin').find_files, desc = '[S]earch [F]iles' },
		{ '<leader>sh', require('telescope.builtin').help_tags, desc = '[S]earch [H]elp' },
		{ '<leader>sw', require('telescope.builtin').grep_string, desc = '[S]earch current [W]ord' },
		{ '<leader>sg', require('telescope.builtin').live_grep, desc = '[S]earch by [G]rep' },
		{ '<leader>sd', require('telescope.builtin').diagnostics, desc = '[S]earch [D]iagnostics' },
		{ '<leader>sr', require('telescope.builtin').resume, desc = '[S]earch [R]esume' },
		-- [[ Netrw ]]
		{ "gpv", vim.cmd.Ex, desc = "[g]o to [p]roject [v]iew (Netrw," },
		-- [[ Undo Tree ]]
		{ "<leader>u", ":UndotreeShow<CR>", desc = 'Open [u]ndo tree' },
	},
})

-- [[ Configure LSP keys ]]
--  This function gets run when an LSP connects to a particular buffer.
--
On_attach = function(_, bufnr)
	-- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
	-- vim.o.omnifunc = 'v:lua.vim.lsp.omnifunc'

	require('fidget').notify("Setting up LSP keys")
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = 'LSP: ' .. desc
		end
		nremap(keys, func, { buffer = bufnr, desc = desc })
	end

	nmap('<leader>r', vim.lsp.buf.rename, '[R]ename')
	nmap('<leader>c', vim.lsp.buf.code_action, '[C]ode Action')

	nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
	nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
	nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
	nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
	nmap('<leader>d', require('telescope.builtin').lsp_document_symbols, '[D]ocument Symbols')
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
