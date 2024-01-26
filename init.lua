require("settings") -- this must come first
require("plugins")
require("keys") -- Depends on plugins being installed
require("mason-lsp") -- Omit this in NixOS Home Manager

-- Use to load config file from an environment variable
require("exstra-loader")
