local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreatePvPIndicator()
    if not self.config.pvpIndicator.enabled then return end

    self.PvPIndicator = self:CreateTexture("$parentPvPIcon", "OVERLAY", nil, 7)
    self.PvPIndicator:SetParent(self.Overlay)
    self.PvPIndicator:SetSize(40, 42)

    return self.PvPIndicator
end

oUF:RegisterMetaFunction("CreatePvPIndicator", UF.CreatePvPIndicator)

function UF:ConfigurePvPIndicator()
    local config = self.config.pvpIndicator
    if not config.enabled then
        self:DisableElement("PvPIndicator")
        return
    elseif not self.PvPIndicator then
        self:CreatePvPIndicator()
    end

    self:EnableElement("PvPIndicator")

    self.PvPIndicator:SetSize(unpack(config.size))
    self.PvPIndicator:ClearAllPoints()
    self.PvPIndicator:SetNormalizedPoint(unpack(config.point))
end

oUF:RegisterMetaFunction("ConfigurePvPIndicator", UF.ConfigurePvPIndicator)
