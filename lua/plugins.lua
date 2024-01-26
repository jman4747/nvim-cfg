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

	-- NOTE: This is where your plugins related to LSP can be installed.
	--  The configuration is done below. Search for lspconfig to find it below.
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

			-- Additional lua configuration, makes nvim stuff amazing!
			'folke/neodev.nvim',
		},
	},

	-- Autocompletion
	{
		'hrsh7th/nvim-cmp',
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
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',

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
				ensure_installed = { "lua", "vim", "vimdoc", "rust", "javascript", "html" },
				modules = {},
                matchup = { enable = true},
				ignore_install = {},
				auto_install = true,
				sync_install = true,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end
	},

	-- Shows current context + goto context motion
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
})
