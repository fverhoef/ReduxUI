local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateRestingIndicator()
    self.RestingIndicator = self:CreateTexture("$parentRestingIcon", "OVERLAY")
    self.RestingIndicator:SetParent(self.Overlay)
    self.RestingIndicator:SetDrawLayer("OVERLAY", 7)
    self.RestingIndicator:SetSize(31, 31) -- 31,34

    self.RestingIndicator.Glow = self:CreateTexture("$parentRestingIconGlow", "OVERLAY")
    self.RestingIndicator.Glow:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
    self.RestingIndicator.Glow:SetTexCoord(0.0, 0.5, 0.5, 1.0)
    self.RestingIndicator.Glow:SetBlendMode("ADD")
    self.RestingIndicator.Glow:SetAllPoints(self.RestingIndicator)
    self.RestingIndicator.Glow:SetAlpha(0)
    self.RestingIndicator.Glow:Hide()

    return self.RestingIndicator
end

oUF:RegisterMetaFunction("CreateRestingIndicator", UF.CreateRestingIndicator)

function UF:UpdateRestingIndicator()
    if not self.RestingIndicator then
        return
    end

    local config = self.config.restingIndicator
    if config.enabled then
        self:EnableElement("RestingIndicator")

        self.RestingIndicator:SetSize(unpack(config.size))
        self.RestingIndicator:ClearAllPoints()
        self.RestingIndicator:Point(unpack(config.point))
    else
        self:DisableElement("RestingIndicator")
    end
end

oUF:RegisterMetaFunction("UpdateRestingIndicator", UF.UpdateRestingIndicator)