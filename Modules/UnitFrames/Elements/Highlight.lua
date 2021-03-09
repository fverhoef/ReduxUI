local addonName, ns = ...
local R = _G.ReduxUI
local CS = R.Modules.CharacterStats
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateHighlight()
end

oUF:RegisterMetaFunction("CreateHighlight", UF.CreateHighlight)

function UF:UpdateHighlight()
    if not self then 
        return
    end

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

    local borderColor = config.colorBorder and color or self.config.border.color
    self.Border:SetVertexColor(unpack(borderColor))
    
    local shadowColor = config.colorShadow and color or self.config.shadow.color
    self.Shadow:SetBackdropBorderColor(unpack(shadowColor))
    
    self.Artwork.Highlight:SetVertexColor(unpack(borderColor))
    self.Artwork.Highlight:SetShown(config.colorBorder and color and true or false)
end

oUF:RegisterMetaFunction("UpdateHighlight", UF.UpdateHighlight)