local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateMasterLooterIndicator()
    if not self.config.masterLooterIndicator.enabled then
        return
    end

    self.MasterLooterIndicator = self:CreateTexture(nil, "OVERLAY")
    self.MasterLooterIndicator:SetParent(self.Overlay)
    self.MasterLooterIndicator:SetSize(14, 14)

    return self.MasterLooterIndicator
end

oUF:RegisterMetaFunction("CreateMasterLooterIndicator", UF.CreateMasterLooterIndicator)

function UF:ConfigureMasterLooterIndicator()
    local config = self.config.masterLooterIndicator
    if not config.enabled then
        self:DisableElement("MasterLooterIndicator")
        return
    elseif not self.MasterLooterIndicator then
        self:CreateMasterLooterIndicator()
    end
    
    self:EnableElement("MasterLooterIndicator")

    self.MasterLooterIndicator:SetSize(unpack(config.size))
    self.MasterLooterIndicator:ClearAllPoints()
    self.MasterLooterIndicator:Point(unpack(config.point))
end

oUF:RegisterMetaFunction("ConfigureMasterLooterIndicator", UF.ConfigureMasterLooterIndicator)