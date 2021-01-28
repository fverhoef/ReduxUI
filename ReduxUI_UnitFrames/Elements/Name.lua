local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames

UF.CreateName = function(self, fontSize)
    self.Name = self:CreateFontString("$parentName", "OVERLAY")
    self.Name:SetFont(R.config.db.profile.modules.unitFrames.font, fontSize or 13, "OUTLINE")
    -- self.Name:SetShadowOffset(1, -1)
    self.Name:SetJustifyH("CENTER")
    self.Name:SetHeight(10)
    self:Tag(self.Name, "[name]")

    return self.Name
end