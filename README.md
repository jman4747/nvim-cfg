# nvim-cfg
My Neovim config

Put these files into: `C:\Users\<user>\AppData\Local\nvim` on windows or: `~\.config\nvim` on linux.

## Requirements:

###  nvim-treesitter:
When a new language parser needs to be installed/updated:
- C compiler (clang/llvm, zig, etc.)
- tar & curl or git

## Install:

### On linux with FHS:
- `mkdir ~/.config && cd ~/.config`
- `git clone https://github.com/jman4747/nvim-cfg.git ./nvim`

### On NixOs:
I don't want Mason to setup LSPs there so I use a different init.vim:
- `mkdir ~/dotfiles && cd ~/dotfiles`
- `git clone https://github.com/jman4747/nvim-cfg.git ./nvim`
- `mkdir -p ~/.config/nvim && cd ~/.config/nvim`
- `ln -s ~/dotfiles/nvim/lua lua`
- `cp ~/dotfiles/nvim/init.vim init.vim`
- Edit the new init.vim and remove the line: `require("mason-lsp")`

This allows the lua files that do all the work to track git but the init.lua
can be edited to handle the specific platform.

### On windows (PowerShell):
- `cd ~\AppData\Local`
- `git clone https://github.com/jman4747/nvim-cfg.git ./nvim`
