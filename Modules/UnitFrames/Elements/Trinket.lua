local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateTrinket()
    if not self.config.trinket.enabled then return end

    self.Trinket = CreateFrame("Frame", "$parentTrinket", self)
    self.Trinket:SetSize(42, 42)
    self.Trinket:CreateBorder()
    self.Trinket.Border:SetInside(self.Trinket, 1, 1)

    return self.Trinket
end

oUF:RegisterMetaFunction("CreateTrinket", UF.CreateTrinket)

function UF:ConfigureTrinket()
    local config = self.config.trinket
    if not config.enabled then
        self:DisableElement("Trinket")
        return
    elseif not self.Trinket then
        self:CreateTrinket()
    end

    self:EnableElement("Trinket")

    self.Trinket:SetSize(unpack(config.size))
    self.Trinket:ClearAllPoints()
    self.Trinket:SetNormalizedPoint(unpack(config.point))
end

oUF:RegisterMetaFunction("ConfigureTrinket", UF.ConfigureTrinket)
