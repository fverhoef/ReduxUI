local addonName, ns = ...
local R = _G.ReduxUI
local BS = R.Modules.ButtonStyles
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateAuras()
    local config = self.config.auras

    self.Auras = CreateFrame("Frame", "$parentAuras", self)
    self.Auras.gap = true
    self.Auras.size = config.iconSize or 25
    self.Auras:SetHeight(self.Auras.size * (math.ceil((config.numBuffs + config.numDebuffs) / (config.numColumns or 5))))
    self.Auras:SetWidth(self.Auras.size * (config.numColumns or 5))
    self.Auras:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
    self.Auras.initialAnchor = "TOPLEFT"
    self.Auras["growth-x"] = "RIGHT"
    self.Auras["growth-y"] = "DOWN"
    self.Auras.numBuffs = config.numBuffs
    self.Auras.numDebuffs = config.numDebuffs
    self.Auras.onlyShowPlayer = config.onlyShowPlayer
    self.Auras.spacing = config.spacing
    self.Auras.showStealableBuffs = true
    self.Auras.showBuffType = false
    self.Auras.showDebuffType = false
    self.Auras.buffFilter = "HELPFUL"
    self.Auras.debuffFilter = "HARMFUL|INCLUDE_NAME_PLATE_ONLY"
    self.Auras.PostCreateIcon = UF.PostCreateAura
    self.Auras.PostUpdateIcon = UF.PostUpdateAura
    self.Auras:SetShown(not config.showDebuffsOnTop)

    self.Buffs = CreateFrame("Frame", "$parentBuffs", self)
    self.Buffs.size = config.iconSize or 25
    self.Buffs:SetHeight(self.Buffs.size * (math.ceil(config.numBuffs / (config.numColumns or 5))))
    self.Buffs:SetWidth(self.Buffs.size * (config.numColumns or 5))
    self.Buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
    self.Buffs.initialAnchor = "TOPLEFT"
    self.Buffs["growth-x"] = "RIGHT"
    self.Buffs["growth-y"] = "DOWN"
    self.Buffs.num = config.numBuffs
    self.Buffs.onlyShowPlayer = config.onlyShowPlayerBuffs
    self.Buffs.spacing = config.spacing
    self.Buffs.showStealableBuffs = true
    self.Buffs.showBuffType = false
    self.Buffs.PostCreateIcon = UF.PostCreateAura
    self.Buffs.PostUpdateIcon = UF.PostUpdateAura
    self.Buffs:SetShown(not config.showDebuffsOnTop)

    self.Debuffs = CreateFrame("Frame", "$parentDebuffs", self)
    self.Debuffs.size = config.iconSize or 25
    self.Debuffs:SetHeight(self.Debuffs.size * (math.ceil(config.numDebuffs / (config.numColumns or 5))))
    self.Debuffs:SetWidth(self.Debuffs.size * (config.numColumns or 5))
    self.Debuffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 5)
    self.Debuffs.initialAnchor = "BOTTOMLEFT"
    self.Debuffs["growth-x"] = "RIGHT"
    self.Debuffs["growth-y"] = "UP"
    self.Debuffs.num = config.numDebuffs
    self.Debuffs.onlyShowPlayer = config.onlyShowPlayerDebuffs
    self.Debuffs.spacing = config.spacing
    self.Debuffs.showDebuffType = false
    self.Debuffs.PostCreateIcon = UF.PostCreateAura
    self.Debuffs.PostUpdateIcon = UF.PostUpdateAura
    self.Debuffs:SetShown(not config.showDebuffsOnTop)
end

oUF:RegisterMetaFunction("CreateAuras", UF.CreateAuras)

function UF:PostCreateAura(button)
    R.Modules.ButtonStyles:StyleAuraButton(button)
end

function UF:PostUpdateAura(unit, button, index, position, duration, expiration, debuffType, isStealable)
    local name, duration, expiration, caster, spellID
    if R.isClassic and R.Libs.ClassicDurations and not UnitIsUnit("player", unit) then
        local durationNew, expirationTimeNew
        name, _, _, _, duration, expiration, caster, _, _, spellID = R.Libs.ClassicDurations:UnitAura(unit, index, button.filter)

        if spellID then
            durationNew, expirationTimeNew = R.Libs.ClassicDurations:GetAuraDurationByUnit(unit, spellID, caster, name)
        end

        if durationNew and durationNew > 0 then
            duration, expiration = durationNew, expirationTimeNew
        end
    else
        name, _, _, _, duration, expiration = UnitAura(unit, index, button.filter)
    end

    if button and button.debuffType ~= debuffType then
        button.debuffType = debuffType
    end

    if button and button.cd then
        if (duration and duration > 0) then
            button.cd:SetCooldown(expiration - duration, duration)
            button.cd:Show()
        else
            button.cd:Hide()
        end
        if self.__owner and self.__owner.config then
            local hideDuration = not self.__owner.config.auras.showDuration or
                                     (button:GetWidth() < (BS.config.auras.minSizeToShowDuration or 32))
            button.cd:SetHideCountdownNumbers(hideDuration)
        end
    end

    R.Modules.ButtonStyles:UpdateAuraButton(button)
end

function UF:UpdateAuras()
    local config = self.config.auras

    if config.enabled then
        self:EnableElement("Auras")

        self.Auras.size = config.iconSize or 25
        self.Auras:SetHeight(self.Auras.size * (math.ceil((config.numBuffs + config.numDebuffs) / (config.numColumns or 5))))
        self.Auras:SetWidth(self.Auras.size * (config.numColumns or 5))
        self.Auras.numBuffs = config.numBuffs
        self.Auras.numDebuffs = config.numDebuffs
        self.Auras.onlyShowPlayer = config.onlyShowPlayer
        self.Auras.spacing = config.spacing
        self.Auras:SetShown(not config.showDebuffsOnTop)
        self.Auras:ForceUpdate()

        self.Buffs.size = config.iconSize or 25
        self.Buffs:SetHeight(self.Buffs.size * (math.ceil(config.numBuffs / (config.numColumns or 5))))
        self.Buffs:SetWidth(self.Buffs.size * (config.numColumns or 5))
        self.Buffs.num = config.numBuffs
        self.Buffs.onlyShowPlayer = config.onlyShowPlayerBuffs
        self.Buffs.spacing = config.spacing
        self.Buffs:SetShown(config.showDebuffsOnTop)
        self.Buffs:ForceUpdate()

        self.Debuffs.size = config.iconSize or 25
        self.Debuffs:SetHeight(self.Debuffs.size * (math.ceil(config.numDebuffs / (config.numColumns or 5))))
        self.Debuffs:SetWidth(self.Debuffs.size * (config.numColumns or 5))
        self.Debuffs.num = config.numDebuffs
        self.Debuffs.onlyShowPlayer = config.onlyShowPlayerDebuffs
        self.Debuffs.spacing = config.spacing
        self.Debuffs:SetShown(config.showDebuffsOnTop)
        self.Debuffs:ForceUpdate()

        self.Auras:ClearAllPoints()
        self.Auras:Point("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
        self.Buffs:ClearAllPoints()
        self.Buffs:Point("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
        self.Debuffs:ClearAllPoints()
        self.Debuffs:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 5)
    else
        self:DisableElement("Auras")
    end
end

oUF:RegisterMetaFunction("UpdateAuras", UF.UpdateAuras)
