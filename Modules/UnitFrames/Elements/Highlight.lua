local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateHighlight()
    self.Highlight = self:CreateTexture("$parentHighlight", "BACKGROUND")
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
        color = UF.config.colors.targetHighlight
    end

    local borderColor = config.colorBorder and color or R.config.db.profile.borders.color
    self:SetBorderColor(unpack(borderColor))
    self.Highlight:SetVertexColor(unpack(borderColor))
    self.Highlight:SetShown(config.colorBorder and color and true or false)
    
    local shadowColor = config.colorShadow and color or R.config.db.profile.shadows.color
    self:SetShadowColor(unpack(shadowColor))
end

oUF:RegisterMetaFunction("UpdateHighlight", UF.UpdateHighlight)