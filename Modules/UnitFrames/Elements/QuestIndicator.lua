local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateQuestIndicator = function(self)
    self.QuestIndicatorParent = CreateFrame("Frame", nil, self)
    self.QuestIndicatorParent:SetFrameLevel(self:GetFrameLevel() + 10)

    self.QuestIndicator = self.QuestIndicatorParent:CreateTexture("$parentQuestIcon", "OVERLAY")
    self.QuestIndicator:SetSize(32, 32)
    self.QuestIndicator:SetPoint("CENTER", self.Health, "TOPRIGHT", 1, 10)

    return self.QuestIndicator
end

oUF:RegisterMetaFunction("CreateQuestIndicator", UF.CreateQuestIndicator)

UF.UpdateQuestIndicator = function(self)
    if not self.QuestIndicator then
        return
    end

    local cfg = self.cfg.questIndicator
    if cfg.enabled then
        self:EnableElement("UpdateQuestIndicator")
    else
        self:DisableElement("UpdateQuestIndicator")
    end
end

oUF:RegisterMetaFunction("UpdateQuestIndicator", UF.UpdateQuestIndicator)