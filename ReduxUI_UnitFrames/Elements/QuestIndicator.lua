local AddonName, AddonTable = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames

UF.CreateQuestIndicator = function(self)
    self.QuestIndicatorParent = CreateFrame("Frame", nil, self)
    self.QuestIndicatorParent:SetFrameLevel(self:GetFrameLevel() + 10)

    self.QuestIndicator = self.QuestIndicatorParent:CreateTexture("$parentQuestIcon", "OVERLAY")
    self.QuestIndicator:SetSize(32, 32)
    self.QuestIndicator:SetPoint("CENTER", self.Health, "TOPRIGHT", 1, 10)

    return self.QuestIndicator
end