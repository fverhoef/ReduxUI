local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateReadyCheckIndicator()
    if not self.config.readyCheckIndicator.enabled then
        return
    end

    self.ReadyCheckIndicatorHolder = CreateFrame("Frame", "$parentReadyCheckIndicatorHolder", self)
    self.ReadyCheckIndicatorHolder:SetAllPoints(self.Overlay)
    self.ReadyCheckIndicatorHolder:SetParent(self.Overlay)
    self.ReadyCheckIndicatorHolder:SetFrameLevel(self.Overlay:GetFrameLevel() + 2)

    self.ReadyCheckIndicator = self.ReadyCheckIndicatorHolder:CreateTexture("$parentReadyCheckIcon", "OVERLAY")
    self.ReadyCheckIndicator:SetParent(self.Overlay)
    self.ReadyCheckIndicator.delayTime = 2
    self.ReadyCheckIndicator.fadeTime = 0.5

    return self.ReadyCheckIndicator
end

oUF:RegisterMetaFunction("CreateReadyCheckIndicator", UF.CreateReadyCheckIndicator)

function UF:ConfigureReadyCheckIndicator()
    local config = self.config.readyCheckIndicator
    if not config.enabled then
        self:DisableElement("ReadyCheckIndicator")
        return
    elseif not self.ReadyCheckIndicator then
        self:CreateReadyCheckIndicator()
    end

    self:EnableElement("ReadyCheckIndicator")

    self.ReadyCheckIndicator:SetSize(unpack(config.size))
    self.ReadyCheckIndicator:ClearAllPoints()
    self.ReadyCheckIndicator:SetNormalizedPoint(unpack(config.point))
end

oUF:RegisterMetaFunction("ConfigureReadyCheckIndicator", UF.ConfigureReadyCheckIndicator)
