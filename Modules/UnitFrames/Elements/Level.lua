local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateLevel = function(self)
    self.LevelParent = CreateFrame("Frame", nil, self)
    self.LevelParent:SetFrameLevel(self:GetFrameLevel() + 10)

    self.Level = self.LevelParent:CreateFontString("$parentLevel", "ARTWORK")
    self.Level:SetFont(UF.config.font, 12, "THICKOUTLINE")

    self:Tag(self.Level, "[difficultycolor][level]")

    return self.Level
end

oUF:RegisterMetaFunction("CreateLevel", UF.CreateLevel)

UF.UpdateLevel = function(self)
    if not self.Level then
        return
    end

    local cfg = self.cfg.level
    if cfg.enabled then
        self.Level:Show()
        self.Level:SetFont(cfg.font or UF.config.font, cfg.fontSize or 13, cfg.fontOutline or "OUTLINE")
        self.Level:SetJustifyH(cfg.justifyH or "CENTER")
        self.Level:SetShadowOffset(cfg.fontShadow and 1 or 0, cfg.fontShadow and -1 or 0)

        self.Level:ClearAllPoints()
        self.Level:SetAllPoints(self.LevelParent)

        self.LevelParent:SetSize(unpack(cfg.size))
        self.LevelParent:SetPoint(unpack(cfg.point))

        if cfg.tag then
            self:Tag(self.Level, cfg.tag)
        end
    else
        self.Level:Hide()
    end
end

oUF:RegisterMetaFunction("UpdateLevel", UF.UpdateLevel)
