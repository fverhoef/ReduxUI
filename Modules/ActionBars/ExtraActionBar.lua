local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:CreateExtraActionBar()
    if not R.isRetail then return end

    local bar = CreateFrame("Frame", addonName .. "ExtraActionBar", UIParent)
    bar.config = AB.config.extraActionBar

    bar.Update = function(self)
        if InCombatLockdown() then
            bar.needsUpdate = true
            bar:RegisterEvent("PLAYER_REGEN_ENABLED")
            return
        end 
        
        local width, height = ExtraActionBarFrame.button:GetSize()
        bar:SetSize(width + 4, height + 4)

        bar.needsUpdate = false
        bar:UnregisterEvent("PLAYER_REGEN_ENABLED")
        ExtraActionBarFrame:SetParent(bar)
    end

    _G.UIPARENT_MANAGED_FRAME_POSITIONS.ExtraAbilityContainer = nil
    ExtraAbilityContainer.SetSize = R.EmptyFunction

    ExtraActionBarFrame:SetParent(bar)
    ExtraActionBarFrame:ClearAllPoints()
    ExtraActionBarFrame:SetAllPoints()
    ExtraActionBarFrame.ignoreInLayout = true

    bar:SetScript("OnEvent", function(self, event)
        if event == "PLAYER_REGEN_ENABLED" and bar.needsUpdate then
            bar:Update()
        end
    end)
    AB:SecureHook(ExtraActionBarFrame, "SetParent", function(self, parent)
        if parent == bar then return end
        bar:Update()
    end)
    AB:SecureHook(ExtraAbilityContainer, "AddFrame", function(self, frame)
        bar:Update()       
    end)
    
	local width, height = ExtraActionBarFrame.button:GetSize()
	bar:SetSize(width + 4, height + 4)

    bar:CreateMover("ExtraActionBar", AB.defaults.extraActionBar.point)
    bar:CreateFader(bar.config.fader)
    bar:SetNormalizedPoint(bar.config.point)

    bar:Update()

    return bar
end
