local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreatePvPClassificationIndicator()
    if not self.config.pvpClassificationIndicator.enabled then return end

    self.PvPClassificationIndicator = self:CreateTexture(nil, "OVERLAY")
    self.PvPClassificationIndicator:SetParent(self.Overlay)
    self.PvPClassificationIndicator:SetSize(24, 24)

    return self.PvPClassificationIndicator
end

oUF:RegisterMetaFunction("CreatePvPClassificationIndicator", UF.CreatePvPClassificationIndicator)

function UF:ConfigurePvPClassificationIndicator()
    local config = self.config.pvpClassificationIndicator
    if not config.enabled then
        self:DisableElement("PvPClassificationIndicator")
        return
    elseif not self.PvPClassificationIndicator then
        self:CreatePvPClassificationIndicator()
    end

    self:EnableElement("PvPClassificationIndicator")

    self.PvPClassificationIndicator:SetSize(unpack(config.size))
    self.PvPClassificationIndicator:ClearAllPoints()
    self.PvPClassificationIndicator:SetNormalizedPoint(unpack(config.point))
end

oUF:RegisterMetaFunction("ConfigurePvPClassificationIndicator", UF.ConfigurePvPClassificationIndicator)
