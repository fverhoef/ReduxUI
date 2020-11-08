local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local MM = Addon.Modules.Minimap

Addon.config.defaults.profile.modules.minimap = {
    enabled = true,
    point = {"TOPRIGHT", "UIParent", "TOPRIGHT", -5, -13},
    enableMailGlow = false, 
    buttonFrame = {
        enabled = true, iconSize = 22, buttonsPerRow = 6, buttonSpacing = 2, collapsed = true
    }
}

Addon.config.options.args.minimap = {    
    type = "group",
    name = "Minimap",
    order = 9,
    args = {
        header = {type = "header", name = Addon.title .. " > Minimap", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if MM.config.db.profile.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return MM.config.db.profile.enabled
            end,
            set = function(_, val)
                MM.config.db.profile.enabled = val
                if not val then
                    ReloadUI()
                else
                    Addon.Modules.Minimap:OnInitialize()
                end
            end
        },
        lineBreak = {type = "header", name = "", order = 2}
    }
}