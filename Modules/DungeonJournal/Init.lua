local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local DJ = Addon:AddModule("DungeonJournal", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

function DJ:OnInitialize()
    DJ:SetupConfig()
end
