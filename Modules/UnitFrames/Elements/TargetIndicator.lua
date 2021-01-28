local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateTargetIndicator = function(self)
    self.TargetIndicator = CreateFrame("Frame", self:GetName() .. "TargetIndicator", self)
    self.TargetIndicator:SetFrameLevel(0)

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

    self:RegisterEvent("PLAYER_TARGET_CHANGED", function(self)
        UF.UpdateTargetIndicator(self)
    end, true)

    UF.UpdateTargetIndicator(self)

    return self.TargetIndicator
end

UF.UpdateTargetIndicator = function(self)
    if self.unit and UnitIsUnit(self.unit, "target") then
        if self.cfg.targetGlow then
            self:SetShadowColor({1, 1, 1, 0.7})
        else
            self:SetShadowColor({0, 0, 0, 0.7})
        end
        if self.cfg.targetArrows then
            self.TargetIndicator.Left:Show()
            self.TargetIndicator.Right:Show()
        else
            self.TargetIndicator.Left:Hide()
            self.TargetIndicator.Right:Hide()
        end
    else
        self:SetShadowColor({0, 0, 0, 0.7})
        self.TargetIndicator.Left:Hide()
        self.TargetIndicator.Right:Hide()
    end
end