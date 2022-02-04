local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateReadyCheckIndicator()
    if not self.config.readyCheckIndicator.enabled then return end

    self.ReadyCheckIndicator = self:CreateTexture("$parentReadyCheckIcon", "OVERLAY", nil, 7)
    self.ReadyCheckIndicator:SetParent(self.Overlay)
    self.ReadyCheckIndicator.delayTime = 2
    self.ReadyCheckIndicator.fadeTime = 0.5

    -- TODO: oUF's ready check element only works on party/unit

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
    self.ReadyCheckIndicator:Point(unpack(config.point))
end

oUF:RegisterMetaFunction("ConfigureReadyCheckIndicator", UF.ConfigureReadyCheckIndicator)
