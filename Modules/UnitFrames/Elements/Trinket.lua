local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateTrinket()
    if not self.config.trinket.enabled then
        return
    end

    self.Trinket = CreateFrame("Frame", "$parentTrinket", self)
    self.Trinket:SetSize(42, 42)
    self.Trinket:CreateBorder()
    self.Trinket.Border:SetInside(self.Trinket, 1, 1)
    self.Trinket.PostTrinketUp = UF.Trinket_PostTrinketUp
    self.Trinket.PostTrinketUsed = UF.Trinket_PostTrinketUsed

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
    self.Trinket.trinketUpAnnounce = config.trinketUpAnnounce
    self.Trinket.trinketUseAnnounce = config.trinketUseAnnounce
    self.Trinket.announceChannel = config.announceChannel
end

oUF:RegisterMetaFunction("ConfigureTrinket", UF.ConfigureTrinket)

function UF:Trinket_PostTrinketUp(unit)
    R:Print("Trinket ready: " .. UnitName(unit))

    if not self.trinketUpAnnounce then return end

    R:Announce(L["Trinket ready: "] .. UnitName(unit) .. " " .. UnitClass(unit), self.announceChannel or "PARTY")
end

function UF:Trinket_PostTrinketUsed(unit, isWotF)
    R:Print("Trinket used: " .. UnitName(unit))

    if not self.trinketUseAnnounce then return end

    R:Announce((isWotF and L["WotF used:"] or L["Trinket used: "]) .. UnitName(unit) .. " " .. UnitClass(unit), self.announceChannel or "PARTY")
end