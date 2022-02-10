local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

R:RegisterModuleOptions(S, {  
    type = "group",
    name = "Skins",
    args = {
        header = {type = "header", name = R.title .. " > Skins", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if S.config.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return S.config.enabled
            end,
            set = function(_, val)
                S.config.enabled = val
                if not val then
                    ReloadUI()
                else
                    S:Initialize()
                end
            end
        },
        lineBreak1 = {type = "header", name = "", order = 2}
    }
})