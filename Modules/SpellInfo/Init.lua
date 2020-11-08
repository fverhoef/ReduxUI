local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local SI = Addon:AddModule("SpellInfo", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

function SI:OnInitialize()
    SI:SetupConfig()
end