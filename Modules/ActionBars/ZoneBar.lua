local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:CreateZoneBar()
    if not R.isRetail then return end

    local bar = CreateFrame("Frame", addonName .. "ZoneAbilityBar", UIParent)
    bar.config = AB.config.zoneBar

    bar.Update = function(self)
         ZoneAbilityFrame:SetParent(bar)
    end

    ZoneAbilityFrame:SetParent(bar)
    ZoneAbilityFrame:ClearAllPoints()
    ZoneAbilityFrame:SetAllPoints()
    ZoneAbilityFrame.ignoreInLayout = true

    bar:SetScript("OnEvent", function(self, event)
        if event == "PLAYER_REGEN_ENABLED" then
            bar:Update()
            bar.needsUpdate = false
            bar:UnregisterEvent("PLAYER_REGEN_ENABLED")
        end
    end)
    AB:SecureHook(ZoneAbilityFrame, "SetParent", function(self, parent)
        if parent == bar then return end

        if InCombatLockdown() then
            bar.needsUpdate = true
            bar:RegisterEvent("PLAYER_REGEN_ENABLED")
            return
        end

        bar:Update()
    end)
    AB:SecureHook(ZoneAbilityFrame, "UpdateDisplayedZoneAbilities", function(self)
        for button in self.SpellButtonContainer:EnumerateActive() do
            -- R.Modules.ButtonStyles:StyleActionButton(button)
        end
    end)
    AB:SecureHook(ZoneAbilityFrame.SpellButtonContainer, "SetSize", function(self)
        local width, height = ZoneAbilityFrame.SpellButtonContainer:GetSize()
        bar:SetSize(width + 4, height + 4)
    end)

    -- R:Disable(ZoneAbilityFrame.Style)
    R:CreateMover(bar, "ZoneBar", AB.defaults.zoneBar.point)
    R:CreateFader(bar, bar.config.fader)
    R:SetPoint(bar, bar.config.point)

    bar:Update()

    return bar
end
