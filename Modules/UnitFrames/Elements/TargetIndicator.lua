local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateTargetIndicator = function(self)
    self.TargetIndicator = CreateFrame("Frame", self:GetName() .. "TargetIndicator", self)
    self.TargetIndicator:SetFrameLevel(self:GetFrameLevel() - 1)
    self.TargetIndicator.PostUpdate = UF.TargetIndicator_PostUpdate

    self.TargetIndicator.Left = self.TargetIndicator:CreateTexture(nil, "BACKGROUND", nil, -5)
    self.TargetIndicator.Left:SetTexture(R.media.textures.arrow)
    self.TargetIndicator.Left:SetRotation(-math.pi / 2)
    self.TargetIndicator.Left:SetSize(16, 16)
    self.TargetIndicator.Left:SetPoint("RIGHT", self.Health, "LEFT", 0, 0)
    self.TargetIndicator.Left:Hide()

    self.TargetIndicator.Right = self.TargetIndicator:CreateTexture(nil, "BACKGROUND", nil, -5)
    self.TargetIndicator.Right:SetTexture(R.media.textures.arrow)
    self.TargetIndicator.Right:SetRotation(math.pi / 2)
    self.TargetIndicator.Right:SetSize(16, 16)
    self.TargetIndicator.Right:SetPoint("LEFT", self.Health, "RIGHT", 0, 0)
    self.TargetIndicator.Right:Hide()

    return self.TargetIndicator
end

oUF:RegisterMetaFunction("CreateTargetIndicator", UF.CreateTargetIndicator)

UF.UpdateTargetIndicator = function(self)
    if not self.TargetIndicator then
        return
    end

    local config = self.config.target
    if config.enabled then
        self:EnableElement("TargetIndicator")
    else
        self:DisableElement("TargetIndicator")
    end
end

oUF:RegisterMetaFunction("UpdateTargetIndicator", UF.UpdateTargetIndicator)

local forcingUpdate
function UF:TargetIndicator_PostUpdate(visible)
    if forcingUpdate then
        return
    end

    local frame = self:GetParent()

    frame.borderHasTargetColor = false
    frame.shadowHasTargetColor = false

    if visible then
        if frame.config.target.border then
            frame:SetBorderColor(1, 1, 1)
            frame.borderHasTargetColor = true
        elseif not frame.borderHasThreatColor then
            frame:SetBorderColor(unpack(R.config.db.profile.borders.color))
        end
        if frame.config.target.glow then
            frame:SetShadowColor(1, 1, 1)
        elseif not frame.shadowHasThreatColor then
            frame:SetShadowColor(0, 0, 0)
            frame.shadowHasTargetColor = true
        end
        if frame.config.target.arrows then
            self.Left:Show()
            self.Right:Show()
        else
            self.Left:Hide()
            self.Right:Hide()
        end
    else
        if not frame.borderHasThreatColor then
            frame:SetBorderColor(unpack(R.config.db.profile.borders.color))
        end
        if not frame.shadowHasThreatColor then
            frame:SetShadowColor(0, 0, 0)
        end
        self.Left:Hide()
        self.Right:Hide()
    end

    if frame.ThreatIndicator and frame.ThreatIndicator:IsShown() then
        forcingUpdate = true
        frame.ThreatIndicator:ForceUpdate()
    end
    forcingUpdate = false
end
