local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateQuestIndicator()
    if not self.config.questIndicator.enabled then return end

    self.QuestIndicator = self:CreateTexture("$parentQuestIcon", "OVERLAY")
    self.QuestIndicator:SetParent(self.Overlay)
    self.QuestIndicator:SetSize(32, 32)

    return self.QuestIndicator
end

oUF:RegisterMetaFunction("CreateQuestIndicator", UF.CreateQuestIndicator)

function UF:ConfigureQuestIndicator()
    local config = self.config.questIndicator
    if not config.enabled then
        self:DisableElement("QuestIndicator")
        return
    elseif not self.QuestIndicator then
        self:CreateQuestIndicator()
    end

    self:EnableElement("QuestIndicator")

    self.QuestIndicator:SetSize(unpack(config.size))
    self.QuestIndicator:ClearAllPoints()
    self.QuestIndicator:Point(unpack(config.point))
end

oUF:RegisterMetaFunction("ConfigureQuestIndicator", UF.ConfigureQuestIndicator)
