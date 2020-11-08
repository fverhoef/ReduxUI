local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local AM = Addon:AddModule("Automation", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

function AM:OnInitialize()
    AM:SetupConfig()
end
