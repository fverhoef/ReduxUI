local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateResurrectIndicator()
    if not self.config.resurrectIndicator.enabled then
        return
    end

    self.ResurrectIndicatorHolder = CreateFrame("Frame", "$parentResurrectIndicatorHolder", self)
    self.ResurrectIndicatorHolder:SetAllPoints(self.Overlay)
    self.ResurrectIndicatorHolder:SetParent(self.Overlay)
    self.ResurrectIndicatorHolder:SetFrameLevel(self.Overlay:GetFrameLevel() + 2)

    self.ResurrectIndicator = self.ResurrectIndicatorHolder:CreateTexture("$parentResurrectIcon", "OVERLAY")
    self.ResurrectIndicator:SetParent(self.Overlay)
    self.ResurrectIndicator:SetSize(16, 16)
end

oUF:RegisterMetaFunction("CreateResurrectIndicator", UF.CreateResurrectIndicator)

function UF:ConfigureResurrectIndicator()
    local config = self.config.resurrectIndicator
    if not config.enabled then
        self:DisableElement("ResurrectIndicator")
        return
    elseif not self.ResurrectIndicator then
        self:CreateResurrectIndicator()
    end

    self:EnableElement("ResurrectIndicator")

    self.ResurrectIndicator:SetSize(unpack(config.size))
    self.ResurrectIndicator:ClearAllPoints()
    self.ResurrectIndicator:SetNormalizedPoint(unpack(config.point))
end

oUF:RegisterMetaFunction("ConfigureResurrectIndicator", UF.ConfigureResurrectIndicator)
