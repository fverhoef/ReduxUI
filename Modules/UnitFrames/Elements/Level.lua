local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateLevel = function(self)
    self.LevelParent = CreateFrame("Frame", nil, self)
    self.LevelParent:SetFrameLevel(self:GetFrameLevel() + 10)

    self.Level = self.LevelParent:CreateFontString("$parentLevel", "ARTWORK")
    self.Level:SetFont(R.config.db.profile.modules.unitFrames.font, 12, "THICKOUTLINE")
    self.Level:SetShadowOffset(0, 0)
    self:Tag(self.Level, "[difficultycolor][level]")

    return self.Level
end

oUF:RegisterMetaFunction("CreateLevel", UF.CreateLevel)