local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames
local BS = Addon.Modules.Buttons
local CD = Addon.Modules.Cooldowns

UF.CreateAuras = function(self)
    local cfg = self.cfg.auras
    local iconSize = cfg.iconSize or 20
    if cfg.showDebuffsOnTop then
        self.Debuffs = CreateFrame("Frame", "$parentDebuffs", self)
        self.Debuffs.gap = true
        self.Debuffs.size = iconSize
        self.Debuffs:SetHeight(self.Debuffs.size * 3)
        self.Debuffs:SetWidth(self.Debuffs.size * 5)
        self.Debuffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 2, 5)
        self.Debuffs.initialAnchor = "BOTTOMLEFT"
        self.Debuffs["growth-x"] = "RIGHT"
        self.Debuffs["growth-y"] = "UP"
        self.Debuffs.num = cfg.numDebuffs
        self.Debuffs.onlyShowPlayer = cfg.onlyShowPlayerDebuffs
        self.Debuffs.spacing = 2 -- 4.5
        self.Debuffs.PostCreateIcon = UF.PostCreateAura
        self.Debuffs.PostUpdateIcon = UF.PostUpdateAura

        self.Buffs = CreateFrame("Frame", "$parentBuffs", self)
        self.Buffs.gap = true
        self.Buffs.size = iconSize
        self.Buffs:SetHeight(self.Buffs.size * 3)
        self.Buffs:SetWidth(self.Buffs.size * 5)
        self.Buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -2, -5)
        self.Buffs.initialAnchor = "TOPLEFT"
        self.Buffs["growth-x"] = "RIGHT"
        self.Buffs["growth-y"] = "DOWN"
        self.Buffs.num = cfg.numBuffs
        self.Buffs.onlyShowPlayer = cfg.onlyShowPlayerBuffs
        self.Buffs.spacing = 2 -- 4.5
        self.Buffs.showStealableBuffs = true
        self.Buffs.PostCreateIcon = UF.PostCreateAura
        self.Buffs.PostUpdateIcon = UF.PostUpdateAura
    else
        self.Auras = CreateFrame("Frame", "$parentAuras", self)
        self.Auras.gap = true
        self.Auras.size = iconSize
        self.Auras:SetHeight(self.Auras.size * 3)
        self.Auras:SetWidth(self.Auras.size * 5)
        self.Auras:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -2, -5)
        self.Auras.initialAnchor = "TOPLEFT"
        self.Auras["growth-x"] = "RIGHT"
        self.Auras["growth-y"] = "DOWN"
        self.Auras.numBuffs = cfg.numBuffs
        self.Auras.numDebuffs = cfg.numDebuffs
        self.Auras.onlyShowPlayer = cfg.onlyShowPlayer
        self.Auras.spacing = 2 -- 4.5
        self.Auras.showStealableBuffs = true
        self.Auras.debuffFilter = "HARMFUL|INCLUDE_NAME_PLATE_ONLY"
        self.Auras.PostCreateIcon = UF.PostCreateAura
        self.Auras.PostUpdateIcon = UF.PostUpdateAura
    end
end

UF.PostCreateAura = function(self, button)
    if LibStub("Masque", true) then
        UF.MasqueGroups.AuraGroup:AddButton(button)
    end
    -- CD:RegisterCooldown(button.cd)
    BS:StyleAuraButton(button)
end

UF.PostUpdateAura = function(self, unit, button, index, position, duration, expiration, debuffType, isStealable)
    local name, duration, expiration, caster, spellID
    if Addon.IsClassic and Addon.Libs.ClassicDurations and not UnitIsUnit("player", unit) then
        local durationNew, expirationTimeNew
        name, _, _, _, duration, expiration, caster, _, _, spellID = Addon.Libs.ClassicDurations:UnitAura(unit, index, button.filter)

        if spellID then
            durationNew, expirationTimeNew = Addon.Libs.ClassicDurations:GetAuraDurationByUnit(unit, spellID, caster, name)
        end

        if durationNew and durationNew > 0 then
            duration, expiration = durationNew, expirationTimeNew
        end
    else
        name, _, _, _, duration, expiration = UnitAura(unit, index, button.filter)
    end

    if button then
        if button.cd then
            if (duration and duration > 0) then
                button.cd:SetCooldown(expiration - duration, duration)
                button.cd:Show()
            else
                button.cd:Hide()
            end
        end
    end
    if self.__owner and self.__owner.cfg then
        if not self.__owner.cfg.showAuraDuration then
            button.cd:SetHideCountdownNumbers(true)
        end
    end

    if LibStub("Masque", true) then
        UF.MasqueGroups.AuraGroup:ReSkin()
    end
end

UF.UpdateAuras = function(self)
    if self.cfg.auras.enabled then
        self:EnableElement("Auras")
    else
        self:DisableElement("Auras")
    end
end
