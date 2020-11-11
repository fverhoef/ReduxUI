
local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local CD = Addon:AddModule("Cooldowns", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

function CD:OnInitialize()
    CD.config = {}
    CD.config.db = {profile = Addon.config.db.profile.modules.cooldowns}
end