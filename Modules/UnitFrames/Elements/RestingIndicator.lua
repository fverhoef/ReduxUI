local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateRestingIndicator()
    if self.unit ~= "player" or not self.config.restingIndicator.enabled then
        return
    end

    self.RestingIndicator = self.Overlay:CreateTexture("$parentRestingIcon", "OVERLAY", nil, 6)
    self.RestingIndicator:SetSize(31, 31) -- 31,34
    self.RestingIndicator:SetTexture(R.media.textures.unitFrames.restingFlipbook)
    self.RestingIndicator.animationIndex = 0

    self.RestingIndicator.PostUpdate = function(element, isResting)
        self.isResting = isResting
        self:UpdateHighlight()
    end

    UF:ScheduleRepeatingTimer(UF.UpdateRestingIndicatorTexture, 0.2, self)

    return self.RestingIndicator
end

oUF:RegisterMetaFunction("CreateRestingIndicator", UF.CreateRestingIndicator)

function UF:ConfigureRestingIndicator()
    local config = self.config.restingIndicator
    if not config.enabled then
        self:DisableElement("RestingIndicator")
        return
    elseif not self.RestingIndicator then
        self:CreateRestingIndicator()
    end

    self:EnableElement("RestingIndicator")

    self.RestingIndicator:SetSize(unpack(config.size))
    self.RestingIndicator:ClearAllPoints()
    self.RestingIndicator:SetNormalizedPoint(unpack(config.point))

    if self.isResting then
        self.RestingIndicator:Show()
        self:UpdateHighlight()
    end
end

oUF:RegisterMetaFunction("ConfigureRestingIndicator", UF.ConfigureRestingIndicator)

function UF:UpdateRestingIndicatorTexture()
    if not self.RestingIndicator:IsShown() then
        return
    end

    self.RestingIndicator:SetTexCoord((self.RestingIndicator.animationIndex * 64) / 1024, ((self.RestingIndicator.animationIndex + 1) * 64) / 1024, 0, 0.5)

    if self.RestingIndicator.animationIndex >= 4 then
        self.RestingIndicator.animationIndex = 0
    else
        self.RestingIndicator.animationIndex = self.RestingIndicator.animationIndex + 1
    end
end
