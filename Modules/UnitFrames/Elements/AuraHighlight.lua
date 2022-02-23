local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateAuraHighlight()
    if not self.config.highlight.debuffs then return end

    self.AuraHighlight = self:CreateTexture("$parentAuraHighlight", "OVERLAY")
    self.AuraHighlight:SetParent(self.Overlay)
    self.AuraHighlight:SetTexture(R.media.textures.blank)
    self.AuraHighlight:SetVertexColor(0, 0, 0, 0)
    self.AuraHighlight:SetBlendMode("ADD")
    self.AuraHighlight.PostUpdate = UF.AuraHighlight_PostUpdate
    self.AuraHighlight:SetInside(self)

    self.AuraHighlightBackdrop = false
    self.AuraHighlightFilter = false
    self.AuraHighlightFilterTable = {}

    return self.AuraHighlight
end

oUF:RegisterMetaFunction("CreateAuraHighlight", UF.CreateAuraHighlight)

function UF:ConfigureAuraHighlight()
    local config = self.config.highlight
    if not config.debuffs then
        self:DisableElement("AuraHighlight")
        self.debuffColor = nil
        return
    elseif not self.AuraHighlight then
        self:CreateAuraHighlight()
    end

    self:EnableElement("AuraHighlight")

    self.AuraHighlight:SetBlendMode(UF.config.colors.auraHighlight.blendMode)
    self.AuraHighlightFilter = config.onlyDispellableDebuffs
end

oUF:RegisterMetaFunction("ConfigureAuraHighlight", UF.ConfigureAuraHighlight)

function UF:AuraHighlight_PostUpdate(self, debuffType, texture, wasFiltered, style, color)
    self.debuffColor = not wasFiltered and debuffType and color and {color.r, color.g, color.b, color.a} or nil
    self:UpdateHighlight()
end
