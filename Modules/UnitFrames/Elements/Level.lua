local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreateLevel = function(self)
    self.Level = self:CreateFontString("$parentLevel", "ARTWORK")
    self.Level:SetFont(UF.config.db.profile.font, 12, "THICKOUTLINE")
    self.Level:SetShadowOffset(0, 0)
    self:Tag(self.Level, "[difficultycolor][level]")

    return self.Level
end