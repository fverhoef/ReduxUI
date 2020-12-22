local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreateAssistantIndicator = function(self)
    self.AssistantIndicatorParent = CreateFrame("Frame", nil, self)
    self.AssistantIndicatorParent:SetFrameLevel(self:GetFrameLevel() + 10)

    self.AssistantIndicator = self.AssistantIndicatorParent:CreateTexture("$parentAssistIcon", "OVERLAY")
    self.AssistantIndicator:SetSize(16, 16)

    return self.AssistantIndicator
end
