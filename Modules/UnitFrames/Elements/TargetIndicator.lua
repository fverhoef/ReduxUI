local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateTargetIndicator()
    if not self.config.highlight.target and not self.config.highlight.targetArrows then
        return
    end

    self.TargetIndicator = CreateFrame("Frame", self:GetName() .. "TargetIndicator", self)
    self.TargetIndicator:SetFrameLevel(self:GetFrameLevel() - 1)
    self.TargetIndicator.PostUpdate = UF.TargetIndicator_PostUpdate

    self.TargetIndicator.LeftArrow = self.TargetIndicator:CreateTexture(nil, "BACKGROUND", nil, -5)
    self.TargetIndicator.LeftArrow:SetTexture(R.media.textures.arrow1)
    self.TargetIndicator.LeftArrow:SetRotation(-math.pi / 2)
    self.TargetIndicator.LeftArrow:SetSize(16, 16)
    self.TargetIndicator.LeftArrow:SetPoint("RIGHT", self.Health, "LEFT", -5, 0)
    self.TargetIndicator.LeftArrow:Hide()

    self.TargetIndicator.RightArrow = self.TargetIndicator:CreateTexture(nil, "BACKGROUND", nil, -5)
    self.TargetIndicator.RightArrow:SetTexture(R.media.textures.arrow1)
    self.TargetIndicator.RightArrow:SetRotation(math.pi / 2)
    self.TargetIndicator.RightArrow:SetSize(16, 16)
    self.TargetIndicator.RightArrow:SetPoint("LEFT", self.Health, "RIGHT", 5, 0)
    self.TargetIndicator.RightArrow:Hide()

    return self.TargetIndicator
end

oUF:RegisterMetaFunction("CreateTargetIndicator", UF.CreateTargetIndicator)

function UF:ConfigureTargetIndicator()
    local config = self.config.highlight
    if not (config.target or config.targetArrows) then
        self:DisableElement("TargetIndicator")
        self.isTarget = false
        return
    elseif not self.TargetIndicator then
        self:CreateTargetIndicator()
    end

    self:EnableElement("TargetIndicator")
end

oUF:RegisterMetaFunction("ConfigureTargetIndicator", UF.ConfigureTargetIndicator)

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
