local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreatePvPIndicator = function(self)
    self.PvPIndicator = self:CreateTexture("$parentPvPIcon", "OVERLAY", nil, 7)
    self.PvPIndicator:SetParent(self.Overlay)
    self.PvPIndicator:SetSize(40, 42)

    return self.PvPIndicator
end

oUF:RegisterMetaFunction("CreatePvPIndicator", UF.CreatePvPIndicator)

UF.UpdatePvPIndicator = function(self)
    if not self.PvPIndicator then
        return
    end

    local config = self.config.pvpIndicator
    if config.enabled then
        self:EnableElement("UpdatePvPIndicator")

        self.PvPIndicator:SetSize(unpack(config.size))
        self.PvPIndicator:ClearAllPoints()
        self.PvPIndicator:SetPoint(unpack(config.point))
    else
        self:DisableElement("UpdatePvPIndicator")
    end
end

oUF:RegisterMetaFunction("UpdatePvPIndicator", UF.UpdatePvPIndicator)