local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateThreatIndicator = function(self)
    self.ThreatIndicator = self:CreateTexture("$parentThreat", "BACKGROUND")

    if self.unit == "target" or self.unit == "focus" or string.match(self.unit, "nameplate") then
        self.ThreatIndicator.feedbackUnit = "player"
    end

    self.ThreatIndicator.PostUpdate = UF.ThreatIndicator_PostUpdate

    return self.ThreatIndicator
end

oUF:RegisterMetaFunction("CreateThreatIndicator", UF.CreateThreatIndicator)

UF.UpdateThreatIndicator = function(self)
    if not self.ThreatIndicator then
        return
    end

    local config = self.config.threat
    if config.enabled then
        self:EnableElement("ThreatIndicator")
    else
        self:DisableElement("ThreatIndicator")
    end
end

oUF:RegisterMetaFunction("UpdateThreatIndicator", UF.UpdateThreatIndicator)

local forcingUpdate
function UF:ThreatIndicator_PostUpdate(unit, status, r, g, b)
    if forcingUpdate then
        return
    end

    local frame = self:GetParent()

    frame.borderHasThreatColor = false
    frame.shadowHasThreatColor = false

    if status and status > 0 then
        if not frame.borderHasTargetColor then
            if frame.config.threat.border then
                frame:SetBorderColor(r, g, b)
                frame.borderHasThreatColor = true
            else
                frame:SetBorderColor(unpack(R.config.db.profile.borders.color))
            end
        end
        if not frame.shadowHasTargetColor then
            if frame.config.threat.glow then
                frame:SetShadowColor(r, g, b)
                frame.shadowHasThreatColor = true
            else
                frame:SetShadowColor(0, 0, 0)
                frame.shadowHasTargetColor = true
            end
        end
    else
        if not frame.borderHasTargetColor then
            frame:SetBorderColor(unpack(R.config.db.profile.borders.color))
        end
        if not frame.shadowHasTargetColor then
            frame:SetShadowColor(0, 0, 0)
        end
    end

    if frame.TargetIndicator and frame.TargetIndicator:IsShown() then
        forcingUpdate = true
        frame.TargetIndicator:ForceUpdate()
    end
    forcingUpdate = false
end
