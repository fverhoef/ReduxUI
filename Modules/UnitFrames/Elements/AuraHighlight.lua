local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateAuraHighlight = function(self)
    self.AuraHighlight = self:CreateTexture("$parentAuraHighlight", "OVERLAY")
    self.AuraHighlight:SetParent(self.Overlay)
    self.AuraHighlight:SetInside(self)
    self.AuraHighlight:SetTexture(R.media.textures.blank)
    self.AuraHighlight:SetVertexColor(0, 0, 0, 0)
    self.AuraHighlight:SetBlendMode("ADD")
    self.AuraHighlight.PostUpdate = UF.PostUpdate_AuraHighlight

    self.AuraHightlightGlow = self:CreateShadow(nil, nil, true)
    self.AuraHightlightGlow:Hide()

    self.AuraHighlightFilter = false
    self.AuraHighlightFilterTable = {}

    return self.AuraHighlight
end

oUF:RegisterMetaFunction("CreateAuraHighlight", UF.CreateAuraHighlight)

UF.UpdateAuraHighlight = function(self)
    if not self.AuraHighlight then
        return
    end

    local config = self.config.auraHighlight
    if config.enabled then
        self:EnableElement("AuraHighlight")

        self.AuraHighlight:SetBlendMode(UF.config.colors.auraHighlight.blendMode)
        self.AuraHighlight:SetAllPoints(self.Health:GetStatusBarTexture())

        self.AuraHighlightBackdrop = config.glow
        self.AuraHighlightBorder = config.border
    else
        self:EnableElement("AuraHighlight")
    end
end

oUF:RegisterMetaFunction("UpdateAuraHighlight", UF.UpdateAuraHighlight)

function UF:PostUpdate_AuraHighlight(object, debuffType, texture, wasFiltered, style, color)
    --if self.AuraHighlightBorder then
        if debuffType and not wasFiltered and color then
            object:SetBorderColor(color.r, color.g, color.b, color.a)
        else
            object:SetBorderColor(unpack(R.config.db.profile.borders.color))
        end
    --end
end
