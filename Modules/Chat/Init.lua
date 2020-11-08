local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local C = Addon:AddModule("Chat", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

function C:OnInitialize()
    C:SetupConfig()
end
