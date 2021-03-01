local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateQuestIndicator()
    self.QuestIndicator = self:CreateTexture("$parentQuestIcon", "OVERLAY")
    self.QuestIndicator:SetParent(self.Overlay)
    self.QuestIndicator:SetSize(32, 32)

    return self.QuestIndicator
end

oUF:RegisterMetaFunction("CreateQuestIndicator", UF.CreateQuestIndicator)

function UF:UpdateQuestIndicator()
    if not self.QuestIndicator then
        return
    end

    local config = self.config.questIndicator
    if config.enabled then
        self:EnableElement("UpdateQuestIndicator")

        self.QuestIndicator:SetSize(unpack(config.size))
        self.QuestIndicator:ClearAllPoints()
        self.QuestIndicator:Point(unpack(config.point))
    else
        self:DisableElement("UpdateQuestIndicator")
    end
end

oUF:RegisterMetaFunction("UpdateQuestIndicator", UF.UpdateQuestIndicator)