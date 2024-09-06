local function script_path()
   local str = debug.getinfo(2, "S").source:sub(2)
   return str:match("(.*[/\\])")
end

require('fidget').notify(string.format("Loading local config at: %s", script_path()))

if On_attach == nil then
        print("Warning: local config can't find \"On_attach\" function!")
end

if Capabilities == nil then
        print("Warning: local config can't find \"Capabilities\" dictionary!")
end

require("lspconfig").lua_ls.setup {
    capabilities = Capabilities,
    on_attach = On_attach,
    Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
        diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { 'vim' },
        },
    },
}
