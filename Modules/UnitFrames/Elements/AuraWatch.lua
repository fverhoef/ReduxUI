local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateAuraWatch()
    if not self.config.auraWatch.enabled then
        return
    end

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

function UF:AuraWatch_PostCreateIcon(button)
end

function UF:AuraWatch_PostUpdateIcon(_, button)
    local settings = self.watched[button.spellID]
    if not settings then
        return
    end

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

local function AddAuras(table, ids, point, color, anyUnit)
    local r, g, b = 1, 1, 1
    if color then
        r, g, b = unpack(color)
    end

    for _, id in ipairs(ids) do
        table[id] = {
            id = id,
            enabled = true,
            point = point or "TOPLEFT",
            color = { r = r, g = g, b = b },
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
end

if R.isRetail then
    UF.aurawatch = {}
else
    UF.aurawatch = { GLOBAL = {}, DRUID = {}, HUNTER = {}, MAGE = {}, PALADIN = {}, PRIEST = {}, ROGUE = {}, SHAMAN = {}, WARLOCK = {}, WARRIOR = {}, PET = {} }

    AddAuras(UF.aurawatch.DRUID, { 1126, 5232, 6756, 5234, 8907, 9884, 9885, 26990, 48469, 21849, 21850, 26991, 48470 }, "TOPLEFT", { 0.2, 0.8, 0.8 }, true) -- Mark/Gift of the Wild
    AddAuras(UF.aurawatch.DRUID, { 467, 782, 1075, 8914, 9756, 9910, 26992, 53307 }, "TOPRIGHT", { 0.4, 0.2, 0.8 }, true) -- Thorns
    AddAuras(UF.aurawatch.DRUID, { 774, 1058, 1430, 2090, 2091, 3627, 8910, 9839, 9840, 9841, 25299, 26981, 26982, 48440, 48441 }, "BOTTOMLEFT", { 0.83, 1.00, 0.25 }) -- Rejuvenation
    AddAuras(UF.aurawatch.DRUID, { 8936, 8938, 8939, 8940, 8941, 9750, 9856, 9857, 9858, 26980, 48442, 48443 }, "BOTTOMRIGHT", { 0.33, 0.73, 0.75 }) -- Regrowth
    AddAuras(UF.aurawatch.DRUID, { 29166 }, "CENTER", { 0.49, 0.60, 0.55 }, true) -- Innervate
    AddAuras(UF.aurawatch.DRUID, { 33763, 48450, 48451 }, "BOTTOM", { 0.33, 0.37, 0.47 }) -- Lifebloom
    AddAuras(UF.aurawatch.DRUID, { 48438, 53248, 53249, 53251 }, "BOTTOMRIGHT", { 0.8, 0.4, 0 }) -- Wild Growth
    -- TODO: Abolish Poison

    AddAuras(UF.aurawatch.HUNTER, { 19506 }, "TOPLEFT", { 0.89, 0.09, 0.05 }) -- Trueshot Aura
    AddAuras(UF.aurawatch.HUNTER, { 13159 }, "TOP", { 0.00, 0.00, 0.85 }, true) -- Aspect of the Pack
    AddAuras(UF.aurawatch.HUNTER, { 20043, 20190, 27045, 49071 }, "TOP", { 0.33, 0.93, 0.79 }) -- Aspect of the Wild
    AddAuras(UF.aurawatch.HUNTER, { 34477 }, "BOTTOM", { 0.85, 0.00, 0.00 }, true) -- Misdirection
    
    AddAuras(UF.aurawatch.MAGE, { 1459, 1460, 1461, 10156, 10157, 27126, 42995, 61024, 61316, 23028, 27127, 43002 }, "TOPLEFT", { 0.89, 0.09, 0.05 }, true) -- Arcane/Dalaran Intellect/Brilliance
    AddAuras(UF.aurawatch.MAGE, { 604, 8450, 8451, 10173, 10174, 33944, 43015 }, "TOPRIGHT", { 0.2, 0.8, 0.2 }, true) -- Dampen Magic
    AddAuras(UF.aurawatch.MAGE, { 1008, 8455, 10169, 10170, 27130, 33946, 43017 }, "TOPRIGHT", { 0.2, 0.8, 0.2 }, true) -- Amplify Magic
    AddAuras(UF.aurawatch.MAGE, { 130 }, "CENTER", { 0.00, 0.00, 0.50 }, true) -- Slow Fall
    AddAuras(UF.aurawatch.MAGE, { 54646 }, "BOTTOMLEFT", { 0.50, 0.00, 0.50 }, true) -- Focus Magic

    AddAuras(UF.aurawatch.PALADIN, { 1044 }, "CENTER", { 0.89, 0.45, 0 }, true) -- Hand of Freedom
    AddAuras(UF.aurawatch.PALADIN, { 1038 }, "CENTER", { 0.11, 1.00, 0.45 }, true) -- Hand of Salvation
    AddAuras(UF.aurawatch.PALADIN, { 6940 }, "CENTER", { 0.89, 0.1, 0.1 }, true) -- Hand of Sacrifice
    AddAuras(UF.aurawatch.PALADIN, { 1022, 5599, 10278 }, "CENTER", { 0.17, 1.00, 0.75 }, true) -- Hand of Protection
    AddAuras(UF.aurawatch.PALADIN, { 19740, 19834, 19835, 19836, 19837, 19838, 25291, 27140, 48931, 48932, 25782, 25916, 27141, 48933, 48934 }, "TOPLEFT", { 0.2, 0.8, 0.2 }, true) -- (Greater) Blessing of Might
    AddAuras(UF.aurawatch.PALADIN, { 19742, 19850, 19852, 19853, 19854, 25290, 27142, 48935, 48936, 25894, 25918, 27143, 48937, 48938 }, "TOPLEFT", { 0.2, 0.8, 0.2 }, true) -- (Greater) Blessing of Wisdom
    AddAuras(UF.aurawatch.PALADIN, { 465, 10290, 643, 10291, 1032, 10292, 10293, 27149, 48941, 48942 }, "BOTTOMLEFT", { 0.58, 1.00, 0.50 }) -- Devotion Aura
    AddAuras(UF.aurawatch.PALADIN, { 19746 }, "BOTTOMLEFT", { 0.83, 1.00, 0.07 }) -- Concentration Aura
    AddAuras(UF.aurawatch.PALADIN, { 32223 }, "BOTTOMLEFT", { 0.83, 1.00, 0.07 }) -- Crusader Aura
    AddAuras(UF.aurawatch.PALADIN, { 53563 }, "TOPRIGHT", { 0.7, 0.3, 0.7 }, true) -- Beacon of Light
    AddAuras(UF.aurawatch.PALADIN, { 53601 }, "BOTTOMRIGHT", { 0.4, 0.7, 0.2 }, true) -- Sacred Shield

    AddAuras(UF.aurawatch.PRIEST, { 1243, 1244, 1245, 2791, 10937, 10938, 25389, 48161 }, "TOPLEFT", { 1, 1, 0.66 }, true) -- Power Word: Fortitude
    AddAuras(UF.aurawatch.PRIEST, { 21562, 21564, 25392, 48162 }, "TOPLEFT", { 1, 1, 0.66 }, true) -- Prayer of Fortitude
    AddAuras(UF.aurawatch.PRIEST, { 14752, 14818, 14819, 27841, 25312, 48073 }, "TOPRIGHT", { 0.2, 0.7, 0.2 }, true) -- Divine Spirit
    AddAuras(UF.aurawatch.PRIEST, { 27681, 32999, 48074 }, "TOPRIGHT", { 0.2, 0.7, 0.2 }, true) -- Prayer of Spirit
    AddAuras(UF.aurawatch.PRIEST, { 976, 10957, 10958, 25433, 48169 }, "BOTTOMLEFT", { 0.7, 0.7, 0.7 }, true) -- Shadow Protection
    AddAuras(UF.aurawatch.PRIEST, { 27683, 39374, 48170 }, "BOTTOMLEFT", { 0.7, 0.7, 0.7 }, true) -- Prayer of Shadow Protection
    AddAuras(UF.aurawatch.PRIEST, { 17, 592, 600, 3747, 6065, 6066, 10898, 10899, 10900, 10901, 25217, 25218, 48065, 48066 }, "BOTTOM", { 0.00, 0.00, 1.00 }) -- Power Word: Shield
    AddAuras(UF.aurawatch.PRIEST, { 139, 6074, 6075, 6076, 6077, 6078, 10927, 10928, 10929, 25315, 25221, 25222, 48067, 48068 }, "BOTTOMRIGHT", { 0.33, 0.73, 0.75 }) -- Renew
    AddAuras(UF.aurawatch.PRIEST, { 6788 }, "TOP", { 0.89, 0.1, 0.1 }) -- Weakened Soul
    -- TODO: Abolish Poison / Abolish Disease / Guardian Spirit / Prayer of Mending / Pain Suppression / Power Infusion

    AddAuras(UF.aurawatch.ROGUE, { 57934 }, "TOPRIGHT", { 0.50, 0.00, 0.50 }, true) -- Tricks of the Trade

    AddAuras(UF.aurawatch.SHAMAN, { 16177, 16236, 16237 }, "RIGHT", { 0.2, 0.2, 1 }) -- Ancestral Fortitude
    AddAuras(UF.aurawatch.SHAMAN, { 5672, 6371, 6372, 10460, 10461, 25567, 58755, 58756, 58757 }, "BOTTOM", { 0.67, 1.00, 0.50 }) -- Healing Stream Totem
    AddAuras(UF.aurawatch.SHAMAN, { 16191 }, "CENTER", { 0.67, 1.00, 0.80 }) -- Mana Tide Totem
    AddAuras(UF.aurawatch.SHAMAN, { 5677, 10491, 10493, 10494, 25569, 58775, 58776, 58777 }, "LEFT", { 0.67, 1.00, 0.80 }) -- Mana Spring Totem
    AddAuras(UF.aurawatch.SHAMAN, { 8072, 8156, 8157, 10403, 10404, 10405, 25506, 25507, 58752, 58754 }, "TOPLEFT", { 0.00, 0.00, 0.26 }) -- Stoneskin Totem
    AddAuras(UF.aurawatch.SHAMAN, { 974, 32593, 32594, 49283, 49284 }, "TOP", { 0.08, 0.21, 0.43 }, true) -- Earth Shield
    AddAuras(UF.aurawatch.SHAMAN, { 61295, 61299, 61300, 61301 }, "BOTTOMLEFT", { 0.33, 0.73, 0.75 }) -- Riptide
    AddAuras(UF.aurawatch.SHAMAN, { 51945, 51990, 51997, 51998, 51999, 52000 }, "BOTTOMRIGHT", { 0.33, 0.73, 0.75 }) -- Earthliving

    AddAuras(UF.aurawatch.WARLOCK, { 5697 }, "TOPLEFT", { 0.89, 0.09, 0.05 }, true) -- Unending Breath
    AddAuras(UF.aurawatch.WARLOCK, { 6512 }, "TOPRIGHT", { 0.2, 0.8, 0.2 }, true) -- Detect Lesser Invisibility
    -- TODO: Soulstone

    AddAuras(UF.aurawatch.WARRIOR, { 6673, 5242, 6192, 11549, 11550, 11551, 25289, 2048, 47436 }, "TOPLEFT", { 0.2, 0.2, 1 }, true) -- Battle Shout
    AddAuras(UF.aurawatch.WARRIOR, { 469, 47439, 47440 }, "TOPRIGHT", { 0.4, 0.2, 0.8 }, true) -- Commanding Shout

    -- Warlock Imp
    AddAuras(UF.aurawatch.PET, { 6307, 7804, 7805, 11766, 11767, 27268, 47982 }, "BOTTOMLEFT", { 0.89, 0.09, 0.05 }) -- Blood Pact
    -- Warlock Felhunter
    AddAuras(UF.aurawatch.PET, { 54424, 57564, 57565, 57566, 57567 }, "BOTTOMLEFT", { 0.2, 0.8, 0.2 }) -- Fel Intelligence
    -- Hunter Pets
    AddAuras(UF.aurawatch.PET, { 24604, 64491, 64492, 64493, 64494, 64495 }, "TOPRIGHT", { 0.08, 0.59, 0.41 }) -- Furious Howl
end
