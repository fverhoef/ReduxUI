local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreateQuestIndicator = function(self)
    self.QuestIndicator = self:CreateTexture("$parentQuestIcon", "OVERLAY")
    self.QuestIndicator:SetSize(32, 32)
    self.QuestIndicator:SetPoint("CENTER", self.Health, "TOPRIGHT", 1, 10)

    return self.QuestIndicator
end