local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreateStatusFlash = function(self)
    self.StatusFlash = self:CreateTexture("$parentStatusFlash", "ARTWORK")
    if self.cfg.largerHealth then
        self.StatusFlash:SetTexture(Addon.media.textures.PlayerStatus_LargerHealth)
    else
        self.StatusFlash:SetTexture(Addon.media.textures.PlayerStatus)
    end
    self.StatusFlash:SetTexCoord(0, 0.74609375, 0, 0.53125)
    self.StatusFlash:SetBlendMode("ADD")
    self.StatusFlash:SetSize(192, 66)
    self.StatusFlash:SetPoint("TOPLEFT", self.Texture, 35, -9)
    self.StatusFlash:SetAlpha(0)

    UF.UpdateStatusFlash(self)

    self.statusCounter = 0
    self.statusSign = -1
    self:HookScript("OnUpdate", function(self, elapsed)
        UF.UpdateStatusFlash(self, elapsed)
    end)

    return self.StatusFlash
end

UF.UpdateStatusFlash = function(self, elapsed)
    if not self.StatusFlash then
        return
    end

    if UnitIsDeadOrGhost("player") then
        self.StatusFlash:Hide()
        return
    end

    local inCombat = UnitAffectingCombat("player")
    if IsResting() then
        if inCombat then
            self.StatusFlash:SetVertexColor(1.0, 0.0, 0.0, 1.0)
            self.StatusFlash:Show()
        else
            self.StatusFlash:SetVertexColor(1.0, 0.88, 0.25, 1.0)
            self.StatusFlash:Show()
        end
    elseif inCombat then
        self.StatusFlash:SetVertexColor(1.0, 0.0, 0.0, 1.0)
        self.StatusFlash:Show()
    else
        self.StatusFlash:Hide()
    end

    if elapsed then
        if self.StatusFlash:IsShown() then
            local alpha = 255
            local counter = self.statusCounter + elapsed
            local sign = self.statusSign

            if counter > 0.5 then
                sign = -sign
                self.statusSign = sign
            end
            counter = mod(counter, 0.5)
            self.statusCounter = counter

            if sign == 1 then
                alpha = (55 + (counter * 400)) / 255
            else
                alpha = (255 - (counter * 400)) / 255
            end
            self.StatusFlash:SetAlpha(alpha)

            if self.RestingIndicator.Glow:IsShown() then
                self.RestingIndicator.Glow:SetAlpha(alpha)
            elseif self.CombatIndicator.Glow:IsShown() then
                self.CombatIndicator.Glow:SetAlpha(alpha)
            end
        end

        if self.RestingIndicator:IsShown() then
            self.RestingIndicator.Glow:Show()
            self.CombatIndicator:Hide()
            self.CombatIndicator.Glow:Hide()
            self.Level:SetAlpha(0.01)
        elseif self.CombatIndicator:IsShown() then
            self.CombatIndicator.Glow:Show()
            self.Level:SetAlpha(0.01)
        else
            self.RestingIndicator.Glow:Hide()
            self.CombatIndicator.Glow:Hide()
            self.Level:SetAlpha(1)
        end
    end
end