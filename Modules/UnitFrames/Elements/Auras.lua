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

    local filter = config.filter or (button.isDebuff and self.debuffFilterConfig or self.buffFilterConfig)
    local isWhiteListed =
        (filter.whitelist.Personal and isPlayer) or (filter.whitelist.NonPersonal and not isPlayer) or (filter.whitelist.Boss and isBossDebuff) or (filter.whitelist.MyPet and myPet) or
            (filter.whitelist.OtherPet and otherPet) or (filter.whitelist.CastByUnit and unitIsCaster) or (filter.whitelist.NotCastByUnit and not unitIsCaster) or
            (filter.whitelist.Dispellable and canDispel) or (filter.whitelist.NotDispellable and not canDispel) or (filter.whitelist.CastByNPC and not casterIsPlayer) or
            (filter.whitelist.CastByPlayers and casterIsPlayer) or (filter.whitelist.Nameplate and (nameplateShowAll or (nameplateShowSelf and (isPlayer or myPet))))
    local isBlackListed = (filter.blacklist.BlockCastByPlayers and casterIsPlayer) or (filter.blacklist.BlockNoDuration and noDuration) or (filter.blacklist.BlockNonPersonal and not isPlayer) or
                              (filter.blacklist.BlockDispellable and canDispel) or (filter.blacklist.BlockNotDispellable and not canDispel)

    return isWhiteListed and not isBlackListed
end

UF.auraFilters = {}

if R.isRetail then
    UF.auraFilters.CrowdControl = {
        -- Death Knight
        [47476] = true, -- Strangulate
        [108194] = true, -- Asphyxiate UH
        [221562] = true, -- Asphyxiate Blood
        [207171] = true, -- Winter is Coming
        [206961] = true, -- Tremble Before Me
        [207167] = true, -- Blinding Sleet
        [212540] = true, -- Flesh Hook (Pet)
        [91807] = true, -- Shambling Rush (Pet)
        [204085] = true, -- Deathchill
        [233395] = true, -- Frozen Center
        [212332] = true, -- Smash (Pet)
        [212337] = true, -- Powerful Smash (Pet)
        [91800] = true, -- Gnaw (Pet)
        [91797] = true, -- Monstrous Blow (Pet)
        [210141] = true, -- Zombie Explosion
        -- Demon Hunter
        [207685] = true, -- Sigil of Misery
        [217832] = true, -- Imprison
        [221527] = true, -- Imprison (Banished version)
        [204490] = true, -- Sigil of Silence
        [179057] = true, -- Chaos Nova
        [211881] = true, -- Fel Eruption
        [205630] = true, -- Illidan's Grasp
        [208618] = true, -- Illidan's Grasp (Afterward)
        [213491] = true, -- Demonic Trample (it's this one or the other)
        [208645] = true, -- Demonic Trample
        -- Druid
        [81261] = true, -- Solar Beam
        [5211] = true, -- Mighty Bash
        [163505] = true, -- Rake
        [203123] = true, -- Maim
        [202244] = true, -- Overrun
        [99] = true, -- Incapacitating Roar
        [33786] = true, -- Cyclone
        [45334] = true, -- Immobilized
        [102359] = true, -- Mass Entanglement
        [339] = true, -- Entangling Roots
        [2637] = true, -- Hibernate
        [102793] = true, -- Ursol's Vortex
        -- Hunter
        [202933] = true, -- Spider Sting (it's this one or the other)
        [233022] = true, -- Spider Sting
        [213691] = true, -- Scatter Shot
        [19386] = true, -- Wyvern Sting
        [3355] = true, -- Freezing Trap
        [203337] = true, -- Freezing Trap (Survival PvPT)
        [209790] = true, -- Freezing Arrow
        [24394] = true, -- Intimidation
        [117526] = true, -- Binding Shot
        [190927] = true, -- Harpoon
        [201158] = true, -- Super Sticky Tar
        [162480] = true, -- Steel Trap
        [212638] = true, -- Tracker's Net
        [200108] = true, -- Ranger's Net
        -- Mage
        [61721] = true, -- Rabbit (Poly)
        [61305] = true, -- Black Cat (Poly)
        [28272] = true, -- Pig (Poly)
        [28271] = true, -- Turtle (Poly)
        [126819] = true, -- Porcupine (Poly)
        [161354] = true, -- Monkey (Poly)
        [161353] = true, -- Polar bear (Poly)
        [61780] = true, -- Turkey (Poly)
        [161355] = true, -- Penguin (Poly)
        [161372] = true, -- Peacock (Poly)
        [277787] = true, -- Direhorn (Poly)
        [277792] = true, -- Bumblebee (Poly)
        [118] = true, -- Polymorph
        [82691] = true, -- Ring of Frost
        [31661] = true, -- Dragon's Breath
        [122] = true, -- Frost Nova
        [33395] = true, -- Freeze
        [157997] = true, -- Ice Nova
        [228600] = true, -- Glacial Spike
        [198121] = true, -- Forstbite
        -- Monk
        [119381] = true, -- Leg Sweep
        [202346] = true, -- Double Barrel
        [115078] = true, -- Paralysis
        [198909] = true, -- Song of Chi-Ji
        [202274] = true, -- Incendiary Brew
        [233759] = true, -- Grapple Weapon
        [123407] = true, -- Spinning Fire Blossom
        [116706] = true, -- Disable
        [232055] = true, -- Fists of Fury (it's this one or the other)
        -- Paladin
        [853] = true, -- Hammer of Justice
        [20066] = true, -- Repentance
        [105421] = true, -- Blinding Light
        [31935] = true, -- Avenger's Shield
        [217824] = true, -- Shield of Virtue
        [205290] = true, -- Wake of Ashes
        -- Priest
        [9484] = true, -- Shackle Undead
        [200196] = true, -- Holy Word: Chastise
        [200200] = true, -- Holy Word: Chastise
        [226943] = true, -- Mind Bomb
        [605] = true, -- Mind Control
        [8122] = true, -- Psychic Scream
        [15487] = true, -- Silence
        [64044] = true, -- Psychic Horror
        [453] = true, -- Mind Soothe
        -- Rogue
        [2094] = true, -- Blind
        [6770] = true, -- Sap
        [1776] = true, -- Gouge
        [1330] = true, -- Garrote - Silence
        [207777] = true, -- Dismantle
        [199804] = true, -- Between the Eyes
        [408] = true, -- Kidney Shot
        [1833] = true, -- Cheap Shot
        [207736] = true, -- Shadowy Duel (Smoke effect)
        [212182] = true, -- Smoke Bomb
        -- Shaman
        [51514] = true, -- Hex
        [211015] = true, -- Hex (Cockroach)
        [211010] = true, -- Hex (Snake)
        [211004] = true, -- Hex (Spider)
        [210873] = true, -- Hex (Compy)
        [196942] = true, -- Hex (Voodoo Totem)
        [269352] = true, -- Hex (Skeletal Hatchling)
        [277778] = true, -- Hex (Zandalari Tendonripper)
        [277784] = true, -- Hex (Wicker Mongrel)
        [118905] = true, -- Static Charge
        [77505] = true, -- Earthquake (Knocking down)
        [118345] = true, -- Pulverize (Pet)
        [204399] = true, -- Earthfury
        [204437] = true, -- Lightning Lasso
        [157375] = true, -- Gale Force
        [64695] = true, -- Earthgrab
        -- Warlock
        [710] = true, -- Banish
        [6789] = true, -- Mortal Coil
        [118699] = true, -- Fear
        [6358] = true, -- Seduction (Succub)
        [171017] = true, -- Meteor Strike (Infernal)
        [22703] = true, -- Infernal Awakening (Infernal CD)
        [30283] = true, -- Shadowfury
        [89766] = true, -- Axe Toss
        [233582] = true, -- Entrenched in Flame
        -- Warrior
        [5246] = true, -- Intimidating Shout
        [132169] = true, -- Storm Bolt
        [132168] = true, -- Shockwave
        [199085] = true, -- Warpath
        [105771] = true, -- Charge
        [199042] = true, -- Thunderstruck
        [236077] = true, -- Disarm
        -- Racial
        [20549] = true, -- War Stomp
        [107079] = true -- Quaking Palm
    }

    UF.auraFilters.TurtleBuffs = {
        -- Death Knight
        [48707] = true, -- Anti-Magic Shell
        [81256] = true, -- Dancing Rune Weapon
        [55233] = true, -- Vampiric Blood
        [193320] = true, -- Umbilicus Eternus
        [219809] = true, -- Tombstone
        [48792] = true, -- Icebound Fortitude
        [207319] = true, -- Corpse Shield
        [194844] = true, -- BoneStorm
        [145629] = true, -- Anti-Magic Zone
        [194679] = true, -- Rune Tap
        -- Demon Hunter
        [207811] = true, -- Nether Bond (DH)
        [207810] = true, -- Nether Bond (Target)
        [187827] = true, -- Metamorphosis
        [263648] = true, -- Soul Barrier
        [209426] = true, -- Darkness
        [196555] = true, -- Netherwalk
        [212800] = true, -- Blur
        [188499] = true, -- Blade Dance
        [203819] = true, -- Demon Spikes
        -- Druid
        [102342] = true, -- Ironbark
        [61336] = true, -- Survival Instincts
        [210655] = true, -- Protection of Ashamane
        [22812] = true, -- Barkskin
        [200851] = true, -- Rage of the Sleeper
        [234081] = true, -- Celestial Guardian
        [202043] = true, -- Protector of the Pack (it's this one or the other)
        [201940] = true, -- Protector of the Pack
        [201939] = true, -- Protector of the Pack (Allies)
        [192081] = true, -- Ironfur
        [50334] = true, -- Berserk (Guardian)
        -- Hunter
        [186265] = true, -- Aspect of the Turtle
        [53480] = true, -- Roar of Sacrifice
        [202748] = true, -- Survival Tactics
        -- Mage
        [45438] = true, -- Ice Block
        [113862] = true, -- Greater Invisibility
        [198111] = true, -- Temporal Shield
        [198065] = true, -- Prismatic Cloak
        [11426] = true, -- Ice Barrier
        [235313] = true, -- Blazing Barrier
        [235450] = true, -- Prismatic Barrier
        [110909] = true, -- Alter Time
        -- Monk
        [122783] = true, -- Diffuse Magic
        [122278] = true, -- Dampen Harm
        [125174] = true, -- Touch of Karma
        [201318] = true, -- Fortifying Elixir
        [202248] = true, -- Guided Meditation
        [120954] = true, -- Fortifying Brew
        [116849] = true, -- Life Cocoon
        [202162] = true, -- Guard
        [215479] = true, -- Ironskin Brew
        [353319] = true, -- Peaceweaver (PvP)
        [353362] = true, -- Dematerialize (PvP)
        -- Paladin
        [642] = true, -- Divine Shield
        [498] = true, -- Divine Protection
        [205191] = true, -- Eye for an Eye
        [184662] = true, -- Shield of Vengeance
        [1022] = true, -- Blessing of Protection
        [6940] = true, -- Blessing of Sacrifice
        [204018] = true, -- Blessing of Spellwarding
        [199507] = true, -- Spreading The Word: Protection
        [216857] = true, -- Guarded by the Light
        [228049] = true, -- Guardian of the Forgotten Queen
        [31850] = true, -- Ardent Defender
        [86659] = true, -- Guardian of Ancien Kings
        [212641] = true, -- Guardian of Ancien Kings (Glyph of the Queen)
        [209388] = true, -- Bulwark of Order
        [152262] = true, -- Seraphim
        [132403] = true, -- Shield of the Righteous
        -- Priest
        [81782] = true, -- Power Word: Barrier
        [47585] = true, -- Dispersion
        [19236] = true, -- Desperate Prayer
        [213602] = true, -- Greater Fade
        [27827] = true, -- Spirit of Redemption
        [197268] = true, -- Ray of Hope
        [47788] = true, -- Guardian Spirit
        [33206] = true, -- Pain Suppression
        -- Rogue
        [5277] = true, -- Evasion
        [31224] = true, -- Cloak of Shadows
        [1966] = true, -- Feint
        [199754] = true, -- Riposte
        [45182] = true, -- Cheating Death
        [199027] = true, -- Veil of Midnight
        -- Shaman
        [325174] = true, -- Spirit Link
        [204288] = true, -- Earth Shield
        [210918] = true, -- Ethereal Form
        [207654] = true, -- Servant of the Queen
        [108271] = true, -- Astral Shift
        [207498] = true, -- Ancestral Protection
        -- Warlock
        [108416] = true, -- Dark Pact
        [104773] = true, -- Unending Resolve
        [221715] = true, -- Essence Drain
        [212295] = true, -- Nether Ward
        -- Warrior
        [118038] = true, -- Die by the Sword
        [184364] = true, -- Enraged Regeneration
        [209484] = true, -- Tactical Advance
        [97463] = true, -- Commanding Shout
        [213915] = true, -- Mass Spell Reflection
        [199038] = true, -- Leave No Man Behind
        [223658] = true, -- Safeguard
        [147833] = true, -- Intervene
        [198760] = true, -- Intercept
        [12975] = true, -- Last Stand
        [871] = true, -- Shield Wall
        [23920] = true, -- Spell Reflection
        [227744] = true, -- Ravager
        [203524] = true, -- Neltharion's Fury
        [190456] = true, -- Ignore Pain
        [132404] = true, -- Shield Block
        -- Racial
        [65116] = true, -- Stoneform
        -- Potion
        [251231] = true, -- Steelskin Potion
        -- Covenant
        [324867] = true -- Fleshcraft (Necrolord)
    }

    UF.auraFilters.PlayerBuffs = {
        -- Death Knight
        [48707] = true, -- Anti-Magic Shell
        [81256] = true, -- Dancing Rune Weapon
        [55233] = true, -- Vampiric Blood
        [193320] = true, -- Umbilicus Eternus
        [219809] = true, -- Tombstone
        [48792] = true, -- Icebound Fortitude
        [207319] = true, -- Corpse Shield
        [194844] = true, -- BoneStorm
        [145629] = true, -- Anti-Magic Zone
        [194679] = true, -- Rune Tap
        [51271] = true, -- Pillar of Frost
        [207256] = true, -- Obliteration
        [152279] = true, -- Breath of Sindragosa
        [233411] = true, -- Blood for Blood
        [212552] = true, -- Wraith Walk
        [343294] = true, -- Soul Reaper
        [194918] = true, -- Blighted Rune Weapon
        [48265] = true, -- Death's Advance
        [49039] = true, -- Lichborne
        [47568] = true, -- Empower Rune Weapon
        -- Demon Hunter
        [207811] = true, -- Nether Bond (DH)
        [207810] = true, -- Nether Bond (Target)
        [187827] = true, -- Metamorphosis
        [263648] = true, -- Soul Barrier
        [209426] = true, -- Darkness
        [196555] = true, -- Netherwalk
        [212800] = true, -- Blur
        [188499] = true, -- Blade Dance
        [203819] = true, -- Demon Spikes
        [206804] = true, -- Rain from Above
        [211510] = true, -- Solitude
        [162264] = true, -- Metamorphosis
        [205629] = true, -- Demonic Trample
        [188501] = true, -- Spectral Sight
        -- Druid
        [102342] = true, -- Ironbark
        [61336] = true, -- Survival Instincts
        [210655] = true, -- Protection of Ashamane
        [22812] = true, -- Barkskin
        [200851] = true, -- Rage of the Sleeper
        [234081] = true, -- Celestial Guardian
        [202043] = true, -- Protector of the Pack (it's this one or the other)
        [201940] = true, -- Protector of the Pack
        [201939] = true, -- Protector of the Pack (Allies)
        [192081] = true, -- Ironfur
        [29166] = true, -- Innervate
        [208253] = true, -- Essence of G'Hanir
        [194223] = true, -- Celestial Alignment
        [102560] = true, -- Incarnation: Chosen of Elune
        [102543] = true, -- Incarnation: King of the Jungle
        [102558] = true, -- Incarnation: Guardian of Ursoc
        [117679] = true, -- Incarnation
        [106951] = true, -- Berserk (Feral)
        [50334] = true, -- Berserk (Guardian)
        [5217] = true, -- Tiger's Fury
        [1850] = true, -- Dash
        [137452] = true, -- Displacer Beast
        [102416] = true, -- Wild Charge
        [77764] = true, -- Stampeding Roar (Cat)
        [77761] = true, -- Stampeding Roar (Bear)
        [305497] = true, -- Thorns
        [233756] = true, -- Moon and Stars (not used?)
        [234084] = true, -- Moon and Stars (PvP)
        [22842] = true, -- Frenzied Regeneration
        -- Hunter
        [186265] = true, -- Aspect of the Turtle
        [53480] = true, -- Roar of Sacrifice
        [202748] = true, -- Survival Tactics
        [62305] = true, -- Master's Call (it's this one or the other)
        [54216] = true, -- Master's Call
        [288613] = true, -- Trueshot
        [260402] = true, -- Double Tap
        [193530] = true, -- Aspect of the Wild
        [19574] = true, -- Bestial Wrath
        [186289] = true, -- Aspect of the Eagle
        [186257] = true, -- Aspect of the Cheetah
        [118922] = true, -- Posthaste
        [90355] = true, -- Ancient Hysteria (Pet)
        [160452] = true, -- Netherwinds (Pet)
        [266779] = true, -- Coordinated Assault
        -- Mage
        [45438] = true, -- Ice Block
        [113862] = true, -- Greater Invisibility
        [198111] = true, -- Temporal Shield
        [198065] = true, -- Prismatic Cloak
        [11426] = true, -- Ice Barrier
        [235313] = true, -- Blazing Barrier
        [235450] = true, -- Prismatic Barrier
        [110909] = true, -- Alter Time
        [190319] = true, -- Combustion
        [80353] = true, -- Time Warp
        [12472] = true, -- Icy Veins
        [12042] = true, -- Arcane Power
        [116014] = true, -- Rune of Power
        [198144] = true, -- Ice Form
        [108839] = true, -- Ice Floes
        [205025] = true, -- Presence of Mind
        [198158] = true, -- Mass Invisibility
        [221404] = true, -- Burning Determination
        -- Monk
        [122783] = true, -- Diffuse Magic
        [122278] = true, -- Dampen Harm
        [125174] = true, -- Touch of Karma
        [201318] = true, -- Fortifying Elixir
        [202248] = true, -- Guided Meditation
        [120954] = true, -- Fortifying Brew
        [116849] = true, -- Life Cocoon
        [202162] = true, -- Guard
        [215479] = true, -- Ironskin Brew
        [152173] = true, -- Serenity
        [137639] = true, -- Storm, Earth, and Fire
        [213664] = true, -- Nimble Brew
        [201447] = true, -- Ride the Wind
        [195381] = true, -- Healing Winds
        [116841] = true, -- Tiger's Lust
        [119085] = true, -- Chi Torpedo
        [199407] = true, -- Light on Your Feet
        [209584] = true, -- Zen Focus Tea
        -- Paladin
        [642] = true, -- Divine Shield
        [498] = true, -- Divine Protection
        [205191] = true, -- Eye for an Eye
        [184662] = true, -- Shield of Vengeance
        [1022] = true, -- Blessing of Protection
        [6940] = true, -- Blessing of Sacrifice
        [204018] = true, -- Blessing of Spellwarding
        [199507] = true, -- Spreading The Word: Protection
        [216857] = true, -- Guarded by the Light
        [228049] = true, -- Guardian of the Forgotten Queen
        [31850] = true, -- Ardent Defender
        [86659] = true, -- Guardian of Ancien Kings
        [212641] = true, -- Guardian of Ancien Kings (Glyph of the Queen)
        [209388] = true, -- Bulwark of Order
        [152262] = true, -- Seraphim
        [132403] = true, -- Shield of the Righteous
        [31884] = true, -- Avenging Wrath
        [105809] = true, -- Holy Avenger
        [231895] = true, -- Crusade
        [200652] = true, -- Tyr's Deliverance
        [216331] = true, -- Avenging Crusader
        [1044] = true, -- Blessing of Freedom
        [210256] = true, -- Blessing of Sanctuary
        [199545] = true, -- Steed of Glory
        [210294] = true, -- Divine Favor
        [221886] = true, -- Divine Steed
        [31821] = true, -- Aura Mastery
        -- Priest
        [81782] = true, -- Power Word: Barrier
        [47585] = true, -- Dispersion
        [19236] = true, -- Desperate Prayer
        [213602] = true, -- Greater Fade
        [27827] = true, -- Spirit of Redemption
        [197268] = true, -- Ray of Hope
        [47788] = true, -- Guardian Spirit
        [33206] = true, -- Pain Suppression
        [200183] = true, -- Apotheosis
        [10060] = true, -- Power Infusion
        [47536] = true, -- Rapture
        [194249] = true, -- Voidform
        [193223] = true, -- Surrdender to Madness
        [197862] = true, -- Archangel
        [197871] = true, -- Dark Archangel
        [197874] = true, -- Dark Archangel
        [215769] = true, -- Spirit of Redemption
        [213610] = true, -- Holy Ward
        [121557] = true, -- Angelic Feather
        [214121] = true, -- Body and Mind
        [65081] = true, -- Body and Soul
        [197767] = true, -- Speed of the Pious
        [210980] = true, -- Focus in the Light
        [221660] = true, -- Holy Concentration
        [15286] = true, -- Vampiric Embrace
        -- Rogue
        [5277] = true, -- Evasion
        [31224] = true, -- Cloak of Shadows
        [1966] = true, -- Feint
        [199754] = true, -- Riposte
        [45182] = true, -- Cheating Death
        [199027] = true, -- Veil of Midnight
        [121471] = true, -- Shadow Blades
        [13750] = true, -- Adrenaline Rush
        [51690] = true, -- Killing Spree
        [185422] = true, -- Shadow Dance
        [198368] = true, -- Take Your Cut
        [198027] = true, -- Turn the Tables
        [213985] = true, -- Thief's Bargain
        [197003] = true, -- Maneuverability
        [212198] = true, -- Crimson Vial
        [185311] = true, -- Crimson Vial
        [209754] = true, -- Boarding Party
        [36554] = true, -- Shadowstep
        [2983] = true, -- Sprint
        [202665] = true, -- Curse of the Dreadblades (Self Debuff)
        -- Shaman
        [325174] = true, -- Spirit Link
        [204288] = true, -- Earth Shield
        [210918] = true, -- Ethereal Form
        [207654] = true, -- Servant of the Queen
        [108271] = true, -- Astral Shift
        [207498] = true, -- Ancestral Protection
        [204366] = true, -- Thundercharge
        [209385] = true, -- Windfury Totem
        [208963] = true, -- Skyfury Totem
        [204945] = true, -- Doom Winds
        [205495] = true, -- Stormkeeper
        [208416] = true, -- Sense of Urgency
        [2825] = true, -- Bloodlust
        [16166] = true, -- Elemental Mastery
        [167204] = true, -- Feral Spirit
        [114050] = true, -- Ascendance (Elem)
        [114051] = true, -- Ascendance (Enh)
        [114052] = true, -- Ascendance (Resto)
        [79206] = true, -- Spiritwalker's Grace
        [58875] = true, -- Spirit Walk
        [157384] = true, -- Eye of the Storm
        [192082] = true, -- Wind Rush
        [2645] = true, -- Ghost Wolf
        [32182] = true, -- Heroism
        [108281] = true, -- Ancestral Guidance
        -- Warlock
        [108416] = true, -- Dark Pact
        [113860] = true, -- Dark Soul: Misery
        [104773] = true, -- Unending Resolve
        [221715] = true, -- Essence Drain
        [212295] = true, -- Nether Ward
        [212284] = true, -- Firestone
        [196098] = true, -- Soul Harvest
        [221705] = true, -- Casting Circle
        [111400] = true, -- Burning Rush
        [196674] = true, -- Planeswalker
        -- Warrior
        [118038] = true, -- Die by the Sword
        [184364] = true, -- Enraged Regeneration
        [209484] = true, -- Tactical Advance
        [97463] = true, -- Commanding Shout
        [213915] = true, -- Mass Spell Reflection
        [199038] = true, -- Leave No Man Behind
        [223658] = true, -- Safeguard
        [147833] = true, -- Intervene
        [198760] = true, -- Intercept
        [12975] = true, -- Last Stand
        [871] = true, -- Shield Wall
        [23920] = true, -- Spell Reflection
        [227744] = true, -- Ravager
        [203524] = true, -- Neltharion's Fury
        [190456] = true, -- Ignore Pain
        [132404] = true, -- Shield Block
        [1719] = true, -- Battle Cry
        [107574] = true, -- Avatar
        [227847] = true, -- Bladestorm (Arm)
        [46924] = true, -- Bladestorm (Fury)
        [118000] = true, -- Dragon Roar
        [199261] = true, -- Death Wish
        [18499] = true, -- Berserker Rage
        [202164] = true, -- Bounding Stride
        [215572] = true, -- Frothing Berserker
        [199203] = true, -- Thirst for Battle
        -- Racials
        [65116] = true, -- Stoneform
        [59547] = true, -- Gift of the Naaru
        [20572] = true, -- Blood Fury
        [26297] = true, -- Berserking
        [68992] = true, -- Darkflight
        [58984] = true, -- Shadowmeld
        -- General Consumables
        [178207] = true, -- Drums of Fury
        [230935] = true, -- Drums of the Mountain (Legion)
        [256740] = true, -- Drums of the Maelstrom (BfA)
        -- Shadowlands Consumables
        [307159] = true, -- Potion of Spectral Agility
        [307160] = true, -- Potion of Hardened Shadows
        [307161] = true, -- Potion of Spiritual Clarity
        [307162] = true, -- Potion of Spectral Intellect
        [307163] = true, -- Potion of Spectral Stamina
        [307164] = true, -- Potion of Spectral Strength
        [307165] = true, -- Spiritual Anti-Venom
        [307185] = true, -- Spectral Flask of Power
        [307187] = true, -- Spectral Flask of Stamina
        [307195] = true, -- Potion of Hidden Spirit
        [307196] = true, -- Potion of Shaded Sight
        [307199] = true, -- Potion of Soul Purity
        [307494] = true, -- Potion of Empowered Exorcisms
        [307495] = true, -- Potion of Phantom Fire
        [307496] = true, -- Potion of Divine Awakening
        [307497] = true, -- Potion of Deathly Fixation
        [307501] = true, -- Potion of Specter Swiftness
        [308397] = true, -- Butterscotch Marinated Ribs
        [308402] = true, -- Surprisingly Palatable Feast
        [308404] = true, -- Cinnamon Bonefish Stew
        [308412] = true, -- Meaty Apple Dumplings
        [308425] = true, -- Sweet Silvergrill Sausages
        [308434] = true, -- Phantasmal Souffle and Fries
        [308488] = true, -- Tenebrous Crown Roast Aspic
        [308506] = true, -- Crawler Ravioli with Apple Sauce
        [308514] = true, -- Steak a la Mode
        [308525] = true, -- Banana Beef Pudding
        [308637] = true, -- Smothered Shank
        [322302] = true, -- Potion of Sacrificial Anima
        [327708] = true, -- Feast of Gluttonous Hedonism
        [327715] = true, -- Fried Bonefish
        [327851] = true -- Seraph Tenders
    }

    UF.auraFilters.RaidBuffs = {
        ----------------------------------------------------------
        -------------------- Mythic+ Specific --------------------
        ----------------------------------------------------------
        -- Mythic+ General
        [209859] = true, -- Bolster
        [178658] = true, -- Raging
        [226510] = true, -- Sanguine
        [343502] = true, -- Inspiring
        ----------------------------------------------------------
        ------------------ Shadowlands Dungeons ------------------
        ----------------------------------------------------------
        -- Tazavesh, the Veiled Market
        [355147] = true, -- Fish Invigoration
        [351960] = true, -- Static Cling
        [351088] = true, -- Relic Link
        [346296] = true, -- Instability
        [355057] = true, -- Cry of Mrrggllrrgg
        [355640] = true, -- Phalanx Field
        [355783] = true, -- Force Multiplied
        [351086] = true, -- Power Overwhelming
        [347840] = true, -- Feral
        [355782] = true, -- Force Multiplier
        [347992] = true, -- Rotar Body Armor
        -- Halls of Atonement
        [326450] = true, -- Loyal Beasts
        -- Mists of Tirna Scithe
        [336499] = true, -- Guessing Game
        -- Plaguefall
        [336451] = true, -- Bulwark of Maldraxxus
        [333737] = true, -- Congealed Contagion
        -- The Necrotic Wake
        [321754] = true, -- Icebound Aegis
        [343558] = true, -- Morbid Fixation
        [343470] = true, -- Boneshatter Shield
        -- Theater of Pain
        [331510] = true, -- Death Wish
        [333241] = true, -- Raging Tantrum
        [326892] = true, -- Fixate
        [330545] = true, -- Commanding Presences
        -- Sanguine Depths
        [322433] = true, -- Stoneskin
        [321402] = true, -- Engorge
        -- Spires of Ascension
        [327416] = true, -- Recharge Anima
        [317936] = true, -- Forsworn Doctrine
        [327808] = true, -- Inspiring Presence
        -- De Other Side
        [344739] = true, -- Spectral
        [333227] = true, -- Undying Rage
        [322773] = true, -- Blood Barrier
        ----------------------------------------------------------
        ----------------- Sanctum of Domination ------------------
        ----------------------------------------------------------
        -- The Tarragrue
        [352491] = true, -- Remnant: Mort'regar's Echoes 1
        [352389] = true, -- Remnant: Mort'regar's Echoes 2
        [352473] = true, -- Remnant: Upper Reaches' Might 1
        [352382] = true, -- Remnant: Upper Reaches' Might 2
        [352398] = true, -- Remnant: Soulforge Heat
        [347490] = true, -- Fury of the Ages
        [347740] = true, -- Hungering Mist 1
        [347679] = true, -- Hungering Mist 2
        [347369] = true, -- The Jailer's Gaze
        -- Eye of the Jailer
        [350006] = true, -- Pulled Down
        [351413] = true, -- Annihilating Glare
        [348805] = true, -- Stygian Darkshield
        [351994] = true, -- Dying Suffering
        [351825] = true, -- Shared Suffering
        [345521] = true, -- Molten Aura
        -- The Nine
        [355294] = true, -- Resentment
        [350286] = true, -- Song of Dissolution
        [352756] = true, -- Wings of Rage 1
        [350365] = true, -- Wings of Rage 2
        [352752] = true, -- Reverberating Refrain 1
        [350385] = true, -- Reverberating Refrain 2
        [350158] = true, -- Annhylde's Bright Aegis
        -- Remnant of Ner'zhul
        [355790] = true, -- Eternal Torment
        [355151] = true, -- Malevolence
        [355439] = true, -- Aura of Spite 1
        [354441] = true, -- Aura of Spite 2
        [350671] = true, -- Aura of Spite 3
        [354440] = true, -- Aura of Spite 4
        -- Soulrender Dormazain
        [351946] = true, -- Hellscream
        [352066] = true, -- Rendered Soul
        [353554] = true, -- Infuse Defiance
        [351773] = true, -- Defiance
        [350415] = true, -- Warmonger's Shackles
        [352933] = true, -- Tormented Eruptions
        -- Painsmith Raznal
        [355525] = true, -- Forge Weapon
        -- Guardian of the First Ones
        [352538] = true, -- Purging Protocol
        [353448] = true, -- Suppression Field
        [350534] = true, -- Purging Protocol
        [352385] = true, -- Energizing Link
        -- Fatescribe Roh-Kalo
        [353604] = true, -- Diviner's Probe
        -- Kel'Thuzad
        [355935] = true, -- Banshee's Cry 1
        [352141] = true, -- Banshee's Cry 2
        [355948] = true, -- Necrotic Empowerment
        [352051] = true, -- Necrotic Surge
        -- Sylvanas Windrunner
        [352650] = true, -- Ranger's Heartseeker 1
        [352663] = true, -- Ranger's Heartseeker 2
        [350865] = true, -- Accursed Might
        [348146] = true, -- Banshee Form
        [347504] = true, -- Windrunner
        [350857] = true, -- Banshee Shroud
        [351109] = true, -- Enflame
        [351452] = true, -- Lethargic Focus
        ---------------------------------------------------------
        ----------------------- Open World ----------------------
        ---------------------------------------------------------
        -- Korthia
        [354840] = true, -- Rift Veiled (Silent Soulstalker, Deadsoul Hatcher, Screaming Shade)
        [355249] = true -- Anima Gorged (Consumption)
    }

    UF.auraFilters.RaidDebuffs = {
        ----------------------------------------------------------
        -------------------- Mythic+ Specific --------------------
        ----------------------------------------------------------
        -- General Affixes
        [209858] = true, -- Necrotic
        [226512] = true, -- Sanguine
        [240559] = true, -- Grievous
        [240443] = true, -- Bursting
        -- Shadowlands Season 2
        [356667] = true, -- Biting Cold 1
        [356666] = true, -- Biting Cold 2
        [355732] = true, -- Melt Soul
        [356925] = true, -- Carnage
        [358777] = true, -- Bindings of Misery
        ----------------------------------------------------------
        ------------------ Shadowlands Dungeons ------------------
        ----------------------------------------------------------
        -- Tazavesh, the Veiled Market
        [350804] = true, -- Collapsing Energy
        [350885] = true, -- Hyperlight Jolt
        [351101] = true, -- Energy Fragmentation
        [346828] = true, -- Sanitizing Field
        [355641] = true, -- Scintillate
        [355451] = true, -- Undertow
        [355581] = true, -- Crackle
        [349999] = true, -- Anima Detonation
        [346961] = true, -- Purging Field
        [351956] = true, -- High-Value Target
        [346297] = true, -- Unstable Explosion
        [347728] = true, -- Flock!
        [356408] = true, -- Ground Stomp
        [347744] = true, -- Quickblade
        [347481] = true, -- Shuri
        [355915] = true, -- Glyph of Restraint
        [350134] = true, -- Infinite Breath
        [350013] = true, -- Gluttonous Feast
        [355465] = true, -- Boulder Throw
        [346116] = true, -- Shearing Swings
        [356011] = true, -- Beam Splicer
        -- Halls of Atonement
        [335338] = true, -- Ritual of Woe
        [326891] = true, -- Anguish
        [329321] = true, -- Jagged Swipe 1
        [344993] = true, -- Jagged Swipe 2
        [319603] = true, -- Curse of Stone
        [319611] = true, -- Turned to Stone
        [325876] = true, -- Curse of Obliteration
        [326632] = true, -- Stony Veins
        [323650] = true, -- Haunting Fixation
        [326874] = true, -- Ankle Bites
        [340446] = true, -- Mark of Envy
        -- Mists of Tirna Scithe
        [325027] = true, -- Bramble Burst
        [323043] = true, -- Bloodletting
        [322557] = true, -- Soul Split
        [331172] = true, -- Mind Link
        [322563] = true, -- Marked Prey
        [322487] = true, -- Overgrowth 1
        [322486] = true, -- Overgrowth 2
        [328756] = true, -- Repulsive Visage
        [325021] = true, -- Mistveil Tear
        [321891] = true, -- Freeze Tag Fixation
        [325224] = true, -- Anima Injection
        [326092] = true, -- Debilitating Poison
        [325418] = true, -- Volatile Acid
        -- Plaguefall
        [336258] = true, -- Solitary Prey
        [331818] = true, -- Shadow Ambush
        [329110] = true, -- Slime Injection
        [325552] = true, -- Cytotoxic Slash
        [336301] = true, -- Web Wrap
        [322358] = true, -- Burning Strain
        [322410] = true, -- Withering Filth
        [328180] = true, -- Gripping Infection
        [320542] = true, -- Wasting Blight
        [340355] = true, -- Rapid Infection
        [328395] = true, -- Venompiercer
        [320512] = true, -- Corroded Claws
        [333406] = true, -- Assassinate
        [332397] = true, -- Shroudweb
        [330069] = true, -- Concentrated Plague
        -- The Necrotic Wake
        [321821] = true, -- Disgusting Guts
        [323365] = true, -- Clinging Darkness
        [338353] = true, -- Goresplatter
        [333485] = true, -- Disease Cloud
        [338357] = true, -- Tenderize
        [328181] = true, -- Frigid Cold
        [320170] = true, -- Necrotic Bolt
        [323464] = true, -- Dark Ichor
        [323198] = true, -- Dark Exile
        [343504] = true, -- Dark Grasp
        [343556] = true, -- Morbid Fixation 1
        [338606] = true, -- Morbid Fixation 2
        [324381] = true, -- Chill Scythe
        [320573] = true, -- Shadow Well
        [333492] = true, -- Necrotic Ichor
        [334748] = true, -- Drain Fluids
        [333489] = true, -- Necrotic Breath
        [320717] = true, -- Blood Hunger
        -- Theater of Pain
        [333299] = true, -- Curse of Desolation 1
        [333301] = true, -- Curse of Desolation 2
        [319539] = true, -- Soulless
        [326892] = true, -- Fixate
        [321768] = true, -- On the Hook
        [323825] = true, -- Grasping Rift
        [342675] = true, -- Bone Spear
        [323831] = true, -- Death Grasp
        [330608] = true, -- Vile Eruption
        [330868] = true, -- Necrotic Bolt Volley
        [323750] = true, -- Vile Gas
        [323406] = true, -- Jagged Gash
        [330700] = true, -- Decaying Blight
        [319626] = true, -- Phantasmal Parasite
        [324449] = true, -- Manifest Death
        [341949] = true, -- Withering Blight
        -- Sanguine Depths
        [326827] = true, -- Dread Bindings
        [326836] = true, -- Curse of Suppression
        [322554] = true, -- Castigate
        [321038] = true, -- Burden Soul
        [328593] = true, -- Agonize
        [325254] = true, -- Iron Spikes
        [335306] = true, -- Barbed Shackles
        [322429] = true, -- Severing Slice
        [334653] = true, -- Engorge
        -- Spires of Ascension
        [338729] = true, -- Charged Stomp
        [323195] = true, -- Purifying Blast
        [327481] = true, -- Dark Lance
        [322818] = true, -- Lost Confidence
        [322817] = true, -- Lingering Doubt
        [324205] = true, -- Blinding Flash
        [331251] = true, -- Deep Connection
        [328331] = true, -- Forced Confession
        [341215] = true, -- Volatile Anima
        [323792] = true, -- Anima Field
        [317661] = true, -- Insidious Venom
        [330683] = true, -- Raw Anima
        [328434] = true, -- Intimidated
        -- De Other Side
        [320786] = true, -- Power Overwhelming
        [334913] = true, -- Master of Death
        [325725] = true, -- Cosmic Artifice
        [328987] = true, -- Zealous
        [334496] = true, -- Soporific Shimmerdust
        [339978] = true, -- Pacifying Mists
        [323692] = true, -- Arcane Vulnerability
        [333250] = true, -- Reaver
        [330434] = true, -- Buzz-Saw 1
        [320144] = true, -- Buzz-Saw 2
        [331847] = true, -- W-00F
        [327649] = true, -- Crushed Soul
        [331379] = true, -- Lubricate
        [332678] = true, -- Gushing Wound
        [322746] = true, -- Corrupted Blood
        [323687] = true, -- Arcane Lightning
        [323877] = true, -- Echo Finger Laser X-treme
        [334535] = true, -- Beak Slice
        --------------------------------------------------------
        ---------------- Sanctum of Domination -----------------
        --------------------------------------------------------
        -- The Tarragrue
        [347283] = true, -- Predator's Howl
        [347286] = true, -- Unshakeable Dread
        [346986] = true, -- Crushed Armor
        [347269] = true, -- Chains of Eternity
        [346985] = true, -- Overpower
        -- Eye of the Jailer
        [350606] = true, -- Hopeless Lethargy
        [355240] = true, -- Scorn
        [355245] = true, -- Ire
        [349979] = true, -- Dragging Chains
        [348074] = true, -- Assailing Lance
        [351827] = true, -- Spreading Misery
        [355143] = true, -- Deathlink
        [350763] = true, -- Annihilating Glare
        -- The Nine
        [350287] = true, -- Song of Dissolution
        [350542] = true, -- Fragments of Destiny
        [350202] = true, -- Unending Strike
        [350475] = true, -- Pierce Soul
        [350555] = true, -- Shard of Destiny
        [350109] = true, -- Brynja's Mournful Dirge
        [350483] = true, -- Link Essence
        [350039] = true, -- Arthura's Crushing Gaze
        [350184] = true, -- Daschla's Mighty Impact
        [350374] = true, -- Wings of Rage
        -- Remnant of Ner'zhul
        [350073] = true, -- Torment
        [349890] = true, -- Suffering
        [350469] = true, -- Malevolence
        [354634] = true, -- Spite 1
        [354479] = true, -- Spite 2
        [354534] = true, -- Spite 3
        -- Soulrender Dormazain
        [353429] = true, -- Tormented
        [353023] = true, -- Torment
        [351787] = true, -- Agonizing Spike
        [350647] = true, -- Brand of Torment
        [350422] = true, -- Ruinblade
        [350851] = true, -- Vessel of Torment
        [354231] = true, -- Soul Manacles
        [348987] = true, -- Warmonger Shackle 1
        [350927] = true, -- Warmonger Shackle 2
        -- Painsmith Raznal
        [356472] = true, -- Lingering Flames
        [355505] = true, -- Shadowsteel Chains 1
        [355506] = true, -- Shadowsteel Chains 2
        [348456] = true, -- Flameclasp Trap
        [356870] = true, -- Flameclasp Eruption
        [355568] = true, -- Cruciform Axe
        [355786] = true, -- Blackened Armor
        [355526] = true, -- Spiked
        -- Guardian of the First Ones
        [352394] = true, -- Radiant Energy
        [350496] = true, -- Threat Neutralization
        [347359] = true, -- Suppression Field
        [355357] = true, -- Obliterate
        [350732] = true, -- Sunder
        [352833] = true, -- Disintegration
        -- Fatescribe Roh-Kalo
        [354365] = true, -- Grim Portent
        [350568] = true, -- Call of Eternity
        [353435] = true, -- Overwhelming Burden
        [351680] = true, -- Invoke Destiny
        [353432] = true, -- Burden of Destiny
        [353693] = true, -- Unstable Accretion
        [350355] = true, -- Fated Conjunction
        [353931] = true, -- Twist Fate
        -- Kel'Thuzad
        [346530] = true, -- Frozen Destruction
        [354289] = true, -- Sinister Miasma
        [347454] = true, -- Oblivion's Echo 1
        [347518] = true, -- Oblivion's Echo 2
        [347292] = true, -- Oblivion's Echo 3
        [348978] = true, -- Soul Exhaustion
        [355389] = true, -- Relentless Haunt (Fixate)
        [357298] = true, -- Frozen Binds
        [355137] = true, -- Shadow Pool
        [348638] = true, -- Return of the Damned
        [348760] = true, -- Frost Blast
        -- Sylvanas Windrunner
        [349458] = true, -- Domination Chains
        [347704] = true, -- Veil of Darkness
        [347607] = true, -- Banshee's Mark
        [347670] = true, -- Shadow Dagger
        [351117] = true, -- Crushing Dread
        [351870] = true, -- Haunting Wave
        [351253] = true, -- Banshee Wail
        [351451] = true, -- Curse of Lethargy
        [351092] = true, -- Destabilize 1
        [351091] = true, -- Destabilize 2
        [348064] = true -- Wailing Arrow
    }

    UF.auraFilters.Blacklist = {
        [36900] = true, -- Soul Split: Evil!
        [36901] = true, -- Soul Split: Good
        [36893] = true, -- Transporter Malfunction
        [97821] = true, -- Void-Touched
        [36032] = true, -- Arcane Charge
        [8733] = true, -- Blessing of Blackfathom
        [25771] = true, -- Forbearance (Pally: Divine Shield, Blessing of Protection, and Lay on Hands)
        [57724] = true, -- Sated (lust debuff)
        [57723] = true, -- Exhaustion (heroism debuff)
        [80354] = true, -- Temporal Displacement (timewarp debuff)
        [95809] = true, -- Insanity debuff (hunter pet heroism: ancient hysteria)
        [58539] = true, -- Watcher's Corpse
        [26013] = true, -- Deserter
        [71041] = true, -- Dungeon Deserter
        [41425] = true, -- Hypothermia
        [55711] = true, -- Weakened Heart
        [8326] = true, -- Ghost
        [23445] = true, -- Evil Twin
        [24755] = true, -- Tricked or Treated
        [96041] = true, -- Stink Bombed
        [25163] = true, -- Oozeling's Disgusting Aura
        [124275] = true, -- Stagger
        [124274] = true, -- Stagger
        [124273] = true, -- Stagger
        [117870] = true, -- Touch of The Titans
        [123981] = true, -- Perdition
        [15007] = true, -- Ress Sickness
        [113942] = true, -- Demonic: Gateway
        [89140] = true, -- Demonic Rebirth: Cooldown
        [287825] = true, -- Lethargy debuff (fight or flight)
        [206662] = true, -- Experience Eliminated (in range)
        [306600] = true, -- Experience Eliminated (oor - 5m)
        [348443] = true, -- Experience Eliminated
        [206151] = true, -- Challenger's Burden
        [313015] = true, -- Recently Failed (mechagnome racial)
        [195776] = true, -- Moonfeather Fever
        [322695] = true -- Drained
    }

    UF.auraFilters.Whitelist = {
        -- Bloodlust effects
        [2825] = true, -- Bloodlust
        [32182] = true, -- Heroism
        [80353] = true, -- Time Warp
        [90355] = true, -- Ancient Hysteria
        -- Paladin
        [31821] = true, -- Aura Mastery
        [1022] = true, -- Blessing of Protection
        [204018] = true, -- Blessing of Spellwarding
        [6940] = true, -- Blessing of Sacrifice
        [1044] = true, -- Blessing of Freedom
        -- Priest
        [47788] = true, -- Guardian Spirit
        [33206] = true, -- Pain Suppression
        [62618] = true, -- Power Word: Barrier
        -- Monk
        [116849] = true, -- Life Cocoon
        -- Druid
        [102342] = true, -- Ironbark
        -- Shaman
        [325174] = true, -- Spirit Link
        [20608] = true, -- Reincarnation
        -- Other
        [97462] = true, -- Rallying Cry
        [196718] = true -- Darkness
    }
else
    UF.auraFilters.CrowdControl = {
        -- Druid
        [339] = true, -- Entangling Roots (Rank 1)
        [1062] = true, -- Entangling Roots (Rank 2)
        [5195] = true, -- Entangling Roots (Rank 3)
        [5196] = true, -- Entangling Roots (Rank 4)
        [9852] = true, -- Entangling Roots (Rank 5)
        [9853] = true, -- Entangling Roots (Rank 6)
        [26989] = true, -- Entangling Roots (Rank 7)
        [2637] = true, -- Hibernate (Rank 1)
        [18657] = true, -- Hibernate (Rank 2)
        [18658] = true, -- Hibernate (Rank 3)
        [19675] = true, -- Feral Charge Effect
        [5211] = true, -- Bash (Rank 1)
        [6798] = true, -- Bash (Rank 2)
        [8983] = true, -- Bash (Rank 3)
        [16922] = true, -- Starfire Stun
        [9005] = true, -- Pounce (Rank 1)
        [9823] = true, -- Pounce (Rank 2)
        [9827] = true, -- Pounce (Rank 3)
        [27006] = true, -- Pounce (Rank 4)
        [770] = true, -- Faerie Fire (Rank 1)
        [778] = true, -- Faerie Fire (Rank 2)
        [9749] = true, -- Faerie Fire (Rank 3)
        [9907] = true, -- Faerie Fire (Rank 4)
        [16857] = true, -- Faerie Fire (Feral) (Rank 1)
        [17390] = true, -- Faerie Fire (Feral) (Rank 2)
        [17391] = true, -- Faerie Fire (Feral) (Rank 3)
        [17392] = true, -- Faerie Fire (Feral) (Rank 4)
        -- Hunter
        [1499] = true, -- Freezing Trap (Rank 1)
        [14310] = true, -- Freezing Trap (Rank 2)
        [14311] = true, -- Freezing Trap (Rank 3)
        [14308] = true, -- Freezing Trap Effect (Rank 2)
        [14309] = true, -- Freezing Trap Effect (Rank 3)
        [13809] = true, -- Frost Trap
        [19503] = true, -- Scatter Shot
        [5116] = true, -- Concussive Shot
        [297] = true, -- Wing Clip (Rank 1)
        [14267] = true, -- Wing Clip (Rank 2)
        [14268] = true, -- Wing Clip (Rank 3)
        [1513] = true, -- Scare Beast (Rank 1)
        [14326] = true, -- Scare Beast (Rank 2)
        [14327] = true, -- Scare Beast (Rank 3)
        [24394] = true, -- Intimidation
        [19386] = true, -- Wyvern Sting (Rank 1)
        [24132] = true, -- Wyvern Sting (Rank 2)
        [24133] = true, -- Wyvern Sting (Rank 3)
        [19229] = true, -- Improved Wing Clip
        [19306] = true, -- Counterattack (Rank 1)
        [20909] = true, -- Counterattack (Rank 2)
        [20910] = true, -- Counterattack (Rank 3)
        -- Mage
        [118] = true, -- Polymorph (Rank 1)
        [12824] = true, -- Polymorph (Rank 2)
        [12825] = true, -- Polymorph (Rank 3)
        [12826] = true, -- Polymorph (Rank 4)
        [122] = true, -- Frost Nova (Rank 1)
        [865] = true, -- Frost Nova (Rank 2)
        [6131] = true, -- Frost Nova (Rank 3)
        [10230] = true, -- Frost Nova (Rank 4)
        [27088] = true, -- Frost Nova (Rank 5)
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
        [12355] = true, -- Impact
        -- Paladin
        [853] = true, -- Hammer of Justice (Rank 1)
        [5588] = true, -- Hammer of Justice (Rank 2)
        [5589] = true, -- Hammer of Justice (Rank 3)
        [10308] = true, -- Hammer of Justice (Rank 4)
        [20066] = true, -- Repentance
        -- Priest
        [8122] = true, -- Psychic Scream (Rank 1)
        [8124] = true, -- Psychic Scream (Rank 2)
        [10888] = true, -- Psychic Scream (Rank 3)
        [10890] = true, -- Psychic Scream (Rank 4)
        [605] = true, -- Mind Control (Rank 1)
        [10911] = true, -- Mind Control (Rank 2)
        [10912] = true, -- Mind Control (Rank 3)
        [15269] = true, -- Blackout
        [15407] = true, -- Mind Flay (Rank 1)
        [17311] = true, -- Mind Flay (Rank 2)
        [17312] = true, -- Mind Flay (Rank 3)
        [17313] = true, -- Mind Flay (Rank 4)
        [17314] = true, -- Mind Flay (Rank 5)
        [18807] = true, -- Mind Flay (Rank 6)
        [25387] = true, -- Mind Flay (Rank 7)
        -- Rogue
        [6770] = true, -- Sap (Rank 1)
        [2070] = true, -- Sap (Rank 2)
        [11297] = true, -- Sap (Rank 3)
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
        [5530] = true, -- Mace Stun Effect
        -- Shaman
        [2484] = true, -- Earthbind Totem
        [8056] = true, -- Frost Shock (Rank 1)
        [8058] = true, -- Frost Shock (Rank 2)
        [10472] = true, -- Frost Shock (Rank 3)
        [10473] = true, -- Frost Shock (Rank 4)
        [25464] = true, -- Frost Shock (Rank 5)
        -- Warlock
        [5782] = true, -- Fear (Rank 1)
        [6213] = true, -- Fear (Rank 2)
        [6215] = true, -- Fear (Rank 3)
        [6358] = true, -- Seduction (Succub)
        [18223] = true, -- Curse of Exhaustion
        [18093] = true, -- Pyroclasm
        [710] = true, -- Banish (Rank 1)
        [18647] = true, -- Banish (Rank 2)
        [30413] = true, -- Shadowfury
        -- Warrior
        [5246] = true, -- Intimidating Shout
        [1715] = true, -- Hamstring (Rank 1)
        [7372] = true, -- Hamstring (Rank 2)
        [7373] = true, -- Hamstring (Rank 3)
        [25212] = true, -- Hamstring (Rank 4)
        [12809] = true, -- Concussion Blow
        [20252] = true, -- Intercept (Rank 1)
        [20616] = true, -- Intercept (Rank 2)
        [20617] = true, -- Intercept (Rank 3)
        [25272] = true, -- Intercept (Rank 4)
        [25275] = true, -- Intercept (Rank 5)
        [7386] = true, -- Sunder Armor (Rank 1)
        [7405] = true, -- Sunder Armor (Rank 2)
        [8380] = true, -- Sunder Armor (Rank 3)
        [11596] = true, -- Sunder Armor (Rank 4)
        [11597] = true, -- Sunder Armor (Rank 5)
        -- Racial
        [20549] = true -- War Stomp
    }

    UF.auraFilters.TurtleBuffs = {
        -- Mage
        [11958] = true, -- Ice Block A
        [27619] = true, -- Ice Block B
        [45438] = true, -- Ice Block C
        -- Paladin
        [498] = true, -- Divine Protection (Rank 1)
        [5573] = true, -- Divine Protection (Rank 2)
        [642] = true, -- Divine Shield (Rank 1)
        [1020] = true, -- Divine Shield (Rank 2)
        [1022] = true, -- Blessing of Protection (Rank 1)
        [5599] = true, -- Blessing of Protection (Rank 2)
        [10278] = true, -- Blessing of Protection (Rank 3)
        -- Warrior
        [20230] = true, -- Retaliation
        -- Consumables
        [3169] = true, -- Limited Invulnerability Potion
        [6615] = true, -- Free Action Potion
        -- Racial
        [7744] = true, -- Will of the Forsaken
        [6346] = true, -- Fear Ward
        [20594] = true, -- Stoneform
        -- All Classes
        [19753] = true -- Divine Intervention
    }

    UF.auraFilters.PlayerBuffs = {
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
        [16864] = true, -- Omen of Clarity
        [5217] = true, -- Tiger's Fury (Rank 1)
        [6793] = true, -- Tiger's Fury (Rank 2)
        [9845] = true, -- Tiger's Fury (Rank 3)
        [9846] = true, -- Tiger's Fury (Rank 4)
        [2893] = true, -- Abolish Poison
        [5229] = true, -- Enrage
        [1850] = true, -- Dash (Rank 1)
        [9821] = true, -- Dash (Rank 2)
        [23110] = true, -- Dash (Rank 3)
        -- Hunter
        [13161] = true, -- Aspect of the Beast
        [5118] = true, -- Aspect of the Cheetah
        [13163] = true, -- Aspect of the Monkey
        [13159] = true, -- Aspect of the Pack
        [20043] = true, -- Aspect of the Wild (Rank 1)
        [20190] = true, -- Aspect of the Wild (Rank 2)
        [27045] = true, -- Aspect of the Wild (Rank 3)
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
        -- Mage
        [11958] = true, -- Ice Block A
        [27619] = true, -- Ice Block B
        [12043] = true, -- Presence of Mind
        [11129] = true, -- Combustion
        [12042] = true, -- Arcane Power
        [11426] = true, -- Ice Barrier (Rank 1)
        [13031] = true, -- Ice Barrier (Rank 2)
        [13032] = true, -- Ice Barrier (Rank 3)
        [13033] = true, -- Ice Barrier (Rank 4)
        [27134] = true, -- Ice Barrier (Rank 5)
        [33405] = true, -- Ice Barrier (Rank 6)
        -- Paladin
        [1044] = true, -- Blessing of Freedom
        [1038] = true, -- Blessing of Salvation
        [465] = true, -- Devotion Aura (Rank 1)
        [10290] = true, -- Devotion Aura (Rank 2)
        [643] = true, -- Devotion Aura (Rank 3)
        [10291] = true, -- Devotion Aura (Rank 4)
        [1032] = true, -- Devotion Aura (Rank 5)
        [10292] = true, -- Devotion Aura (Rank 6)
        [10293] = true, -- Devotion Aura (Rank 7)
        [27149] = true, -- Devotion Aura (Rank 8)
        [19746] = true, -- Concentration Aura
        [7294] = true, -- Retribution Aura (Rank 1)
        [10298] = true, -- Retribution Aura (Rank 2)
        [10299] = true, -- Retribution Aura (Rank 3)
        [10300] = true, -- Retribution Aura (Rank 4)
        [10301] = true, -- Retribution Aura (Rank 5)
        [27150] = true, -- Retribution Aura (Rank 6)
        [19876] = true, -- Shadow Resistance Aura (Rank 1)
        [19895] = true, -- Shadow Resistance Aura (Rank 2)
        [19896] = true, -- Shadow Resistance Aura (Rank 3)
        [27151] = true, -- Shadow Resistance Aura (Rank 4)
        [19888] = true, -- Frost Resistance Aura (Rank 1)
        [19897] = true, -- Frost Resistance Aura (Rank 2)
        [19898] = true, -- Frost Resistance Aura (Rank 3)
        [27152] = true, -- Frost Resistance Aura (Rank 4)
        [19891] = true, -- Fire Resistance Aura (Rank 1)
        [19899] = true, -- Fire Resistance Aura (Rank 2)
        [19900] = true, -- Fire Resistance Aura (Rank 3)
        [27153] = true, -- Fire Resistance Aura (Rank 4)
        -- Priest
        [15473] = true, -- Shadowform
        [10060] = true, -- Power Infusion
        [14751] = true, -- Inner Focus
        [1706] = true, -- Levitate
        [586] = true, -- Fade (Rank 1)
        [9578] = true, -- Fade (Rank 2)
        [9579] = true, -- Fade (Rank 3)
        [9592] = true, -- Fade (Rank 4)
        [10941] = true, -- Fade (Rank 5)
        [10942] = true, -- Fade (Rank 6)
        [25429] = true, -- Fade (Rank 7)
        -- Rogue
        [14177] = true, -- Cold Blood
        [13877] = true, -- Blade Flurry
        [13750] = true, -- Adrenaline Rush
        [2983] = true, -- Sprint (Rank 1)
        [8696] = true, -- Sprint (Rank 2)
        [11305] = true, -- Sprint (Rank 3)
        [5171] = true, -- Slice and Dice (Rank 1)
        [6774] = true, -- Slice and Dice (Rank 2)
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
        [16188] = true, -- Nature's Swiftness
        [16166] = true, -- Elemental Mastery
        [24398] = true, -- Water Shield (Rank 1)
        [33736] = true, -- Water Shield (Rank 2)
        -- Warlock
        [18788] = true, -- Demonic Sacrifice
        [5697] = true, -- Unending Breath
        [19028] = true, -- Soul Link A
        [25228] = true, -- Soul Link B
        -- Warrior
        [12975] = true, -- Last Stand
        [871] = true, -- Shield Wall
        [20230] = true, -- Retaliation
        [1719] = true, -- Recklessness
        [18499] = true, -- Berserker Rage
        [2687] = true, -- Bloodrage
        [12328] = true, -- Death Wish
        [2565] = true, -- Shield Block
        [12880] = true, -- Enrage (Rank 1)
        [14201] = true, -- Enrage (Rank 2)
        [14202] = true, -- Enrage (Rank 3)
        [14203] = true, -- Enrage (Rank 4)
        [14204] = true, -- Enrage (Rank 5)
        -- Racial
        [20554] = true, -- Berserking
        [7744] = true, -- Will of the Forsaken
        [20572] = true, -- Blood Fury
        [6346] = true, -- Fear Ward
        [20594] = true -- Stoneform
    }

    UF.auraFilters.RaidBuffs = {
        -------------------------------------------------
        -------------------- Phase 1 --------------------
        -------------------------------------------------
        -- Karazhan
        -- Attument the Huntsman
        -- Moroes
        [29448] = true, -- Vanish
        [37023] = true, -- Enrage
        -- Opera Hall Event
        [30887] = true, -- Devotion
        [30841] = true, -- Daring
        -- Maiden of Virtue
        [32429] = true, -- Draining Touch
        -- The Curator
        -- Terestian Illhoof
        [29908] = true, -- Astral Bite
        -- Shade of Aran
        [29920] = true, -- Phasing Invisibility
        [29921] = true, -- Phasing Invisibility
        -- Netherspite
        [30522] = true, -- Nether Burn
        [30487] = true, -- Nether Portal - Perseverence
        [30491] = true, -- Nether Portal - Domination
        -- Chess Event
        [37469] = true, -- Poison Cloud
        -- Prince Malchezaar
        [30859] = true, -- Hellfire
        -- Nightbane
        [37098] = true, -- Rain of Bones
        -- Gruul's Lair
        -- High King Maulgar
        [33232] = true, -- Flurry
        [33238] = true, -- Whirlwind
        [33054] = true, -- Spell Shield
        -- Gruul the Dragonkiller
        [36300] = true, -- Growth
        -- Magtheridon's Lair
        -- Magtheridon
        [30205] = true, -- Shadow Cage
        [30576] = true, -- Quake
        [30207] = true -- Shadow Grasp
        -------------------------------------------------
        -------------------- Phase 2 --------------------
        -------------------------------------------------
        -- Serpentshrine Cavern
        -- Hydross the Unstable
        -- The Lurker Below
        -- Leotheras the Blind
        -- Fathom-Lord Karathress
        -- Morogrim Tidewalker
        -- Lady Vashj
        -- The Eye
        -- Al'ar
        -- Void Reaver
        -- High Astromancer Solarian
        -- Kael'thas Sunstrider
        -------------------------------------------------
        -------------------- Phase 3 --------------------
        -------------------------------------------------
        -- The Battle for Mount Hyjal
        -- Rage Winterchill
        -- Anetheron
        -- Kaz'rogal
        -- Azgalor
        -- Archimonde
        -- Black Temple
        -- High Warlord Naj'entus
        -- Supremus
        -- Shade of Akama
        -- Teron Gorefiend
        -- Gurtogg Bloodboil
        -- Reliquary of Souls
        -- Mother Shahraz
        -- Illidari Council
        -- Illidan Stormrage
        -------------------------------------------------
        -------------------- Phase 4 --------------------
        -------------------------------------------------
        -- Zul'Aman
        -- Nalor
        -- Jan'alai
        -- Akil'zon
        -- Halazzi
        -- Hexxlord Jin'Zakk
        -- Zul'jin
        -------------------------------------------------
        -------------------- Phase 5 --------------------
        -------------------------------------------------
        -- Sunwell Plateau
        -- Kalecgos
        -- Sathrovarr
        -- Brutallus
        -- Felmyst
        -- Alythess
        -- Sacrolash
        -- M'uru
        -- Kil'Jaeden
    }

    UF.auraFilters.RaidDebuffs = {
        -------------------------------------------------
        -------------------- Phase 1 --------------------
        -------------------------------------------------
        -- Karazhan
        -- Attument the Huntsman
        [29833] = true, -- Intangible Presence
        [29711] = true, -- Knockdown
        -- Moroes
        [29425] = true, -- Gouge
        [34694] = true, -- Blind
        [37066] = true, -- Garrote
        -- Opera Hall Event
        [30822] = true, -- Poisoned Thrust
        [30889] = true, -- Powerful Attraction
        [30890] = true, -- Blinding Passion
        -- Maiden of Virtue
        [29511] = true, -- Repentance
        [29522] = true, -- Holy Fire
        [29512] = true, -- Holy Ground
        -- The Curator
        -- Terestian Illhoof
        [30053] = true, -- Amplify Flames
        [30115] = true, -- Sacrifice
        -- Shade of Aran
        [29946] = true, -- Flame Wreath
        [29947] = true, -- Flame Wreath
        [29990] = true, -- Slow
        [29991] = true, -- Chains of Ice
        [29954] = true, -- Frostbolt
        [29951] = true, -- Blizzard
        -- Netherspite
        [38637] = true, -- Nether Exhaustion (Red)
        [38638] = true, -- Nether Exhaustion (Green)
        [38639] = true, -- Nether Exhaustion (Blue)
        [30400] = true, -- Nether Beam - Perseverence
        [30401] = true, -- Nether Beam - Serenity
        [30402] = true, -- Nether Beam - Dominance
        [30421] = true, -- Nether Portal - Perseverence
        [30422] = true, -- Nether Portal - Serenity
        [30423] = true, -- Nether Portal - Dominance
        -- Chess Event
        [30529] = true, -- Recently In Game
        -- Prince Malchezaar
        [39095] = true, -- Amplify Damage
        [30898] = true, -- Shadow Word: Pain 1
        [30854] = true, -- Shadow Word: Pain 2
        -- Nightbane
        [37091] = true, -- Rain of Bones
        [30210] = true, -- Smoldering Breath
        [30129] = true, -- Charred Earth
        [30127] = true, -- Searing Cinders
        [36922] = true, -- Bellowing Roar
        -- Gruul's Lair
        -- High King Maulgar
        [36032] = true, -- Arcane Blast
        [11726] = true, -- Enslave Demon
        [33129] = true, -- Dark Decay
        [33175] = true, -- Arcane Shock
        [33061] = true, -- Blast Wave
        [33130] = true, -- Death Coil
        [16508] = true, -- Intimidating Roar
        -- Gruul the Dragonkiller
        [38927] = true, -- Fel Ache
        [36240] = true, -- Cave In
        [33652] = true, -- Stoned
        [33525] = true, -- Ground Slam
        -- Magtheridon's Lair
        -- Magtheridon
        [44032] = true, -- Mind Exhaustion
        [30530] = true, -- Fear
        -------------------------------------------------
        -------------------- Phase 2 --------------------
        -------------------------------------------------
        -- Serpentshrine Cavern
        -- Trash
        [38634] = true, -- Arcane Lightning
        [39032] = true, -- Initial Infection
        [38572] = true, -- Mortal Cleave
        [38635] = true, -- Rain of Fire
        [39042] = true, -- Rampent Infection
        [39044] = true, -- Serpentshrine Parasite
        [38591] = true, -- Shatter Armor
        [38491] = true, -- Silence
        -- Hydross the Unstable
        [38246] = true, -- Vile Sludge
        [38235] = true, -- Water Tomb
        -- Leotheras the Blind
        [37675] = true, -- Chaos Blast
        [37749] = true, -- Consuming Madness
        [37676] = true, -- Insidious Whisper
        [37641] = true, -- Whirlwind
        -- Fathom-Lord Karathress
        [39261] = true, -- Gusting Winds
        [29436] = true, -- Leeching Throw
        -- Morogrim Tidewalker
        [38049] = true, -- Watery Grave
        [37850] = true, -- Watery Grave
        -- Lady Vashj
        [38280] = true, -- Static Charge
        [38316] = true, -- Entangle
        -- The Eye
        -- Trash
        [37133] = true, -- Arcane Buffet
        [37132] = true, -- Arcane Shock
        [37122] = true, -- Domination
        [37135] = true, -- Domination
        [37120] = true, -- Fragmentation Bomb
        [13005] = true, -- Hammer of Justice
        [39077] = true, -- Hammer of Justice
        [37279] = true, -- Rain of Fire
        [37123] = true, -- Saw Blade
        [37118] = true, -- Shell Shock
        [37160] = true, -- Silence
        -- Al'ar
        [35410] = true, -- Melt Armor
        -- High Astromancer Solarian
        [34322] = true, -- Psychic Scream
        [42783] = true, -- Wrath of the Astromancer (Patch 2.2.0)
        -- Kael'thas Sunstrider
        [36965] = true, -- Rend
        [30225] = true, -- Silence
        [44863] = true, -- Bellowing Roar
        [37018] = true, -- Conflagration
        [37027] = true, -- Remote Toy
        [36991] = true, -- Rend
        [36797] = true, -- Mind Control
        -------------------------------------------------
        -------------------- Phase 3 --------------------
        -------------------------------------------------
        -- The Battle for Mount Hyjal
        -- Rage Winterchill
        [31249] = true, -- Icebolt
        [31250] = true, -- Frost Nova
        -- Anetheron
        [31302] = true, -- Inferno
        [31298] = true, -- Sleep
        [31306] = true, -- Carrion Swarm
        -- Kaz'rogal
        [31447] = true, -- Mark of Kaz'rogal
        -- Azgalor
        [31341] = true, -- Unquenchable Flames
        [31340] = true, -- Rain of Fire
        [31347] = true, -- Doom
        -- Archimonde
        [31972] = true, -- Grip of the Legion
        [31970] = true, -- Fear
        [31944] = true, -- Doomfire
        -- Trash
        [31610] = true, -- Knockdown
        [28991] = true, -- Web
        -- Black Temple
        -- High Warlord Naj'entus
        [39837] = true, -- Impaling Spine
        -- Supremus
        [40253] = true, -- Molten Flame
        -- Shade of Akama
        [42023] = true, -- Rain of Fire
        -- Teron Gorefiend
        [40243] = true, -- Crushing Shadows
        [40239] = true, -- Incinerate
        [40251] = true, -- Shadow of Death
        -- Gurtogg Bloodboil
        [40481] = true, -- Acidic Wound
        [40599] = true, -- Arcing Smash
        [40491] = true, -- Bewildering Strike
        [42005] = true, -- Bloodboil
        [40508] = true, -- Fel Acid Breath
        [40604] = true, -- Fel Rage
        -- Reliquary of Souls
        [41303] = true, -- Soul Drain
        [41410] = true, -- Deaden
        [41426] = true, -- Spirit Shack
        [41294] = true, -- Fixate
        [41376] = true, -- Spite
        -- Mother Shahraz
        [41001] = true, -- Fatal Attraction
        [40860] = true, -- Vile Beam
        [40823] = true, -- Interrupting Shriek
        -- Illidari Council
        [41541] = true, -- Consecration
        [41468] = true, -- Hammer of Justice
        [41461] = true, -- Judgement of Blood
        [41485] = true, -- Deadly Poison
        [41472] = true, -- Divine Wrath
        [41482] = true, -- Blizzard
        [41481] = true, -- Flamestrike
        -- Illidan Stormrage
        [40932] = true, -- Agonizing Flame
        [41032] = true, -- Shear
        [40585] = true, -- Dark Barrage
        [41914] = true, -- Parasitic Shadowfiend
        [41142] = true, -- Aura of Dread
        -- Trash
        [41213] = true, -- Throw Shield
        [40864] = true, -- Throbbing Stun
        [41197] = true, -- Shield Bash
        [41171] = true, -- Skeleton Shot
        [41338] = true, -- Love Tap
        [13444] = true, -- Sunder Armor
        [41396] = true, -- Sleep
        [41334] = true, -- Polymorph
        [24698] = true, -- Gauge
        [41150] = true, -- Fear
        [34654] = true, -- Blind
        [39674] = true -- Banish
        -------------------------------------------------
        -------------------- Phase 4 --------------------
        -------------------------------------------------
        -- Zul'Aman
        -- Nalorakk
        -- Jan'alai
        -- Akil'zon
        -- Halazzi
        -- Hexxlord Jin'Zakk
        -- Zul'jin
        -------------------------------------------------
        -------------------- Phase 5 --------------------
        -------------------------------------------------
        -- Sunwell Plateau
        -- Kalecgos
        -- Sathrovarr
        -- Brutallus
        -- Felmyst
        -- Alythess
        -- Sacrolash
        -- M'uru
        -- Kil'Jaeden
    }

    UF.auraFilters.Blacklist = {
        -- General
        [186403] = true -- Sign of Battle
    }

    UF.auraFilters.Whitelist = {}
end
