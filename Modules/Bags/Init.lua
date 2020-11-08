local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local B = Addon:AddModule("Bags", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
 
function B:OnInitialize()
    B.config = {}
    B.config.db = {
        profile = Addon.config.db.profile.modules.bags
    }
end
