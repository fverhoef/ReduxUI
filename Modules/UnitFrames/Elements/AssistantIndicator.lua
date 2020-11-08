local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreateAssistantIndicator = function(self)
    self.AssistantIndicator = self:CreateTexture("$parentAssistIcon", "OVERLAY")
    self.AssistantIndicator:SetSize(16, 16)

    return self.AssistantIndicator
end