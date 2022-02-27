local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:CreateVehicleExitBar()
    local bar = CreateFrame("Frame", addonName .. "_VehicleExitBar", UIParent)
    bar.buttons = {}
    bar.config = AB.config.vehicleExitBar

    local button = CreateFrame("Button", "$parent_Button", bar)
    button:SetPoint("TOPLEFT")
    button:SetPoint("BOTTOMRIGHT")
    button:SetScript("OnClick", AB.VehicleExitButton_OnClick)
    button:SetScript("OnEvent", AB.VehicleExitButton_OnEvent)
    button:SetScript("OnEnter", AB.VehicleExitButton_OnEnter)
    button:SetScript("OnLeave", AB.VehicleExitButton_OnLeave)
    button:RegisterEvent("UNIT_ENTERED_VEHICLE")
    button:RegisterEvent("UNIT_EXITED_VEHICLE")
    button:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
    if R.isRetail then button:RegisterEvent("UPDATE_MULTI_CAST_ACTIONBAR") end
    button:RegisterEvent("VEHICLE_UPDATE")

    button:SetNormalTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up")
    button:GetNormalTexture():SetTexCoord(0.140625, 0.859375, 0.140625, 0.859375)
    button:SetPushedTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
    button:GetPushedTexture():SetTexCoord(0.140625, 0.859375, 0.140625, 0.859375)
    button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
    button:GetHighlightTexture():SetBlendMode("ADD")

    button:CreateBorder({1, 0, 0}, nil, 2)

    bar.buttons[1] = button

    bar.Update = function(self) AB.VehicleExitButton_OnEvent(button) end

    bar:CreateBackdrop({bgFile = R.media.textures.blank})
    bar:CreateBorder()
    bar:CreateShadow()
    bar:CreateFader(bar.config.fader, bar.buttons)
    bar:CreateMover(bar:GetName(), AB.defaults.vehicleExitBar.point)

    return bar
end

function AB:VehicleExitButton_OnEvent()
    if UnitOnTaxi("player") or (_G.CanExitVehicle and CanExitVehicle()) then
        self:Show()
        self:GetNormalTexture():SetDesaturated(false)
        self:Enable()
    else
        self:Hide()
    end
end

function AB:VehicleExitButton_OnEnter()
    if (UnitOnTaxi("player")) then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(TAXI_CANCEL, 1, 1, 1)
        GameTooltip:AddLine(TAXI_CANCEL_DESCRIPTION, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
        GameTooltip:Show()
    elseif GameTooltip_AddNewbieTip then
        GameTooltip_AddNewbieTip(self, LEAVE_VEHICLE, 1.0, 1.0, 1.0, nil)
    end
end

function AB:VehicleExitButton_OnLeave() GameTooltip:Hide() end

function AB:VehicleExitButton_OnClick()
    if UnitOnTaxi("player") then
        TaxiRequestEarlyLanding()

        self:SetButtonState("NORMAL")
        self:GetNormalTexture():SetDesaturated(true)
        self:Disable()
    elseif _G.VehicleExit then
        VehicleExit()
    end
end
