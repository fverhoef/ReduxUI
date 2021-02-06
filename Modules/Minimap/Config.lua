local addonName, ns = ...
local R = _G.ReduxUI
local MM = R.Modules.Minimap

R:RegisterModuleConfig(MM, {
    enabled = true,
    point = {"TOPRIGHT", "UIParent", "TOPRIGHT", -5, -13},
    enableMailGlow = false, 
    buttonFrame = {
        enabled = true, iconSize = 22, buttonsPerRow = 6, buttonSpacing = 2, collapsed = true
    }
})

R:RegisterModuleOptions(MM, {    
    type = "group",
    name = "Minimap",
    args = {
        header = {type = "header", name = R.title .. " > Minimap", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if MM.config.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return MM.config.enabled
            end,
            set = function(_, val)
                MM.config.enabled = val
                if not val then
                    ReloadUI()
                else
                    MM:Initialize()
                end
            end
        },
        lineBreak = {type = "header", name = "", order = 2}
    }
})