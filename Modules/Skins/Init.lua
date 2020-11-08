local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local S = Addon:AddModule("Skins", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

function S:OnInitialize()
    S.config = {}
    S.config.db = {
        profile = Addon.config.db.profile.modules.skins
    }
end
