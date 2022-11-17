local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

local ANIMATION_REFRESH_RATE = 0.05

function UF:CreateHighlight()
    self.highlightAnimationCounter = 0
    self.highlightAnimationSign = -1
end

oUF:RegisterMetaFunction("CreateHighlight", UF.CreateHighlight)

function UF:UpdateHighlight()
    local config = self.config.highlight
    local animate = config.animate

    local color
    if config.debuffs and self.debuffColor then
        color = self.debuffColor
    elseif config.threat and self.threatStatus and self.threatStatus > 0 then
        color = self.threatColor
    elseif config.target and self.isTarget then
        animate = false
        if config.targetClassColor then
            local class = select(2, UnitClass(self.unit))
            color = UF.config.colors.class[class]
        end
        color = color or UF.config.colors.targetHighlight
    elseif config.combat and self.inCombat then
        color = UF.config.colors.combatHighlight
    elseif config.resting and self.isResting then
        color = UF.config.colors.restingHighlight
    end

    if color and not color[4] then
        color[4] = 1
    end

    if self.Border then
        self.Border:SetBackdropBorderColor(unpack(config.colorBorder and color or R.DEFAULT_BORDER_COLOR))
    end
    if self.Shadow then
        self.Shadow:SetBackdropBorderColor(unpack(config.colorShadow and color or R.DEFAULT_SHADOW_COLOR))
    end
    if self.Flash and self.config.style ~= UF.Styles.Custom then
        self.Flash:SetShown(color ~= nil)
        if color then
            self.Flash:SetVertexColor(unpack(color))
        end
    end

    if color and animate and not self.highlightAnimationTimer then
        self.highlightAnimationTimer = UF:ScheduleRepeatingTimer(self.UpdateHighlightAnimation, ANIMATION_REFRESH_RATE, self)
    elseif not color or not animate and self.highlightAnimationTimer then
        UF:CancelTimer(self.highlightAnimationTimer)
        self.highlightAnimationTimer = nil
        if self.Flash and self.config.style ~= UF.Styles.Custom then
            self.Flash:SetShown(color ~= nil)
        end
        self:UpdateHighlightAnimation()
    end
end

oUF:RegisterMetaFunction("UpdateHighlight", UF.UpdateHighlight)

function UF:UpdateHighlightAnimation()
    local config = self.config.highlight

    local alpha = 1
    if config.animate and self.highlightAnimationTimer then
        alpha = 255
        local counter = self.highlightAnimationCounter + ANIMATION_REFRESH_RATE
        local sign = self.highlightAnimationSign

        if counter > 0.5 then
            sign = -sign
            self.highlightAnimationSign = sign
        end
        counter = mod(counter, 0.5)
        self.highlightAnimationCounter = counter

        if sign == 1 then
            alpha = (55 + (counter * 400)) / 255
        else
            alpha = (255 - (counter * 400)) / 255
        end
    end

    if self.Border and self.config.style ~= UF.Styles.Blizzard then
        self.Border:SetAlpha(config.colorBorder and alpha or 1)
    end
    if self.Shadow and self.config.style ~= UF.Styles.Blizzard then
        self.Shadow:SetAlpha(config.colorShadow and alpha or 1)
    end
    if self.Flash and self.config.style == UF.Styles.Blizzard then
        self.Flash:SetAlpha(alpha)
    end
end

oUF:RegisterMetaFunction("UpdateHighlightAnimation", UF.UpdateHighlightAnimation)
