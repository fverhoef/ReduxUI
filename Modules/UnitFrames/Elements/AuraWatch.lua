local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateAuraWatch()
    if not self.config.auraWatch.enabled then return end

    self.AuraWatch = CreateFrame("Frame", "$parentAuraWatch", self)
    self.AuraWatch:SetParent(self.Overlay)
    self.AuraWatch.presentAlpha = 1
    self.AuraWatch.missingAlpha = 0
    self.AuraWatch.strictMatching = true  
    self.AuraWatch.showBuffType = true
    self.AuraWatch.showDebuffType = true
    self.AuraWatch.PostCreateIcon = UF.AuraWatch_PostCreateIcon
    self.AuraWatch.PostUpdateIcon = UF.AuraWatch_PostUpdateIcon
    self.AuraWatch:SetInside(self.Health)

    return self.AuraWatch
end

oUF:RegisterMetaFunction("CreateAuraWatch", UF.CreateAuraWatch)

function UF:ConfigureAuraWatch()
    local config = self.config.auraWatch
    if not config.enabled then
        self:DisableElement("AuraWatch")
        return
    elseif not self.AuraWatch then
        self:CreateAuraHighlight()
    end

    self.AuraWatch.size = config.iconSize
    self.AuraWatch.countFontSize = config.countFontSize

    if self.unit == "pet" or isPet then
        self.AuraWatch:SetNewTable(UF.aurawatch.PET)
    else
        self.AuraWatch:SetNewTable(UF.aurawatch[R.PlayerInfo.class])
    end

    self:EnableElement("AuraWatch")
end

oUF:RegisterMetaFunction("ConfigureAuraWatch", UF.ConfigureAuraWatch)

function UF:AuraWatch_PostCreateIcon(button) end

function UF:AuraWatch_PostUpdateIcon(_, button)
    local settings = self.watched[button.spellID]
    if not settings then return end

    local onlyText = settings.style == "timerOnly"
    local colorIcon = settings.style == "coloredIcon"
    local textureIcon = settings.style == "texturedIcon"

    if (colorIcon or textureIcon) and not button.icon:IsShown() then
        button.icon:Show()
        button.cd:SetDrawSwipe(true)
    elseif onlyText and button.icon:IsShown() then
        button.icon:Hide()
        button.cd:SetDrawSwipe(false)
    end

    if colorIcon then
        button.icon:SetTexture(R.media.textures.blank)
        button.icon:SetVertexColor(settings.color.r, settings.color.g, settings.color.b, settings.color.a)
    elseif textureIcon then
        button.icon:SetVertexColor(1, 1, 1)
    end

    button.cd:SetHideCountdownNumbers(not onlyText and not settings.displayText)
    button.count:SetFont(STANDARD_TEXT_FONT, self.countFontSize or 12, "OUTLINE")
end

function UF:AuraWatch_AddSpell(id, point, color, anyUnit)
    local r, g, b = 1, 1, 1
    if color then r, g, b = unpack(color) end

    return {
        id = id,
        enabled = true,
        point = point or "TOPLEFT",
        color = {r = r, g = g, b = b},
        style = "texturedIcon",
        anyUnit = anyUnit or false,
        onlyShowMissing = false,
        displayText = false,
        textThreshold = -1,
        xOffset = 0,
        yOffset = 0,
        sizeOffset = 0
    }
end

if R.isRetail then
    UF.aurawatch = {}
else
    UF.aurawatch = {
        GLOBAL = {},
        ROGUE = {}, -- No buffs
        WARRIOR = {
            [6673] = UF:AuraWatch_AddSpell(6673, "TOPLEFT", {0.2, 0.2, 1}, true), -- Battle Shout (Rank 1)
            [5242] = UF:AuraWatch_AddSpell(5242, "TOPLEFT", {0.2, 0.2, 1}, true), -- Battle Shout (Rank 2)
            [6192] = UF:AuraWatch_AddSpell(6192, "TOPLEFT", {0.2, 0.2, 1}, true), -- Battle Shout (Rank 3)
            [11549] = UF:AuraWatch_AddSpell(11549, "TOPLEFT", {0.2, 0.2, 1}, true), -- Battle Shout (Rank 4)
            [11550] = UF:AuraWatch_AddSpell(11550, "TOPLEFT", {0.2, 0.2, 1}, true), -- Battle Shout (Rank 5)
            [11551] = UF:AuraWatch_AddSpell(11551, "TOPLEFT", {0.2, 0.2, 1}, true), -- Battle Shout (Rank 6)
            [25289] = UF:AuraWatch_AddSpell(25289, "TOPLEFT", {0.2, 0.2, 1}, true), -- Battle Shout (Rank 7)
            [2048] = UF:AuraWatch_AddSpell(2048, "TOPLEFT", {0.2, 0.2, 1}, true), -- Battle Shout (Rank 8)
            [469] = UF:AuraWatch_AddSpell(469, "TOPRIGHT", {0.4, 0.2, 0.8}, true) -- Commanding Shout
        },
        PRIEST = {
            [1243] = UF:AuraWatch_AddSpell(1243, "TOPLEFT", {1, 1, 0.66}, true), -- Power Word: Fortitude (Rank 1)
            [1244] = UF:AuraWatch_AddSpell(1244, "TOPLEFT", {1, 1, 0.66}, true), -- Power Word: Fortitude (Rank 2)
            [1245] = UF:AuraWatch_AddSpell(1245, "TOPLEFT", {1, 1, 0.66}, true), -- Power Word: Fortitude (Rank 3)
            [2791] = UF:AuraWatch_AddSpell(2791, "TOPLEFT", {1, 1, 0.66}, true), -- Power Word: Fortitude (Rank 4)
            [10937] = UF:AuraWatch_AddSpell(10937, "TOPLEFT", {1, 1, 0.66}, true), -- Power Word: Fortitude (Rank 5)
            [10938] = UF:AuraWatch_AddSpell(10938, "TOPLEFT", {1, 1, 0.66}, true), -- Power Word: Fortitude (Rank 6)
            [25389] = UF:AuraWatch_AddSpell(25389, "TOPLEFT", {1, 1, 0.66}, true), -- Power Word: Fortitude (Rank 7)
            [21562] = UF:AuraWatch_AddSpell(21562, "TOPLEFT", {1, 1, 0.66}, true), -- Prayer of Fortitude (Rank 1)
            [21564] = UF:AuraWatch_AddSpell(21564, "TOPLEFT", {1, 1, 0.66}, true), -- Prayer of Fortitude (Rank 2)
            [25392] = UF:AuraWatch_AddSpell(25392, "TOPLEFT", {1, 1, 0.66}, true), -- Prayer of Fortitude (Rank 3)
            [14752] = UF:AuraWatch_AddSpell(14752, "TOPRIGHT", {0.2, 0.7, 0.2}, true), -- Divine Spirit (Rank 1)
            [14818] = UF:AuraWatch_AddSpell(14818, "TOPRIGHT", {0.2, 0.7, 0.2}, true), -- Divine Spirit (Rank 2)
            [14819] = UF:AuraWatch_AddSpell(14819, "TOPRIGHT", {0.2, 0.7, 0.2}, true), -- Divine Spirit (Rank 3)
            [27841] = UF:AuraWatch_AddSpell(27841, "TOPRIGHT", {0.2, 0.7, 0.2}, true), -- Divine Spirit (Rank 4)
            [25312] = UF:AuraWatch_AddSpell(25312, "TOPRIGHT", {0.2, 0.7, 0.2}, true), -- Divine Spirit (Rank 5)
            [27681] = UF:AuraWatch_AddSpell(27681, "TOPRIGHT", {0.2, 0.7, 0.2}, true), -- Prayer of Spirit (Rank 1)
            [32999] = UF:AuraWatch_AddSpell(32999, "TOPRIGHT", {0.2, 0.7, 0.2}, true), -- Prayer of Spirit (Rank 2)
            [976] = UF:AuraWatch_AddSpell(976, "BOTTOMLEFT", {0.7, 0.7, 0.7}, true), -- Shadow Protection (Rank 1)
            [10957] = UF:AuraWatch_AddSpell(10957, "BOTTOMLEFT", {0.7, 0.7, 0.7}, true), -- Shadow Protection (Rank 2)
            [10958] = UF:AuraWatch_AddSpell(10958, "BOTTOMLEFT", {0.7, 0.7, 0.7}, true), -- Shadow Protection (Rank 3)
            [25433] = UF:AuraWatch_AddSpell(25433, "BOTTOMLEFT", {0.7, 0.7, 0.7}, true), -- Shadow Protection (Rank 4)
            [27683] = UF:AuraWatch_AddSpell(27683, "BOTTOMLEFT", {0.7, 0.7, 0.7}, true), -- Prayer of Shadow Protection (Rank 1)
            [39374] = UF:AuraWatch_AddSpell(39374, "BOTTOMLEFT", {0.7, 0.7, 0.7}, true), -- Prayer of Shadow Protection (Rank 2)
            [17] = UF:AuraWatch_AddSpell(17, "BOTTOM", {0.00, 0.00, 1.00}), -- Power Word: Shield (Rank 1)
            [592] = UF:AuraWatch_AddSpell(592, "BOTTOM", {0.00, 0.00, 1.00}), -- Power Word: Shield (Rank 2)
            [600] = UF:AuraWatch_AddSpell(600, "BOTTOM", {0.00, 0.00, 1.00}), -- Power Word: Shield (Rank 3)
            [3747] = UF:AuraWatch_AddSpell(3747, "BOTTOM", {0.00, 0.00, 1.00}), -- Power Word: Shield (Rank 4)
            [6065] = UF:AuraWatch_AddSpell(6065, "BOTTOM", {0.00, 0.00, 1.00}), -- Power Word: Shield (Rank 5)
            [6066] = UF:AuraWatch_AddSpell(6066, "BOTTOM", {0.00, 0.00, 1.00}), -- Power Word: Shield (Rank 6)
            [10898] = UF:AuraWatch_AddSpell(10898, "BOTTOM", {0.00, 0.00, 1.00}), -- Power Word: Shield (Rank 7)
            [10899] = UF:AuraWatch_AddSpell(10899, "BOTTOM", {0.00, 0.00, 1.00}), -- Power Word: Shield (Rank 8)
            [10900] = UF:AuraWatch_AddSpell(10900, "BOTTOM", {0.00, 0.00, 1.00}), -- Power Word: Shield (Rank 9)
            [10901] = UF:AuraWatch_AddSpell(10901, "BOTTOM", {0.00, 0.00, 1.00}), -- Power Word: Shield (Rank 10)
            [25217] = UF:AuraWatch_AddSpell(25217, "BOTTOM", {0.00, 0.00, 1.00}), -- Power Word: Shield (Rank 11)
            [25218] = UF:AuraWatch_AddSpell(25218, "BOTTOM", {0.00, 0.00, 1.00}), -- Power Word: Shield (Rank 12)
            [139] = UF:AuraWatch_AddSpell(139, "BOTTOMRIGHT", {0.33, 0.73, 0.75}), -- Renew (Rank 1)
            [6074] = UF:AuraWatch_AddSpell(6074, "BOTTOMRIGHT", {0.33, 0.73, 0.75}), -- Renew (Rank 2)
            [6075] = UF:AuraWatch_AddSpell(6075, "BOTTOMRIGHT", {0.33, 0.73, 0.75}), -- Renew (Rank 3)
            [6076] = UF:AuraWatch_AddSpell(6076, "BOTTOMRIGHT", {0.33, 0.73, 0.75}), -- Renew (Rank 4)
            [6077] = UF:AuraWatch_AddSpell(6077, "BOTTOMRIGHT", {0.33, 0.73, 0.75}), -- Renew (Rank 5)
            [6078] = UF:AuraWatch_AddSpell(6078, "BOTTOMRIGHT", {0.33, 0.73, 0.75}), -- Renew (Rank 6)
            [10927] = UF:AuraWatch_AddSpell(10927, "BOTTOMRIGHT", {0.33, 0.73, 0.75}), -- Renew (Rank 7)
            [10928] = UF:AuraWatch_AddSpell(10928, "BOTTOMRIGHT", {0.33, 0.73, 0.75}), -- Renew (Rank 8)
            [10929] = UF:AuraWatch_AddSpell(10929, "BOTTOMRIGHT", {0.33, 0.73, 0.75}), -- Renew (Rank 9)
            [25315] = UF:AuraWatch_AddSpell(25315, "BOTTOMRIGHT", {0.33, 0.73, 0.75}), -- Renew (Rank 10)
            [25221] = UF:AuraWatch_AddSpell(25221, "BOTTOMRIGHT", {0.33, 0.73, 0.75}), -- Renew (Rank 11)
            [25222] = UF:AuraWatch_AddSpell(25222, "BOTTOMRIGHT", {0.33, 0.73, 0.75}) -- Renew (Rank 12)
        },
        DRUID = {
            [1126] = UF:AuraWatch_AddSpell(1126, "TOPLEFT", {0.2, 0.8, 0.8}, true), -- Mark of the Wild (Rank 1)
            [5232] = UF:AuraWatch_AddSpell(5232, "TOPLEFT", {0.2, 0.8, 0.8}, true), -- Mark of the Wild (Rank 2)
            [6756] = UF:AuraWatch_AddSpell(6756, "TOPLEFT", {0.2, 0.8, 0.8}, true), -- Mark of the Wild (Rank 3)
            [5234] = UF:AuraWatch_AddSpell(5234, "TOPLEFT", {0.2, 0.8, 0.8}, true), -- Mark of the Wild (Rank 4)
            [8907] = UF:AuraWatch_AddSpell(8907, "TOPLEFT", {0.2, 0.8, 0.8}, true), -- Mark of the Wild (Rank 5)
            [9884] = UF:AuraWatch_AddSpell(9884, "TOPLEFT", {0.2, 0.8, 0.8}, true), -- Mark of the Wild (Rank 6)
            [9885] = UF:AuraWatch_AddSpell(9885, "TOPLEFT", {0.2, 0.8, 0.8}, true), -- Mark of the Wild (Rank 7)
            [26990] = UF:AuraWatch_AddSpell(26990, "TOPLEFT", {0.2, 0.8, 0.8}, true), -- Mark of the Wild (Rank 8)
            [21849] = UF:AuraWatch_AddSpell(21849, "TOPLEFT", {0.2, 0.8, 0.8}, true), -- Gift of the Wild (Rank 1)
            [21850] = UF:AuraWatch_AddSpell(21850, "TOPLEFT", {0.2, 0.8, 0.8}, true), -- Gift of the Wild (Rank 2)
            [26991] = UF:AuraWatch_AddSpell(26991, "TOPLEFT", {0.2, 0.8, 0.8}, true), -- Gift of the Wild (Rank 3)
            [467] = UF:AuraWatch_AddSpell(467, "TOPRIGHT", {0.4, 0.2, 0.8}, true), -- Thorns (Rank 1)
            [782] = UF:AuraWatch_AddSpell(782, "TOPRIGHT", {0.4, 0.2, 0.8}, true), -- Thorns (Rank 2)
            [1075] = UF:AuraWatch_AddSpell(1075, "TOPRIGHT", {0.4, 0.2, 0.8}, true), -- Thorns (Rank 3)
            [8914] = UF:AuraWatch_AddSpell(8914, "TOPRIGHT", {0.4, 0.2, 0.8}, true), -- Thorns (Rank 4)
            [9756] = UF:AuraWatch_AddSpell(9756, "TOPRIGHT", {0.4, 0.2, 0.8}, true), -- Thorns (Rank 5)
            [9910] = UF:AuraWatch_AddSpell(9910, "TOPRIGHT", {0.4, 0.2, 0.8}, true), -- Thorns (Rank 6)
            [26992] = UF:AuraWatch_AddSpell(26992, "TOPRIGHT", {0.4, 0.2, 0.8}, true), -- Thorns (Rank 7)
            [774] = UF:AuraWatch_AddSpell(774, "BOTTOMLEFT", {0.83, 1.00, 0.25}), -- Rejuvenation (Rank 1)
            [1058] = UF:AuraWatch_AddSpell(1058, "BOTTOMLEFT", {0.83, 1.00, 0.25}), -- Rejuvenation (Rank 2)
            [1430] = UF:AuraWatch_AddSpell(1430, "BOTTOMLEFT", {0.83, 1.00, 0.25}), -- Rejuvenation (Rank 3)
            [2090] = UF:AuraWatch_AddSpell(2090, "BOTTOMLEFT", {0.83, 1.00, 0.25}), -- Rejuvenation (Rank 4)
            [2091] = UF:AuraWatch_AddSpell(2091, "BOTTOMLEFT", {0.83, 1.00, 0.25}), -- Rejuvenation (Rank 5)
            [3627] = UF:AuraWatch_AddSpell(3627, "BOTTOMLEFT", {0.83, 1.00, 0.25}), -- Rejuvenation (Rank 6)
            [8910] = UF:AuraWatch_AddSpell(8910, "BOTTOMLEFT", {0.83, 1.00, 0.25}), -- Rejuvenation (Rank 7)
            [9839] = UF:AuraWatch_AddSpell(9839, "BOTTOMLEFT", {0.83, 1.00, 0.25}), -- Rejuvenation (Rank 8)
            [9840] = UF:AuraWatch_AddSpell(9840, "BOTTOMLEFT", {0.83, 1.00, 0.25}), -- Rejuvenation (Rank 9)
            [9841] = UF:AuraWatch_AddSpell(9841, "BOTTOMLEFT", {0.83, 1.00, 0.25}), -- Rejuvenation (Rank 10)
            [25299] = UF:AuraWatch_AddSpell(25299, "BOTTOMLEFT", {0.83, 1.00, 0.25}), -- Rejuvenation (Rank 11)
            [26981] = UF:AuraWatch_AddSpell(26981, "BOTTOMLEFT", {0.83, 1.00, 0.25}), -- Rejuvenation (Rank 12)
            [26982] = UF:AuraWatch_AddSpell(26982, "BOTTOMLEFT", {0.83, 1.00, 0.25}), -- Rejuvenation (Rank 13)
            [8936] = UF:AuraWatch_AddSpell(8936, "BOTTOMRIGHT", {0.33, 0.73, 0.75}), -- Regrowth (Rank 1)
            [8938] = UF:AuraWatch_AddSpell(8938, "BOTTOMRIGHT", {0.33, 0.73, 0.75}), -- Regrowth (Rank 2)
            [8939] = UF:AuraWatch_AddSpell(8939, "BOTTOMRIGHT", {0.33, 0.73, 0.75}), -- Regrowth (Rank 3)
            [8940] = UF:AuraWatch_AddSpell(8940, "BOTTOMRIGHT", {0.33, 0.73, 0.75}), -- Regrowth (Rank 4)
            [8941] = UF:AuraWatch_AddSpell(8941, "BOTTOMRIGHT", {0.33, 0.73, 0.75}), -- Regrowth (Rank 5)
            [9750] = UF:AuraWatch_AddSpell(9750, "BOTTOMRIGHT", {0.33, 0.73, 0.75}), -- Regrowth (Rank 6)
            [9856] = UF:AuraWatch_AddSpell(9856, "BOTTOMRIGHT", {0.33, 0.73, 0.75}), -- Regrowth (Rank 7)
            [9857] = UF:AuraWatch_AddSpell(9857, "BOTTOMRIGHT", {0.33, 0.73, 0.75}), -- Regrowth (Rank 8)
            [9858] = UF:AuraWatch_AddSpell(9858, "BOTTOMRIGHT", {0.33, 0.73, 0.75}), -- Regrowth (Rank 9)
            [26980] = UF:AuraWatch_AddSpell(26980, "BOTTOMRIGHT", {0.33, 0.73, 0.75}), -- Regrowth (Rank 10)
            [29166] = UF:AuraWatch_AddSpell(29166, "CENTER", {0.49, 0.60, 0.55}, true), -- Innervate
            [33763] = UF:AuraWatch_AddSpell(33763, "BOTTOM", {0.33, 0.37, 0.47}) -- Lifebloom
        },
        PALADIN = {
            [1044] = UF:AuraWatch_AddSpell(1044, "CENTER", {0.89, 0.45, 0}), -- Blessing of Freedom
            [1038] = UF:AuraWatch_AddSpell(1038, "TOPLEFT", {0.11, 1.00, 0.45}, true), -- Blessing of Salvation
            [6940] = UF:AuraWatch_AddSpell(6940, "CENTER", {0.89, 0.1, 0.1}), -- Blessing Sacrifice (Rank 1)
            [20729] = UF:AuraWatch_AddSpell(20729, "CENTER", {0.89, 0.1, 0.1}), -- Blessing Sacrifice (Rank 2)
            [27147] = UF:AuraWatch_AddSpell(27147, "CENTER", {0.89, 0.1, 0.1}), -- Blessing Sacrifice (Rank 3)
            [27148] = UF:AuraWatch_AddSpell(27148, "CENTER", {0.89, 0.1, 0.1}), -- Blessing Sacrifice (Rank 4)
            [19740] = UF:AuraWatch_AddSpell(19740, "TOPLEFT", {0.2, 0.8, 0.2}, true), -- Blessing of Might (Rank 1)
            [19834] = UF:AuraWatch_AddSpell(19834, "TOPLEFT", {0.2, 0.8, 0.2}, true), -- Blessing of Might (Rank 2)
            [19835] = UF:AuraWatch_AddSpell(19835, "TOPLEFT", {0.2, 0.8, 0.2}, true), -- Blessing of Might (Rank 3)
            [19836] = UF:AuraWatch_AddSpell(19836, "TOPLEFT", {0.2, 0.8, 0.2}, true), -- Blessing of Might (Rank 4)
            [19837] = UF:AuraWatch_AddSpell(19837, "TOPLEFT", {0.2, 0.8, 0.2}, true), -- Blessing of Might (Rank 5)
            [19838] = UF:AuraWatch_AddSpell(19838, "TOPLEFT", {0.2, 0.8, 0.2}, true), -- Blessing of Might (Rank 6)
            [25291] = UF:AuraWatch_AddSpell(25291, "TOPLEFT", {0.2, 0.8, 0.2}, true), -- Blessing of Might (Rank 7)
            [27140] = UF:AuraWatch_AddSpell(27140, "TOPLEFT", {0.2, 0.8, 0.2}, true), -- Blessing of Might (Rank 8)
            [19742] = UF:AuraWatch_AddSpell(19742, "TOPLEFT", {0.2, 0.8, 0.2}, true), -- Blessing of Wisdom (Rank 1)
            [19850] = UF:AuraWatch_AddSpell(19850, "TOPLEFT", {0.2, 0.8, 0.2}, true), -- Blessing of Wisdom (Rank 2)
            [19852] = UF:AuraWatch_AddSpell(19852, "TOPLEFT", {0.2, 0.8, 0.2}, true), -- Blessing of Wisdom (Rank 3)
            [19853] = UF:AuraWatch_AddSpell(19853, "TOPLEFT", {0.2, 0.8, 0.2}, true), -- Blessing of Wisdom (Rank 4)
            [19854] = UF:AuraWatch_AddSpell(19854, "TOPLEFT", {0.2, 0.8, 0.2}, true), -- Blessing of Wisdom (Rank 5)
            [25290] = UF:AuraWatch_AddSpell(25290, "TOPLEFT", {0.2, 0.8, 0.2}, true), -- Blessing of Wisdom (Rank 6)
            [27142] = UF:AuraWatch_AddSpell(27142, "TOPLEFT", {0.2, 0.8, 0.2}, true), -- Blessing of Wisdom (Rank 7)
            [25782] = UF:AuraWatch_AddSpell(25782, "TOPLEFT", {0.2, 0.8, 0.2}, true), -- Greater Blessing of Might (Rank 1)
            [25916] = UF:AuraWatch_AddSpell(25916, "TOPLEFT", {0.2, 0.8, 0.2}, true), -- Greater Blessing of Might (Rank 2)
            [27141] = UF:AuraWatch_AddSpell(27141, "TOPLEFT", {0.2, 0.8, 0.2}, true), -- Greater Blessing of Might (Rank 3)
            [25894] = UF:AuraWatch_AddSpell(25894, "TOPLEFT", {0.2, 0.8, 0.2}, true), -- Greater Blessing of Wisdom (Rank 1)
            [25918] = UF:AuraWatch_AddSpell(25918, "TOPLEFT", {0.2, 0.8, 0.2}, true), -- Greater Blessing of Wisdom (Rank 2)
            [27143] = UF:AuraWatch_AddSpell(27143, "TOPLEFT", {0.2, 0.8, 0.2}, true), -- Greater Blessing of Wisdom (Rank 3)
            [465] = UF:AuraWatch_AddSpell(465, "BOTTOMLEFT", {0.58, 1.00, 0.50}), -- Devotion Aura (Rank 1)
            [10290] = UF:AuraWatch_AddSpell(10290, "BOTTOMLEFT", {0.58, 1.00, 0.50}), -- Devotion Aura (Rank 2)
            [643] = UF:AuraWatch_AddSpell(643, "BOTTOMLEFT", {0.58, 1.00, 0.50}), -- Devotion Aura (Rank 3)
            [10291] = UF:AuraWatch_AddSpell(10291, "BOTTOMLEFT", {0.58, 1.00, 0.50}), -- Devotion Aura (Rank 4)
            [1032] = UF:AuraWatch_AddSpell(1032, "BOTTOMLEFT", {0.58, 1.00, 0.50}), -- Devotion Aura (Rank 5)
            [10292] = UF:AuraWatch_AddSpell(10292, "BOTTOMLEFT", {0.58, 1.00, 0.50}), -- Devotion Aura (Rank 6)
            [10293] = UF:AuraWatch_AddSpell(10293, "BOTTOMLEFT", {0.58, 1.00, 0.50}), -- Devotion Aura (Rank 7)
            [27149] = UF:AuraWatch_AddSpell(27149, "BOTTOMLEFT", {0.58, 1.00, 0.50}), -- Devotion Aura (Rank 8)
            [19977] = UF:AuraWatch_AddSpell(19977, "BOTTOMRIGHT", {0.17, 1.00, 0.75}, true), -- Blessing of Light (Rank 1)
            [19978] = UF:AuraWatch_AddSpell(19978, "BOTTOMRIGHT", {0.17, 1.00, 0.75}, true), -- Blessing of Light (Rank 2)
            [19979] = UF:AuraWatch_AddSpell(19979, "BOTTOMRIGHT", {0.17, 1.00, 0.75}, true), -- Blessing of Light (Rank 3)
            [27144] = UF:AuraWatch_AddSpell(27144, "BOTTOMRIGHT", {0.17, 1.00, 0.75}, true), -- Blessing of Light (Rank 4)
            [1022] = UF:AuraWatch_AddSpell(1022, "TOPRIGHT", {0.17, 1.00, 0.75}, true), -- Blessing of Protection (Rank 1)
            [5599] = UF:AuraWatch_AddSpell(5599, "TOPRIGHT", {0.17, 1.00, 0.75}, true), -- Blessing of Protection (Rank 2)
            [10278] = UF:AuraWatch_AddSpell(10278, "TOPRIGHT", {0.17, 1.00, 0.75}, true), -- Blessing of Protection (Rank 3)
            [19746] = UF:AuraWatch_AddSpell(19746, "BOTTOMLEFT", {0.83, 1.00, 0.07}), -- Concentration Aura
            [32223] = UF:AuraWatch_AddSpell(32223, "BOTTOMLEFT", {0.83, 1.00, 0.07}) -- Crusader Aura
        },
        SHAMAN = {
            [29203] = UF:AuraWatch_AddSpell(29203, "TOPRIGHT", {0.7, 0.3, 0.7}), -- Healing Way
            [16237] = UF:AuraWatch_AddSpell(16237, "RIGHT", {0.2, 0.2, 1}), -- Ancestral Fortitude
            [8185] = UF:AuraWatch_AddSpell(8185, "TOPLEFT", {0.05, 1.00, 0.50}), -- Fire Resistance Totem (Rank 1)
            [10534] = UF:AuraWatch_AddSpell(10534, "TOPLEFT", {0.05, 1.00, 0.50}), -- Fire Resistance Totem (Rank 2)
            [10535] = UF:AuraWatch_AddSpell(10535, "TOPLEFT", {0.05, 1.00, 0.50}), -- Fire Resistance Totem (Rank 3)
            [25563] = UF:AuraWatch_AddSpell(25563, "TOPLEFT", {0.05, 1.00, 0.50}), -- Fire Resistance Totem (Rank 4)
            [8182] = UF:AuraWatch_AddSpell(8182, "TOPLEFT", {0.54, 0.53, 0.79}), -- Frost Resistance Totem (Rank 1)
            [10476] = UF:AuraWatch_AddSpell(10476, "TOPLEFT", {0.54, 0.53, 0.79}), -- Frost Resistance Totem (Rank 2)
            [10477] = UF:AuraWatch_AddSpell(10477, "TOPLEFT", {0.54, 0.53, 0.79}), -- Frost Resistance Totem (Rank 3)
            [25560] = UF:AuraWatch_AddSpell(25560, "TOPLEFT", {0.54, 0.53, 0.79}), -- Frost Resistance Totem (Rank 4)
            [10596] = UF:AuraWatch_AddSpell(10596, "TOPLEFT", {0.33, 1.00, 0.20}), -- Nature Resistance Totem (Rank 1)
            [10598] = UF:AuraWatch_AddSpell(10598, "TOPLEFT", {0.33, 1.00, 0.20}), -- Nature Resistance Totem (Rank 2)
            [10599] = UF:AuraWatch_AddSpell(10599, "TOPLEFT", {0.33, 1.00, 0.20}), -- Nature Resistance Totem (Rank 3)
            [25574] = UF:AuraWatch_AddSpell(25574, "TOPLEFT", {0.33, 1.00, 0.20}), -- Nature Resistance Totem (Rank 4)
            [5672] = UF:AuraWatch_AddSpell(5672, "BOTTOM", {0.67, 1.00, 0.50}), -- Healing Stream Totem (Rank 1)
            [6371] = UF:AuraWatch_AddSpell(6371, "BOTTOM", {0.67, 1.00, 0.50}), -- Healing Stream Totem (Rank 2)
            [6372] = UF:AuraWatch_AddSpell(6372, "BOTTOM", {0.67, 1.00, 0.50}), -- Healing Stream Totem (Rank 3)
            [10460] = UF:AuraWatch_AddSpell(10460, "BOTTOM", {0.67, 1.00, 0.50}), -- Healing Stream Totem (Rank 4)
            [10461] = UF:AuraWatch_AddSpell(10461, "BOTTOM", {0.67, 1.00, 0.50}), -- Healing Stream Totem (Rank 5)
            [25567] = UF:AuraWatch_AddSpell(25567, "BOTTOM", {0.67, 1.00, 0.50}), -- Healing Stream Totem (Rank 6)
            [16191] = UF:AuraWatch_AddSpell(16191, "BOTTOMLEFT", {0.67, 1.00, 0.80}), -- Mana Tide Totem (Rank 1)
            [17355] = UF:AuraWatch_AddSpell(17355, "BOTTOMLEFT", {0.67, 1.00, 0.80}), -- Mana Tide Totem (Rank 2)
            [17360] = UF:AuraWatch_AddSpell(17360, "BOTTOMLEFT", {0.67, 1.00, 0.80}), -- Mana Tide Totem (Rank 3)
            [5677] = UF:AuraWatch_AddSpell(5677, "LEFT", {0.67, 1.00, 0.80}), -- Mana Spring Totem (Rank 1)
            [10491] = UF:AuraWatch_AddSpell(10491, "LEFT", {0.67, 1.00, 0.80}), -- Mana Spring Totem (Rank 2)
            [10493] = UF:AuraWatch_AddSpell(10493, "LEFT", {0.67, 1.00, 0.80}), -- Mana Spring Totem (Rank 3)
            [10494] = UF:AuraWatch_AddSpell(10494, "LEFT", {0.67, 1.00, 0.80}), -- Mana Spring Totem (Rank 4)
            [25570] = UF:AuraWatch_AddSpell(25570, "LEFT", {0.67, 1.00, 0.80}), -- Mana Spring Totem (Rank 5)
            [8072] = UF:AuraWatch_AddSpell(8072, "BOTTOMRIGHT", {0.00, 0.00, 0.26}), -- Stoneskin Totem (Rank 1)
            [8156] = UF:AuraWatch_AddSpell(8156, "BOTTOMRIGHT", {0.00, 0.00, 0.26}), -- Stoneskin Totem (Rank 2)
            [8157] = UF:AuraWatch_AddSpell(8157, "BOTTOMRIGHT", {0.00, 0.00, 0.26}), -- Stoneskin Totem (Rank 3)
            [10403] = UF:AuraWatch_AddSpell(10403, "BOTTOMRIGHT", {0.00, 0.00, 0.26}), -- Stoneskin Totem (Rank 4)
            [10404] = UF:AuraWatch_AddSpell(10404, "BOTTOMRIGHT", {0.00, 0.00, 0.26}), -- Stoneskin Totem (Rank 5)
            [10405] = UF:AuraWatch_AddSpell(10405, "BOTTOMRIGHT", {0.00, 0.00, 0.26}), -- Stoneskin Totem (Rank 6)
            [25508] = UF:AuraWatch_AddSpell(25508, "BOTTOMRIGHT", {0.00, 0.00, 0.26}), -- Stoneskin Totem (Rank 7)
            [25509] = UF:AuraWatch_AddSpell(25509, "BOTTOMRIGHT", {0.00, 0.00, 0.26}), -- Stoneskin Totem (Rank 8)
            [974] = UF:AuraWatch_AddSpell(974, "TOP", {0.08, 0.21, 0.43}, true), -- Earth Shield (Rank 1)
            [32593] = UF:AuraWatch_AddSpell(32593, "TOP", {0.08, 0.21, 0.43}, true), -- Earth Shield (Rank 2)
            [32594] = UF:AuraWatch_AddSpell(32594, "TOP", {0.08, 0.21, 0.43}, true) -- Earth Shield (Rank 3)
        },
        MAGE = {
            [1459] = UF:AuraWatch_AddSpell(1459, "TOPLEFT", {0.89, 0.09, 0.05}, true), -- Arcane Intellect (Rank 1)
            [1460] = UF:AuraWatch_AddSpell(1460, "TOPLEFT", {0.89, 0.09, 0.05}, true), -- Arcane Intellect (Rank 2)
            [1461] = UF:AuraWatch_AddSpell(1461, "TOPLEFT", {0.89, 0.09, 0.05}, true), -- Arcane Intellect (Rank 3)
            [10156] = UF:AuraWatch_AddSpell(10156, "TOPLEFT", {0.89, 0.09, 0.05}, true), -- Arcane Intellect (Rank 4)
            [10157] = UF:AuraWatch_AddSpell(10157, "TOPLEFT", {0.89, 0.09, 0.05}, true), -- Arcane Intellect (Rank 5)
            [27126] = UF:AuraWatch_AddSpell(27126, "TOPLEFT", {0.89, 0.09, 0.05}, true), -- Arcane Intellect (Rank 6)
            [23028] = UF:AuraWatch_AddSpell(23028, "TOPLEFT", {0.89, 0.09, 0.05}, true), -- Arcane Brilliance (Rank 1)
            [27127] = UF:AuraWatch_AddSpell(27127, "TOPLEFT", {0.89, 0.09, 0.05}, true), -- Arcane Brilliance (Rank 2)
            [604] = UF:AuraWatch_AddSpell(604, "TOPRIGHT", {0.2, 0.8, 0.2}, true), -- Dampen Magic (Rank 1)
            [8450] = UF:AuraWatch_AddSpell(8450, "TOPRIGHT", {0.2, 0.8, 0.2}, true), -- Dampen Magic (Rank 2)
            [8451] = UF:AuraWatch_AddSpell(8451, "TOPRIGHT", {0.2, 0.8, 0.2}, true), -- Dampen Magic (Rank 3)
            [10173] = UF:AuraWatch_AddSpell(10173, "TOPRIGHT", {0.2, 0.8, 0.2}, true), -- Dampen Magic (Rank 4)
            [10174] = UF:AuraWatch_AddSpell(10174, "TOPRIGHT", {0.2, 0.8, 0.2}, true), -- Dampen Magic (Rank 5)
            [33944] = UF:AuraWatch_AddSpell(33944, "TOPRIGHT", {0.2, 0.8, 0.2}, true), -- Dampen Magic (Rank 6)
            [1008] = UF:AuraWatch_AddSpell(1008, "TOPRIGHT", {0.2, 0.8, 0.2}, true), -- Amplify Magic (Rank 1)
            [8455] = UF:AuraWatch_AddSpell(8455, "TOPRIGHT", {0.2, 0.8, 0.2}, true), -- Amplify Magic (Rank 2)
            [10169] = UF:AuraWatch_AddSpell(10169, "TOPRIGHT", {0.2, 0.8, 0.2}, true), -- Amplify Magic (Rank 3)
            [10170] = UF:AuraWatch_AddSpell(10170, "TOPRIGHT", {0.2, 0.8, 0.2}, true), -- Amplify Magic (Rank 4)
            [27130] = UF:AuraWatch_AddSpell(27130, "TOPRIGHT", {0.2, 0.8, 0.2}, true), -- Amplify Magic (Rank 5)
            [33946] = UF:AuraWatch_AddSpell(33946, "TOPRIGHT", {0.2, 0.8, 0.2}, true), -- Amplify Magic (Rank 6)
            [130] = UF:AuraWatch_AddSpell(130, "CENTER", {0.00, 0.00, 0.50}, true) -- Slow Fall
        },
        HUNTER = {
            [19506] = UF:AuraWatch_AddSpell(19506, "TOPLEFT", {0.89, 0.09, 0.05}), -- Trueshot Aura (Rank 1)
            [20905] = UF:AuraWatch_AddSpell(20905, "TOPLEFT", {0.89, 0.09, 0.05}), -- Trueshot Aura (Rank 2)
            [20906] = UF:AuraWatch_AddSpell(20906, "TOPLEFT", {0.89, 0.09, 0.05}), -- Trueshot Aura (Rank 3)
            [27066] = UF:AuraWatch_AddSpell(27066, "TOPLEFT", {0.89, 0.09, 0.05}), -- Trueshot Aura (Rank 4)
            [13159] = UF:AuraWatch_AddSpell(13159, "TOP", {0.00, 0.00, 0.85}, true), -- Aspect of the Pack
            [20043] = UF:AuraWatch_AddSpell(20043, "TOP", {0.33, 0.93, 0.79}), -- Aspect of the Wild (Rank 1)
            [20190] = UF:AuraWatch_AddSpell(20190, "TOP", {0.33, 0.93, 0.79}), -- Aspect of the Wild (Rank 2)
            [27045] = UF:AuraWatch_AddSpell(27045, "TOP", {0.33, 0.93, 0.79}) -- Aspect of the Wild (Rank 3)
        },
        WARLOCK = {
            [5597] = UF:AuraWatch_AddSpell(5597, "TOPLEFT", {0.89, 0.09, 0.05}, true), -- Unending Breath
            [6512] = UF:AuraWatch_AddSpell(6512, "TOPRIGHT", {0.2, 0.8, 0.2}, true), -- Detect Lesser Invisibility
            [2970] = UF:AuraWatch_AddSpell(2970, "TOPRIGHT", {0.2, 0.8, 0.2}, true), -- Detect Invisibility
            [11743] = UF:AuraWatch_AddSpell(11743, "TOPRIGHT", {0.2, 0.8, 0.2}, true) -- Detect Greater Invisibility
        },
        PET = {
            -- Warlock Imp
            [6307] = UF:AuraWatch_AddSpell(6307, "BOTTOMLEFT", {0.89, 0.09, 0.05}), -- Blood Pact (Rank 1)
            [7804] = UF:AuraWatch_AddSpell(7804, "BOTTOMLEFT", {0.89, 0.09, 0.05}), -- Blood Pact (Rank 2)
            [7805] = UF:AuraWatch_AddSpell(7805, "BOTTOMLEFT", {0.89, 0.09, 0.05}), -- Blood Pact (Rank 3)
            [11766] = UF:AuraWatch_AddSpell(11766, "BOTTOMLEFT", {0.89, 0.09, 0.05}), -- Blood Pact (Rank 4)
            [11767] = UF:AuraWatch_AddSpell(11767, "BOTTOMLEFT", {0.89, 0.09, 0.05}), -- Blood Pact (Rank 5)
            -- Warlock Felhunter
            [19480] = UF:AuraWatch_AddSpell(19480, "BOTTOMLEFT", {0.2, 0.8, 0.2}), -- Paranoia
            -- Hunter Pets
            [24604] = UF:AuraWatch_AddSpell(24604, "TOPRIGHT", {0.08, 0.59, 0.41}), -- Furious Howl (Rank 1)
            [24605] = UF:AuraWatch_AddSpell(24605, "TOPRIGHT", {0.08, 0.59, 0.41}), -- Furious Howl (Rank 2)
            [24603] = UF:AuraWatch_AddSpell(24603, "TOPRIGHT", {0.08, 0.59, 0.41}), -- Furious Howl (Rank 3)
            [24597] = UF:AuraWatch_AddSpell(24597, "TOPRIGHT", {0.08, 0.59, 0.41}) -- Furious Howl (Rank 4)
        }
    }
end
