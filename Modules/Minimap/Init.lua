local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local MM = Addon:AddModule("Minimap", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

function MM:OnInitialize()
    MM:SetupConfig()
end
