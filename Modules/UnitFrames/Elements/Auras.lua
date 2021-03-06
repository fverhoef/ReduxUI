local addonName, ns = ...
local R = _G.ReduxUI
local BS = R.Modules.ButtonStyles
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateAuras()
    local config = self.config.auras

    self.Buffs = CreateFrame("Frame", "$parentBuffs", self)
    self.Buffs.config = config.buffs
    self.Buffs.showStealableBuffs = true
    self.Buffs.showBuffType = false
    self.Buffs.PostCreateIcon = UF.PostCreateAura
    self.Buffs.PostUpdateIcon = UF.PostUpdateAura

    self.Debuffs = CreateFrame("Frame", "$parentDebuffs", self)
    self.Debuffs.config = config.debuffs
    self.Debuffs.showDebuffType = false
    self.Debuffs.PostCreateIcon = UF.PostCreateAura
    self.Debuffs.PostUpdateIcon = UF.PostUpdateAura
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

        local hideDuration = not self.config.showDuration or (button:GetWidth() < (BS.config.auras.minSizeToShowDuration or 32))
        button.cd:SetHideCountdownNumbers(hideDuration)
    end

    R.Modules.ButtonStyles:UpdateAuraButton(button)
end

function UF:UpdateAuras()
    local config = self.config.auras

    if config.enabled then
        self:EnableElement("Auras")

        self.Buffs.size = config.buffs.iconSize or 25
        self.Buffs:SetHeight(self.Buffs.size * (math.ceil(config.buffs.num / (config.buffs.numColumns or 5))))
        self.Buffs:SetWidth(self.Buffs.size * (config.buffs.numColumns or 5))
        self.Buffs:ClearAllPoints()
        self.Buffs:Point(unpack(config.buffs.point))
        self.Buffs.initialAnchor = config.buffs.initialAnchor
        self.Buffs["growth-x"] = config.buffs.growthX
        self.Buffs["growth-y"] = config.buffs.growthY
        self.Buffs.num = config.buffs.num
        self.Buffs.onlyShowPlayer = config.buffs.onlyShowPlayer
        self.Buffs.spacing = config.buffs.spacing
        self.Buffs:SetShown(config.buffs.enabled)
        self.Buffs:ForceUpdate()

        self.Debuffs.size = config.debuffs.iconSize or 25
        self.Debuffs:SetHeight(self.Debuffs.size * (math.ceil(config.debuffs.num / (config.debuffs.numColumns or 5))))
        self.Debuffs:SetWidth(self.Debuffs.size * (config.debuffs.numColumns or 5))
        self.Debuffs:ClearAllPoints()
        self.Debuffs:Point(unpack(config.debuffs.point))
        self.Debuffs.initialAnchor = config.debuffs.initialAnchor
        self.Debuffs["growth-x"] = config.debuffs.growthX
        self.Debuffs["growth-y"] = config.debuffs.growthY
        self.Debuffs.num = config.debuffs.num
        self.Debuffs.onlyShowPlayer = config.debuffs.onlyShowPlayer
        self.Debuffs.spacing = config.debuffs.spacing
        self.Debuffs:SetShown(config.debuffs.enabled)
        self.Debuffs:ForceUpdate()
    else
        self:DisableElement("Auras")
    end
end

oUF:RegisterMetaFunction("UpdateAuras", UF.UpdateAuras)
