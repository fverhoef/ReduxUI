local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateName()
    local config = self.config.name
    if not config or not config.enabled then return end

    self.Name = self.Overlay:CreateFontString("$parentName", "OVERLAY")
    self.Name:SetFont(UF.config.font, 13, "OUTLINE")

    return self.Name
end

oUF:RegisterMetaFunction("CreateName", UF.CreateName)

function UF:ConfigureName()
    local config = self.config.name
    if not config.enabled then
        if self.Name then
            self.Name:Hide()
            self:Untag(self.Name)
        end
        return
    elseif not self.Name then
        self:CreateName()
    end

    self.Name:Show()
    self.Name:SetFont(config.font or UF.config.font, config.fontSize or 13, config.fontOutline or "OUTLINE")
    self.Name:SetJustifyH(config.justifyH or "CENTER")
    self.Name:SetShadowOffset(config.fontShadow and 1 or 0, config.fontShadow and -1 or 0)

    self.Name:ClearAllPoints()
    self.Name:SetSize(unpack(config.size))
    self.Name:SetNormalizedPoint(unpack(config.point))

    if config.tag then
        self:Tag(self.Name, config.tag)
    else
        self:Untag(self.Name)
    end
end

oUF:RegisterMetaFunction("ConfigureName", UF.ConfigureName)
