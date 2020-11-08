local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local B = Addon:AddModule("Bags", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
 
function B:OnInitialize()
    B:SetupConfig()
end
