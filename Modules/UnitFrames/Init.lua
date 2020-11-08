local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local UF = Addon:AddModule("UnitFrames", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

function UF:OnInitialize()
    UF.config = {}
    UF.config.db = {profile = Addon.config.db.profile.modules.unitFrames}
end
