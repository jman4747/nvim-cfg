-- Requirements:
--  For treesitter:
--    C compiler (clang/llvm, zig, etc.)
--    tar & curl or git

require("settings") -- this must come first
require("plugins")
require("keys") -- Depends on plugins being installed
require("mason-lsp") -- Omit this in NixOS

-- Use to load config file from an environment variable
require("exstra-loader")
