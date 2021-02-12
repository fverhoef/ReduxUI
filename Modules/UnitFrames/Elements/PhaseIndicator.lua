local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreatePhaseIndicator = function(self)
    self.PhaseIndicator = self:CreateTexture("$parentPhaseIcon", "OVERLAY")
    self.PhaseIndicator:SetParent(self.Overlay)
    self.PhaseIndicator:SetSize(18, 18)

    return self.PhaseIndicator
end

oUF:RegisterMetaFunction("CreatePhaseIndicator", UF.CreatePhaseIndicator)

UF.UpdatePhaseIndicator = function(self)
    if not self.PhaseIndicator then
        return
    end

    local config = self.config.phaseIndicator
    if config.enabled then
        self:EnableElement("PhaseIndicator")

        self.PhaseIndicator:SetSize(unpack(config.size))
        self.PhaseIndicator:ClearAllPoints()
        self.PhaseIndicator:SetPoint(unpack(config.point))
    else
        self:DisableElement("PhaseIndicator")
    end
end

oUF:RegisterMetaFunction("UpdatePhaseIndicator", UF.UpdatePhaseIndicator)