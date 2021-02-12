local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateLevel = function(self)
    self.Level = self:CreateFontString("$parentLevel", "ARTWORK")
    self.Level:SetParent(self.Overlay)
    self.Level:SetFont(UF.config.font, 12, "THICKOUTLINE")

    self:Tag(self.Level, "[difficultycolor][level]")

    return self.Level
end

oUF:RegisterMetaFunction("CreateLevel", UF.CreateLevel)

UF.UpdateLevel = function(self)
    if not self.Level then
        return
    end

    local config = self.config.level
    if config.enabled then
        self.Level:Show()
        self.Level:SetFont(config.font or UF.config.font, config.fontSize or 13, config.fontOutline or "OUTLINE")
        self.Level:SetJustifyH(config.justifyH or "CENTER")
        self.Level:SetShadowOffset(config.fontShadow and 1 or 0, config.fontShadow and -1 or 0)

        self.Level:ClearAllPoints()
        self.Level:SetSize(unpack(config.size))
        self.Level:SetPoint(unpack(config.point))

        if config.tag then
            self:Tag(self.Level, config.tag)
        end
    else
        self.Level:Hide()
    end
end

oUF:RegisterMetaFunction("UpdateLevel", UF.UpdateLevel)
