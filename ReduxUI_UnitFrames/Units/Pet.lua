local AddonName, AddonTable = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = AddonTable.oUF or oUF

function UF:SpawnPet()
    local config = R.config.db.profile.modules.unitFrames.pet
    local default = R.config.defaults.profile.modules.unitFrames.pet

    if config.enabled then
        return UF:SpawnFrame("Pet", "pet", UF.CreatePet, config, default)
    end
end

function UF:CreatePet()
    -- config
    self.cfg = R.config.db.profile.modules.unitFrames.pet

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
    self.Texture:SetTexture(R.media.textures.SmallTargetingFrame)
    self.Texture.SetTexture = function()
    end

    -- health
    UF.CreateHealth(self)
    self.Health:SetSize(70, 9)
    self.Health:SetPoint("TOPLEFT", self.Texture, 45, -20)
    self.Health.Value:Hide()

    -- power
    UF.CreatePower(self)
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
    UF.CreateCombatFeedback(self)

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
                R:StartFadeIn(self, {
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

function UF:UpdatePet()
    local self = UF.frames.pet
    if self then
        UF:UpdateFrame(self)

        if UF:IsBlizzardTheme() then
        else
        end
    end
end
