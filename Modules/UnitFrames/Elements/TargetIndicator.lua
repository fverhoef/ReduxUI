local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateTargetIndicator()
    self.TargetIndicator = CreateFrame("Frame", self:GetName() .. "TargetIndicator", self)
    self.TargetIndicator:SetFrameLevel(self:GetFrameLevel() - 1)
    self.TargetIndicator.PostUpdate = UF.TargetIndicator_PostUpdate

    self.TargetIndicator.LeftArrow = self.TargetIndicator:CreateTexture(nil, "BACKGROUND", nil, -5)
    self.TargetIndicator.LeftArrow:SetTexture(R.media.textures.arrow)
    self.TargetIndicator.LeftArrow:SetRotation(-math.pi / 2)
    self.TargetIndicator.LeftArrow:SetSize(16, 16)
    self.TargetIndicator.LeftArrow:SetPoint("RIGHT", self.Health, "LEFT", 0, 0)
    self.TargetIndicator.LeftArrow:Hide()

    self.TargetIndicator.RightArrow = self.TargetIndicator:CreateTexture(nil, "BACKGROUND", nil, -5)
    self.TargetIndicator.RightArrow:SetTexture(R.media.textures.arrow)
    self.TargetIndicator.RightArrow:SetRotation(math.pi / 2)
    self.TargetIndicator.RightArrow:SetSize(16, 16)
    self.TargetIndicator.RightArrow:SetPoint("LEFT", self.Health, "RIGHT", 0, 0)
    self.TargetIndicator.RightArrow:Hide()

    return self.TargetIndicator
end

oUF:RegisterMetaFunction("CreateTargetIndicator", UF.CreateTargetIndicator)

function UF:UpdateTargetIndicator()
    if not self.TargetIndicator then
        return
    end

    local config = self.config.highlight
    if config.target or config.targetArrows then
        self:EnableElement("TargetIndicator")
    else
        self:DisableElement("TargetIndicator")

        self.isTarget = false
    end
end

oUF:RegisterMetaFunction("UpdateTargetIndicator", UF.UpdateTargetIndicator)

function UF:TargetIndicator_PostUpdate(visible)
    local frame = self:GetParent()
    frame.isTarget = visible
    frame:UpdateHighlight()

    local config = frame.config.highlight
    if visible and config.targetArrows then
        self.LeftArrow:Show()
        self.RightArrow:Show()
    else
        self.LeftArrow:Hide()
        self.RightArrow:Hide()
    end
end
