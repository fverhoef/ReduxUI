local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateName()
    self.Name = self:CreateFontString("$parentName", "OVERLAY")
    self.Name:SetParent(self.Overlay)
    self.Name:SetFont(UF.config.font, 13, "OUTLINE")

    self:Tag(self.Name, "[name]")

    return self.Name
end

oUF:RegisterMetaFunction("CreateName", UF.CreateName)

function UF:UpdateName()
    if not self.Name then
        return
    end

    local config = self.config.name
    if config.enabled then
        self.Name:Show()
        self.Name:SetFont(config.font or UF.config.font, config.fontSize or 13, config.fontOutline or "OUTLINE")
        self.Name:SetJustifyH(config.justifyH or "CENTER")
        self.Name:SetShadowOffset(config.fontShadow and 1 or 0, config.fontShadow and -1 or 0)

        self.Name:ClearAllPoints()
        self.Name:SetSize(unpack(config.size))
        self.Name:Point(unpack(config.point))

        if config.tag then
            self:Tag(self.Name, config.tag)
        end
    else
        self.Name:Hide()
    end
end

oUF:RegisterMetaFunction("UpdateName", UF.UpdateName)
