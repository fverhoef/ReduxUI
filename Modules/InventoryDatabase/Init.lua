local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local ID = Addon:AddModule("InventoryDatabase", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

function ID:OnInitialize()
    ID.config = {}
    ID.config.db = {
        profile = Addon.config.db.profile.modules.inventoryDatbase
    }
end