local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateCombatIndicator = function(self)
    self.CombatIndicator = self:CreateTexture("$parentCombatIcon", "OVERLAY")
    self.CombatIndicator:SetParent(self.Overlay)
    self.CombatIndicator:SetDrawLayer("OVERLAY", 7)

    self.CombatIndicator.Glow = self:CreateTexture("$parentCombatIconGlow", "OVERLAY")
    self.CombatIndicator.Glow:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
    self.CombatIndicator.Glow:SetTexCoord(0.5, 1.0, 0.5, 1.0)
    self.CombatIndicator.Glow:SetVertexColor(1.0, 0.0, 0.0)
    self.CombatIndicator.Glow:SetBlendMode("ADD")
    self.CombatIndicator.Glow:SetSize(32, 32)
    self.CombatIndicator.Glow:SetAllPoints(self.CombatIndicator)
    self.CombatIndicator.Glow:SetAlpha(0)
    self.CombatIndicator.Glow:Hide()

    return self.CombatIndicator
end

oUF:RegisterMetaFunction("CreateCombatIndicator", UF.CreateCombatIndicator)

UF.UpdateCombatIndicator = function(self)
    if not self.CombatIndicator then
        return
    end

    local config = self.config.combatIndicator
    if config.enabled then
        self:EnableElement("CombatIndicator")

        self.CombatIndicator:SetSize(unpack(config.size))
        self.CombatIndicator:ClearAllPoints()
        self.CombatIndicator:Point(unpack(config.point))
    else
        self:DisableElement("CombatIndicator")
    end
end

oUF:RegisterMetaFunction("UpdateCombatIndicator", UF.UpdateCombatIndicator)