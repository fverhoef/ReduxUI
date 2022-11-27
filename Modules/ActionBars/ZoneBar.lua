local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:CreateZoneBar()
    if not R.isRetail then
        return
    end

    local bar = CreateFrame("Frame", addonName .. "ZoneAbilityBar", UIParent)
    bar.config = AB.config.zoneBar

    bar.Update = function(self)
        ZoneAbilityFrame:SetParent(bar)
    end

    ZoneAbilityFrame:SetParent(bar)
    ZoneAbilityFrame:ClearAllPoints()
    ZoneAbilityFrame:SetAllPoints()
    ZoneAbilityFrame.ignoreInLayout = true

    bar:SetScript("OnEvent", bar.OnEvent)
    AB:SecureHook(ZoneAbilityFrame, "SetParent", AB.ZoneAbilityFrame_SetParent)
    AB:SecureHook(ZoneAbilityFrame.SpellButtonContainer, "SetSize", AB.ZoneAbilityFrame_SpellButtonContainer_SetSize)

    -- R:Disable(ZoneAbilityFrame.Style)
    bar:CreateMover("ZoneBar", AB.defaults.zoneBar.point)
    bar:CreateFader(bar.config.fader)
    bar:SetNormalizedPoint(bar.config.point)

    bar:Update()

    return bar
end

function AB:ZoneAbilityFrame_SetParent(parent)
    if parent == AB.zoneBar then
        return
    end

    if InCombatLockdown() then
        AB.zoneBar.needsUpdate = true
        AB.zoneBar:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    AB.zoneBar:Update()
end

function AB:ZoneAbilityFrame_SpellButtonContainer_SetSize()
    local width, height = ZoneAbilityFrame.SpellButtonContainer:GetSize()
    AB.zoneBar:SetSize(width + 4, height + 4)
end

AB.ZoneBarMixin = {}

function AB.ZoneBarMixin:OnEvent(event)
    if event == "PLAYER_REGEN_ENABLED" then
        self:Update()
        self.needsUpdate = false
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    end
end
