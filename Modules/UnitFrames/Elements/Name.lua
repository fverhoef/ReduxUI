local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateName = function(self)
    self.Name = self:CreateFontString("$parentName", "OVERLAY")
    self.Name:SetFont(UF.config.font, 13, "OUTLINE")
    -- self.Name:SetShadowOffset(1, -1)
    self.Name:SetJustifyH("CENTER")
    self.Name:SetHeight(10)
    self:Tag(self.Name, "[name]")

    return self.Name
end

oUF:RegisterMetaFunction("CreateName", UF.CreateName)

UF.UpdateName = function(self)
    if not self.Name then
        return
    end

    if self.cfg.name.enabled then
        self.Name:Show()
        self.Name:SetFont(UF.config.font, self.cfg.name.fontSize, "OUTLINE")
    else
        self.Name:Hide()
    end
end

oUF:RegisterMetaFunction("UpdateName", UF.UpdateName)