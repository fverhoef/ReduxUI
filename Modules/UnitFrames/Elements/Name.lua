local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreateName = function(self, fontSize)
    self.Name = self:CreateFontString("$parentName", "OVERLAY")
    self.Name:SetFont(UF.config.db.profile.font, fontSize or 13, "OUTLINE")
    -- self.Name:SetShadowOffset(1, -1)
    self.Name:SetJustifyH("CENTER")
    self.Name:SetHeight(10)
    self:Tag(self.Name, "[name]")

    return self.Name
end