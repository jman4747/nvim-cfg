-- Relative line numbers w/absolute at cursor
vim.cmd("set nu rnu")
-- I want LF not CRLF even on Windows
vim.cmd("set fileformat=unix")

vim.g.mapleader = " "

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

	vim.opt.updatetime = 2000

-- The following will set up powershell as the default shell if running windows.
-- See: https://www.reddit.com/r/neovim/comments/vpnhrl/how_do_i_make_neovim_use_powershell_for_external/
if string.match(vim.loop.os_uname().sysname, "Windows") then
	vim.cmd([[
	set shell=powershell.exe
	set shellxquote=
	let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command '
	let &shellquote   = ''
	let &shellpipe    = '| Out-File -Encoding UTF8 %s'
	let &shellredir   = '| Out-File -Encoding UTF8 %s'
	]])
end

