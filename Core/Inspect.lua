local addonName, ns = ...
local R = _G.ReduxUI
local L = R.L

R.Inspect = CreateFrame("Frame")
R.Inspect:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, event, ...)
end)
R.Inspect:RegisterEvent("INSPECT_READY")
R.Inspect:RegisterEvent("UNIT_INVENTORY_CHANGED")

R.Inspect.InventoryCache = {}
R.Inspect.TalentCache = {}

R.Inspect.NextInspectTime = 0
R.Inspect.Queue = {}

R.Inspect.Callbacks = {}

local INSPECT_DELAY = 2
local MAX_QUEUE = 20

local GUIDIsPlayer = C_PlayerInfo.GUIDIsPlayer

function R.Inspect:INSPECT_READY(event, guid)
    if not guid then
        return
    end

    R.Inspect:CacheUserTalents(guid)
    R.Inspect:CacheInventory(guid)

    if R.Inspect.Callbacks[guid] then
        R.Inspect.Callbacks[guid]()
        R.Inspect.Callbacks[guid] = nil
    end

    R.Inspect.Queue[guid] = nil
    for nextGuid, callback in pairs(R.Inspect.Queue) do
        R.Inspect:StartInspect(nextGuid, callback)
        break
    end
end

function R.Inspect:UNIT_INVENTORY_CHANGED(event, unit)
    if unit and UnitIsPlayer(unit) and not UnitIsUnit(unit, "player") then
        R.Inspect:CacheInventory(UnitGUID(unit))
    end
end

function R.Inspect:CacheUserTalents(guid)
    local unit = R:PlayerGUIDToUnitToken(guid)
    if not unit then
        return
    end

    local class = select(2, UnitClass(unit))

    local talents = R.Inspect.TalentCache[guid] or { [1] = { [1] = {}, [2] = {}, [3] = {} }, [2] = { [1] = {}, [2] = {}, [3] = {} } }
    for group = 1, 2 do
        for tab = 1, 3 do
            talents[group][tab].name = R.SpecNames[class][tab]
            talents[group][tab].count = 0

            for index = 1, GetNumTalents(tab, true, false) do
                local rank = select(5, GetTalentInfo(tab, index, true, false, group))
                talents[group][tab][index] = rank
                talents[group][tab].count = talents[group][tab].count + rank
            end
        end

        talents[group].spec = (talents[group][1].count > talents[group][2].count and talents[group][1].count > talents[group][3].count and talents[group][1].name) or
                                  (talents[group][2].count > talents[group][1].count and talents[group][2].count > talents[group][3].count and talents[group][2].name) or talents[group][3].name
    end

    talents.activeTalents = GetActiveTalentGroup(true, false)

    R.Inspect.TalentCache[guid] = talents
end

function R.Inspect:CacheInventory(guid)
    local unit = R:PlayerGUIDToUnitToken(guid)
    if not unit then
        return
    end

    local items = R.Inspect.InventoryCache[guid] or {}
    for i, slot in ipairs(R.EquipmentSlots) do
        items[slot] = GetInventoryItemID(unit, i)
    end

    R.Inspect.InventoryCache[guid] = items
end

function R.Inspect:CanInspect(unitOrGuid)
    if not unitOrGuid or InCombatLockdown() then
        return false
    end

    local unit
    if GUIDIsPlayer(unitOrGuid) then
        unit = lib:PlayerGUIDToUnitToken(unitOrGuid)
    elseif UnitIsPlayer(unitOrGuid) then
        unit = unitOrGuid
    end
    return unit and UnitExists(unit) and UnitIsConnected(unit) and not UnitIsDeadOrGhost(unit) and not UnitIsUnit(unit, "player") and CheckInteractDistance(unit, 1) and
               (not InspectFrame or not InspectFrame:IsShown()) and CanInspect(unit, false)
end

function R.Inspect:StartInspect(unitOrGuid, callback)
    if not unitOrGuid then
        return nil
    end

    local unit, guid
    if GUIDIsPlayer(unitOrGuid) then
        unit = R:PlayerGUIDToUnitToken(unitOrGuid)
        guid = unitOrGuid
    elseif UnitIsPlayer(unitOrGuid) then
        unit = unitOrGuid
        guid = UnitGUID(unit)
    end
    if R.Inspect:CanInspect(unit) then
        if #R.Inspect.Queue == 0 and GetTime() >= R.Inspect.NextInspectTime then
            R.Inspect.NextInspectTime = GetTime() + INSPECT_DELAY

            NotifyInspect(unit)
            R.Inspect.Queue[guid] = nil
            R.Inspect.Callbacks[guid] = callback

            return 1
        else
            if #R.Inspect.Queue >= MAX_QUEUE then
                table.remove(R.Inspect.Queue, 1)
            end

            R.Inspect.Queue[guid] = callback or nop
            return 2
        end
    end
    return 0
end
