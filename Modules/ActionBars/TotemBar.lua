local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

local L = R.L

function AB:CreateTotemBar()
    if R.isRetail then
        return
    end

    local bar = _G.MultiCastActionBarFrame
    bar:SetParent(UIParent)
    bar:Show()
    bar.config = AB.config.totemBar
    bar.defaults = AB.defaults.totemBar

    bar:SetScript("OnShow", nil)
    bar:SetScript("OnHide", nil)
    bar:SetScript("OnUpdate", nil)

    bar.ignoreFramePositionManager = true
    bar:SetAttribute("ignoreFramePositionManager", true)
    UIPARENT_MANAGED_FRAME_POSITIONS[bar:GetName()] = nil

    bar.buttons = { MultiCastSummonSpellButton, MultiCastRecallSpellButton }
    for i = 1, 4 do
        table.insert(bar.buttons, _G["MultiCastSlotButton" .. i])
    end
    for i = 1, 12 do
        table.insert(bar.buttons, _G["MultiCastActionButton" .. i])
    end

    bar:CreateBackdrop({ bgFile = R.media.textures.blank })
    bar:CreateBorder()
    bar:CreateShadow()
    bar:CreateMover(L["Totem Bar"], bar.defaults.point)
    bar:CreateFader(bar.config.fader, bar.buttons)

    AB:RegisterEvent("PLAYER_ENTERING_WORLD", AB.PositionTotemBarButtons)
    AB:SecureHook("MultiCastActionBarFrame_Update", AB.PositionTotemBarButtons)

    return bar
end

function AB:ConfigureTotemBar()
    if R.isRetail then
        return
    end

    local bar = _G.MultiCastActionBarFrame

    bar:ClearAllPoints()
    bar:SetNormalizedPoint(bar.config.point)

    bar.Backdrop:SetShown(bar.config.backdrop)
    bar.Border:SetShown(bar.config.border)
    bar.Shadow:SetShown(bar.config.shadow)
    bar.Mover:Unlock()

    -- TODO: KeyBound support
end

function AB:PositionTotemBarButtons()
    local bar = _G.MultiCastActionBarFrame

    MultiCastSummonSpellButton:ClearAllPoints()
    MultiCastSummonSpellButton:SetPoint("BOTTOMLEFT", MultiCastActionBarFrame, "BOTTOMLEFT", 0, 0)

    MultiCastSlotButton1:ClearAllPoints()
    MultiCastSlotButton1:SetPoint("LEFT", MultiCastSummonSpellButton, "RIGHT", bar.config.columnSpacing, 0)
    MultiCastSlotButton2:SetPoint("LEFT", MultiCastSlotButton1, "RIGHT", bar.config.columnSpacing, 0)
    MultiCastSlotButton3:SetPoint("LEFT", MultiCastSlotButton2, "RIGHT", bar.config.columnSpacing, 0)
    MultiCastSlotButton4:SetPoint("LEFT", MultiCastSlotButton3, "RIGHT", bar.config.columnSpacing, 0)

    MultiCastRecallSpellButton:ClearAllPoints()
    MultiCastRecallSpellButton:SetPoint("LEFT", MultiCastSlotButton4, "RIGHT", bar.config.columnSpacing, 0)

    for i = 1, 3 do
        for j = 1, 4 do
            local actionButton = _G["MultiCastActionButton" .. (j + (i - 1) * 4)]
            local slotButton = _G["MultiCastSlotButton" .. j]
            actionButton:ClearAllPoints()
            actionButton:SetPoint("CENTER", slotButton, "CENTER")
        end
    end

    for _, button in ipairs(bar.buttons) do
        button:SetNormalizedSize(bar.config.buttonSize)
    end
end
