local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateHighlight()
end

oUF:RegisterMetaFunction("CreateHighlight", UF.CreateHighlight)

function UF:UpdateHighlight()
    local config = self.config.highlight

    local color
    if config.debuffs and self.debuffColor then
        color = self.debuffColor
    elseif config.threat and self.threatStatus and self.threatStatus > 0 then
        color = self.threatColor
    elseif config.target and self.isTarget then
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

    if self.Border then
        self.Border:SetBackdropBorderColor(unpack(config.colorBorder and color or R.DEFAULT_BORDER_COLOR))
    end
    if self.Shadow then
        self.Shadow:SetBackdropBorderColor(unpack(config.colorShadow and color or R.DEFAULT_SHADOW_COLOR))
    end
    if self.Flash and self.config ~= UF.Styles.Custom then
        if color then
            self.Flash:Show()
            self.Flash:SetVertexColor(unpack(color))
        else
            self.Flash:Hide()
        end
    end
end

oUF:RegisterMetaFunction("UpdateHighlight", UF.UpdateHighlight)
