local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateName = function(self)
    self.Name = self:CreateFontString("$parentName", "OVERLAY")
    self.Name:SetFont(UF.config.font, 13, "OUTLINE")
    self:Tag(self.Name, "[name]")

    return self.Name
end

oUF:RegisterMetaFunction("CreateName", UF.CreateName)

UF.UpdateName = function(self)
    if not self.Name then
        return
    end

    local cfg = self.cfg.name
    if cfg.enabled then
        self.Name:Show()
        self.Name:SetFont(cfg.font or UF.config.font, cfg.fontSize or 13, cfg.fontOutline or "OUTLINE")
        self.Name:SetJustifyH(cfg.justifyH or "CENTER")
        self.Name:SetShadowOffset(cfg.fontShadow and 1 or 0, cfg.fontShadow and -1 or 0)
        self.Name:SetHeight(cfg.height)

        if cfg.tag then
            self:Tag(self.Name, cfg.tag)
        end
    else
        self.Name:Hide()
    end
end

oUF:RegisterMetaFunction("UpdateName", UF.UpdateName)