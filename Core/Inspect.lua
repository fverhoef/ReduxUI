local addonName, ns = ...
local R = _G.ReduxUI
local L = R.L

R.Inspect = CreateFrame("Frame")
R.Inspect:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, event, ...)
end)
R.Inspect:RegisterEvent("INSPECT_READY")

R.Inspect.InventoryCache = {}
R.Inspect.TalentCache = {}

R.Inspect.NextInspectTime = 0
R.Inspect.Queue = {}

local INSPECT_DELAY = 2
local MAX_QUEUE = 20

local GUIDIsPlayer = C_PlayerInfo.GUIDIsPlayer

function R.Inspect:INSPECT_READY(event, guid)
    if not guid then
        return
    end

    local unit = R:PlayerGUIDToUnitToken(guid)
    if not unit or UnitIsUnit(unit, "player") then
        return
    end

    R.Inspect:CacheInventory(unit)

    R.Inspect.Queue[guid] = nil
    for nextGuid, _ in pairs(R.Inspect.Queue) do
        R.Inspect:StartInspect(nextGuid)
        break
    end
end

function R.Inspect:CacheInventory(unit)
    local guid = UnitGUID(unit)
    if not guid then
        return
    end

    local items = {}
    for _, slot in ipairs(R.EquipmentSlots) do
        items[slot] = GetInventoryItemLink(unit, GetInventorySlotInfo(slot))
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

function R.Inspect:StartInspect(unitOrGuid)
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
        if GetTime() >= R.Inspect.NextInspectTime then
            R.Inspect.NextInspectTime = GetTime() + INSPECT_DELAY

            NotifyInspect(unit)

            return 1
        else
            local c = #R.Inspect.Queue
            if c >= MAX_QUEUE then
                table.remove(R.Inspect.Queue, 1)
            end

            R.Inspect.Queue[guid] = true
            return 2
        end
    end
    return 0
end
