local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames
local oUF = AddonTable.oUF or oUF

function UF:SpawnNamePlates()
    local config = UF.config.db.profile.nameplates
    if config.enabled then
        oUF:RegisterStyle(AddonName .. "Nameplate", UF.CreateNamePlate)
        oUF:SetActiveStyle(AddonName .. "Nameplate")
        oUF:SpawnNamePlates(AddonName, UF.NamePlate_Callback, config.cvars)
    end
end

function UF:CreateNamePlate()
    self.cfg = UF.config.db.profile.nameplates

    self:SetSize(unpack(self.cfg.size))
    self:SetPoint("CENTER")
    self:SetFrameStrata("BACKGROUND")

    -- nameplates are not part of uiparent, they must be multiplied by uiparent scale!
    self:SetScale(1 * UIParent:GetScale())

    -- health
    UF.CreateHealth(self)
    self.Health:SetSize(self:GetWidth(), 16)
    if not self.cfg.showPower then
        self.Health:SetPoint("CENTER", self, 0, 0)
    else
        self.Health:SetPoint("CENTER", self, 0, 4)
    end
    self.Health.Value:SetPoint("CENTER", self.Health, 0, 0)
    self.Health.colorReaction = true

    -- power
    if self.cfg.showPower then
        UF.CreatePower(self)
        self.Power:SetHeight(6)
        self:SetHeight(self:GetHeight() + 8)
    end

    -- name
    UF.CreateName(self)
    if not self.cfg.showPower then
        self.Name:SetPoint("LEFT", self, "LEFT", 2, 15)
        self.Name:SetPoint("RIGHT", self, "RIGHT", -16, 15)
        self.Name:SetJustifyH("LEFT")
    else
        self.Name:SetPoint("LEFT", self, "LEFT", 2, 23)
        self.Name:SetPoint("RIGHT", self, "RIGHT", -16, 23)
        self.Name:SetJustifyH("LEFT")
    end

    -- level
    UF.CreateLevel(self)
    self.Level:SetPoint("RIGHT", self.Health, 0, 0)
    self.Level:SetFont(UF.config.db.profile.font, 12, "OUTLINE")
    if not self.cfg.showPower then
        self.Level:SetPoint("RIGHT", self, 0, 15)
    else
        self.Level:SetPoint("RIGHT", self, 0, 23)
    end

    -- border
    if self.cfg.showBorder then
        Addon.CreateBorder(self, self.cfg.borderSize)
    end

    -- auras
    if self.cfg.auras.enabled then
        UF.CreateAuras(self)

        if not self.cfg.auras.showDebuffsOnTop then
            self.Auras:ClearAllPoints()
            self.Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 15)
            self.Auras.initialAnchor = "BOTTOMLEFT"
            self.Auras["growth-x"] = "RIGHT"
            self.Auras["growth-y"] = "UP"
        end
    end

    -- castbar
    if self.cfg.castbar.enabled then
        UF.CreateCastbar(self)
        self.Castbar:ClearAllPoints()
        if self.cfg.castbar.showIcon and not self.cfg.castbar.showIconOutside then
            local _, height = unpack(self.cfg.castbar.size)
            local leftPadding = height - self.cfg.castbar.borderSize / 2 - 1
            self.Castbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", leftPadding, -5)
        else
            self.Castbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
        end
    end

    -- combo points
    if self.cfg.showComboPoints then
        UF.CreateComboFrame(self)
    end

    -- raid target
    UF.CreateRaidTargetIndicator(self)

    UF.CreateCombatFeedback(self)
    self.CombatFeedbackText:SetPoint("CENTER", self.Health, "CENTER", 0, 30)
    if not self.cfg.combatfeedback.enabled then
        self.CombatFeedbackText:Hide()
    end

    -- threat glow
    UF.CreateThreatIndicator(self)

    -- target indicator
    UF.CreateTargetIndicator(self)
end

function UF:UpdateNamePlates()
end

UF.NamePlate_Callback = function(self, event, unit)
    if self then
        UF.UpdateTargetIndicator(self)
    end
end

UF.NamePlate_DebuffFilter = function(...)
    -- icons, unit, icon, name, texture, count, dispelType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll
    local _, _, _, _, _, _, _, _, _, caster, _, _, _, _, _, _, nameplateShowAll = ...
    return nameplateShowAll or (caster == "player" or caster == "pet" or caster == "vehicle")
end

UF.CreateTargetIndicator = function(self)
    self.TargetIndicator = CreateFrame("Frame", self:GetName() .. "TargetIndicator", self)
    self.TargetIndicator:SetFrameLevel(0)

    self.TargetIndicator.Shadow = CreateFrame("Frame", nil, self.TargetIndicator)
    self.TargetIndicator.Shadow:SetBackdrop({edgeFile = Addon.media.textures.Glow, edgeSize = 5})
    self.TargetIndicator.Shadow:Hide()

    self.TargetIndicator.Left = self.TargetIndicator:CreateTexture(nil, "BACKGROUND", nil, -5)
    self.TargetIndicator.Left:SetTexture(Addon.media.textures.Arrow)
    self.TargetIndicator.Left:SetRotation(-math.pi / 2)
    self.TargetIndicator.Left:SetSize(16, 16)
    self.TargetIndicator.Left:SetPoint("RIGHT", self.Health, "LEFT", 0, 0)
    self.TargetIndicator.Left:Hide()

    self.TargetIndicator.Right = self.TargetIndicator:CreateTexture(nil, "BACKGROUND", nil, -5)
    self.TargetIndicator.Right:SetTexture(Addon.media.textures.Arrow)
    self.TargetIndicator.Right:SetRotation(math.pi / 2)
    self.TargetIndicator.Right:SetSize(16, 16)
    self.TargetIndicator.Right:SetPoint("LEFT", self.Health, "RIGHT", 0, 0)
    self.TargetIndicator.Right:Hide()

    self:RegisterEvent("PLAYER_TARGET_CHANGED", function(self)
        UF.UpdateTargetIndicator(self)
    end, true)

    UF.UpdateTargetIndicator(self)

    return self.TargetIndicator
end

UF.UpdateTargetIndicator = function(self)
    if self.unit and UnitIsUnit(self.unit, "target") then
        if UF.config.db.profile.nameplates.targetGlow then
            Addon:SetOutside(self.TargetIndicator.Shadow, self.Health, 4, 4)
            self.TargetIndicator.Shadow:SetBackdropBorderColor(1, 1, 1)
            self.TargetIndicator.Shadow:SetAlpha(1)
            self.TargetIndicator.Shadow:Show()
        end
        if UF.config.db.profile.nameplates.targetArrows then
            self.TargetIndicator.Left:Show()
            self.TargetIndicator.Right:Show()
        end
    else
        self.TargetIndicator.Shadow:Hide()
        self.TargetIndicator.Left:Hide()
        self.TargetIndicator.Right:Hide()
    end
end
