local addonName, ns = ...
local R = _G.ReduxUI

local GUIDIsPlayer = C_PlayerInfo.GUIDIsPlayer

R.PlayerInfo = {
    name = UnitName("player"),
    guid = UnitGUID("player"),
    class = select(2, UnitClass("player")),
    localizedClass = select(1, UnitClass("player")),
    faction = UnitFactionGroup("player"),
    realm = GetRealmName()
}

R.HiddenFrame = CreateFrame("Frame")
R.HiddenFrame:Hide()

R.UnlocalizedClasses = {}
for k, v in pairs(_G.LOCALIZED_CLASS_NAMES_MALE) do
    R.UnlocalizedClasses[v] = k
end
for k, v in pairs(_G.LOCALIZED_CLASS_NAMES_FEMALE) do
    R.UnlocalizedClasses[v] = k
end

R.EquipmentSlots = {
    "HeadSlot", "NeckSlot", "ShoulderSlot", "ShirtSlot", "ChestSlot", "WaistSlot", "LegsSlot", "FeetSlot", "WristSlot", "HandsSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot",
    "BackSlot", "MainHandSlot", "SecondaryHandSlot", "TabardSlot"
}

R.SpecNames = {
    ["WARRIOR"] = { "Arms", "Fury", "Protection" },
    ["PALADIN"] = { "Holy", "Protection", "Retribution" },
    ["HUNTER"] = { "Beast Mastery", "Marksmanship", "Survival" },
    ["ROGUE"] = { "Assassination", "Combat", "Subtlety" },
    ["PRIEST"] = { "Discipline", "Holy", "Shadow" },
    ["DEATHKNIGHT"] = { "Blood", "Frost", "Unholy" },
    ["SHAMAN"] = { "Elemental", "Enhancement", "Restoration" },
    ["MAGE"] = { "Arcane", "Fire", "Frost" },
    ["WARLOCK"] = { "Affliction", "Demonology", "Destruction" },
    ["DRUID"] = { "Balance", "Feral Combat", "Restoration" }
}

if not R.isRetail then
    table.insert(R.EquipmentSlots, 18, "RangedSlot")
end

R.EmptyFunction = function()
end

function R:Disable(frame, skipEvents, skipSetEmpty)
    if not frame then
        return
    end

    if frame.UnregisterAllEvents then
        if not skipEvents then
            frame:UnregisterAllEvents()
        end

        if frame:GetName() then
            frame.ignoreFramePositionManager = true
            frame:SetAttribute("ignoreFramePositionManager", true)
            if not R.isRetail then
                UIPARENT_MANAGED_FRAME_POSITIONS[frame:GetName()] = nil
            end
        end
    end

    if not skipSetEmpty then
        if frame.ClearAllPoints then
            frame.ClearAllPoints = R.EmptyFunction
        end
        if frame.SetPoint then
            frame.SetPoint = R.EmptyFunction
        end
        if frame.SetScale then
            frame.SetScale = R.EmptyFunction
        end
        if frame.SetShown then
            frame.SetShown = R.EmptyFunction
        end
        if frame.SetSize then
            frame.SetSize = R.EmptyFunction
        end
        if frame.Show then
            frame.Show = R.EmptyFunction
        end
        if frame.GetTop then
            frame.GetTop = function()
                return 0
            end
        end
        if frame.GetBottom then
            frame.GetBottom = function()
                return 0
            end
        end
    end

    frame:Hide()
    frame:SetParent(R.HiddenFrame)
end

local EDIT_MODE_METHODS = { "OnEditModeEnter", "OnEditModeExit", "HasActiveChanges", "HighlightSystem", "SelectSystem" }

function R:DisableEditMode(frame, isBar)
    if not frame then
        return
    end

    if not skipEditMode and EditModeManagerFrame then
        for _, registeredFrame in ipairs(EditModeManagerFrame.registeredSystemFrames or {}) do
            if frame == registeredFrame then
                for _, method in ipairs(EDIT_MODE_METHODS) do
                    frame[method] = nop
                end

                if frame.config and frame.config.point then
                    if not R:IsHooked(frame, "UpdateSystem") then
                        R:SecureHook(frame, "UpdateSystem", function()
                            frame:ClearAllPoints()
                            frame:SetNormalizedPoint(frame.config.point)
                        end)
                    end
                end
            end
        end
    end
end

function R:UnlocalizedClassName(className)
    return (className and className ~= "") and R.UnlocalizedClasses[className]
end

function R:LocalizedClassName(className)
    return (className and className ~= "") and (UnitSex("player") == 2 and _G.LOCALIZED_CLASS_NAMES_MALE[className] or UnitSex("player") == 3 and _G.LOCALIZED_CLASS_NAMES_FEMALE[className]) or
               className
end

function R:Print(value, ...)
    print(R.title .. ":", string.format(value, ...))
end

function R:PrintError(value, ...)
    print(R.title .. ": error ", string.format(value, ...))
end

function R:Announce(message, channel)
    if channel == "GROUP" and not IsInGroup() then
        channel = "EMOTE"
    end

    if channel == "GROUP" and IsInGroup() then
        SendChatMessage(message, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or (IsInRaid() and "RAID" or "PARTY"))
    elseif channel == "SAY" and instanceType ~= "none" then
        SendChatMessage(message, "SAY")
    elseif channel == "YELL" and instanceType ~= "none" then
        SendChatMessage(message, "YELL")
    elseif channel == "EMOTE" then
        SendChatMessage(message, "EMOTE")
    end
end

function R:FormatValue(value)
    if value < 1e3 then
        return math.floor(value)
    elseif value >= 1e12 then
        return string.format("%.3ft", value / 1e12)
    elseif value >= 1e9 then
        return string.format("%.3fb", value / 1e9)
    elseif value >= 1e6 then
        return string.format("%.2fm", value / 1e6)
    elseif value >= 1e3 then
        return string.format("%.1fk", value / 1e3)
    end
end

local COLOR_COPPER, COLOR_SILVER, COLOR_GOLD = "|cffeda55f", "|cffc7c7cf", "|cffffd700"
local ICON_COPPER = "|TInterface\\MoneyFrame\\UI-CopperIcon:12:12|t"
local ICON_SILVER = "|TInterface\\MoneyFrame\\UI-SilverIcon:12:12|t"
local ICON_GOLD = "|TInterface\\MoneyFrame\\UI-GoldIcon:12:12|t"

function R:FormatMoney(amount, style)
    local value = math.abs(amount)
    local gold = math.floor(value / 10000)
    local silver = math.floor(mod(value / 100, 100))
    local copper = math.floor(mod(value, 100))

    if not style or style == "SMART" then
        local str = ""
        if gold > 0 then
            str = format("%d%s%s", gold, ICON_GOLD, (silver > 0 or copper > 0) and " " or "")
        end
        if silver > 0 then
            str = format("%s%d%s%s", str, silver, ICON_SILVER, copper > 0 and " " or "")
        end
        if copper > 0 or value == 0 then
            str = format("%s%d%s", str, copper, ICON_COPPER)
        end
        return str
    end

    if style == "FULL" then
        if gold > 0 then
            return format("%d%s %d%s %d%s", gold, ICON_GOLD, silver, ICON_SILVER, copper, ICON_COPPER)
        elseif silver > 0 then
            return format("%d%s %d%s", silver, ICON_SILVER, copper, ICON_COPPER)
        else
            return format("%d%s", copper, ICON_COPPER)
        end
    elseif style == "SHORT" then
        if gold > 0 then
            return format("%.1f%s", amount / 10000, ICON_GOLD)
        elseif silver > 0 then
            return format("%.1f%s", amount / 100, ICON_SILVER)
        else
            return format("%d%s", amount, ICON_COPPER)
        end
    elseif style == "SHORTINT" then
        if gold > 0 then
            return format("%d%s", gold, ICON_GOLD)
        elseif silver > 0 then
            return format("%d%s", silver, ICON_SILVER)
        else
            return format("%d%s", copper, ICON_COPPER)
        end
    elseif style == "CONDENSED" then
        if gold > 0 then
            return format("%s%d|r.%s%02d|r.%s%02d|r", COLOR_GOLD, gold, COLOR_SILVER, silver, COLOR_COPPER, copper)
        elseif silver > 0 then
            return format("%s%d|r.%s%02d|r", COLOR_SILVER, silver, COLOR_COPPER, copper)
        else
            return format("%s%d|r", COLOR_COPPER, copper)
        end
    elseif style == "BLIZZARD" then
        if gold > 0 then
            return format("%s%s %d%s %d%s", BreakUpLargeNumbers(gold), ICON_GOLD, silver, ICON_SILVER, copper, ICON_COPPER)
        elseif silver > 0 then
            return format("%d%s %d%s", silver, ICON_SILVER, copper, ICON_COPPER)
        else
            return format("%d%s", copper, ICON_COPPER)
        end
    elseif style == "BLIZZARD2" then
        if gold > 0 then
            return format("%s%s %02d%s %02d%s", BreakUpLargeNumbers(gold), ICON_GOLD, silver, ICON_SILVER, copper, ICON_COPPER)
        elseif silver > 0 then
            return format("%d%s %02d%s", silver, ICON_SILVER, copper, ICON_COPPER)
        else
            return format("%d%s", copper, ICON_COPPER)
        end
    end

    -- Shouldn't be here; punt
    return self:FormatMoney(amount, "SMART")
end

function R:Hex(r, g, b)
    if (type(r) == "table") then
        if (r.r) then
            r, g, b = r.r, r.g, r.b
        else
            r, g, b = unpack(r)
        end
    end

    return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
end

function R:Round(num, idp)
    if type(num) ~= "number" then
        return num, idp
    end

    if idp and idp > 0 then
        local mult = 10 ^ idp
        return math.floor(num * mult + 0.5) / mult
    end

    return math.floor(num + 0.5)
end

function R:PolarToXY(angle, radius)
    return radius * math.sin(math.rad(angle)), radius * math.cos(math.rad(angle))
end

function R:RomanNumeral(number)
    local roman = nil
    if number == 1 then
        roman = "I"
    elseif number == 2 then
        roman = "II"
    elseif number == 3 then
        roman = "III"
    elseif number == 4 then
        roman = "IV"
    elseif number == 5 then
        roman = "V"
    elseif number == 6 then
        roman = "VI"
    elseif number == 7 then
        roman = "VII"
    elseif number == 8 then
        roman = "VIII"
    elseif number == 9 then
        roman = "IX"
    elseif number == 10 then
        roman = "X"
    end

    return roman
end

function R:ShortValue(value, decimalPlaces)
    if type(value) ~= "number" then
        return value
    end

    local absoluteValue = math.abs(value)
    local suffix = ""

    if absoluteValue >= 1e12 then
        suffix = "T"
        value = value / 1e12
        decimalPlaces = decimalPlaces or 1
    elseif absoluteValue >= 1e9 then
        suffix = "B"
        value = value / 1e9
        decimalPlaces = decimalPlaces or 1
    elseif absoluteValue >= 1e6 then
        suffix = "M"
        value = value / 1e6
        decimalPlaces = decimalPlaces or 1
    elseif absoluteValue >= 1e3 then
        suffix = "k"
        value = value / 1e3
        decimalPlaces = decimalPlaces or 1
    end

    return string.format("%." .. (decimalPlaces and tonumber(decimalPlaces) or 0) .. "f" .. suffix, value)
end

function R:ParseItemLink(itemLink)
    if not itemLink then
        return {}
    end
    local _, _, color, Ltype, itemId, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name = string.find(itemLink,
                                                                                                                   "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")

    return { itemId = itemId, color = color }
end

function R:GetItemIdFromLink(itemLink)
    return R:ParseItemLink(itemLink).itemId
end

function R:PlayerCanInvite()
    return not UnitExists("party1") or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")
end

function R:PlayerHasAura(auraId)
    local i = 1
    local spellId = select(10, UnitAura("player", i))
    while spellId do
        if spellId == auraId then
            return true
        end

        i = i + 1
        spellId = select(10, UnitAura("player", i))
    end

    return false
end

function R:GetPlayerRole()
    if not R.isRetail then
        return "NONE"
    end

    local role = UnitGroupRolesAssigned("player") or "NONE"
    return (role == "NONE" and GetSpecializationRole(GetSpecialization())) or role
end

function R:GetPlayerEquippedItems(includeShirt, includeTabard)
    local items = {}
    for slotId, slot in ipairs(R.EquipmentSlots) do
        local itemId = GetInventoryItemID("player", slotId)
        if slot == "ShirtSlot" then
            if includeShirt then
                items[slot] = itemId
            end
        elseif slot == "TabardSlot" then
            if includeTabard then
                items[slot] = itemId
            end
        else
            items[slot] = itemId
        end
    end

    return items
end

function R:GetPlayerItemLevelAndQuality()
    local items = R:GetPlayerEquippedItems()
    local minimumItemQuality = 5
    local totalItemLevel = 0
    local count = 0
    local hasTwoHander = false
    for slot, itemId in pairs(items) do
        if itemId then
            local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemIcon = GetItemInfo(itemId)
            if itemEquipLoc == "INVTYPE_2HWEAPON" then
                hasTwoHander = true
            end
            if itemLevel then
                totalItemLevel = totalItemLevel + itemLevel
            end
            if itemRarity and itemRarity < minimumItemQuality then
                minimumItemQuality = itemRarity
            end
            count = count + 1
        elseif slot ~= "SecondaryHandSlot" and hasTwoHander then
            count = count + 1
        end
    end

    return math.floor((count and totalItemLevel / count) or 0), minimumItemQuality
end

function R:GetPlayerTalents()
    local talents = { [1] = { [1] = {}, [2] = {}, [3] = {} }, [2] = { [1] = {}, [2] = {}, [3] = {} } }
    for group = 1, 2 do
        for tab = 1, 3 do
            talents[group][tab].name = R.SpecNames[R.PlayerInfo.class][tab]
            talents[group][tab].count = 0

            for index = 1, GetNumTalents(tab, false, false) do
                local rank = select(5, GetTalentInfo(tab, index, false, false, group))
                talents[group][tab][index] = rank
                talents[group][tab].count = talents[group][tab].count + rank
            end
        end

        talents[group].spec = (talents[group][1].count > talents[group][2].count and talents[group][1].count > talents[group][3].count and talents[group][1].name) or
                                  (talents[group][2].count > talents[group][1].count and talents[group][2].count > talents[group][3].count and talents[group][2].name) or talents[group][3].name
    end

    talents.activeTalents = GetActiveTalentGroup(false, false)

    return talents
end

function R:GetMinimumItemQuality(items)
    local minimumItemQuality = 5
    for slot, itemId in pairs(items) do
        if itemId then
            local itemRarity = select(3, GetItemInfo(itemId))
            if itemRarity and itemRarity < minimumItemQuality then
                minimumItemQuality = itemRarity
            end
        end
    end

    return minimumItemQuality
end

function R:GetAuraId(spellName, unit)
    local auraName, spellId
    for i = 1, 255 do
        auraName, _, _, _, _, _, _, _, _, spellId = UnitBuff(unit, i)
        if auraName == spellName then
            break
        elseif not auraName then
            spellId = nil
            break
        end
    end
    return spellId
end

function R:FixNormalTextureSize(button)
    local normalTexture = button:GetNormalTexture()
    if normalTexture then
        local texture = normalTexture:GetTexture()
        if texture == 130841 or texture == [[Interface\Buttons\UI-Quickslot2]] then
            local size = 66 * (button:GetWidth() / 36)
            normalTexture:SetSize(size, size)
        end
    end
end

function R:CopyTable(table, overwrites)
    local copy = {}

    for k, v in pairs(table) do
        if type(v) == "table" then
            copy[k] = R:CopyTable(v)
        else
            copy[k] = v
        end
    end

    if overwrites then
        R:OverwriteTableValues(copy, overwrites)
    end

    return copy
end

function R:OverwriteTableValues(target, overwrites)
    for k, v in pairs(overwrites) do
        if type(v) == "table" and target[k] then
            target[k] = R:OverwriteTableValues(target[k], v)
        else
            target[k] = v
        end
    end
    return target
end

R.mountIDs = {}

if R.isRetail then
    local mountIDs = C_MountJournal.GetMountIDs()
    for _, mountID in ipairs(mountIDs) do
        local name, spellID, icon = C_MountJournal.GetMountInfoByID(mountID)
        R.mountIDs[spellID] = { name = name, icon = icon }
    end
else
    R:ScheduleTimer(function()
        local mountSpellIDs = {
            458, 459, 468, 470, 472, 578, 579, 580, 581, 5784, 6648, 6653, 6654, 6777, 6896, 6898, 6899, 8394, 8395, 8980, 10789, 10790, 10793, 10795, 10796, 10799, 10873, 10969, 13819, 15779, 15780,
            16055, 16056, 16080, 16081, 16082, 16083, 16084, 17229, 17450, 17453, 17454, 17459, 17460, 17461, 17462, 17463, 17464, 17465, 17481, 18363, 18989, 18990, 18991, 18992, 22717, 22718, 22719,
            22720, 22721, 22722, 22723, 22724, 23161, 23214, 23219, 23221, 23222, 23223, 23225, 23227, 23228, 23229, 23238, 23239, 23240, 23241, 23242, 23243, 23246, 23247, 23248, 23249, 23250, 23251,
            23252, 23338, 23509, 23510, 24242, 24252, 25863, 25953, 26054, 26055, 26056, 26655, 26656, 28828, 30174, 32235, 32239, 32240, 32242, 32243, 32244, 32245, 32246, 32289, 32290, 32292, 32295,
            32296, 32297, 33630, 33660, 34406, 34767, 34769, 34790, 34795, 34896, 34897, 34898, 34899, 35018, 35020, 35022, 35025, 35027, 35028, 35710, 35711, 35712, 35713, 35714, 36702, 37015, 39315,
            39316, 39317, 39318, 39319, 39798, 39800, 39801, 39802, 39803, 40192, 41252, 41513, 41514, 41515, 41516, 41517, 41518, 42776, 42777, 43688, 43899, 43900, 43927, 44151, 44153, 44317, 44744,
            46197, 46199, 46628, 48025, 48027, 48778, 48954, 49193, 49322, 49378, 49379, 51412, 54729, 54753, 55164, 55531, 58615, 58983, 59567, 59568, 59569, 59570, 59571, 59572, 59650, 59785, 59788,
            59791, 59793, 59797, 59799, 59961, 59976, 59996, 60002, 60021, 60024, 60025, 60114, 60116, 60118, 60119, 60136, 60140, 60424, 61229, 61230, 61294, 61309, 61425, 61447, 61451, 61465, 61467,
            61469, 61470, 61996, 61997, 62048, 63232, 63635, 63636, 63637, 63638, 63639, 63640, 63641, 63642, 63643, 63796, 63844, 63956, 63963, 64656, 64657, 64658, 64659, 64731, 64927, 64977, 65439,
            65637, 65638, 65639, 65640, 65641, 65642, 65643, 65644, 65645, 65646, 65917, 66087, 66088, 66090, 66091, 66122, 66123, 66124, 66846, 66847, 66906, 67336, 67466, 68056, 68057, 68187, 68188,
            69395, 69820, 69826, 71342, 71810, 72286, 72807, 72808, 73313, 73629, 73630, 74856, 74918, 75207, 75596, 75614, 75973, 348459, 372677, 394209
        }

        for _, spellID in ipairs(mountSpellIDs) do
            local name, _, icon = GetSpellInfo(spellID)
            if name then
                R.mountIDs[spellID] = { name = name, icon = icon }
            end
        end
    end, 5)
end

function R:GetUnitMountInfo(unit)
    local index = 1
    local spellID = select(10, UnitAura(unit, index, "HELPFUL"))
    while spellID do
        local mountInfo = R.mountIDs[spellID]
        if mountInfo then
            return mountInfo
        else
            index = index + 1
            spellID = select(10, UnitAura(unit, index, "HELPFUL"))
        end
    end
end

function R:IsTalentActivationSpell(spellID)
    if spellID and TALENT_ACTIVATION_SPELLS then
        for _, id in ipairs(TALENT_ACTIVATION_SPELLS) do
            if id == spellID then
                return true
            end
        end
    end

    return false
end

function R:PlayerGUIDToUnitToken(guid)
    if not guid or not GUIDIsPlayer(guid) then
        return nil
    end
    if UnitGUID("player") == guid then
        return "player"
    end
    if IsInGroup() and IsGUIDInGroup(guid) then
        if IsInRaid() then
            for i = 1, 40 do
                if UnitGUID("raid" .. i) == guid then
                    return "raid" .. i
                end
            end
        else
            for i = 1, 4 do
                if UnitGUID("party" .. i) == guid then
                    return "party" .. i
                end
            end
        end
    end
    if UnitGUID("target") == guid then
        return "target"
    end
    if UnitGUID("focus") == guid then
        return "focus"
    end
    if UnitGUID("mouseover") == guid then
        return "mouseover"
    end
    if GetCVar("nameplateShowFriends") == "1" or GetCVar("nameplateShowEnemies") == "1" then
        local nameplatesArray = C_NamePlate.GetNamePlates()
        for i, nameplate in ipairs(nameplatesArray) do
            if UnitGUID(nameplate.namePlateUnitToken) == guid then
                return nameplate.namePlateUnitToken
            end
        end
    end
    if UnitGUID("targettarget") == guid then
        return "targettarget"
    end
    if UnitGUID("focustarget") == guid then
        return "focustarget"
    end
    if UnitGUID("mouseovertarget") == guid then
        return "mouseovertarget"
    end
    return nil
end
