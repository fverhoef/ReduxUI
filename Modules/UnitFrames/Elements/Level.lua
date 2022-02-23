local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateLevel()
    if not self.config.level.enabled then return end

    self.Level = self.Overlay:CreateFontString("$parentLevel", "OVERLAY")
    self.Level:SetFont(UF.config.font, 12, "THICKOUTLINE")

    return self.Level
end

oUF:RegisterMetaFunction("CreateLevel", UF.CreateLevel)

function UF:ConfigureLevel()
    local config = self.config.level
    if not config.enabled then
        if self.Level then
            self.Level:Hide()
            self:Untag(self.Level)
        end
        return
    elseif not self.Level then
        self:CreateLevel()
    end

    self.Level:Show()
    self.Level:SetFont(config.font or UF.config.font, config.fontSize or 13, config.fontOutline or "OUTLINE")
    self.Level:SetJustifyH(config.justifyH or "CENTER")
    self.Level:SetShadowOffset(config.fontShadow and 1 or 0, config.fontShadow and -1 or 0)

    self.Level:ClearAllPoints()
    self.Level:SetSize(unpack(config.size))
    self.Level:SetNormalizedPoint(unpack(config.point))

    if config.tag then
        self:Tag(self.Level, config.tag)
    else
        self:Untag(self.Level)
    end
end

oUF:RegisterMetaFunction("ConfigureLevel", UF.ConfigureLevel)
