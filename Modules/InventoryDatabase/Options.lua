local addonName, ns = ...
local R = _G.ReduxUI
local ID = R.Modules.InventoryDatabase
local L = R.L

local selectedCharacter

R:RegisterModuleOptions(ID, {
    type = "group",
    name = L["Inventory Database"],
    args = {
        header = { type = "header", name = R.title .. " > Inventory Database", order = 0 },
        lineBreak = { type = "header", name = "", order = 2 },
        character = {
            type = "select",
            name = L["Characters"],
            desc = L["Characters in the inventory database."],
            order = 3,
            values = R.Modules.InventoryDatabase.GetCharacterKeys,
            get = function()
                return selectedCharacter
            end,
            set = function(_, key)
                selectedCharacter = key
            end
        },
        clear = {
            order = 4,
            type = "execute",
            name = L["Clear Character Database"],
            disabled = function()
                return selectedCharacter == nil
            end,
            func = function()
                R.Modules.InventoryDatabase:ClearCharacterDatabase(selectedCharacter)
            end
        }
    }
})
