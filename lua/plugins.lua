-- lazy.nvim see: https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Load Colorscheme first:
	{
		'rose-pine/neovim',
		name = 'rose-pine',
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("rose-pine")
		end,
	},

	"folke/which-key.nvim",

	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" }
	},

	-- Undo
	'mbbill/undotree',

	-- Power Shell
	{
		"TheLeoP/powershell.nvim",
		opts = {
			bundle_path = vim.fn.stdpath "data" .. "/mason/packages/powershell-editor-services",
		}
	},

	-- lsp install & config
	{
		-- LSP Configuration & Plugins
		'neovim/nvim-lspconfig',
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ 'j-hui/fidget.nvim', opts = {} },
		},
	},

	-- Auto-completion
	{
		'hrsh7th/nvim-cmp',
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = "lazydev",
				group_index = 0, -- set group index to 0 to skip loading LuaLS completions
			})
		end,
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
			-- Adds LSP completion capabilities
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
		},
	},

	-- Git related plugins
	-- 'tpope/vim-fugitive',
	-- 'tpope/vim-rhubarb',

	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			-- Lang specific jump to matching pair (extends: %)
			'andymass/vim-matchup',
		},
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = { "lua", "vim", "vimdoc", "rust", "javascript", "html", "nu" },
				modules = {},
				matchup = { enable = true },
				ignore_install = {},
				auto_install = true,
				sync_install = true,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end
	},

	-- for editing vim config
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta",  lazy = true }, -- optional `vim.uv` typings

	-- Shows current context + go to context motion
	{
		-- requires nvim-treesitter
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			local conf = require("treesitter-context")

			conf.setup({
				enable = true,
			})
		end
	},

	-- Status bar
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' }
	},

	-- "gc" to comment visual regions/lines
	{ 'numToStr/Comment.nvim', opts = {} },

	-- Nushell
	{
		'LhKipp/nvim-nu',
	},
})

require("mason").setup()
require("mason-lspconfig").setup()

local global_capabilities = vim.lsp.protocol.make_client_capabilities()
global_capabilities.textDocument.completion.completionItem.snippetSupport = true
global_capabilities.textDocument.completion.contextSupport = true
global_capabilities.textDocument.completion.dynamicRegistration = true
global_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
Capabilities = require("cmp_nvim_lsp").default_capabilities(global_capabilities)

require'nu'.setup{
    use_lsp_features = false, -- requires https://github.com/jose-elias-alvarez/null-ls.nvim
    -- lsp_feature: all_cmd_names is the source for the cmd name completion.
    -- It can be
    --  * a string, which is evaluated by nushell and the returned list is the source for completions (requires plenary.nvim)
    --  * a list, which is the direct source for completions (e.G. all_cmd_names = {"echo", "to csv", ...})
    --  * a function, returning a list of strings and the return value is used as the source for completions
    all_cmd_names = [[help commands | get name | str join "\n"]]
}

local global_capabilities = vim.lsp.protocol.make_client_capabilities()
global_capabilities.textDocument.completion.completionItem.snippetSupport = true
global_capabilities.textDocument.completion.contextSupport = true
global_capabilities.textDocument.completion.dynamicRegistration = true
global_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

Capabilities = require("cmp_nvim_lsp").default_capabilities(global_capabilities)

require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'auto'
	}
}
require('Comment').setup()

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
		{ name = 'nvim_lsp',
			option = {
				markdown_oxide = {
					keyword_pattern = [[\(\k\| \|\/\|#\)\+]]
				}
			}
		},
		{ name = 'luasnip' },
	},
}
