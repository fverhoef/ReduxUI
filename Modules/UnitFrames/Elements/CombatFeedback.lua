local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateCombatFeedback = function(self)
    local cfg = self.cfg.combatfeedback
    self.CombatFeedbackText = self:CreateFontString(nil, "OVERLAY")
    if self.Portrait then
        self.CombatFeedbackText:SetPoint("CENTER", self.Portrait, "CENTER")
    else
        self.CombatFeedbackText:SetPoint("CENTER", self.Health, "CENTER")
    end
    self.CombatFeedbackText:SetFont(UF.config.font, cfg.fontSize or 19, "OUTLINE")
    self.CombatFeedbackText.ignoreImmune = cfg.ignoreImmune
    self.CombatFeedbackText.ignoreDamage = cfg.ignoreDamage
    self.CombatFeedbackText.ignoreHeal = cfg.ignoreHeal
    self.CombatFeedbackText.ignoreEnergize = cfg.ignoreEnergize
    self.CombatFeedbackText.ignoreOther = cfg.ignoreOther

    return self.CombatFeedbackText
end

oUF:RegisterMetaFunction("CreateCombatFeedback", UF.CreateCombatFeedback)

UF.UpdateCombatFeedback = function(self)
    if self.cfg.combatfeedback.enabled then
        self:EnableElement("CombatFeedbackText")
    else
        self:DisableElement("CombatFeedbackText")
    end
end

oUF:RegisterMetaFunction("UpdateCombatFeedback", UF.UpdateCombatFeedback)