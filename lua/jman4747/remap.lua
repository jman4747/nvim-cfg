vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
function normremap(old, new)
    vim.keymap.set("n", old, new)
end
function visremap(old, new)
    vim.keymap.set("v", old, new)
end
function insmremap(old, new)
	vim.keymap.set("i", old, new)
end

insmremap("<S-Tab>", "<C-q>\t")
normremap("<S-Tab>", "<C-q>\t")
normremap("gpv", vim.cmd.Ex)
normremap("<leader>u", ":UndotreeShow<CR>")

visremap("J", ":m '>+1<CR>gv=gv")
visremap("K", ":m '<-2<CR>gv=gv")

normremap("Y", "yg$")
normremap("J", "mzJ`z")
normremap("<C-d>", "<C-d>zz")
normremap("<C-u>", "<C-u>zz")
normremap("n", "nzzzv")
normremap("N", "Nzzzv")

visremap("<leader>pc", "\"+p")
normremap("<leader>pc", "\"+p")
visremap("<leader>cc", "\"+y")

normremap("<Tab>", "i\t")
