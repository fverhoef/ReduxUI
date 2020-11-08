local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local TT = Addon:AddModule("Tooltips", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

function TT:OnInitialize()
    TT:SetupConfig()
end