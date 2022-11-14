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
    R.Modules.ButtonStyles:StyleAuraButton(button)
end

function UF:PostUpdateGap(unit, gapButton, visibleBuffs) gapButton.Border:Hide() end

function UF:AuraFilter(unit, button, name, texture, count, debuffType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll)
    local config = self.config
    if not name then
        return
    elseif not config then
        return true
    end

    button.canDesaturate = config.desaturate
    button.texture = texture

    local minDuration = config.minDuration or (button.isDebuff and self:GetParent().config.debuffs.minDuration or self:GetParent().config.buffs.minDuration)
    local maxDuration = config.maxDuration or (button.isDebuff and self:GetParent().config.debuffs.maxDuration or self:GetParent().config.buffs.maxDuration)
    local noDuration = (not duration or duration == 0)
    local allowDuration = noDuration or
                              (duration and duration > 0 and (not maxDuration or maxDuration == 0 or duration <= maxDuration) and (not minDuration or minDuration == 0 or duration >= minDuration))

    if not allowDuration then return false end

    local filter = config.filter or (button.isDebuff and self.debuffFilterConfig or self.buffFilterConfig)
    
    if filter.whitelist.CrowdControl and UF.auraFilters.CrowdControl[spellID] then
        return true
    elseif filter.whitelist.TurtleBuffs and UF.auraFilters.TurtleBuffs[spellID] then
        return true
    elseif filter.whitelist.PlayerBuffs and UF.auraFilters.PlayerBuffs[spellID] then
        return true
    elseif filter.whitelist.RaidBuffs and UF.auraFilters.RaidBuffs[spellID] then
        return true
    elseif filter.whitelist.RaidDebuffs and UF.auraFilters.RaidDebuffs[spellID] then
        return true
    elseif UF.auraFilters.Blacklist[spellID] then
        return false
    elseif UF.auraFilters.Whitelist[spellID] then
        return true
    end

    local myPet = caster == "pet"
    local otherPet = caster and not UnitIsUnit("pet", caster) and string.match(caster, "pet%d+")
    local isPlayer = caster == "player" or caster == "vehicle"
    local unitIsCaster = unit and caster and UnitIsUnit(unit, caster)
    local canDispel = (self.type == "debuffs" and R:PlayerCanDispel(debuffType)) or (self.type == "buffs" and isStealable)

    local isWhiteListed =
        (filter.whitelist.Personal and isPlayer) or (filter.whitelist.NonPersonal and not isPlayer) or (filter.whitelist.Boss and isBossDebuff) or (filter.whitelist.MyPet and myPet) or
            (filter.whitelist.OtherPet and otherPet) or (filter.whitelist.CastByUnit and unitIsCaster) or (filter.whitelist.NotCastByUnit and not unitIsCaster) or
            (filter.whitelist.Dispellable and canDispel) or (filter.whitelist.NotDispellable and not canDispel) or (filter.whitelist.CastByNPC and not casterIsPlayer) or
            (filter.whitelist.CastByPlayers and casterIsPlayer) or (filter.whitelist.Nameplate and (nameplateShowAll or (nameplateShowSelf and (isPlayer or myPet))))
    local isBlackListed = (filter.blacklist.BlockCastByPlayers and casterIsPlayer) or (filter.blacklist.BlockNoDuration and noDuration) or (filter.blacklist.BlockNonPersonal and not isPlayer) or
                              (filter.blacklist.BlockDispellable and canDispel) or (filter.blacklist.BlockNotDispellable and not canDispel)

    return isWhiteListed and not isBlackListed
end

if R.isRetail then
    --TODO: update
    UF.auraFilters = {
        CrowdControl = {
            -- Death Knight
            [55741] = true, -- Desecration
            [47481] = true, -- Gnaw (Ghoul)
            [49203] = true, -- Hungering Cold
            [47476] = true, -- Strangulate
            [53534] = true, -- Chains of Ice
            -- Druid
            [339] = true, -- Entangling Roots (Rank 1)
            [1062] = true, -- Entangling Roots (Rank 2)
            [5195] = true, -- Entangling Roots (Rank 3)
            [5196] = true, -- Entangling Roots (Rank 4)
            [9852] = true, -- Entangling Roots (Rank 5)
            [9853] = true, -- Entangling Roots (Rank 6)
            [26989] = true, -- Entangling Roots (Rank 7)
            [53308] = true, -- Entangling Roots (Rank 8)
            [19975] = true, -- Entangling Roots (Nature's Grasp) (Rank 1)
            [19974] = true, -- Entangling Roots (Nature's Grasp) (Rank 2)
            [19973] = true, -- Entangling Roots (Nature's Grasp) (Rank 3)
            [19972] = true, -- Entangling Roots (Nature's Grasp) (Rank 4)
            [19971] = true, -- Entangling Roots (Nature's Grasp) (Rank 5)
            [19970] = true, -- Entangling Roots (Nature's Grasp) (Rank 6)
            [27010] = true, -- Entangling Roots (Nature's Grasp) (Rank 7)
            [53313] = true, -- Entangling Roots (Nature's Grasp) (Rank 8)
            [2637] = true, -- Hibernate (Rank 1)
            [18657] = true, -- Hibernate (Rank 2)
            [18658] = true, -- Hibernate (Rank 3)
            [45334] = true, -- Feral Charge Effect
            [5211] = true, -- Bash (Rank 1)
            [6798] = true, -- Bash (Rank 2)
            [8983] = true, -- Bash (Rank 3)
            [16922] = true, -- Celestial Focus (Starfire Stun)
            [9005] = true, -- Pounce (Rank 1)
            [9823] = true, -- Pounce (Rank 2)
            [9827] = true, -- Pounce (Rank 3)
            [27006] = true, -- Pounce (Rank 4)
            [49803] = true, -- Pounce (Rank 5)
            [770] = true, -- Faerie Fire
            [16857] = true, -- Faerie Fire (Feral)
            [22570] = true, -- Maim (Rank 1)
            [49802] = true, -- Maim (Rank 2)
            [33786] = true, -- Cyclone
            [50259] = true, -- Dazed (Feral Charge - Cat)
            [61391] = true, -- Typhoon
            -- Hunter
            [60210] = true, -- Freezing Arrow Effect
            [3355] = true, -- Freezing Trap Effect (Rank 1)
            [14308] = true, -- Freezing Trap Effect (Rank 2)
            [14309] = true, -- Freezing Trap Effect (Rank 3)
            [13810] = true, -- Frost Trap Aura
            [19503] = true, -- Scatter Shot
            [5116] = true, -- Concussive Shot
            [2974] = true, -- Wing Clip
            [1513] = true, -- Scare Beast (Rank 1)
            [14326] = true, -- Scare Beast (Rank 2)
            [14327] = true, -- Scare Beast (Rank 3)
            [24394] = true, -- Intimidation
            [19386] = true, -- Wyvern Sting (Rank 1)
            [24132] = true, -- Wyvern Sting (Rank 2)
            [24133] = true, -- Wyvern Sting (Rank 3)
            [27068] = true, -- Wyvern Sting (Rank 4)
            [49011] = true, -- Wyvern Sting (Rank 5)
            [49012] = true, -- Wyvern Sting (Rank 6)
            [19229] = true, -- Improved Wing Clip
            [19306] = true, -- Counterattack (Rank 1)
            [20909] = true, -- Counterattack (Rank 2)
            [20910] = true, -- Counterattack (Rank 3)
            [27067] = true, -- Counterattack (Rank 4)
            [48998] = true, -- Counterattack (Rank 5)
            [48999] = true, -- Counterattack (Rank 6)
            [34490] = true, -- Silencing Shot
            [25999] = true, -- Charge (Boar)
            [19185] = true, -- Entrapment
            [53359] = true, -- Chimera Shot - Scorpid
            [35101] = true, -- Concussive Barrage
            [61394] = true, -- Glyph of Freezing Trap
            -- Mage
            [118] = true, -- Polymorph (Rank 1)
            [12824] = true, -- Polymorph (Rank 2)
            [12825] = true, -- Polymorph (Rank 3)
            [12826] = true, -- Polymorph (Rank 4)
            [28271] = true, -- Polymorph (Turtle)
            [28272] = true, -- Polymorph (Pig)
            [59634] = true, -- Polymorph (Penguin)
            [61305] = true, -- Polymorph (Black Cat)
            [61721] = true, -- Polymorph (Rabbit)
            [61780] = true, -- Polymorph (Turkey)
            [31661] = true, -- Dragon's Breath (Rank 1)
            [33041] = true, -- Dragon's Breath (Rank 2)
            [33042] = true, -- Dragon's Breath (Rank 3)
            [33043] = true, -- Dragon's Breath (Rank 4)
            [42949] = true, -- Dragon's Breath (Rank 5)
            [42950] = true, -- Dragon's Breath (Rank 6)
            [122] = true, -- Frost Nova (Rank 1)
            [865] = true, -- Frost Nova (Rank 2)
            [6131] = true, -- Frost Nova (Rank 3)
            [10230] = true, -- Frost Nova (Rank 4)
            [27088] = true, -- Frost Nova (Rank 5)
            [42917] = true, -- Frost Nova (Rank 6)
            [12494] = true, -- Frostbite
            [116] = true, -- Frostbolt (Rank 1)
            [205] = true, -- Frostbolt (Rank 2)
            [837] = true, -- Frostbolt (Rank 3)
            [7322] = true, -- Frostbolt (Rank 4)
            [8406] = true, -- Frostbolt (Rank 5)
            [8407] = true, -- Frostbolt (Rank 6)
            [8408] = true, -- Frostbolt (Rank 7)
            [10179] = true, -- Frostbolt (Rank 8)
            [10180] = true, -- Frostbolt (Rank 9)
            [10181] = true, -- Frostbolt (Rank 10)
            [25304] = true, -- Frostbolt (Rank 11)
            [27071] = true, -- Frostbolt (Rank 12)
            [27072] = true, -- Frostbolt (Rank 13)
            [38697] = true, -- Frostbolt (Rank 14)
            [42841] = true, -- Frostbolt (Rank 15)
            [42842] = true, -- Frostbolt (Rank 16)
            [12355] = true, -- Impact
            [18469] = true, -- Silenced - Improved Counterspell
            [33395] = true, -- Freeze (Water Elemental)
            [11113] = true, -- Blast Wave
            [12484] = true, -- Chilled (Blizzard) (Rank 1)
            [12485] = true, -- Chilled (Blizzard) (Rank 2)
            [12486] = true, -- Chilled (Blizzard) (Rank 3)
            [6136] = true, -- Chilled (Frost Armor)
            [7321] = true, -- Chilled (Ice Armor)
            [120] = true, -- Cone of Cold (Rank 1)
            [8492] = true, -- Cone of Cold (Rank 2)
            [10159] = true, -- Cone of Cold (Rank 3)
            [10160] = true, -- Cone of Cold (Rank 4)
            [10161] = true, -- Cone of Cold (Rank 5)
            [27087] = true, -- Cone of Cold (Rank 6)
            [42930] = true, -- Cone of Cold (Rank 7)
            [42931] = true, -- Cone of Cold (Rank 8)
            [44572] = true, -- Deep Freeze
            [64346] = true, -- Fiery Payback
            [44614] = true, -- Frostfire Bolt (Rank 1)
            [47610] = true, -- Frostfire Bolt (Rank 2)
            [31589] = true, -- Slow
            -- Paladin
            [853] = true, -- Hammer of Justice (Rank 1)
            [5588] = true, -- Hammer of Justice (Rank 2)
            [5589] = true, -- Hammer of Justice (Rank 3)
            [10308] = true, -- Hammer of Justice (Rank 4)
            [20066] = true, -- Repentance
            [20170] = true, -- Stun (Seal of Justice Proc)
            [10326] = true, -- Turn Evil
            [63529] = true, -- Silenced - Shield of the Templar
            [31935] = true, -- Avenger's Shield
            -- Priest
            [8122] = true, -- Psychic Scream (Rank 1)
            [8124] = true, -- Psychic Scream (Rank 2)
            [10888] = true, -- Psychic Scream (Rank 3)
            [10890] = true, -- Psychic Scream (Rank 4)
            [605] = true, -- Mind Control
            [15269] = true, -- Blackout
            [15407] = true, -- Mind Flay (Rank 1)
            [17311] = true, -- Mind Flay (Rank 2)
            [17312] = true, -- Mind Flay (Rank 3)
            [17313] = true, -- Mind Flay (Rank 4)
            [17314] = true, -- Mind Flay (Rank 5)
            [18807] = true, -- Mind Flay (Rank 6)
            [25387] = true, -- Mind Flay (Rank 7)
            [48155] = true, -- Mind Flay (Rank 8)
            [48156] = true, -- Mind Flay (Rank 9)
            [9484] = true, -- Shackle Undead (Rank 1)
            [9485] = true, -- Shackle Undead (Rank 2)
            [10955] = true, -- Shackle Undead (Rank 3)
            [64044] = true, -- Psychic Horror
            [64058] = true, -- Psychic Horror (Disarm)
            [15487] = true, -- Silence
            -- Rogue
            [6770] = true, -- Sap (Rank 1)
            [2070] = true, -- Sap (Rank 2)
            [11297] = true, -- Sap (Rank 3)
            [51724] = true, -- Sap (Rank 4)
            [2094] = true, -- Blind
            [408] = true, -- Kidney Shot (Rank 1)
            [8643] = true, -- Kidney Shot (Rank 2)
            [1833] = true, -- Cheap Shot
            [1776] = true, -- Gouge (Rank 1)
            [1777] = true, -- Gouge (Rank 2)
            [8629] = true, -- Gouge (Rank 3)
            [11285] = true, -- Gouge (Rank 4)
            [11286] = true, -- Gouge (Rank 5)
            [38764] = true, -- Gouge (Rank 6)
            [1330] = true, -- Garrote - Silence
            [18425] = true, -- Silenced - Improved Kick
            [51722] = true, -- Dismantle
            [31125] = true, -- Blade Twisting (Rank 1)
            [51585] = true, -- Blade Twisting (Rank 2)
            [3409] = true, -- Crippling Poison
            [26679] = true, -- Deadly Throw
            [32747] = true, -- Interrupt (Deadly Throw)
            [51693] = true, -- Waylay
            -- Shaman
            [2484] = true, -- Earthbind Totem
            [8056] = true, -- Frost Shock (Rank 1)
            [8058] = true, -- Frost Shock (Rank 2)
            [10472] = true, -- Frost Shock (Rank 3)
            [10473] = true, -- Frost Shock (Rank 4)
            [25464] = true, -- Frost Shock (Rank 5)
            [49235] = true, -- Frost Shock (Rank 6)
            [49236] = true, -- Frost Shock (Rank 7)
            [39796] = true, -- Stoneclaw Totem
            [58861] = true, -- Bash (Spirit Wolf)
            [51514] = true, -- Hex
            [8034] = true, -- Frostbrand Attack (Rank 1)
            [8037] = true, -- Frostbrand Attack (Rank 2)
            [10458] = true, -- Frostbrand Attack (Rank 3)
            [16352] = true, -- Frostbrand Attack (Rank 4)
            [16353] = true, -- Frostbrand Attack (Rank 5)
            [25501] = true, -- Frostbrand Attack (Rank 6)
            [58797] = true, -- Frostbrand Attack (Rank 7)
            [58798] = true, -- Frostbrand Attack (Rank 8)
            [58799] = true, -- Frostbrand Attack (Rank 9)
            -- Warlock
            [5782] = true, -- Fear (Rank 1)
            [6213] = true, -- Fear (Rank 2)
            [6215] = true, -- Fear (Rank 3)
            [6358] = true, -- Seduction (Succubus)
            [18223] = true, -- Curse of Exhaustion
            [18093] = true, -- Pyroclasm
            [710] = true, -- Banish (Rank 1)
            [18647] = true, -- Banish (Rank 2)
            [30413] = true, -- Shadowfury
            [6789] = true, -- Death Coil (Rank 1)
            [17925] = true, -- Death Coil (Rank 2)
            [17926] = true, -- Death Coil (Rank 3)
            [27223] = true, -- Death Coil (Rank 4)
            [5484] = true, -- Howl of Terror (Rank 1)
            [17928] = true, -- Howl of Terror (Rank 2)
            [24259] = true, -- Spell Lock (Felhunter)
            [18118] = true, -- Aftermath
            [20812] = true, -- Cripple (Doomguard)
            [60995] = true, -- Demon Charge (Metamorphosis)
            [1098] = true, -- Enslave Demon (Rank 1)
            [11725] = true, -- Enslave Demon (Rank 2)
            [11726] = true, -- Enslave Demon (Rank 3)
            [61191] = true, -- Enslave Demon (Rank 4)
            [63311] = true, -- Glyph of Shadowflame
            [30153] = true, -- Intercept (Felguard)
            [31117] = true, -- Unstable Affliction (Silence)
            -- Warrior
            [20511] = true, -- Intimidating Shout (Cower)
            [5246] = true, -- Intimidating Shout (Fear)
            [1715] = true, -- Hamstring
            [12809] = true, -- Concussion Blow
            [20253] = true, -- Intercept Stun (Rank 1)
            [20614] = true, -- Intercept Stun (Rank 2)
            [20615] = true, -- Intercept Stun (Rank 3)
            [25273] = true, -- Intercept Stun (Rank 4)
            [25274] = true, -- Intercept Stun (Rank 5)
            [7386] = true, -- Sunder Armor
            [7922] = true, -- Charge Stun
            [18498] = true, -- Silenced - Gag Order
            [46968] = true, -- Shockwave
            [23694] = true, -- Improved Hamstring
            [58373] = true, -- Glyph of Hamstring
            [676] = true, -- Disarm
            [12323] = true, -- Piercing Howl
            -- Racial
            [20549] = true, -- War Stomp
            [28730] = true, -- Arcane Torrent (Mana)
            [25046] = true, -- Arcane Torrent (Energy)
            [50613] = true -- Arcane Torrent (Runic Power)
        },
        TurtleBuffs = {
            -- Death Knight
            [48707] = true, -- Anti-Magic Shell
            [51052] = true, -- Anti-Magic Zone
            [42650] = true, -- Army of the Dead
            [49222] = true, -- Bone Shield
            [48792] = true, -- Icebound Fortitude
            [49039] = true, -- Lichborne
            [51271] = true, -- Unbreakable Armor
            [55233] = true, -- Vampiric Blood
            -- Druid
            [22812] = true, -- Barkskin
            -- Hunter
            [19263] = true, -- Deterrence
            [34471] = true, -- The Beast Within
            -- Mage
            [45438] = true, -- Ice Block
            [66] = true, -- Invisibility
            -- Paladin
            [498] = true, -- Divine Protection
            [642] = true, -- Divine Shield
            [1022] = true, -- Hand of Protection (Rank 1)
            [5599] = true, -- Hand of Protection (Rank 2)
            [10278] = true, -- Hand of Protection (Rank 3)
            [31821] = true, -- Aura Mastery
            [70940] = true, -- Divine Guardian
            [64205] = true, -- Divine Sacrifice
            -- Priest
            [47585] = true, -- Dispersion
            [47788] = true, -- Guardian Spirit
            -- Rogue
            [31224] = true, -- Cloak of Shadows
            [5277] = true, -- Evasion (Rank 1)
            [26669] = true, -- Evasion (Rank 2)
            [1856] = true, -- Vanish (Rank 1)
            [1857] = true, -- Vanish (Rank 2)
            [26889] = true, -- Vanish (Rank 3)
            -- Shaman
            [974] = true, -- Earth Shield (Rank 1)
            [32593] = true, -- Earth Shield (Rank 2)
            [32594] = true, -- Earth Shield (Rank 3)
            [49283] = true, -- Earth Shield (Rank 4)
            [49284] = true, -- Earth Shield (Rank 5)
            [30823] = true, -- Shamanistic Rage
            -- Warrior
            [12975] = true, -- Last Stand
            [871] = true, -- Shield Wall
            [20230] = true, -- Retaliation
            [2565] = true, -- Shield Block
            [46924] = true, -- Bladestorm
            [23920] = true, -- Spell Reflection
            -- Consumables
            [3169] = true, -- Limited Invulnerability Potion
            [6615] = true, -- Free Action Potion
            -- Racial
            [7744] = true, -- Will of the Forsaken
            [6346] = true, -- Fear Ward
            [20594] = true, -- Stoneform
            -- All Classes
            [19753] = true -- Divine Intervention
        },
        PlayerBuffs = {
            -- Death Knight
            [48707] = true, -- Anti-Magic Shell
            [51052] = true, -- Anti-Magic Zone
            [49222] = true, -- Bone Shield
            [49028] = true, -- Dancing Rune Weapon
            [49796] = true, -- Deathchill
            [63560] = true, -- Ghoul Frenzy (Ghoul)
            [48792] = true, -- Icebound Fortitude
            [49039] = true, -- Lichborne
            [61777] = true, -- Summon Gargoyle
            [51271] = true, -- Unbreakable Armor
            [55233] = true, -- Vampiric Blood
            -- Druid
            [29166] = true, -- Innervate
            [22812] = true, -- Barkskin
            [17116] = true, -- Nature's Swiftness
            [16689] = true, -- Nature's Grasp (Rank 1)
            [16810] = true, -- Nature's Grasp (Rank 2)
            [16811] = true, -- Nature's Grasp (Rank 3)
            [16812] = true, -- Nature's Grasp (Rank 4)
            [16813] = true, -- Nature's Grasp (Rank 5)
            [17329] = true, -- Nature's Grasp (Rank 6)
            [27009] = true, -- Nature's Grasp (Rank 7)
            [53312] = true, -- Nature's Grasp (Rank 8)
            [16864] = true, -- Omen of Clarity
            [5217] = true, -- Tiger's Fury (Rank 1)
            [6793] = true, -- Tiger's Fury (Rank 2)
            [9845] = true, -- Tiger's Fury (Rank 3)
            [9846] = true, -- Tiger's Fury (Rank 4)
            [50212] = true, -- Tiger's Fury (Rank 5)
            [50213] = true, -- Tiger's Fury (Rank 6)
            [2893] = true, -- Abolish Poison
            [5229] = true, -- Enrage
            [1850] = true, -- Dash (Rank 1)
            [9821] = true, -- Dash (Rank 2)
            [33357] = true, -- Dash (Rank 3)
            [50334] = true, -- Berserk
            [48505] = true, -- Starfall (Rank 1)
            [53199] = true, -- Starfall (Rank 2)
            [53200] = true, -- Starfall (Rank 3)
            [53201] = true, -- Starfall (Rank 4)
            [61336] = true, -- Survival Instincts
            [740] = true, -- Tranquility
            -- Hunter
            [13161] = true, -- Aspect of the Beast
            [5118] = true, -- Aspect of the Cheetah
            [13163] = true, -- Aspect of the Monkey
            [13159] = true, -- Aspect of the Pack
            [20043] = true, -- Aspect of the Wild (Rank 1)
            [20190] = true, -- Aspect of the Wild (Rank 2)
            [27045] = true, -- Aspect of the Wild (Rank 3)
            [49071] = true, -- Aspect of the Wild (Rank 4)
            [3045] = true, -- Rapid Fire
            [19263] = true, -- Deterrence
            [13165] = true, -- Aspect of the Hawk (Rank 1)
            [14318] = true, -- Aspect of the Hawk (Rank 2)
            [14319] = true, -- Aspect of the Hawk (Rank 3)
            [14320] = true, -- Aspect of the Hawk (Rank 4)
            [14321] = true, -- Aspect of the Hawk (Rank 5)
            [14322] = true, -- Aspect of the Hawk (Rank 6)
            [25296] = true, -- Aspect of the Hawk (Rank 7)
            [27044] = true, -- Aspect of the Hawk (Rank 8)
            [19574] = true, -- Bestial Wrath
            [35098] = true, -- Rapid Killing
            [34471] = true, -- The Beast Within
            -- Mage
            [45438] = true, -- Ice Block
            [12043] = true, -- Presence of Mind
            [28682] = true, -- Combustion
            [12042] = true, -- Arcane Power
            [11426] = true, -- Ice Barrier (Rank 1)
            [13031] = true, -- Ice Barrier (Rank 2)
            [13032] = true, -- Ice Barrier (Rank 3)
            [13033] = true, -- Ice Barrier (Rank 4)
            [27134] = true, -- Ice Barrier (Rank 5)
            [33405] = true, -- Ice Barrier (Rank 6)
            [43038] = true, -- Ice Barrier (Rank 7)
            [43039] = true, -- Ice Barrier (Rank 8)
            [12472] = true, -- Icy Veins
            [66] = true, -- Invisibility
            [55342] = true, -- Mirror Image
            -- Paladin
            [1044] = true, -- Hand of Freedom
            [1038] = true, -- Hand of Salvation
            [465] = true, -- Devotion Aura (Rank 1)
            [10290] = true, -- Devotion Aura (Rank 2)
            [643] = true, -- Devotion Aura (Rank 3)
            [10291] = true, -- Devotion Aura (Rank 4)
            [1032] = true, -- Devotion Aura (Rank 5)
            [10292] = true, -- Devotion Aura (Rank 6)
            [10293] = true, -- Devotion Aura (Rank 7)
            [27149] = true, -- Devotion Aura (Rank 8)
            [48941] = true, -- Devotion Aura (Rank 9)
            [48942] = true, -- Devotion Aura (Rank 10)
            [19746] = true, -- Concentration Aura
            [7294] = true, -- Retribution Aura (Rank 1)
            [10298] = true, -- Retribution Aura (Rank 2)
            [10299] = true, -- Retribution Aura (Rank 3)
            [10300] = true, -- Retribution Aura (Rank 4)
            [10301] = true, -- Retribution Aura (Rank 5)
            [27150] = true, -- Retribution Aura (Rank 6)
            [54043] = true, -- Retribution Aura (Rank 7)
            [19876] = true, -- Shadow Resistance Aura (Rank 1)
            [19895] = true, -- Shadow Resistance Aura (Rank 2)
            [19896] = true, -- Shadow Resistance Aura (Rank 3)
            [27151] = true, -- Shadow Resistance Aura (Rank 4)
            [48943] = true, -- Shadow Resistance Aura (Rank 5)
            [19888] = true, -- Frost Resistance Aura (Rank 1)
            [19897] = true, -- Frost Resistance Aura (Rank 2)
            [19898] = true, -- Frost Resistance Aura (Rank 3)
            [27152] = true, -- Frost Resistance Aura (Rank 4)
            [48945] = true, -- Frost Resistance Aura (Rank 5)
            [19891] = true, -- Fire Resistance Aura (Rank 1)
            [19899] = true, -- Fire Resistance Aura (Rank 2)
            [19900] = true, -- Fire Resistance Aura (Rank 3)
            [27153] = true, -- Fire Resistance Aura (Rank 4)
            [48497] = true, -- Fire Resistance Aura (Rank 5)
            [498] = true, -- Divine Protection
            [642] = true, -- Divine Shield
            [1022] = true, -- Hand of Protection (Rank 1)
            [5599] = true, -- Hand of Protection (Rank 2)
            [10278] = true, -- Hand of Protection (Rank 3)
            [31821] = true, -- Aura Mastery
            [70940] = true, -- Divine Guardian
            [64205] = true, -- Divine Sacrifice
            [6940] = true, -- Hand of Sacrifice
            [31884] = true, -- Avenging Wrath
            [20216] = true, -- Divine Favor
            [31842] = true, -- Divine Illumination
            -- Priest
            [15473] = true, -- Shadowform
            [10060] = true, -- Power Infusion
            [14751] = true, -- Inner Focus
            [1706] = true, -- Levitate
            [586] = true, -- Fade
            [64843] = true, -- Divine Hymn
            [47788] = true, -- Guardian Spirit
            [64901] = true, -- Hymn of Hope
            [47585] = true, -- Dispersion
            -- Rogue
            [14177] = true, -- Cold Blood
            [13877] = true, -- Blade Flurry
            [13750] = true, -- Adrenaline Rush
            [2983] = true, -- Sprint (Rank 1)
            [8696] = true, -- Sprint (Rank 2)
            [11305] = true, -- Sprint (Rank 3)
            [5171] = true, -- Slice and Dice (Rank 1)
            [6774] = true, -- Slice and Dice (Rank 2)
            [45182] = true, -- Cheating Death
            [51690] = true, -- Killing Spree
            [51713] = true, -- Shadow Dance
            [57933] = true, -- Tricks of the Trade
            [31224] = true, -- Cloak of Shadows
            [5277] = true, -- Evasion (Rank 1)
            [26669] = true, -- Evasion (Rank 2)
            [1856] = true, -- Vanish (Rank 1)
            [1857] = true, -- Vanish (Rank 2)
            [26889] = true, -- Vanish (Rank 3)
            -- Shaman
            [2645] = true, -- Ghost Wolf
            [324] = true, -- Lightning Shield (Rank 1)
            [325] = true, -- Lightning Shield (Rank 2)
            [905] = true, -- Lightning Shield (Rank 3)
            [945] = true, -- Lightning Shield (Rank 4)
            [8134] = true, -- Lightning Shield (Rank 5)
            [10431] = true, -- Lightning Shield (Rank 6)
            [10432] = true, -- Lightning Shield (Rank 7)
            [25469] = true, -- Lightning Shield (Rank 8)
            [25472] = true, -- Lightning Shield (Rank 9)
            [49280] = true, -- Lightning Shield (Rank 10)
            [49281] = true, -- Lightning Shield (Rank 11)
            [16188] = true, -- Nature's Swiftness
            [16166] = true, -- Elemental Mastery
            [52127] = true, -- Water Shield (Rank 1)
            [52129] = true, -- Water Shield (Rank 2)
            [52131] = true, -- Water Shield (Rank 3)
            [52134] = true, -- Water Shield (Rank 4)
            [52136] = true, -- Water Shield (Rank 5)
            [52138] = true, -- Water Shield (Rank 6)
            [24398] = true, -- Water Shield (Rank 7)
            [33736] = true, -- Water Shield (Rank 8)
            [57960] = true, -- Water Shield (Rank 9)
            [974] = true, -- Earth Shield (Rank 1)
            [32593] = true, -- Earth Shield (Rank 2)
            [32594] = true, -- Earth Shield (Rank 3)
            [49283] = true, -- Earth Shield (Rank 4)
            [49284] = true, -- Earth Shield (Rank 5)
            [30823] = true, -- Shamanistic Rage
            [8178] = true, -- Grounding Totem Effect
            [16191] = true, -- Mana Tide
            [55198] = true, -- Tidal Force
            -- Warlock
            [18789] = true, -- Demonic Sacrifice (Burning Wish)
            [18790] = true, -- Demonic Sacrifice (Fel Stamina)
            [18791] = true, -- Demonic Sacrifice (Touch of Shadow)
            [18792] = true, -- Demonic Sacrifice (Fel Energy)
            [35701] = true, -- Demonic Sacrifice (Touch of Shadow)
            [5697] = true, -- Unending Breath
            [6512] = true, -- Detect Lesser Invisibility
            [25228] = true, -- Soul Link
            [18708] = true, -- Fel Domination
            [47241] = true, -- Metamorphosis
            -- Warrior
            [12975] = true, -- Last Stand
            [871] = true, -- Shield Wall
            [20230] = true, -- Retaliation
            [1719] = true, -- Recklessness
            [18499] = true, -- Berserker Rage
            [2687] = true, -- Bloodrage
            [12292] = true, -- Death Wish
            [12328] = true, -- Sweeping Strikes
            [2565] = true, -- Shield Block
            [12880] = true, -- Enrage (Rank 1)
            [14201] = true, -- Enrage (Rank 2)
            [14202] = true, -- Enrage (Rank 3)
            [14203] = true, -- Enrage (Rank 4)
            [14204] = true, -- Enrage (Rank 5)
            [46924] = true, -- Bladestorm
            [23920] = true, -- Spell Reflection
            -- Consumables
            [3169] = true, -- Limited Invulnerability Potion
            [6615] = true, -- Free Action Potion
            -- Racial
            [26297] = true, -- Berserking
            [7744] = true, -- Will of the Forsaken
            [20572] = true, -- Blood Fury (Physical)
            [33697] = true, -- Blood Fury (Both)
            [33702] = true, -- Blood Fury (Spell)
            [6346] = true, -- Fear Ward
            [20594] = true, -- Stoneform
            [28880] = true, -- Gift of the Naaru
            -- All Classes
            [19753] = true -- Divine Intervention
        },
        RaidBuffs = {
            -------------------------------------------------
            -------------------- Dungeons -------------------
            -------------------------------------------------
            -- Ahn'kahet: The Old Kingdom
            -- Azjol-Nerub
            -- Drak'Tharon Keep
            -- Gundrak
            -- Halls of Lightning
            -- Halls of Reflection
            -- Halls of Stone
            -- Pit of Saron
            -- The Culling of Stratholme
            -- The Forge of Souls
            -- The Nexus
            -- The Oculus
            -- The Violet Hold
            -- Trial of the Champion
            -- Utgarde Keep
            -- Utgarde Pinnacle
            -------------------------------------------------
            -------------------- Phase 1 --------------------
            -------------------------------------------------
            -- Naxxramas
            -- Anub'Rekhan
            [8269] = true, -- Frenzy
            [54021] = true, -- Locust Swarm
            -- Grand Widow Faerlina
            [54100] = true, -- Frenzy
            -- Maexxna
            [54124] = true, -- Frenzy
            -- Noth the Plaguebringer
            -- Heigan the Unclean
            -- Loatheb
            -- Instructor Razuvious
            [29061] = true, -- Bone Barrier
            -- Gothik the Harvester
            -- The Four Horsemen
            -- Patchwerk
            [28131] = true, -- Frenzy
            -- Grobbulus
            -- Gluth
            [54427] = true, -- Enrage
            -- Thaddius
            [28134] = true, -- Power Surge
            -- Sapphiron
            -- Kel'Thuzad
            -- The Eye of Eternity
            -- Malygos
            [56505] = true, -- Surge of Power
            [57060] = true, -- Haste
            [57428] = true, -- Static Field
            -- The Obsidian Sanctum
            -- Sartharion
            [58766] = true, -- Gift of Twilight
            [60639] = true, -- Twilight Revenge
            [61254] = true, -- Will of Sartharion
            [60430] = true -- Molten Fury
            -------------------------------------------------
            -------------------- Phase 2 --------------------
            -------------------------------------------------
            -- Ulduar
            -- Flame Leviathan
            -- Ignis the Furnace Master
            -- Razorscale
            -- XT-002 Deconstructor
            -- The Assembly of Iron
            -- Kologarn
            -- Auriaya
            -- Hodir
            -- Thorim
            -- Freya
            -- Mimiron
            -- General Vezax
            -- Yogg-Saron
            -- Algalon the Observer
            -------------------------------------------------
            -------------------- Phase 3 --------------------
            -------------------------------------------------
            -- Trial of the Crusader
            -- The Northrend Beasts
            -- Lord Jaraxxus
            -- Champions of the Horde
            -- Champions of the Alliance
            -- Twin Val'kyr
            -- Anub'arak
            -- Onyxia’s Lair
            -- Onyxia
            -------------------------------------------------
            -------------------- Phase 4 --------------------
            -------------------------------------------------
            -- Icecrown Citadel
            -- Lord Marrowgar
            -- Lady Deathwhisper
            -- Gunship Battle Alliance
            -- Gunship Battle Horde
            -- Deathbringer Saurfang
            -- Festergut
            -- Rotface
            -- Professor Putricide
            -- Blood Prince Council
            -- Blood-Queen Lana'thel
            -- Valithria Dreamwalker
            -- Sindragosa
            -- The Lich King
            -------------------------------------------------
            -------------------- Phase 5 --------------------
            -------------------------------------------------
            -- The Ruby Sanctum
            -- Halion
        },
        RaidDebuffs = {
            -------------------------------------------------
            -------------------- Dungeons -------------------
            -------------------------------------------------
            -- Ahn'kahet: The Old Kingdom
            -- Azjol-Nerub
            -- Drak'Tharon Keep
            -- Gundrak
            -- Halls of Lightning
            -- Halls of Reflection
            -- Halls of Stone
            -- Pit of Saron
            -- The Culling of Stratholme
            -- The Forge of Souls
            -- The Nexus
            -- The Oculus
            -- The Violet Hold
            -- Trial of the Champion
            -- Utgarde Keep
            -- Utgarde Pinnacle
            -------------------------------------------------
            -------------------- Phase 1 --------------------
            -------------------------------------------------
            -- Naxxramas
            -- Anub'Rekhan
            [54022] = true, -- Locust Swarm
            [56098] = true, -- Acid Spit
            -- Grand Widow Faerlina
            [54099] = true, -- Rain of Fire
            [54098] = true, -- Poison Bolt Volley
            -- Maexxna
            [54121] = true, -- Necrotic Poison 1
            [28776] = true, -- Necrotic Poison 2
            [28622] = true, -- Web Wrap
            [54125] = true, -- Web Spray
            -- Noth the Plaguebringer
            [54835] = true, -- Curse of the Plaguebringer
            [54814] = true, -- Cripple 1
            [29212] = true, -- Cripple 2
            -- Heigan the Unclean
            [55011] = true, -- Decrepit Fever
            -- Loatheb
            [55052] = true, -- Inevitable Doom
            [55053] = true, -- Deathbloom
            -- Instructor Razuvious
            [55550] = true, -- Jagged Knife
            [55470] = true, -- Unbalancing Strike
            -- Gothik the Harvester
            [55646] = true, -- Drain Life
            [55645] = true, -- Death Plague
            [28679] = true, -- Harvest Soul
            -- The Four Horsemen
            [57369] = true, -- Unholy Shadow
            [28832] = true, -- Mark of Korth'azz
            [28835] = true, -- Mark of Zeliek
            [28833] = true, -- Mark of Blaumeux
            [28834] = true, -- Mark of Rivendare
            -- Patchwerk
            [28801] = true, -- Slime / Not really Encounter related
            -- Grobbulus
            [28169] = true, -- Mutating Injection
            -- Gluth
            [54378] = true, -- Mortal Wound
            [29306] = true, -- Infected Wound
            -- Thaddius
            [28084] = true, -- Negative Charge (-)
            [28059] = true, -- Positive Charge (+)
            -- Sapphiron
            [28522] = true, -- Icebolt
            [55665] = true, -- Life Drain
            [28547] = true, -- Chill 1
            [55699] = true, -- Chill 2
            -- Kel'Thuzad
            [55807] = true, -- Frostbolt 1
            [55802] = true, -- Frostbolt 2
            [27808] = true, -- Frost Blast
            [28410] = true, -- Chains of Kel'Thuzad
            -- The Eye of Eternity
            -- Malygos
            [56272] = true, -- Arcane Breath
            [55853] = true, -- Vortex 1
            [56263] = true, -- Vortex 2
            [57407] = true, -- Surge of Power
            [57429] = true, -- Static Field
            -- The Obsidian Sanctum
            -- Sartharion
            [60708] = true, -- Fade Armor
            [58105] = true, -- Power of Shadron
            [61248] = true, -- Power of Tenebron
            [56910] = true, -- Tail Lash
            [57874] = true, -- Twilight Shift
            [57632] = true -- Magma
            -------------------------------------------------
            -------------------- Phase 2 --------------------
            -------------------------------------------------
            -- Ulduar
            -- Flame Leviathan
            -- Ignis the Furnace Master
            -- Razorscale
            -- XT-002 Deconstructor
            -- The Assembly of Iron
            -- Kologarn
            -- Auriaya
            -- Hodir
            -- Thorim
            -- Freya
            -- Mimiron
            -- General Vezax
            -- Yogg-Saron
            -- Algalon the Observer
            -------------------------------------------------
            -------------------- Phase 3 --------------------
            -------------------------------------------------
            -- Trial of the Crusader
            -- The Northrend Beasts
            -- Lord Jaraxxus
            -- Champions of the Horde
            -- Champions of the Alliance
            -- Twin Val'kyr
            -- Anub'arak
            -- Onyxia’s Lair
            -- Onyxia
            -------------------------------------------------
            -------------------- Phase 4 --------------------
            -------------------------------------------------
            -- Icecrown Citadel
            -- Lord Marrowgar
            -- Lady Deathwhisper
            -- Gunship Battle Alliance
            -- Gunship Battle Horde
            -- Deathbringer Saurfang
            -- Festergut
            -- Rotface
            -- Professor Putricide
            -- Blood Prince Council
            -- Blood-Queen Lana'thel
            -- Valithria Dreamwalker
            -- Sindragosa
            -- The Lich King
            -------------------------------------------------
            -------------------- Phase 5 --------------------
            -------------------------------------------------
            -- The Ruby Sanctum
            -- Halion
        },
        Blacklist = {
            -- General
            [186403] = true, -- Sign of Battle
            [377749] = true -- Joyous Journeys (50% exp buff)
        },
        Whitelist = {}
    }
else
    UF.auraFilters = {
        CrowdControl = {
            -- Death Knight
            [55741] = true, -- Desecration
            [47481] = true, -- Gnaw (Ghoul)
            [49203] = true, -- Hungering Cold
            [47476] = true, -- Strangulate
            [53534] = true, -- Chains of Ice
            -- Druid
            [339] = true, -- Entangling Roots (Rank 1)
            [1062] = true, -- Entangling Roots (Rank 2)
            [5195] = true, -- Entangling Roots (Rank 3)
            [5196] = true, -- Entangling Roots (Rank 4)
            [9852] = true, -- Entangling Roots (Rank 5)
            [9853] = true, -- Entangling Roots (Rank 6)
            [26989] = true, -- Entangling Roots (Rank 7)
            [53308] = true, -- Entangling Roots (Rank 8)
            [19975] = true, -- Entangling Roots (Nature's Grasp) (Rank 1)
            [19974] = true, -- Entangling Roots (Nature's Grasp) (Rank 2)
            [19973] = true, -- Entangling Roots (Nature's Grasp) (Rank 3)
            [19972] = true, -- Entangling Roots (Nature's Grasp) (Rank 4)
            [19971] = true, -- Entangling Roots (Nature's Grasp) (Rank 5)
            [19970] = true, -- Entangling Roots (Nature's Grasp) (Rank 6)
            [27010] = true, -- Entangling Roots (Nature's Grasp) (Rank 7)
            [53313] = true, -- Entangling Roots (Nature's Grasp) (Rank 8)
            [2637] = true, -- Hibernate (Rank 1)
            [18657] = true, -- Hibernate (Rank 2)
            [18658] = true, -- Hibernate (Rank 3)
            [45334] = true, -- Feral Charge Effect
            [5211] = true, -- Bash (Rank 1)
            [6798] = true, -- Bash (Rank 2)
            [8983] = true, -- Bash (Rank 3)
            [16922] = true, -- Celestial Focus (Starfire Stun)
            [9005] = true, -- Pounce (Rank 1)
            [9823] = true, -- Pounce (Rank 2)
            [9827] = true, -- Pounce (Rank 3)
            [27006] = true, -- Pounce (Rank 4)
            [49803] = true, -- Pounce (Rank 5)
            [770] = true, -- Faerie Fire
            [16857] = true, -- Faerie Fire (Feral)
            [22570] = true, -- Maim (Rank 1)
            [49802] = true, -- Maim (Rank 2)
            [33786] = true, -- Cyclone
            [50259] = true, -- Dazed (Feral Charge - Cat)
            [61391] = true, -- Typhoon
            -- Hunter
            [60210] = true, -- Freezing Arrow Effect
            [3355] = true, -- Freezing Trap Effect (Rank 1)
            [14308] = true, -- Freezing Trap Effect (Rank 2)
            [14309] = true, -- Freezing Trap Effect (Rank 3)
            [13810] = true, -- Frost Trap Aura
            [19503] = true, -- Scatter Shot
            [5116] = true, -- Concussive Shot
            [2974] = true, -- Wing Clip
            [1513] = true, -- Scare Beast (Rank 1)
            [14326] = true, -- Scare Beast (Rank 2)
            [14327] = true, -- Scare Beast (Rank 3)
            [24394] = true, -- Intimidation
            [19386] = true, -- Wyvern Sting (Rank 1)
            [24132] = true, -- Wyvern Sting (Rank 2)
            [24133] = true, -- Wyvern Sting (Rank 3)
            [27068] = true, -- Wyvern Sting (Rank 4)
            [49011] = true, -- Wyvern Sting (Rank 5)
            [49012] = true, -- Wyvern Sting (Rank 6)
            [19229] = true, -- Improved Wing Clip
            [19306] = true, -- Counterattack (Rank 1)
            [20909] = true, -- Counterattack (Rank 2)
            [20910] = true, -- Counterattack (Rank 3)
            [27067] = true, -- Counterattack (Rank 4)
            [48998] = true, -- Counterattack (Rank 5)
            [48999] = true, -- Counterattack (Rank 6)
            [34490] = true, -- Silencing Shot
            [25999] = true, -- Charge (Boar)
            [19185] = true, -- Entrapment
            [53359] = true, -- Chimera Shot - Scorpid
            [35101] = true, -- Concussive Barrage
            [61394] = true, -- Glyph of Freezing Trap
            -- Mage
            [118] = true, -- Polymorph (Rank 1)
            [12824] = true, -- Polymorph (Rank 2)
            [12825] = true, -- Polymorph (Rank 3)
            [12826] = true, -- Polymorph (Rank 4)
            [28271] = true, -- Polymorph (Turtle)
            [28272] = true, -- Polymorph (Pig)
            [59634] = true, -- Polymorph (Penguin)
            [61305] = true, -- Polymorph (Black Cat)
            [61721] = true, -- Polymorph (Rabbit)
            [61780] = true, -- Polymorph (Turkey)
            [31661] = true, -- Dragon's Breath (Rank 1)
            [33041] = true, -- Dragon's Breath (Rank 2)
            [33042] = true, -- Dragon's Breath (Rank 3)
            [33043] = true, -- Dragon's Breath (Rank 4)
            [42949] = true, -- Dragon's Breath (Rank 5)
            [42950] = true, -- Dragon's Breath (Rank 6)
            [122] = true, -- Frost Nova (Rank 1)
            [865] = true, -- Frost Nova (Rank 2)
            [6131] = true, -- Frost Nova (Rank 3)
            [10230] = true, -- Frost Nova (Rank 4)
            [27088] = true, -- Frost Nova (Rank 5)
            [42917] = true, -- Frost Nova (Rank 6)
            [12494] = true, -- Frostbite
            [116] = true, -- Frostbolt (Rank 1)
            [205] = true, -- Frostbolt (Rank 2)
            [837] = true, -- Frostbolt (Rank 3)
            [7322] = true, -- Frostbolt (Rank 4)
            [8406] = true, -- Frostbolt (Rank 5)
            [8407] = true, -- Frostbolt (Rank 6)
            [8408] = true, -- Frostbolt (Rank 7)
            [10179] = true, -- Frostbolt (Rank 8)
            [10180] = true, -- Frostbolt (Rank 9)
            [10181] = true, -- Frostbolt (Rank 10)
            [25304] = true, -- Frostbolt (Rank 11)
            [27071] = true, -- Frostbolt (Rank 12)
            [27072] = true, -- Frostbolt (Rank 13)
            [38697] = true, -- Frostbolt (Rank 14)
            [42841] = true, -- Frostbolt (Rank 15)
            [42842] = true, -- Frostbolt (Rank 16)
            [12355] = true, -- Impact
            [18469] = true, -- Silenced - Improved Counterspell
            [33395] = true, -- Freeze (Water Elemental)
            [11113] = true, -- Blast Wave
            [12484] = true, -- Chilled (Blizzard) (Rank 1)
            [12485] = true, -- Chilled (Blizzard) (Rank 2)
            [12486] = true, -- Chilled (Blizzard) (Rank 3)
            [6136] = true, -- Chilled (Frost Armor)
            [7321] = true, -- Chilled (Ice Armor)
            [120] = true, -- Cone of Cold (Rank 1)
            [8492] = true, -- Cone of Cold (Rank 2)
            [10159] = true, -- Cone of Cold (Rank 3)
            [10160] = true, -- Cone of Cold (Rank 4)
            [10161] = true, -- Cone of Cold (Rank 5)
            [27087] = true, -- Cone of Cold (Rank 6)
            [42930] = true, -- Cone of Cold (Rank 7)
            [42931] = true, -- Cone of Cold (Rank 8)
            [44572] = true, -- Deep Freeze
            [64346] = true, -- Fiery Payback
            [44614] = true, -- Frostfire Bolt (Rank 1)
            [47610] = true, -- Frostfire Bolt (Rank 2)
            [31589] = true, -- Slow
            -- Paladin
            [853] = true, -- Hammer of Justice (Rank 1)
            [5588] = true, -- Hammer of Justice (Rank 2)
            [5589] = true, -- Hammer of Justice (Rank 3)
            [10308] = true, -- Hammer of Justice (Rank 4)
            [20066] = true, -- Repentance
            [20170] = true, -- Stun (Seal of Justice Proc)
            [10326] = true, -- Turn Evil
            [63529] = true, -- Silenced - Shield of the Templar
            [31935] = true, -- Avenger's Shield
            -- Priest
            [8122] = true, -- Psychic Scream (Rank 1)
            [8124] = true, -- Psychic Scream (Rank 2)
            [10888] = true, -- Psychic Scream (Rank 3)
            [10890] = true, -- Psychic Scream (Rank 4)
            [605] = true, -- Mind Control
            [15269] = true, -- Blackout
            [15407] = true, -- Mind Flay (Rank 1)
            [17311] = true, -- Mind Flay (Rank 2)
            [17312] = true, -- Mind Flay (Rank 3)
            [17313] = true, -- Mind Flay (Rank 4)
            [17314] = true, -- Mind Flay (Rank 5)
            [18807] = true, -- Mind Flay (Rank 6)
            [25387] = true, -- Mind Flay (Rank 7)
            [48155] = true, -- Mind Flay (Rank 8)
            [48156] = true, -- Mind Flay (Rank 9)
            [9484] = true, -- Shackle Undead (Rank 1)
            [9485] = true, -- Shackle Undead (Rank 2)
            [10955] = true, -- Shackle Undead (Rank 3)
            [64044] = true, -- Psychic Horror
            [64058] = true, -- Psychic Horror (Disarm)
            [15487] = true, -- Silence
            -- Rogue
            [6770] = true, -- Sap (Rank 1)
            [2070] = true, -- Sap (Rank 2)
            [11297] = true, -- Sap (Rank 3)
            [51724] = true, -- Sap (Rank 4)
            [2094] = true, -- Blind
            [408] = true, -- Kidney Shot (Rank 1)
            [8643] = true, -- Kidney Shot (Rank 2)
            [1833] = true, -- Cheap Shot
            [1776] = true, -- Gouge (Rank 1)
            [1777] = true, -- Gouge (Rank 2)
            [8629] = true, -- Gouge (Rank 3)
            [11285] = true, -- Gouge (Rank 4)
            [11286] = true, -- Gouge (Rank 5)
            [38764] = true, -- Gouge (Rank 6)
            [1330] = true, -- Garrote - Silence
            [18425] = true, -- Silenced - Improved Kick
            [51722] = true, -- Dismantle
            [31125] = true, -- Blade Twisting (Rank 1)
            [51585] = true, -- Blade Twisting (Rank 2)
            [3409] = true, -- Crippling Poison
            [26679] = true, -- Deadly Throw
            [32747] = true, -- Interrupt (Deadly Throw)
            [51693] = true, -- Waylay
            -- Shaman
            [2484] = true, -- Earthbind Totem
            [8056] = true, -- Frost Shock (Rank 1)
            [8058] = true, -- Frost Shock (Rank 2)
            [10472] = true, -- Frost Shock (Rank 3)
            [10473] = true, -- Frost Shock (Rank 4)
            [25464] = true, -- Frost Shock (Rank 5)
            [49235] = true, -- Frost Shock (Rank 6)
            [49236] = true, -- Frost Shock (Rank 7)
            [39796] = true, -- Stoneclaw Totem
            [58861] = true, -- Bash (Spirit Wolf)
            [51514] = true, -- Hex
            [8034] = true, -- Frostbrand Attack (Rank 1)
            [8037] = true, -- Frostbrand Attack (Rank 2)
            [10458] = true, -- Frostbrand Attack (Rank 3)
            [16352] = true, -- Frostbrand Attack (Rank 4)
            [16353] = true, -- Frostbrand Attack (Rank 5)
            [25501] = true, -- Frostbrand Attack (Rank 6)
            [58797] = true, -- Frostbrand Attack (Rank 7)
            [58798] = true, -- Frostbrand Attack (Rank 8)
            [58799] = true, -- Frostbrand Attack (Rank 9)
            -- Warlock
            [5782] = true, -- Fear (Rank 1)
            [6213] = true, -- Fear (Rank 2)
            [6215] = true, -- Fear (Rank 3)
            [6358] = true, -- Seduction (Succubus)
            [18223] = true, -- Curse of Exhaustion
            [18093] = true, -- Pyroclasm
            [710] = true, -- Banish (Rank 1)
            [18647] = true, -- Banish (Rank 2)
            [30413] = true, -- Shadowfury
            [6789] = true, -- Death Coil (Rank 1)
            [17925] = true, -- Death Coil (Rank 2)
            [17926] = true, -- Death Coil (Rank 3)
            [27223] = true, -- Death Coil (Rank 4)
            [5484] = true, -- Howl of Terror (Rank 1)
            [17928] = true, -- Howl of Terror (Rank 2)
            [24259] = true, -- Spell Lock (Felhunter)
            [18118] = true, -- Aftermath
            [20812] = true, -- Cripple (Doomguard)
            [60995] = true, -- Demon Charge (Metamorphosis)
            [1098] = true, -- Enslave Demon (Rank 1)
            [11725] = true, -- Enslave Demon (Rank 2)
            [11726] = true, -- Enslave Demon (Rank 3)
            [61191] = true, -- Enslave Demon (Rank 4)
            [63311] = true, -- Glyph of Shadowflame
            [30153] = true, -- Intercept (Felguard)
            [31117] = true, -- Unstable Affliction (Silence)
            -- Warrior
            [20511] = true, -- Intimidating Shout (Cower)
            [5246] = true, -- Intimidating Shout (Fear)
            [1715] = true, -- Hamstring
            [12809] = true, -- Concussion Blow
            [20253] = true, -- Intercept Stun (Rank 1)
            [20614] = true, -- Intercept Stun (Rank 2)
            [20615] = true, -- Intercept Stun (Rank 3)
            [25273] = true, -- Intercept Stun (Rank 4)
            [25274] = true, -- Intercept Stun (Rank 5)
            [7386] = true, -- Sunder Armor
            [7922] = true, -- Charge Stun
            [18498] = true, -- Silenced - Gag Order
            [46968] = true, -- Shockwave
            [23694] = true, -- Improved Hamstring
            [58373] = true, -- Glyph of Hamstring
            [676] = true, -- Disarm
            [12323] = true, -- Piercing Howl
            -- Racial
            [20549] = true, -- War Stomp
            [28730] = true, -- Arcane Torrent (Mana)
            [25046] = true, -- Arcane Torrent (Energy)
            [50613] = true -- Arcane Torrent (Runic Power)
        },
        TurtleBuffs = {
            -- Death Knight
            [48707] = true, -- Anti-Magic Shell
            [51052] = true, -- Anti-Magic Zone
            [42650] = true, -- Army of the Dead
            [49222] = true, -- Bone Shield
            [48792] = true, -- Icebound Fortitude
            [49039] = true, -- Lichborne
            [51271] = true, -- Unbreakable Armor
            [55233] = true, -- Vampiric Blood
            -- Druid
            [22812] = true, -- Barkskin
            -- Hunter
            [19263] = true, -- Deterrence
            [34471] = true, -- The Beast Within
            -- Mage
            [45438] = true, -- Ice Block
            [66] = true, -- Invisibility
            -- Paladin
            [498] = true, -- Divine Protection
            [642] = true, -- Divine Shield
            [1022] = true, -- Hand of Protection (Rank 1)
            [5599] = true, -- Hand of Protection (Rank 2)
            [10278] = true, -- Hand of Protection (Rank 3)
            [31821] = true, -- Aura Mastery
            [70940] = true, -- Divine Guardian
            [64205] = true, -- Divine Sacrifice
            -- Priest
            [47585] = true, -- Dispersion
            [47788] = true, -- Guardian Spirit
            -- Rogue
            [31224] = true, -- Cloak of Shadows
            [5277] = true, -- Evasion (Rank 1)
            [26669] = true, -- Evasion (Rank 2)
            [1856] = true, -- Vanish (Rank 1)
            [1857] = true, -- Vanish (Rank 2)
            [26889] = true, -- Vanish (Rank 3)
            -- Shaman
            [974] = true, -- Earth Shield (Rank 1)
            [32593] = true, -- Earth Shield (Rank 2)
            [32594] = true, -- Earth Shield (Rank 3)
            [49283] = true, -- Earth Shield (Rank 4)
            [49284] = true, -- Earth Shield (Rank 5)
            [30823] = true, -- Shamanistic Rage
            -- Warrior
            [12975] = true, -- Last Stand
            [871] = true, -- Shield Wall
            [20230] = true, -- Retaliation
            [2565] = true, -- Shield Block
            [46924] = true, -- Bladestorm
            [23920] = true, -- Spell Reflection
            -- Consumables
            [3169] = true, -- Limited Invulnerability Potion
            [6615] = true, -- Free Action Potion
            -- Racial
            [7744] = true, -- Will of the Forsaken
            [6346] = true, -- Fear Ward
            [20594] = true, -- Stoneform
            -- All Classes
            [19753] = true -- Divine Intervention
        },
        PlayerBuffs = {
            -- Death Knight
            [48707] = true, -- Anti-Magic Shell
            [51052] = true, -- Anti-Magic Zone
            [49222] = true, -- Bone Shield
            [49028] = true, -- Dancing Rune Weapon
            [49796] = true, -- Deathchill
            [63560] = true, -- Ghoul Frenzy (Ghoul)
            [48792] = true, -- Icebound Fortitude
            [49039] = true, -- Lichborne
            [61777] = true, -- Summon Gargoyle
            [51271] = true, -- Unbreakable Armor
            [55233] = true, -- Vampiric Blood
            -- Druid
            [29166] = true, -- Innervate
            [22812] = true, -- Barkskin
            [17116] = true, -- Nature's Swiftness
            [16689] = true, -- Nature's Grasp (Rank 1)
            [16810] = true, -- Nature's Grasp (Rank 2)
            [16811] = true, -- Nature's Grasp (Rank 3)
            [16812] = true, -- Nature's Grasp (Rank 4)
            [16813] = true, -- Nature's Grasp (Rank 5)
            [17329] = true, -- Nature's Grasp (Rank 6)
            [27009] = true, -- Nature's Grasp (Rank 7)
            [53312] = true, -- Nature's Grasp (Rank 8)
            [16864] = true, -- Omen of Clarity
            [5217] = true, -- Tiger's Fury (Rank 1)
            [6793] = true, -- Tiger's Fury (Rank 2)
            [9845] = true, -- Tiger's Fury (Rank 3)
            [9846] = true, -- Tiger's Fury (Rank 4)
            [50212] = true, -- Tiger's Fury (Rank 5)
            [50213] = true, -- Tiger's Fury (Rank 6)
            [2893] = true, -- Abolish Poison
            [5229] = true, -- Enrage
            [1850] = true, -- Dash (Rank 1)
            [9821] = true, -- Dash (Rank 2)
            [33357] = true, -- Dash (Rank 3)
            [50334] = true, -- Berserk
            [48505] = true, -- Starfall (Rank 1)
            [53199] = true, -- Starfall (Rank 2)
            [53200] = true, -- Starfall (Rank 3)
            [53201] = true, -- Starfall (Rank 4)
            [61336] = true, -- Survival Instincts
            [740] = true, -- Tranquility
            -- Hunter
            [13161] = true, -- Aspect of the Beast
            [5118] = true, -- Aspect of the Cheetah
            [13163] = true, -- Aspect of the Monkey
            [13159] = true, -- Aspect of the Pack
            [20043] = true, -- Aspect of the Wild (Rank 1)
            [20190] = true, -- Aspect of the Wild (Rank 2)
            [27045] = true, -- Aspect of the Wild (Rank 3)
            [49071] = true, -- Aspect of the Wild (Rank 4)
            [3045] = true, -- Rapid Fire
            [19263] = true, -- Deterrence
            [13165] = true, -- Aspect of the Hawk (Rank 1)
            [14318] = true, -- Aspect of the Hawk (Rank 2)
            [14319] = true, -- Aspect of the Hawk (Rank 3)
            [14320] = true, -- Aspect of the Hawk (Rank 4)
            [14321] = true, -- Aspect of the Hawk (Rank 5)
            [14322] = true, -- Aspect of the Hawk (Rank 6)
            [25296] = true, -- Aspect of the Hawk (Rank 7)
            [27044] = true, -- Aspect of the Hawk (Rank 8)
            [19574] = true, -- Bestial Wrath
            [35098] = true, -- Rapid Killing
            [34471] = true, -- The Beast Within
            -- Mage
            [45438] = true, -- Ice Block
            [12043] = true, -- Presence of Mind
            [28682] = true, -- Combustion
            [12042] = true, -- Arcane Power
            [11426] = true, -- Ice Barrier (Rank 1)
            [13031] = true, -- Ice Barrier (Rank 2)
            [13032] = true, -- Ice Barrier (Rank 3)
            [13033] = true, -- Ice Barrier (Rank 4)
            [27134] = true, -- Ice Barrier (Rank 5)
            [33405] = true, -- Ice Barrier (Rank 6)
            [43038] = true, -- Ice Barrier (Rank 7)
            [43039] = true, -- Ice Barrier (Rank 8)
            [12472] = true, -- Icy Veins
            [66] = true, -- Invisibility
            [55342] = true, -- Mirror Image
            -- Paladin
            [1044] = true, -- Hand of Freedom
            [1038] = true, -- Hand of Salvation
            [465] = true, -- Devotion Aura (Rank 1)
            [10290] = true, -- Devotion Aura (Rank 2)
            [643] = true, -- Devotion Aura (Rank 3)
            [10291] = true, -- Devotion Aura (Rank 4)
            [1032] = true, -- Devotion Aura (Rank 5)
            [10292] = true, -- Devotion Aura (Rank 6)
            [10293] = true, -- Devotion Aura (Rank 7)
            [27149] = true, -- Devotion Aura (Rank 8)
            [48941] = true, -- Devotion Aura (Rank 9)
            [48942] = true, -- Devotion Aura (Rank 10)
            [19746] = true, -- Concentration Aura
            [7294] = true, -- Retribution Aura (Rank 1)
            [10298] = true, -- Retribution Aura (Rank 2)
            [10299] = true, -- Retribution Aura (Rank 3)
            [10300] = true, -- Retribution Aura (Rank 4)
            [10301] = true, -- Retribution Aura (Rank 5)
            [27150] = true, -- Retribution Aura (Rank 6)
            [54043] = true, -- Retribution Aura (Rank 7)
            [19876] = true, -- Shadow Resistance Aura (Rank 1)
            [19895] = true, -- Shadow Resistance Aura (Rank 2)
            [19896] = true, -- Shadow Resistance Aura (Rank 3)
            [27151] = true, -- Shadow Resistance Aura (Rank 4)
            [48943] = true, -- Shadow Resistance Aura (Rank 5)
            [19888] = true, -- Frost Resistance Aura (Rank 1)
            [19897] = true, -- Frost Resistance Aura (Rank 2)
            [19898] = true, -- Frost Resistance Aura (Rank 3)
            [27152] = true, -- Frost Resistance Aura (Rank 4)
            [48945] = true, -- Frost Resistance Aura (Rank 5)
            [19891] = true, -- Fire Resistance Aura (Rank 1)
            [19899] = true, -- Fire Resistance Aura (Rank 2)
            [19900] = true, -- Fire Resistance Aura (Rank 3)
            [27153] = true, -- Fire Resistance Aura (Rank 4)
            [48497] = true, -- Fire Resistance Aura (Rank 5)
            [498] = true, -- Divine Protection
            [642] = true, -- Divine Shield
            [1022] = true, -- Hand of Protection (Rank 1)
            [5599] = true, -- Hand of Protection (Rank 2)
            [10278] = true, -- Hand of Protection (Rank 3)
            [31821] = true, -- Aura Mastery
            [70940] = true, -- Divine Guardian
            [64205] = true, -- Divine Sacrifice
            [6940] = true, -- Hand of Sacrifice
            [31884] = true, -- Avenging Wrath
            [20216] = true, -- Divine Favor
            [31842] = true, -- Divine Illumination
            -- Priest
            [15473] = true, -- Shadowform
            [10060] = true, -- Power Infusion
            [14751] = true, -- Inner Focus
            [1706] = true, -- Levitate
            [586] = true, -- Fade
            [64843] = true, -- Divine Hymn
            [47788] = true, -- Guardian Spirit
            [64901] = true, -- Hymn of Hope
            [47585] = true, -- Dispersion
            -- Rogue
            [14177] = true, -- Cold Blood
            [13877] = true, -- Blade Flurry
            [13750] = true, -- Adrenaline Rush
            [2983] = true, -- Sprint (Rank 1)
            [8696] = true, -- Sprint (Rank 2)
            [11305] = true, -- Sprint (Rank 3)
            [5171] = true, -- Slice and Dice (Rank 1)
            [6774] = true, -- Slice and Dice (Rank 2)
            [45182] = true, -- Cheating Death
            [51690] = true, -- Killing Spree
            [51713] = true, -- Shadow Dance
            [57933] = true, -- Tricks of the Trade
            [31224] = true, -- Cloak of Shadows
            [5277] = true, -- Evasion (Rank 1)
            [26669] = true, -- Evasion (Rank 2)
            [1856] = true, -- Vanish (Rank 1)
            [1857] = true, -- Vanish (Rank 2)
            [26889] = true, -- Vanish (Rank 3)
            -- Shaman
            [2645] = true, -- Ghost Wolf
            [324] = true, -- Lightning Shield (Rank 1)
            [325] = true, -- Lightning Shield (Rank 2)
            [905] = true, -- Lightning Shield (Rank 3)
            [945] = true, -- Lightning Shield (Rank 4)
            [8134] = true, -- Lightning Shield (Rank 5)
            [10431] = true, -- Lightning Shield (Rank 6)
            [10432] = true, -- Lightning Shield (Rank 7)
            [25469] = true, -- Lightning Shield (Rank 8)
            [25472] = true, -- Lightning Shield (Rank 9)
            [49280] = true, -- Lightning Shield (Rank 10)
            [49281] = true, -- Lightning Shield (Rank 11)
            [16188] = true, -- Nature's Swiftness
            [16166] = true, -- Elemental Mastery
            [52127] = true, -- Water Shield (Rank 1)
            [52129] = true, -- Water Shield (Rank 2)
            [52131] = true, -- Water Shield (Rank 3)
            [52134] = true, -- Water Shield (Rank 4)
            [52136] = true, -- Water Shield (Rank 5)
            [52138] = true, -- Water Shield (Rank 6)
            [24398] = true, -- Water Shield (Rank 7)
            [33736] = true, -- Water Shield (Rank 8)
            [57960] = true, -- Water Shield (Rank 9)
            [974] = true, -- Earth Shield (Rank 1)
            [32593] = true, -- Earth Shield (Rank 2)
            [32594] = true, -- Earth Shield (Rank 3)
            [49283] = true, -- Earth Shield (Rank 4)
            [49284] = true, -- Earth Shield (Rank 5)
            [30823] = true, -- Shamanistic Rage
            [8178] = true, -- Grounding Totem Effect
            [16191] = true, -- Mana Tide
            [55198] = true, -- Tidal Force
            -- Warlock
            [18789] = true, -- Demonic Sacrifice (Burning Wish)
            [18790] = true, -- Demonic Sacrifice (Fel Stamina)
            [18791] = true, -- Demonic Sacrifice (Touch of Shadow)
            [18792] = true, -- Demonic Sacrifice (Fel Energy)
            [35701] = true, -- Demonic Sacrifice (Touch of Shadow)
            [5697] = true, -- Unending Breath
            [6512] = true, -- Detect Lesser Invisibility
            [25228] = true, -- Soul Link
            [18708] = true, -- Fel Domination
            [47241] = true, -- Metamorphosis
            -- Warrior
            [12975] = true, -- Last Stand
            [871] = true, -- Shield Wall
            [20230] = true, -- Retaliation
            [1719] = true, -- Recklessness
            [18499] = true, -- Berserker Rage
            [2687] = true, -- Bloodrage
            [12292] = true, -- Death Wish
            [12328] = true, -- Sweeping Strikes
            [2565] = true, -- Shield Block
            [12880] = true, -- Enrage (Rank 1)
            [14201] = true, -- Enrage (Rank 2)
            [14202] = true, -- Enrage (Rank 3)
            [14203] = true, -- Enrage (Rank 4)
            [14204] = true, -- Enrage (Rank 5)
            [46924] = true, -- Bladestorm
            [23920] = true, -- Spell Reflection
            -- Consumables
            [3169] = true, -- Limited Invulnerability Potion
            [6615] = true, -- Free Action Potion
            -- Racial
            [26297] = true, -- Berserking
            [7744] = true, -- Will of the Forsaken
            [20572] = true, -- Blood Fury (Physical)
            [33697] = true, -- Blood Fury (Both)
            [33702] = true, -- Blood Fury (Spell)
            [6346] = true, -- Fear Ward
            [20594] = true, -- Stoneform
            [28880] = true, -- Gift of the Naaru
            -- All Classes
            [19753] = true -- Divine Intervention
        },
        RaidBuffs = {
            -------------------------------------------------
            -------------------- Dungeons -------------------
            -------------------------------------------------
            -- Ahn'kahet: The Old Kingdom
            -- Azjol-Nerub
            -- Drak'Tharon Keep
            -- Gundrak
            -- Halls of Lightning
            -- Halls of Reflection
            -- Halls of Stone
            -- Pit of Saron
            -- The Culling of Stratholme
            -- The Forge of Souls
            -- The Nexus
            -- The Oculus
            -- The Violet Hold
            -- Trial of the Champion
            -- Utgarde Keep
            -- Utgarde Pinnacle
            -------------------------------------------------
            -------------------- Phase 1 --------------------
            -------------------------------------------------
            -- Naxxramas
            -- Anub'Rekhan
            [8269] = true, -- Frenzy
            [54021] = true, -- Locust Swarm
            -- Grand Widow Faerlina
            [54100] = true, -- Frenzy
            -- Maexxna
            [54124] = true, -- Frenzy
            -- Noth the Plaguebringer
            -- Heigan the Unclean
            -- Loatheb
            -- Instructor Razuvious
            [29061] = true, -- Bone Barrier
            -- Gothik the Harvester
            -- The Four Horsemen
            -- Patchwerk
            [28131] = true, -- Frenzy
            -- Grobbulus
            -- Gluth
            [54427] = true, -- Enrage
            -- Thaddius
            [28134] = true, -- Power Surge
            -- Sapphiron
            -- Kel'Thuzad
            -- The Eye of Eternity
            -- Malygos
            [56505] = true, -- Surge of Power
            [57060] = true, -- Haste
            [57428] = true, -- Static Field
            -- The Obsidian Sanctum
            -- Sartharion
            [58766] = true, -- Gift of Twilight
            [60639] = true, -- Twilight Revenge
            [61254] = true, -- Will of Sartharion
            [60430] = true -- Molten Fury
            -------------------------------------------------
            -------------------- Phase 2 --------------------
            -------------------------------------------------
            -- Ulduar
            -- Flame Leviathan
            -- Ignis the Furnace Master
            -- Razorscale
            -- XT-002 Deconstructor
            -- The Assembly of Iron
            -- Kologarn
            -- Auriaya
            -- Hodir
            -- Thorim
            -- Freya
            -- Mimiron
            -- General Vezax
            -- Yogg-Saron
            -- Algalon the Observer
            -------------------------------------------------
            -------------------- Phase 3 --------------------
            -------------------------------------------------
            -- Trial of the Crusader
            -- The Northrend Beasts
            -- Lord Jaraxxus
            -- Champions of the Horde
            -- Champions of the Alliance
            -- Twin Val'kyr
            -- Anub'arak
            -- Onyxia’s Lair
            -- Onyxia
            -------------------------------------------------
            -------------------- Phase 4 --------------------
            -------------------------------------------------
            -- Icecrown Citadel
            -- Lord Marrowgar
            -- Lady Deathwhisper
            -- Gunship Battle Alliance
            -- Gunship Battle Horde
            -- Deathbringer Saurfang
            -- Festergut
            -- Rotface
            -- Professor Putricide
            -- Blood Prince Council
            -- Blood-Queen Lana'thel
            -- Valithria Dreamwalker
            -- Sindragosa
            -- The Lich King
            -------------------------------------------------
            -------------------- Phase 5 --------------------
            -------------------------------------------------
            -- The Ruby Sanctum
            -- Halion
        },
        RaidDebuffs = {
            -------------------------------------------------
            -------------------- Dungeons -------------------
            -------------------------------------------------
            -- Ahn'kahet: The Old Kingdom
            -- Azjol-Nerub
            -- Drak'Tharon Keep
            -- Gundrak
            -- Halls of Lightning
            -- Halls of Reflection
            -- Halls of Stone
            -- Pit of Saron
            -- The Culling of Stratholme
            -- The Forge of Souls
            -- The Nexus
            -- The Oculus
            -- The Violet Hold
            -- Trial of the Champion
            -- Utgarde Keep
            -- Utgarde Pinnacle
            -------------------------------------------------
            -------------------- Phase 1 --------------------
            -------------------------------------------------
            -- Naxxramas
            -- Anub'Rekhan
            [54022] = true, -- Locust Swarm
            [56098] = true, -- Acid Spit
            -- Grand Widow Faerlina
            [54099] = true, -- Rain of Fire
            [54098] = true, -- Poison Bolt Volley
            -- Maexxna
            [54121] = true, -- Necrotic Poison 1
            [28776] = true, -- Necrotic Poison 2
            [28622] = true, -- Web Wrap
            [54125] = true, -- Web Spray
            -- Noth the Plaguebringer
            [54835] = true, -- Curse of the Plaguebringer
            [54814] = true, -- Cripple 1
            [29212] = true, -- Cripple 2
            -- Heigan the Unclean
            [55011] = true, -- Decrepit Fever
            -- Loatheb
            [55052] = true, -- Inevitable Doom
            [55053] = true, -- Deathbloom
            -- Instructor Razuvious
            [55550] = true, -- Jagged Knife
            [55470] = true, -- Unbalancing Strike
            -- Gothik the Harvester
            [55646] = true, -- Drain Life
            [55645] = true, -- Death Plague
            [28679] = true, -- Harvest Soul
            -- The Four Horsemen
            [57369] = true, -- Unholy Shadow
            [28832] = true, -- Mark of Korth'azz
            [28835] = true, -- Mark of Zeliek
            [28833] = true, -- Mark of Blaumeux
            [28834] = true, -- Mark of Rivendare
            -- Patchwerk
            [28801] = true, -- Slime / Not really Encounter related
            -- Grobbulus
            [28169] = true, -- Mutating Injection
            -- Gluth
            [54378] = true, -- Mortal Wound
            [29306] = true, -- Infected Wound
            -- Thaddius
            [28084] = true, -- Negative Charge (-)
            [28059] = true, -- Positive Charge (+)
            -- Sapphiron
            [28522] = true, -- Icebolt
            [55665] = true, -- Life Drain
            [28547] = true, -- Chill 1
            [55699] = true, -- Chill 2
            -- Kel'Thuzad
            [55807] = true, -- Frostbolt 1
            [55802] = true, -- Frostbolt 2
            [27808] = true, -- Frost Blast
            [28410] = true, -- Chains of Kel'Thuzad
            -- The Eye of Eternity
            -- Malygos
            [56272] = true, -- Arcane Breath
            [55853] = true, -- Vortex 1
            [56263] = true, -- Vortex 2
            [57407] = true, -- Surge of Power
            [57429] = true, -- Static Field
            -- The Obsidian Sanctum
            -- Sartharion
            [60708] = true, -- Fade Armor
            [58105] = true, -- Power of Shadron
            [61248] = true, -- Power of Tenebron
            [56910] = true, -- Tail Lash
            [57874] = true, -- Twilight Shift
            [57632] = true -- Magma
            -------------------------------------------------
            -------------------- Phase 2 --------------------
            -------------------------------------------------
            -- Ulduar
            -- Flame Leviathan
            -- Ignis the Furnace Master
            -- Razorscale
            -- XT-002 Deconstructor
            -- The Assembly of Iron
            -- Kologarn
            -- Auriaya
            -- Hodir
            -- Thorim
            -- Freya
            -- Mimiron
            -- General Vezax
            -- Yogg-Saron
            -- Algalon the Observer
            -------------------------------------------------
            -------------------- Phase 3 --------------------
            -------------------------------------------------
            -- Trial of the Crusader
            -- The Northrend Beasts
            -- Lord Jaraxxus
            -- Champions of the Horde
            -- Champions of the Alliance
            -- Twin Val'kyr
            -- Anub'arak
            -- Onyxia’s Lair
            -- Onyxia
            -------------------------------------------------
            -------------------- Phase 4 --------------------
            -------------------------------------------------
            -- Icecrown Citadel
            -- Lord Marrowgar
            -- Lady Deathwhisper
            -- Gunship Battle Alliance
            -- Gunship Battle Horde
            -- Deathbringer Saurfang
            -- Festergut
            -- Rotface
            -- Professor Putricide
            -- Blood Prince Council
            -- Blood-Queen Lana'thel
            -- Valithria Dreamwalker
            -- Sindragosa
            -- The Lich King
            -------------------------------------------------
            -------------------- Phase 5 --------------------
            -------------------------------------------------
            -- The Ruby Sanctum
            -- Halion
        },
        Blacklist = {
            -- General
            [186403] = true, -- Sign of Battle
            [377749] = true -- Joyous Journeys (50% exp buff)
        },
        Whitelist = {}
    }
end
