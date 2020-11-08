local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local CB = Addon:AddModule("ClassBars", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

function CB:OnInitialize()
    CB:SetupConfig()
end