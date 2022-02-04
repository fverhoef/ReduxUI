local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreatePhaseIndicator()
    if not self.config.phaseIndicator.enabled then
        return
    end

    self.PhaseIndicator = self:CreateTexture("$parentPhaseIcon", "OVERLAY")
    self.PhaseIndicator:SetParent(self.Overlay)
    self.PhaseIndicator:SetSize(18, 18)

    return self.PhaseIndicator
end

oUF:RegisterMetaFunction("CreatePhaseIndicator", UF.CreatePhaseIndicator)

function UF:ConfigurePhaseIndicator()
    local config = self.config.phaseIndicator
    if not config.enabled then
        self:DisableElement("PhaseIndicator")
        return
    elseif not self.PhaseIndicator then
        self:CreatePhaseIndicator()
    end

    self:EnableElement("PhaseIndicator")

    self.PhaseIndicator:SetSize(unpack(config.size))
    self.PhaseIndicator:ClearAllPoints()
    self.PhaseIndicator:Point(unpack(config.point))
end

oUF:RegisterMetaFunction("ConfigurePhaseIndicator", UF.ConfigurePhaseIndicator)
