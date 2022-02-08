local addonName, ns = ...
local R = _G.ReduxUI
local SS = R:AddModule("ScreenSaver", "AceEvent-3.0")
local L = R.L

local CAMERA_SPEED = 0.035

function SS:Initialize()
    if not SS.config.enabled then return end

    SS.Canvas = _G.ScreenSaverCanvas
    SS.Canvas:Initialize()
    SS.Canvas:Configure()

    SS:Toggle()

    SS:RegisterEvent("PLAYER_FLAGS_CHANGED", SS.OnEvent)
    SS:RegisterEvent("PLAYER_ENTERING_WORLD", SS.OnEvent)
    SS:RegisterEvent("PLAYER_LEAVING_WORLD", SS.OnEvent)
    SS:RegisterEvent("PLAYER_LOGIN", SS.OnEvent)
    SS:RegisterEvent("PLAYER_REGEN_DISABLED", SS.OnEvent)
    SS:RegisterEvent("UPDATE_BATTLEFIELD_STATUS", SS.OnEvent)
end

function SS:OnEvent() SS:Toggle() end

function SS:Toggle()
    if UnitIsAFK("player") then
        SS:Show()
    else
        SS:Hide()
    end
end

function SS:Show()
    if SS.isActive then return end

    SS.isActive = true

    MoveViewLeftStart(CAMERA_SPEED)
    _G.UIParent:Hide()
    CloseAllWindows()
    SS.startTime = GetTime()
    SS.timer = SS:ScheduleRepeatingTimer(SS.Canvas.UpdateTimer, 1, SS.Canvas)

    SS.Canvas:Enable()

    SetCVar("autoClearAFK", "1")
end

function SS:Hide()
    if not SS.isActive then return end
    if InCombatLockdown() or CinematicFrame:IsShown() or MovieFrame:IsShown() then return end

    SS.isActive = false

    MoveViewLeftStop()
    _G.UIParent:Show()
    SS:CancelTimer(SS.timer)
    SS.timer = nil
    SS.Canvas:Disable()
end
