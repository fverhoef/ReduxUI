local addonName, ns = ...
local R = _G.ReduxUI
local ID = R.Modules.InventoryDatabase

R:RegisterModuleConfig(ID, {enabled = true})

R:RegisterModuleOptions(ID, {
    type = "group",
    name = "Inventory Database",
    args = {
        header = {type = "header", name = R.title .. " > Inventory Database", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if ID.config.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return ID.config
            end,
            set = function(_, val)
                ID.config = val
                if not val then
                    ReloadUI()
                else
                    ID:Initialize()
                end
            end
        }
    }
})
