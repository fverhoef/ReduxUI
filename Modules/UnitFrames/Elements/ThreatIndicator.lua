local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateThreatIndicator()
    if not self.config.highlight.threat then
        return
    end

    self.ThreatIndicator = self:CreateTexture("$parentThreat", "BACKGROUND")

    if self.unit == "target" or self.unit == "focus" or string.match(self.unit, "nameplate") then
        self.ThreatIndicator.feedbackUnit = "player"
    end

    self.ThreatIndicator.PostUpdate = UF.ThreatIndicator_PostUpdate

    return self.ThreatIndicator
end

oUF:RegisterMetaFunction("CreateThreatIndicator", UF.CreateThreatIndicator)

function UF:ConfigureThreatIndicator()
    local config = self.config.highlight
    if not config.threat then
        self:DisableElement("ThreatIndicator")
        self.threatStatus = nil
        self.threatColor = nil
        return
    elseif not self.ThreatIndicator then
        self:CreateThreatIndicator()
    end

    self:EnableElement("ThreatIndicator")
end

oUF:RegisterMetaFunction("ConfigureThreatIndicator", UF.ConfigureThreatIndicator)

function UF:ThreatIndicator_PostUpdate(unit, status, r, g, b)
    local frame = self:GetParent()
    frame.threatStatus = status
    frame.threatColor = { r, g, b }
    frame:UpdateHighlight()
end
