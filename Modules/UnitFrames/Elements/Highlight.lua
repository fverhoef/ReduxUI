local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateHighlight()
end

oUF:RegisterMetaFunction("CreateHighlight", UF.CreateHighlight)

function UF:UpdateHighlight()
    if not self or (not self.Backdrop and not self.Shadow) then return end

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
    end

    if self.Backdrop and config.colorBorder then
        local borderColor = config.colorBorder and color or R.DEFAULT_BORDER_COLOR
        self.Backdrop:SetBackdropBorderColor(unpack(borderColor))
    end

    if self.Shadow and config.colorShadow then
        local shadowColor = config.colorShadow and color or R.DEFAULT_SHADOW_COLOR
        self.Shadow:SetBackdropBorderColor(unpack(color))
    end
end

oUF:RegisterMetaFunction("UpdateHighlight", UF.UpdateHighlight)
