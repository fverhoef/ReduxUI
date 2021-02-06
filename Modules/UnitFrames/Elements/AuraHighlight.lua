local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateAuraHighlight = function(self)
    self.AuraHighlight = self:CreateTexture("$parentAuraHighlight", "OVERLAY")
    self.AuraHighlight:SetInside(self)
    self.AuraHighlight:SetTexture(R.media.textures.blank)
    self.AuraHighlight:SetVertexColor(0, 0, 0, 0)
    self.AuraHighlight:SetBlendMode("ADD")
    self.AuraHighlight.PostUpdate = UF.PostUpdate_AuraHighlight

    self.AuraHightlightGlow = self:CreateShadow(nil, nil, true)
    self.AuraHightlightGlow:Hide()

    self.AuraHighlightFilter = false
    self.AuraHighlightFilterTable = {}

    if self.Health then
        self.AuraHighlight:SetParent(self.Health)
        self.AuraHightlightGlow:SetParent(self.Health)
    end

    return self.AuraHighlight
end

oUF:RegisterMetaFunction("CreateAuraHighlight", UF.CreateAuraHighlight)

UF.UpdateAuraHighlight = function(self)
    local cfg = self.cfg.auraHighlight
    if cfg and cfg.enabled then
        self:EnableElement("AuraHighlight")

        self.AuraHighlight:SetBlendMode(UF.config.colors.auraHighlight.blendMode)
        self.AuraHighlight:SetAllPoints(self.Health:GetStatusBarTexture())

        if cfg.mode == "GLOW" then
            self.AuraHighlightBackdrop = true
            if self.ThreatIndicator then
                self.AuraHightlightGlow:SetAllPoints(self.ThreatIndicator.MainGlow)
            elseif self.TargetGlow then
                self.AuraHightlightGlow:SetAllPoints(self.TargetGlow)
            end
        else
            self.AuraHighlightBackdrop = false
        end
    else
        self:EnableElement("AuraHighlight")
    end
end

oUF:RegisterMetaFunction("UpdateAuraHighlight", UF.UpdateAuraHighlight)

function UF:PostUpdate_AuraHighlight(object, debuffType, _, wasFiltered)
    if debuffType and not wasFiltered then
        local color = UF.config.colors.auraHighlight[debuffType]
        if object.AuraHighlightBackdrop and object.AuraHightlightGlow then
            object.AuraHightlightGlow:SetBackdropBorderColor(unpack(color))
        else
            object.AuraHighlight:SetVertexColor(unpack(color))
        end
    end
end
