local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local CB = Addon:AddModule("ClassBars", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

function CB:OnInitialize()
    CB.config = {}
    CB.config.db = {
        profile = Addon.config.db.profile.modules.classBars
    }
end