local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateAssistantIndicator = function(self)
    self.AssistantIndicatorParent = CreateFrame("Frame", nil, self)
    self.AssistantIndicatorParent:SetFrameLevel(self:GetFrameLevel() + 10)

    self.AssistantIndicator = self.AssistantIndicatorParent:CreateTexture("$parentAssistIcon", "OVERLAY")
    self.AssistantIndicator:SetSize(16, 16)

    return self.AssistantIndicator
end

oUF:RegisterMetaFunction("CreateAssistantIndicator", UF.CreateAssistantIndicator)
