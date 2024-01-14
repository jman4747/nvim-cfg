vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
local function normremap(old, new)
    vim.keymap.set("n", old, new)
end
local function visremap(old, new)
    vim.keymap.set("v", old, new)
end

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

-- for typing tab literals
normremap("<S-Tab>", "a\t")
normremap("<Tab>", "i\t")
