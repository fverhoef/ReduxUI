local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateAuras = function(self)
    local cfg = self.cfg.auras
    if cfg.showDebuffsOnTop then
        self.Debuffs = CreateFrame("Frame", "$parentDebuffs", self)
        self.Debuffs.size = cfg.iconSize or 25
        self.Debuffs:SetHeight(self.Debuffs.size * (math.ceil(cfg.numDebuffs / (cfg.numColumns or 5))))
        self.Debuffs:SetWidth(self.Debuffs.size * (cfg.numColumns or 5))
        self.Debuffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 2, 5)
        self.Debuffs.initialAnchor = "BOTTOMLEFT"
        self.Debuffs["growth-x"] = "RIGHT"
        self.Debuffs["growth-y"] = "UP"
        self.Debuffs.num = cfg.numDebuffs
        self.Debuffs.onlyShowPlayer = cfg.onlyShowPlayerDebuffs
        self.Debuffs.spacing = cfg.spacing
        self.Debuffs.showDebuffType = false
        self.Debuffs.PostCreateIcon = UF.PostCreateAura
        self.Debuffs.PostUpdateIcon = UF.PostUpdateAura

        self.Buffs = CreateFrame("Frame", "$parentBuffs", self)
        self.Buffs.size = cfg.iconSize or 25
        self.Buffs:SetHeight(self.Buffs.size * (math.ceil(cfg.numBuffs / (cfg.numColumns or 5))))
        self.Buffs:SetWidth(self.Buffs.size * (cfg.numColumns or 5))
        self.Buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -2, -5)
        self.Buffs.initialAnchor = "TOPLEFT"
        self.Buffs["growth-x"] = "RIGHT"
        self.Buffs["growth-y"] = "DOWN"
        self.Buffs.num = cfg.numBuffs
        self.Buffs.onlyShowPlayer = cfg.onlyShowPlayerBuffs
        self.Buffs.spacing = cfg.spacing
        self.Buffs.showStealableBuffs = true
        self.Buffs.showBuffType = false
        self.Buffs.PostCreateIcon = UF.PostCreateAura
        self.Buffs.PostUpdateIcon = UF.PostUpdateAura
    else
        self.Auras = CreateFrame("Frame", "$parentAuras", self)
        self.Auras.gap = true
        self.Auras.size = cfg.iconSize or 25
        self.Auras:SetHeight(self.Auras.size * (math.ceil((cfg.numBuffs + cfg.numDebuffs) / (cfg.numColumns or 5))))
        self.Auras:SetWidth(self.Auras.size * (cfg.numColumns or 5))
        self.Auras:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -2, -5)
        self.Auras.initialAnchor = "TOPLEFT"
        self.Auras["growth-x"] = "RIGHT"
        self.Auras["growth-y"] = "DOWN"
        self.Auras.numBuffs = cfg.numBuffs
        self.Auras.numDebuffs = cfg.numDebuffs
        self.Auras.onlyShowPlayer = cfg.onlyShowPlayer
        self.Auras.spacing = cfg.spacing
        self.Auras.showStealableBuffs = true
        self.Auras.showBuffType = false
        self.Auras.showDebuffType = false
        self.Auras.buffFilter = "HELPFUL"
        self.Auras.debuffFilter = "HARMFUL|INCLUDE_NAME_PLATE_ONLY"
        self.Auras.PostCreateIcon = UF.PostCreateAura
        self.Auras.PostUpdateIcon = UF.PostUpdateAura
    end
end

oUF:RegisterMetaFunction("CreateAuras", UF.CreateAuras)

UF.PostCreateAura = function(self, button)
    R.Modules.ButtonStyles:StyleAuraButton(button)
end

UF.PostUpdateAura = function(self, unit, button, index, position, duration, expiration, debuffType, isStealable)
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
        if self.__owner and self.__owner.cfg then
            button.cd:SetHideCountdownNumbers(not self.__owner.cfg.auras.showDuration)
        end
    end

    R.Modules.ButtonStyles:UpdateAuraButton(button)
end

UF.UpdateAuras = function(self)
    if self.cfg.auras.enabled then
        self:EnableElement("Auras")
    else
        self:DisableElement("Auras")
    end
end

oUF:RegisterMetaFunction("UpdateAuras", UF.UpdateAuras)
