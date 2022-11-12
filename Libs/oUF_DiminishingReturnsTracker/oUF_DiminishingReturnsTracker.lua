local _, ns = ...
local oUF = ns.oUF
assert(oUF, "oUF not loaded")

local DRList = _G.LibStub("DRList-1.0")
if not DRList then
    return
end

local DR_STATE_COLORS = {
    { r = 0, g = 1, b = 0, a = 1 }, -- applied 1, green
    { r = 1, g = 1, b = 0, a = 1 }, -- applied 2, yellow
    { r = 1, g = 0, b = 0, a = 1 } -- applied 3, red
}

local trackers = {}
local trackerCount = 0

local AddTracker = function(unit, tracker)
    trackers[unit] = tracker
    trackerCount = trackerCount + 1
end

local RemoveTracker = function(unit)
    trackers[unit] = nil
    trackerCount = trackerCount - 1
end

local GetAuraInfo = function(unit, spellID)
    if not unit or not spellID then
        return
    end

    for i = 1, 40 do
        local _, texture, _, _, duration, expirationTime, _, _, _, id = UnitAura(unit, i, "HARMFUL")
        if not id then
            return
        end -- no more debuffs

        if spellID == id then
            return duration, expirationTime, texture
        end
    end
end

local CreateTimer = function(self, category)
    local timer = CreateFrame("Frame", "$parentTimer_" .. category, self)
    timer:SetSize(self.iconSize or 24, self.iconSize or 24)
    timer.Category = category
    timer.Count = 0
    timer.Start = 0
    timer.Duration = 0
    timer.Expiration = 0

    timer.Cooldown = CreateFrame("Cooldown", nil, timer)
    timer.Cooldown:SetAllPoints()
    timer.Cooldown.Text = timer.Cooldown:GetRegions()

    timer.Icon = timer:CreateTexture(nil, "BACKGROUND")
    timer.Icon:SetAllPoints()
    timer.Icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

    timer.IsExpired = function(self)
        return self.Expiration < GetTime()
    end

    if self.PostCreateTimer then
        self:PostCreateTimer(timer)
    end

    return timer
end

local UpdateTimer = function(self, unit, category, spellID)
    local timer = self.Timers[category]
    if not timer then
        timer = self:CreateTimer(category)
        self.Timers[category] = timer
    end

    local auraDuration, auraExpiration, auraTexture = GetAuraInfo(unit, spellID)
    local drTime = DRList:GetResetTime(category)

    if timer:IsExpired() then
        timer.Count = 1
    elseif timer.Count < 3 then
        timer.Count = timer.Count + 1
    end

    if timer.Count < 4 then
        timer.Start = GetTime()
        timer.Duration = auraDuration + drTime
        timer.Expiration = auraExpiration + drTime
    end

    timer.Icon:SetTexture(auraTexture)

    local textColor = (self.StateColors or DR_STATE_COLORS)[timer.Count]
    timer.Cooldown.Text:SetTextColor(textColor.r, textColor.g, textColor.b, textColor.a or 1)

    timer:SetSize(self.iconSize or 24, self.iconSize or 24)

    CooldownFrame_Set(timer.Cooldown, GetTime(), timer.Duration, 1)

    if self.PostUpdateTimer then
        self:PostUpdateTimer(timer)
    end

    self:LayoutTimers()

    C_Timer.After(timer.Duration, function()
        self:LayoutTimers()
    end)
end

local LayoutTimers = function(self)
    local lastTimer
    for category, timer in pairs(self.Timers) do
        if not timer:IsExpired() then
            timer:Show()
            timer:ClearAllPoints()
            timer:SetPoint("LEFT", lastTimer or self, lastTimer and "RIGHT" or "LEFT", (lastTimer and (self.iconSpacing or 5)) or 0)

            lastTimer = timer
        else
            timer:Hide()
        end

        if self.PostLayoutTimer then
            self:PostLayoutTimer(timer)
        end
    end
end

local ResetTimers = function(self)
    for category, timer in pairs(self.Timers) do
        timer.Count = 0
        timer.Start = 0
        timer.Duration = 0
        timer.Expiration = 0
        timer:Hide()

        if self.PostResetTimer then
            self:PostResetTimer(timer)
        end
    end
end

local GetTracker = function(unitGUID)
    for unit, tracker in pairs(trackers) do
        if UnitGUID(unit) == unitGUID then
            return unit, tracker
        end
    end
end

local OnAuraApplied = function(category, destGUID, spellID)
    local unit, tracker = GetTracker(destGUID)
    if tracker then
        tracker:UpdateTimer(unit, category, spellID)
    end
end

local OnAuraRemoved = function(category, destGUID, spellID)
    local unit, tracker = GetTracker(destGUID)
    if tracker then
    end
end

local OnAuraRefresh = function(category, destGUID, spellID)
    local unit, tracker = GetTracker(destGUID)
    if tracker then
        tracker:UpdateTimer(unit, category, spellID)
    end
end

local Update = function(self, event, ...)
    if event == "ARENA_OPPONENT_UPDATE" then
        local unit, type = ...
        if type == "seen" then
            if UnitExists(unit) and UnitIsPlayer(unit) and trackers[unit] then
            end
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        for unit, tracker in pairs(trackers) do
            tracker:ResetTimers()
        end
    else
        if trackerCount <= 0 then
            return
        end

        local _, eventType, _, srcGUID, _, srcFlags, _, destGUID, _, destFlags, _, spellID, spellName, _, auraType = CombatLogGetCurrentEventInfo()

        if auraType == "DEBUFF" then
            local category = DRList:GetCategoryBySpellID(spellID)
            if not category or category == "knockback" then
                return
            end

            local isPlayer = bit.band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0
            if not isPlayer then
                return
            end

            if eventType == "SPELL_AURA_APPLIED" then
                OnAuraApplied(category, destGUID, spellID)
            elseif eventType == "SPELL_AURA_REMOVED" then
                OnAuraRemoved(category, destGUID, spellID)
            elseif eventType == "SPELL_AURA_REFRESH" then
                OnAuraRefresh(category, destGUID, spellID)
            end
        end
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:RegisterEvent("ARENA_OPPONENT_UPDATE")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", Update)

local Enable = function(self)
    if self.DiminishingReturnsTracker then
        AddTracker(self.unit, self.DiminishingReturnsTracker)

        if not self.DiminishingReturnsTracker.CreateTimer then
            self.DiminishingReturnsTracker.CreateTimer = CreateTimer
        end
        if not self.DiminishingReturnsTracker.UpdateTimer then
            self.DiminishingReturnsTracker.UpdateTimer = UpdateTimer
        end
        if not self.DiminishingReturnsTracker.LayoutTimers then
            self.DiminishingReturnsTracker.LayoutTimers = LayoutTimers
        end
        if not self.DiminishingReturnsTracker.ResetTimers then
            self.DiminishingReturnsTracker.ResetTimers = ResetTimers
        end

        self.DiminishingReturnsTracker.Timers = {}
    end
end

local Disable = function(self)
    if self.DiminishingReturnsTracker then
        RemoveTracker(self.unit)
    end
end

oUF:AddElement("DiminishingReturnsTracker", function()
    return
end, Enable, Disable)

-- incapacitate
-- stun
-- random_stun
-- opener_stun
-- fear
-- root
-- random_root
-- disarm
-- silence
-- horror
-- scatter
-- cyclone
-- mind_control
-- charge
-- counterattack
