local addonName, ns = ...
local R = _G.ReduxUI

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
    "HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "ShirtSlot", "TabardSlot", "WristSlot", "HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot",
    "Trinket0Slot", "Trinket1Slot", "MainHandSlot", "SecondaryHandSlot"
}

if not R.isRetail then
    table.insert(R.EquipmentSlots, "RangedSlot")
end

R.EmptyFunction = function()
end

local EDIT_MODE_METHODS = { "OnEditModeEnter", "OnEditModeExit", "HasActiveChanges", "HighlightSystem", "SelectSystem" }

function R:Disable(frame, skipEvents, skipSetEmpty, skipEditMode)
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

    if not skipEditMode and EditModeManagerFrame then
        for _, registeredFrame in ipairs(EditModeManagerFrame.registeredSystemFrames) do
            if frame == registeredFrame then
                for _, method in ipairs(EDIT_MODE_METHODS) do
                    frame[method] = nop
                end
            end
        end
    end

    frame:Hide()
    frame:SetParent(R.HiddenFrame)
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
