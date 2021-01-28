local addonName, ns = ...
local R = _G.ReduxUI
local MM = R.Modules.Minimap

R.config.defaults.profile.modules.minimap = {
    enabled = true,
    point = {"TOPRIGHT", "UIParent", "TOPRIGHT", -5, -13},
    enableMailGlow = false, 
    buttonFrame = {
        enabled = true, iconSize = 22, buttonsPerRow = 6, buttonSpacing = 2, collapsed = true
    }
}

R.config.options.args.minimap = {    
    type = "group",
    name = "Minimap",
    order = 10,
    args = {
        header = {type = "header", name = R.title .. " > Minimap", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if R.config.defaults.profile.modules.minimap.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return R.config.defaults.profile.modules.minimap.enabled
            end,
            set = function(_, val)
                R.config.defaults.profile.modules.minimap.enabled = val
                if not val then
                    ReloadUI()
                else
                    R.Modules.Minimap:OnInitialize()
                end
            end
        },
        lineBreak = {type = "header", name = "", order = 2}
    }
}