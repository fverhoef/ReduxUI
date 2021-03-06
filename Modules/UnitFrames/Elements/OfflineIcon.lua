local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateOfflineIcon()
    self.OfflineIcon = self:CreateTexture("$parentOfflineIcon", "OVERLAY")
    self.OfflineIcon:SetParent(self.Overlay)
    self.OfflineIcon:SetSize(64, 64)
    self.OfflineIcon:Hide()

    return self.OfflineIcon
end

oUF:RegisterMetaFunction("CreateOfflineIcon", UF.CreateOfflineIcon)

function UF:UpdateOfflineIcon()
    if not self.OfflineIcon then
        return
    end

    local config = self.config.offlineIcon
    if config.enabled then
        self:EnableElement("OfflineIcon")

        self.OfflineIcon:SetSize(unpack(config.size))
        self.OfflineIcon:ClearAllPoints()
        self.OfflineIcon:Point(unpack(config.point))
    else
        self:DisableElement("OfflineIcon")
    end
end

oUF:RegisterMetaFunction("UpdateOfflineIcon", UF.UpdateOfflineIcon)
