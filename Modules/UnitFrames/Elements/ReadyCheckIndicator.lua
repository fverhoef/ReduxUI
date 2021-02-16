local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateReadyCheckIndicator = function(self)
    self.ReadyCheckIndicator = self:CreateTexture("$parentReadyCheckIcon", "OVERLAY", nil, 7)
    self.ReadyCheckIndicator:SetParent(self.Overlay)
    self.ReadyCheckIndicator.delayTime = 2
    self.ReadyCheckIndicator.fadeTime = 0.5

    return self.ReadyCheckIndicator
end

oUF:RegisterMetaFunction("CreateReadyCheckIndicator", UF.CreateReadyCheckIndicator)

UF.UpdateReadyCheckIndicator = function(self)
    if not self.ReadyCheckIndicator then
        return
    end

    local config = self.config.readyCheckIndicator
    if config.enabled then
        self:EnableElement("ReadyCheckIndicator")

        self.ReadyCheckIndicator:SetSize(unpack(config.size))
        self.ReadyCheckIndicator:ClearAllPoints()
        self.ReadyCheckIndicator:Point(unpack(config.point))
    else
        self:DisableElement("ReadyCheckIndicator")
    end
end

oUF:RegisterMetaFunction("UpdateReadyCheckIndicator", UF.UpdateReadyCheckIndicator)