local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreateHealth = function(self)
    self.Health = CreateFrame("StatusBar", nil, self)
    self.Health:SetStatusBarTexture(UF.config.db.profile.statusbars.health)
    self.Health:SetFrameLevel(self:GetFrameLevel() - 1)
    self.Health:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
    self.Health:SetBackdropColor(0, 0, 0, 0.70)

    self.Health.frequentUpdates = true
    self.Health.Smooth = true
    self.Health.colorDisconnected = true
    self.Health.colorTapping = true
    self.Health.colorClass = true
    self.Health.colorHealth = true
    self.Health.colorReaction = true

    self.Health.Value = self:CreateFontString("$parentHealthText", "OVERLAY")
    self.Health.Value:SetShadowOffset(1, -1)
    self.Health.Value:SetFont(UF.config.db.profile.font, 11)
    self.Health.Value:SetPoint("CENTER", self.Health, 0, 1)

    self:Tag(self.Health.Value, "[curhp_status]")

    local myBar = CreateFrame("StatusBar", nil, self.Health)
    myBar:SetPoint("TOP")
    myBar:SetPoint("BOTTOM")
    myBar:SetPoint("LEFT", self.Health:GetStatusBarTexture(), "RIGHT")
    myBar:SetWidth(125)

    local otherBar = CreateFrame("StatusBar", nil, self.Health)
    otherBar:SetPoint("TOP")
    otherBar:SetPoint("BOTTOM")
    otherBar:SetPoint("LEFT", myBar:GetStatusBarTexture(), "RIGHT")
    otherBar:SetWidth(125)

    local absorbBar = CreateFrame("StatusBar", nil, self.Health)
    absorbBar:SetPoint("TOP")
    absorbBar:SetPoint("BOTTOM")
    absorbBar:SetPoint("LEFT", otherBar:GetStatusBarTexture(), "RIGHT")
    absorbBar:SetWidth(125)

    self.HealthPrediction = {myBar = myBar, otherBar = otherBar, absorbBar = absorbBar, maxOverflow = 1}
	self.HealthPrediction.frequentUpdates = true

    return self.Health
end

UF.UpdateHealth = function(self)
    if self.Health then
        self.Health:SetStatusBarTexture(UF.config.db.profile.statusbars.health)
    end
end