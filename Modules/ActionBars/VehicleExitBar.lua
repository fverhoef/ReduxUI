local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:CreateVehicleExitBar()
    local config = AB.config.vehicleExitBar
    local default = AB.defaults.vehicleExitBar

    -- create new parent frame for buttons
    local frame = CreateFrame("Frame", addonName .. "VehicleExitBar", UIParent, "SecureHandlerStateTemplate")
    frame.config = config
    frame:SetSize(36, 36)
    frame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 200)

    MainMenuBarVehicleLeaveButton:ClearAllPoints()
    MainMenuBarVehicleLeaveButton:SetParent(frame)
    MainMenuBarVehicleLeaveButton:SetInside()

    AB:SecureHook(MainMenuBarVehicleLeaveButton, "SetPoint", function(_, _, parent)
        if parent ~= frame then
            MainMenuBarVehicleLeaveButton:ClearAllPoints()
            MainMenuBarVehicleLeaveButton:SetParent(frame)
            MainMenuBarVehicleLeaveButton:SetPoint("CENTER", frame, "CENTER")
        end
    end)

    AB:SecureHook(MainMenuBarVehicleLeaveButton, "SetHighlightTexture", function(btn, tex)
        if tex ~= btn.hover then
            MainMenuBarVehicleLeaveButton:SetHighlightTexture(btn.hover)
        end
    end)

    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
    local function HandleEvent(this, event)
        if event ~= "PLAYER_ENTERING_WORLD" and event ~= "UPDATE_BONUS_ACTIONBAR" then
            return
        end
        if UnitOnTaxi("player") then
            frame:Show()
            MainMenuBarVehicleLeaveButton:Show()
        else
            frame:Hide()
            MainMenuBarVehicleLeaveButton:Hide()
        end
    end
    frame:HookScript("OnEvent", HandleEvent)

    frame:CreateFader(config.fader, {MainMenuBarVehicleLeaveButton})
    R:CreateDragFrame(frame, "Vehicle Exit Bar", default.point)

    return frame
end

function AB:UpdateVehicleExitBar()
    local config = AB.config.vehicleExitBar
    local frame = AB.bars.VehicleExitBar

    if config.enabled then
        frame:Show()
        frame:Point(unpack(config.point))
    else
        frame:Hide()
    end
end
