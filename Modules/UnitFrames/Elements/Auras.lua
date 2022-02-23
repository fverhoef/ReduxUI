local addonName, ns = ...
local R = _G.ReduxUI
local BS = R.Modules.ButtonStyles
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateAuras()
    if not self.config.auras.enabled then return end

    self.Auras = CreateFrame("Frame", "$parentAuras", self)
    self.Auras.config = self.config.auras.buffsAndDebuffs
    self.Auras.buffFilterConfig = self.config.auras.buffs.filter
    self.Auras.debuffFilterConfig = self.config.auras.debuffs.filter
    self.Auras.PostCreateIcon = UF.PostCreateAura
    self.Auras.PostUpdateIcon = UF.PostUpdateAura
    self.Auras.PostUpdateGapIcon = UF.PostUpdateGap
    self.Auras.CustomFilter = UF.AuraFilter

    self.Buffs = CreateFrame("Frame", "$parentBuffs", self)
    self.Buffs.config = self.config.auras.buffs
    self.Buffs.PostCreateIcon = UF.PostCreateAura
    self.Buffs.PostUpdateIcon = UF.PostUpdateAura
    self.Buffs.CustomFilter = UF.AuraFilter

    self.Debuffs = CreateFrame("Frame", "$parentDebuffs", self)
    self.Debuffs.config = self.config.auras.debuffs
    self.Debuffs.PostCreateIcon = UF.PostCreateAura
    self.Debuffs.PostUpdateIcon = UF.PostUpdateAura
    self.Debuffs.CustomFilter = UF.AuraFilter
end

oUF:RegisterMetaFunction("CreateAuras", UF.CreateAuras)

function UF:ConfigureAuras()
    local config = self.config.auras
    if not config.enabled then
        self:DisableElement("Auras")
        return
    elseif not self.Auras then
        self:CreateAuras()
    end

    self:EnableElement("Auras")

    self.Auras.size = config.buffsAndDebuffs.iconSize or 25
    self.Auras:SetHeight(self.Auras.size * (math.ceil((config.buffsAndDebuffs.numBuffs + config.buffsAndDebuffs.numDebuffs) / (config.buffsAndDebuffs.numColumns or 5))))
    self.Auras:SetWidth(self.Auras.size * (config.buffsAndDebuffs.numColumns or 5))
    self.Auras:ClearAllPoints()
    self.Auras:SetNormalizedPoint(unpack(config.buffsAndDebuffs.point))
    self.Auras.initialAnchor = config.buffsAndDebuffs.initialAnchor
    self.Auras["growth-x"] = config.buffsAndDebuffs.growthX
    self.Auras["growth-y"] = config.buffsAndDebuffs.growthY
    self.Auras.numBuffs = config.buffsAndDebuffs.numBuffs
    self.Auras.numDebuffs = config.buffsAndDebuffs.numDebuffs
    self.Auras.spacing = config.buffsAndDebuffs.spacing
    self.Auras.showStealableBuffs = self.Auras.config.showStealableBuffs
    self.Auras.showBuffType = self.Auras.config.showBuffType
    self.Auras.showDebuffType = self.Auras.config.showDebuffType
    self.Auras.gap = self.Auras.config.gap
    self.Auras:SetShown(not config.separateBuffsAndDebuffs and config.buffsAndDebuffs.enabled)
    self.Auras:ForceUpdate()

    self.Buffs.size = config.buffs.iconSize or 25
    self.Buffs:SetHeight(self.Buffs.size * (math.ceil(config.buffs.num / (config.buffs.numColumns or 5))))
    self.Buffs:SetWidth(self.Buffs.size * (config.buffs.numColumns or 5))
    self.Buffs:ClearAllPoints()
    self.Buffs:SetNormalizedPoint(unpack(config.buffs.point))
    self.Buffs.initialAnchor = config.buffs.initialAnchor
    self.Buffs["growth-x"] = config.buffs.growthX
    self.Buffs["growth-y"] = config.buffs.growthY
    self.Buffs.num = config.buffs.num
    self.Buffs.spacing = config.buffs.spacing
    self.Buffs.showStealableBuffs = self.Buffs.config.showStealableBuffs
    self.Buffs.showBuffType = self.Buffs.config.showBuffType
    self.Buffs:SetShown(config.separateBuffsAndDebuffs and config.buffs.enabled)
    self.Buffs:ForceUpdate()

    self.Debuffs.size = config.debuffs.iconSize or 25
    self.Debuffs:SetHeight(self.Debuffs.size * (math.ceil(config.debuffs.num / (config.debuffs.numColumns or 5))))
    self.Debuffs:SetWidth(self.Debuffs.size * (config.debuffs.numColumns or 5))
    self.Debuffs:ClearAllPoints()
    self.Debuffs:SetNormalizedPoint(unpack(config.debuffs.point))
    self.Debuffs.initialAnchor = config.debuffs.initialAnchor
    self.Debuffs["growth-x"] = config.debuffs.growthX
    self.Debuffs["growth-y"] = config.debuffs.growthY
    self.Debuffs.num = config.debuffs.num
    self.Debuffs.spacing = config.debuffs.spacing
    self.Buffs.showStealableBuffs = self.Buffs.config.showStealableBuffs
    self.Buffs.showDebuffType = self.Buffs.config.showDebuffType
    self.Debuffs:SetShown(config.separateBuffsAndDebuffs and config.debuffs.enabled)
    self.Debuffs:ForceUpdate()
end

oUF:RegisterMetaFunction("ConfigureAuras", UF.ConfigureAuras)

function UF:PostCreateAura(button)
    button.cd:SetInside(nil, 1, 1)
    R.Modules.ButtonStyles:StyleAuraButton(button)
end

function UF:PostUpdateAura(unit, button, index, position, duration, expiration, debuffType, isStealable)
    local name, _, _, _, duration, expiration = UnitAura(unit, index, button.filter)

    if button and button.debuffType ~= debuffType then button.debuffType = debuffType end

    if button and button.cd then
        if (duration and duration > 0) then
            button.cd:SetCooldown(expiration - duration, duration)
            button.cd:Show()
        else
            button.cd:Hide()
        end

        button.cd:SetHideCountdownNumbers(not self.config.showDuration)
    end

    button.Border:Show()
    R.Modules.ButtonStyles:UpdateAuraButton(button)
end

function UF:PostUpdateGap(unit, gapButton, visibleBuffs)
    gapButton.Border:Hide()
end

function UF:AuraFilter(unit, button, name, texture, count, debuffType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll)
    local config = self.config
    if not name then
        return
    elseif not config then
        return true
    end

    button.canDesaturate = config.desaturate
    button.texture = texture

    local myPet = caster == "pet"
    local otherPet = caster and not UnitIsUnit("pet", caster) and string.match(caster, "pet%d+")
    local isPlayer = caster == "player" or caster == "vehicle"
    local isFriend = unit and UnitIsFriend("player", unit) and not UnitCanAttack("player", unit)
    local unitIsCaster = unit and caster and UnitIsUnit(unit, caster)
    local canDispel = (self.type == "debuffs" and isStealable) or (self.type == "buffs" and isStealable)

    local minDuration = config.minDuration or (button.isDebuff and self:GetParent().config.debuffs.minDuration or self:GetParent().config.buffs.minDuration)
    local maxDuration = config.maxDuration or (button.isDebuff and self:GetParent().config.debuffs.maxDuration or self:GetParent().config.buffs.maxDuration)
    local noDuration = (not duration or duration == 0)
    local allowDuration = noDuration or
                              (duration and duration > 0 and (not maxDuration or maxDuration == 0 or duration <= maxDuration) and (not minDuration or minDuration == 0 or duration >= minDuration))

    local filter = config.filter or (button.isDebuff and self.debuffFilterConfig or self.buffFilterConfig)
    local isWhiteListed =
        (filter.whiteList.Personal and isPlayer) or (filter.whiteList.NonPersonal and not isPlayer) or (filter.whiteList.Boss and isBossDebuff) or (filter.whiteList.MyPet and myPet) or
            (filter.whiteList.OtherPet and otherPet) or (filter.whiteList.CastByUnit and caster and unitIsCaster) or (filter.whiteList.NotCastByUnit and caster and not unitIsCaster) or
            (filter.whiteList.Dispellable and canDispel) or (filter.whiteList.NotDispellable and not canDispel) or (filter.whiteList.CastByNPC and not casterIsPlayer) or
            (filter.whiteList.CastByPlayers and casterIsPlayer) or (filter.whiteList.Nameplate and (nameplateShowAll or (nameplateShowSelf and (isPlayer or myPet))))
    local isBlackListed = (filter.blackList.BlockCastByPlayers and casterIsPlayer) or (filter.blackList.BlockNoDuration and noDuration) or (filter.blackList.BlockNonPersonal and not isPlayer) or
                              (filter.blackList.BlockDispellable and canDispel) or (filter.blackList.BlockNotDispellable and not canDispel)

    return allowDuration and isWhiteListed and not isBlackListed
end
