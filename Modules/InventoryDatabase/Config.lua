local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local ID = Addon.Modules.InventoryDatabase

Addon.config.defaults.profile.modules.inventoryDatabase = {
    enabled = true
}