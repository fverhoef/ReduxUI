local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateDiminishingReturnsTracker()
    if not self.config.diminishingReturnsTracker.enabled then return end

    self.DiminishingReturnsTracker = CreateFrame("Frame", "$parentDiminishingReturnsTracker", self)
    self.DiminishingReturnsTracker.iconSize = self.config.diminishingReturnsTracker.iconSize
    self.DiminishingReturnsTracker.PostCreateTimer = DiminishingReturnsTracker_PostCreateTimer

    return self.DiminishingReturnsTracker
end

oUF:RegisterMetaFunction("CreateDiminishingReturnsTracker", UF.CreateDiminishingReturnsTracker)

function UF:ConfigureDiminishingReturnsTracker()
    local config = self.config.diminishingReturnsTracker
    if not config.enabled then
        self:DisableElement("DiminishingReturnsTracker")
        return
    elseif not self.Trinket then
        self:CreateDiminishingReturnsTracker()
    end

    self:EnableElement("DiminishingReturnsTracker")

    self.DiminishingReturnsTracker.iconSize = self.config.diminishingReturnsTracker.iconSize
    self.DiminishingReturnsTracker:ClearAllPoints()
    self.DiminishingReturnsTracker:SetNormalizedPoint(unpack(config.point))
end

oUF:RegisterMetaFunction("ConfigureDiminishingReturnsTracker", UF.ConfigureDiminishingReturnsTracker)

function UF:DiminishingReturnsTracker_PostCreateTimer(timer)
    timer:CreateBorder()
end
