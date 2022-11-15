local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF
local NUM_TOTEMS = R.isRetail and 5 or 4

function UF:CreateTotems()
    if not self.config.totems.enabled then return end

    self.TotemsHolder = CreateFrame("Frame", "$parentTotemsHolder", self)
    self.TotemsHolder:SetFrameLevel(self.Power:GetFrameLevel())
    self.TotemsHolder:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 5)
    self.TotemsHolder:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 5)

    self.Totems = {}
    for i = 1, NUM_TOTEMS do
        local totem = CreateFrame("Button", nil, self.TotemsHolder)
        totem.Icon = totem:CreateTexture(nil, "OVERLAY")        
        totem.Icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        totem.Icon:SetInside(totem, 2, 2)

        totem.Cooldown = CreateFrame("Cooldown", nil, totem, "CooldownFrameTemplate")
        totem.Cooldown:SetInside(totem, 1, 1)
        totem.Cooldown:SetFrameLevel(totem:GetFrameLevel() + 1)

        totem:CreateBorder()
        totem.Border:SetOutside(totem, 1, 1)
        totem.Border:SetFrameLevel(totem:GetFrameLevel() + 2)

        self.Totems[i] = totem
    end

    return self.Totems
end

oUF:RegisterMetaFunction("CreateTotems", UF.CreateTotems)

function UF:ConfigureTotems()
    local config = self.config.totems
    if not config.enabled then
        self:DisableElement("Totems")
        return
    elseif not self.Totems then
        self:CreateTotems()
    end

    self:EnableElement("Totems")

    self.TotemsHolder:SetSize(unpack(config.size))

    if R.isRetail then
        self.Totems[3]:SetPoint("CENTER", self.TotemsHolder, "CENTER")
        self.Totems[2]:SetPoint("RIGHT", self.Totems[3], "LEFT", -config.spacing, 0)
        self.Totems[1]:SetPoint("RIGHT", self.Totems[2], "LEFT", -config.spacing, 0)
        self.Totems[4]:SetPoint("LEFT", self.Totems[3], "RIGHT", config.spacing, 0)
        self.Totems[5]:SetPoint("LEFT", self.Totems[4], "RIGHT", config.spacing, 0)
    else
        self.Totems[2]:SetPoint("RIGHT", self.TotemsHolder, "CENTER", -config.spacing / 2, 0)
        self.Totems[1]:SetPoint("RIGHT", self.Totems[2], "LEFT", -config.spacing, 0)
        self.Totems[3]:SetPoint("LEFT", self.Totems[2], "RIGHT", config.spacing, 0)
        self.Totems[4]:SetPoint("LEFT", self.Totems[3], "RIGHT", config.spacing, 0)
    end

    for i, totem in ipairs(self.Totems) do totem:SetSize(config.size[2], config.size[2]) end
end

oUF:RegisterMetaFunction("ConfigureTotems", UF.ConfigureTotems)
