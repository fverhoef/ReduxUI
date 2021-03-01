local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateThreatIndicator()
    self.ThreatIndicator = self:CreateTexture("$parentThreat", "BACKGROUND")

    if self.unit == "target" or self.unit == "focus" or string.match(self.unit, "nameplate") then
        self.ThreatIndicator.feedbackUnit = "player"
    end

    self.ThreatIndicator.PostUpdate = UF.ThreatIndicator_PostUpdate

    return self.ThreatIndicator
end

oUF:RegisterMetaFunction("CreateThreatIndicator", UF.CreateThreatIndicator)

function UF:UpdateThreatIndicator()
    if not self.ThreatIndicator then
        return
    end

    local config = self.config.highlight
    if config.threat then
        self:EnableElement("ThreatIndicator")
    else
        self:DisableElement("ThreatIndicator")

        self.threatStatus = nil
        self.threatColor = nil
    end
end

oUF:RegisterMetaFunction("UpdateThreatIndicator", UF.UpdateThreatIndicator)

function UF:ThreatIndicator_PostUpdate(unit, status, r, g, b)
    local frame = self:GetParent()
    frame.threatStatus = status
    frame.threatColor = {r, g, b}
    frame:UpdateHighlight()
end
