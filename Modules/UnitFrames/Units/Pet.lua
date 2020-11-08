local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames
local oUF = AddonTable.oUF or oUF

function UF:SpawnPet()
    local config = UF.config.db.profile.pet
    local default = Addon.config.defaults.profile.modules.unitFrames.pet

    if config.enabled then
        return UF:SpawnFrame("Pet", "pet", UF.CreatePetStyle, config, default)
    end
end

function UF:CreatePetStyle()
    -- config
    self.cfg = UF.config.db.profile.pet

    local player = UF.frames.player

    self:SetSize(unpack(self.cfg.size))
    self:SetPoint(unpack(self.cfg.point))
    self:SetFrameStrata("LOW")
    self:SetFrameLevel(20)

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    -- texture
    self.Texture = self:CreateTexture("$parentFrameTexture", "BORDER")
    self.Texture:SetSize(128, 64)
    self.Texture:SetPoint("TOPLEFT", self, 0, -2)
    self.Texture:SetTexture(Addon.media.textures.SmallTargetingFrame)
    self.Texture.SetTexture = function()
    end

    -- health
    UF.CreateHealthBar(self)
    self.Health:SetSize(70, 9)
    self.Health:SetPoint("TOPLEFT", self.Texture, 45, -20)
    self.Health.Value:Hide()

    -- power
    UF.CreatePowerBar(self)
    self.Power:SetHeight(self.Health:GetHeight())
    self.Power.Value:Hide()

    -- name
    UF.CreateName(self, 11)
    self.Name:SetWidth(110)
    self.Name:SetJustifyH("LEFT")
    self.Name:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 2, 3)

    -- portrait
    UF.CreatePortrait(self)
    self.Portrait:SetSize(37, 37)
    self.Portrait:SetPoint("TOPLEFT", self.Texture, 7, -6)

    -- combat feedback
    if self.cfg.combatfeedback.enabled then
        UF.CreateCombatFeedback(self)
    end

    -- raid target
    UF.CreateRaidTargetIndicator(self)

    -- auras
    if self.cfg.auras.enabled then
        UF.CreateAuras(self)
        if self.Auras then
            self.Auras:ClearAllPoints()
            self.Auras:SetPoint("TOPLEFT", self, "TOPRIGHT", 30, 15)
        else
            self.Buffs:ClearAllPoints()
            self.Buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 46, -2)
            self.Buffs.initialAnchor = "TOPLEFT"

            self.Debuffs:ClearAllPoints()
            self.Debuffs:SetPoint("TOPLEFT", self, "TOPRIGHT", 16, 7)
            self.Debuffs.initialAnchor = "TOPLEFT"
        end
    end

    -- castbar
    if self.cfg.castbar.enabled then
        UF.CreateCastbar(self)
        self.Castbar:SetPoint("LEFT", self, "RIGHT", 16, -5)
    end

    -- range check
    self.SpellRange = {
        insideAlpha = 1,
        outsideAlpha = 0.5,
        Update = function(self, inRange)
            if self.fader and not self:IsShown() then
                Addon:StartFadeIn(self, {
                    fadeInAlpha = self.SpellRange[inRange and "insideAlpha" or "outsideAlpha"],
                    fadeInDuration = self.faderConfig.fadeInDuration,
                    fadeInSmooth = self.faderConfig.fadeInSmooth
                })
            else
                self:SetAlpha(self.SpellRange[inRange and "insideAlpha" or "outsideAlpha"])
            end
        end
    }
end
