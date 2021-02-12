local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateCombatFeedback = function(self)
    local config = self.config.combatfeedback
    self.CombatFeedbackText = self:CreateFontString(nil, "OVERLAY")
    if self.Portrait then
        self.CombatFeedbackText:SetPoint("CENTER", self.Portrait, "CENTER")
    else
        self.CombatFeedbackText:SetPoint("CENTER", self.Health, "CENTER")
    end
    self.CombatFeedbackText:SetFont(UF.config.font, config.fontSize or 19, "OUTLINE")
    self.CombatFeedbackText.ignoreImmune = config.ignoreImmune
    self.CombatFeedbackText.ignoreDamage = config.ignoreDamage
    self.CombatFeedbackText.ignoreHeal = config.ignoreHeal
    self.CombatFeedbackText.ignoreEnergize = config.ignoreEnergize
    self.CombatFeedbackText.ignoreOther = config.ignoreOther

    return self.CombatFeedbackText
end

oUF:RegisterMetaFunction("CreateCombatFeedback", UF.CreateCombatFeedback)

UF.UpdateCombatFeedback = function(self)
    local config = self.config.combatfeedback
    if config.enabled then
        self:EnableElement("CombatFeedbackText")

        self.CombatFeedbackText:SetFont(config.font or UF.config.font, config.fontSize or 19, config.fontOutline or "OUTLINE")
        self.CombatFeedbackText:SetShadowOffset(config.fontShadow and 1 or 0, config.fontShadow and -1 or 0)
        
        self.CombatFeedbackText.ignoreImmune = config.ignoreImmune
        self.CombatFeedbackText.ignoreDamage = config.ignoreDamage
        self.CombatFeedbackText.ignoreHeal = config.ignoreHeal
        self.CombatFeedbackText.ignoreEnergize = config.ignoreEnergize
        self.CombatFeedbackText.ignoreOther = config.ignoreOther
    else
        self:DisableElement("CombatFeedbackText")
    end
end

oUF:RegisterMetaFunction("UpdateCombatFeedback", UF.UpdateCombatFeedback)