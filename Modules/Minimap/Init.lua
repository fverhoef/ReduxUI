local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local MM = Addon:AddModule("Minimap", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

function MM:OnInitialize()
    MM.config = {}
    MM.config.db = {
        profile = Addon.config.defaults.profile.modules.minimap
    }
end
