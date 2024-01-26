-- [[ Attempt to load exstra config file ]]
--[[ example file content for manual lsp setup:

require('fidget').notify("Seting up Rust-Analyzer")

require('lspconfig').rust_analyzer.setup {
    on_attach = require('keys').on_attach,
    settings = {
        ['rust-analyzer'] = {},
    },
}

--]]

vim.api.nvim_create_user_command("ExstraCfg",
    function ()
        print(vim.g.exstra_cfg)
    end
, {})
local exstra_cfg = os.getenv("NVIM_EXSTRA_CFG")
if exstra_cfg == nil then
    vim.g.exstra_cfg = "NVIM_EXSTRA_CFG: N/A"
elseif exstra_cfg.len == 0 then
    vim.g.exstra_cfg = "NVIM_EXSTRA_CFG: N/A"
else
    vim.g.exstra_cfg = exstra_cfg
    print("Loading NVIM_EXSTRA_CFG: " .. exstra_cfg)
    local file_ext = exstra_cfg:match("[^/\\]*[.]([lL][uU][aA])$")
    if file_ext == "" or file_ext == nil then
        print("Warning: exstra config file given is not a '.lua' file")
    end

    local ok, error = pcall(dofile, exstra_cfg)
    if ok == false then
        print(error)
    end
end
