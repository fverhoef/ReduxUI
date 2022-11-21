local _, ns = ...
local oUF = ns.oUF
assert(oUF, "oUF not loaded")

local GetTrinketIcon = function(unit)
    if UnitFactionGroup(unit) == "Horde" then
        return "Interface\\Icons\\INV_Jewelry_TrinketPVP_02"
    else
        return "Interface\\Icons\\INV_Jewelry_TrinketPVP_01"
    end
end

local TrinketUpdate = function(self, elapsed)
    if self.endTime < GetTime() then
        if self.PostTrinketUp then
            self:PostTrinketUp(self.__owner.unit)
        end
        self:SetScript("OnUpdate", nil)
    end
end

local TrinketUsed = function(self, time)
    CooldownFrame_Set(self.Cooldown, GetTime(), time, 1)
    if self.PostTrinketUsed then
        self:PostTrinketUsed(self.__owner.unit, time > 100)
    end
    self.endTime = GetTime() + time
    self:SetScript("OnUpdate", TrinketUpdate)
end

local Update = function(self, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local timestamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID = CombatLogGetCurrentEventInfo()
        if subEvent == "SPELL_CAST_SUCCESS" and UnitGUID(self.unit) == sourceGUID then
            if spellID == 42292 or spellID == 59752 then
                TrinketUsed(self.Trinket, 120)
            elseif spellID == 7744 then
                TrinketUsed(self.Trinket, 45)
            end
        end
    end
end

local Path = function(self, ...)
    return (self.Trinket.Override or Update)(self, ...)
end

local Enable = function(self)
    if self.Trinket then
        self.Trinket.__owner = self
        self.Trinket.Cooldown = CreateFrame("Cooldown", nil, self.Trinket)
        self.Trinket.Cooldown:SetInside(self.Trinket, 3, 3)
        self.Trinket.Cooldown:SetSwipeColor(0, 0, 0)

        self.Trinket.Icon = self.Trinket:CreateTexture(nil, "BACKGROUND")
        self.Trinket.Icon:SetTexture(GetTrinketIcon(self.unit))
        self.Trinket.Icon:SetInside(self.Trinket, 4, 4)
        self.Trinket.Icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

        self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", Path, true)

        return true
    end
end

local Disable = function(self)
    if self.Trinket then
        self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED", Path)

        return false
    end
end

oUF:AddElement("Trinket", Path, Enable, Disable)
