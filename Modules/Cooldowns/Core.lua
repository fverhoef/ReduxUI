local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local CD = Addon.Modules.Cooldowns
CD.RegisteredCooldowns = {}

local ICON_SIZE = 36 -- the normal size for an icon (don't change this)
local FONT_SIZE = 20 -- the base font size to use at a scale of 1
local MIN_SCALE = 0.5 -- the minimum scale we want to show cooldown counts at, anything below this will be hidden
local MIN_DURATION = 2 -- the minimum duration to show cooldown text for

CD.TimeThreshold = 3

CD.TimeColors = { -- aura time colors
    [0] = "|cffeeeeee", -- days
    [1] = "|cffeeeeee", -- hours
    [2] = "|cffeeeeee", -- minutes
    [3] = "|cffeeeeee", -- seconds
    [4] = "|cfffe0000", -- expire (fade timer)
    [5] = "|cff909090", -- mmss
    [6] = "|cff707070" -- hhmm
}

CD.TimeFormats = { -- short / indicator color
    [0] = {"%dd", "%d%sd|r"},
    [1] = {"%dh", "%d%sh|r"},
    [2] = {"%dm", "%d%sm|r"},
    [3] = {"%ds", "%d%ss|r"},
    [4] = {"%.1fs", "%.1f%ss|r"},
    [5] = {"%d:%02d", "%d%s:|r%02d"}, -- mmss
    [6] = {"%d:%02d", "%d%s:|r%02d"} -- hhmm
}

for _, x in pairs(CD.TimeFormats) do
    x[3] = gsub(x[1], "s$", "") -- 1 without seconds
    x[4] = gsub(x[2], "%%ss", "%%s") -- 2 without seconds
end

CD.TimeIndicatorColors = {[0] = "|cff00b3ff", [1] = "|cff00b3ff", [2] = "|cff00b3ff", [3] = "|cff00b3ff", [4] = "|cff00b3ff", [5] = "|cff00b3ff", [6] = "|cff00b3ff"}

local DAY, HOUR, MINUTE = 86400, 3600, 60 -- used for calculating aura time text
local DAYISH, HOURISH, MINUTEISH = HOUR * 23.5, MINUTE * 59.5, 59.5 -- used for caclculating aura time at transition points
local HALFDAYISH, HALFHOURISH, HALFMINUTEISH = DAY / 2 + 0.5, HOUR / 2 + 0.5, MINUTE / 2 + 0.5 -- used for calculating next update times
local Infinity = math.huge

function CD:GetTimeInfo(s, threshhold, hhmm, mmss)
    if s == Infinity then
        return
    end

    if s < MINUTE then
        if s >= threshhold then
            return floor(s), 3, 0.51
        else
            return s, 4, 0.051
        end
    elseif s < HOUR then
        if mmss and s < mmss then
            return s / MINUTE, 5, 0.51, s % MINUTE
        else
            local minutes = floor((s / MINUTE) + .5)
            if hhmm and s < (hhmm * MINUTE) then
                return s / HOUR, 6, minutes > 1 and (s - (minutes * MINUTE - HALFMINUTEISH)) or (s - MINUTEISH), minutes % MINUTE
            else
                return ceil(s / MINUTE), 2, minutes > 1 and (s - (minutes * MINUTE - HALFMINUTEISH)) or (s - MINUTEISH)
            end
        end
    elseif s < DAY then
        if mmss and s < mmss then
            return s / MINUTE, 5, 0.51, s % MINUTE
        elseif hhmm and s < (hhmm * MINUTE) then
            local minutes = floor((s / MINUTE) + .5)
            return s / HOUR, 6, minutes > 1 and (s - (minutes * MINUTE - HALFMINUTEISH)) or (s - MINUTEISH), minutes % MINUTE
        else
            local hours = floor((s / HOUR) + .5)
            return ceil(s / HOUR), 1, hours > 1 and (s - (hours * HOUR - HALFHOURISH)) or (s - HOURISH)
        end
    else
        local days = floor((s / DAY) + .5)
        return ceil(s / DAY), 0, days > 1 and (s - (days * DAY - HALFDAYISH)) or (s - DAYISH)
    end
end

function CD:RegisterCooldown(cooldown)
    if not cooldown.isHooked then
        hooksecurefunc(cooldown, "SetCooldown", CD.OnSetCooldown)
        cooldown.isHooked = true
    end

    if not cooldown.isRegisteredCooldown then
        table.insert(CD.RegisteredCooldowns, cooldown)
        cooldown.isRegisteredCooldown = true
    end
end

function CD:OnSetCooldown(start, duration)
    if (not self.forceDisabled) and (start and duration) and (duration > MIN_DURATION) then
        local timer = self.timer or CD:CreateCooldownTimer(self)
        timer.start = start
        timer.duration = duration
        timer.endTime = start + duration
        timer.endCooldown = timer.endTime - 0.05
        CD:ForceUpdate(timer)
    elseif self.timer then
        CD:StopTimer(self.timer)
    end
end

function CD:CreateCooldownTimer(parent)
    local timer = CreateFrame("Frame", nil, parent)
    timer:Hide()
    timer:SetAllPoints()
    timer.parent = parent
    parent.timer = timer

    local text = timer:CreateFontString(nil, "OVERLAY")
    text:SetPoint("LEFT", timer, "LEFT")
    text:SetPoint("RIGHT", timer, "RIGHT")
    text:SetJustifyH("CENTER")
    timer.text = text

    CD:ToggleBlizzardCooldownText(parent, timer)

    -- keep an eye on the size so we can rescale the font if needed
    CD:OnSizeChanged(timer, parent:GetWidth())
    parent:SetScript("OnSizeChanged", function(_, width)
        CD:OnSizeChanged(timer, width)
    end)

    timer:SetScript("OnUpdate", CD.OnUpdate)

    return timer
end

function CD:StopTimer(cd)
    cd:Hide()
end

function CD:ForceUpdate(cooldown)
    CD.OnUpdate(cooldown, -1)
    cooldown:Show()
end

function CD:OnUpdate(elapsed)
    local forced = elapsed == -1
    if forced then
        self.nextUpdate = 0
    elseif self.nextUpdate > 0 then
        self.nextUpdate = self.nextUpdate - elapsed
        return
    end

    if not CD:IsEnabled(self) then
        CD:StopTimer(self)
    else
        local now = GetTime()
        if self.endCooldown and now >= self.endCooldown then
            CD:StopTimer(self)
        elseif CD:IsBelowScale(self) then
            self.text:SetText("")
            if not forced then
                self.nextUpdate = 500
            end
        elseif CD:IsOverTextThreshold(self, now) then
            self.text:SetText("")
            if not forced then
                self.nextUpdate = 1
            end
        elseif self.endTime then
            local value, id, nextUpdate, remainder = CD:GetTimeInfo(self.endTime - now, self.threshold, self.hhmmThreshold, self.mmssThreshold)
            if not forced then
                self.nextUpdate = nextUpdate
            end

            local style = CD.TimeFormats[id]
            if style then
                local which = (self.textColors and 2 or 1) + (self.showSeconds and 0 or 2)
                if self.textColors then
                    self.text:SetFormattedText(style[which], value, self.textColors[id], remainder)
                else
                    self.text:SetFormattedText(style[which], value, remainder)
                end
            end

            local color = self.timeColors[id]
            if color then
                self.text:SetTextColor(color.r, color.g, color.b)
            end
        end
    end
end

function CD:ToggleBlizzardCooldownText(cd, timer, request)
    if timer and cd and cd.SetHideCountdownNumbers then
        local forceHide = cd.hideText or timer.hideBlizzard
        if request then
            return forceHide or CD:IsEnabled(timer)
        else
            cd:SetHideCountdownNumbers(forceHide or CD:IsEnabled(timer) or false)
        end
    end
end

function CD:IsEnabled(cd)
    if cd.forceEnabled then
        return true
    elseif cd.forceDisabled then
        return false
    else
        return CD.config.db.enabled
    end
end

function CD:IsOverTextThreshold(cd, now)
    if cd.parent and cd.parent.textThreshold and cd.endTime then
        return (cd.endTime - now) >= cd.parent.textThreshold
    end
end

function CD:IsBelowScale(cd)
    if cd.parent and cd.parent.hideText then
        return true
    end

    return cd.fontScale and (cd.fontScale < MIN_SCALE)
end

function CD:OnSizeChanged(cd, width, force)
    local scale = width and (floor(width + 0.5) / ICON_SIZE)

    -- dont bother updating when the fontScale is the same, unless we are passing the force arg
    if scale and (scale == cd.fontScale) and (force ~= true) then
        return
    end
    cd.fontScale = scale

    if CD:IsBelowScale(cd) then
        scale = MIN_SCALE
    end

    if scale then
        cd.text:SetFont(CD.config.db.profile.font, (scale * FONT_SIZE), "OUTLINE")
    end
end
