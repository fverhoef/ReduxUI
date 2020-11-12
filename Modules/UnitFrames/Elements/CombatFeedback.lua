local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreateCombatFeedback = function(self)
    local cfg = self.cfg.combatfeedback
    self.CombatFeedbackText = self:CreateFontString(nil, "OVERLAY")
    if self.Portrait then
        self.CombatFeedbackText:SetPoint("CENTER", self.Portrait, "CENTER")
    else
        self.CombatFeedbackText:SetPoint("CENTER", self.Health, "CENTER")
    end
    self.CombatFeedbackText:SetFont(UF.config.db.profile.font, cfg.fontSize or 19, "OUTLINE")
    self.CombatFeedbackText.ignoreImmune = cfg.ignoreImmune
    self.CombatFeedbackText.ignoreDamage = cfg.ignoreDamage
    self.CombatFeedbackText.ignoreHeal = cfg.ignoreHeal
    self.CombatFeedbackText.ignoreEnergize = cfg.ignoreEnergize
    self.CombatFeedbackText.ignoreOther = cfg.ignoreOther

    return self.CombatFeedbackText
end

UF.UpdateCombatFeedback = function(self)
    if self.cfg.combatfeedback.enabled then -- TODO: enable/disable this properly
        self.CombatFeedbackText:Show()
    else
        self.CombatFeedbackText:Hide()
    end
end