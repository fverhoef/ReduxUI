local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:CreateMicroButtonAndBagsBar()
    local config = AB.config.microButtonAndBags
    local default = AB.defaults.microButtonAndBags

    local widthOffset = 0
    local playerLevel = UnitLevel("player")
    if (playerLevel < _G.SHOW_SPEC_LEVEL) then
        widthOffset = 93
    else
        widthOffset = 47
    end

    -- create new parent frame for buttons
    local frame = CreateFrame("Frame", addonName .. "MicroMenuBar", UIParent, "SecureHandlerStateTemplate")
    frame:SetSize(298 - widthOffset, 88)
    frame:SetPoint("BOTTOMRIGHT", _G.UIParent, "BOTTOMRIGHT", 0, 0)

    frame.Texture = frame:CreateTexture("BACKGROUND")
    frame.Texture:SetTexture(R.media.textures.actionBars.mainMenuBar)
    frame.Texture:SetTexCoord((257 + widthOffset) / 1024, (257 + 286) / 1024, 168 / 255, 255 / 255)
    frame.Texture:SetSize(286 - widthOffset, 88)
    frame.Texture:SetPoint("RIGHT", frame, "RIGHT", 0, 0)

    frame.TextureEndCap = frame:CreateTexture("BACKGROUND")
    frame.TextureEndCap:SetTexture(R.media.textures.actionBars.mainMenuBar)
    frame.TextureEndCap:SetTexCoord(245 / 1024, (245 + 12) / 1024, 168 / 255, 255 / 255)
    frame.TextureEndCap:SetSize(12, 88)
    frame.TextureEndCap:SetPoint("LEFT", frame, "LEFT", 0, 0)

    local previous
    local buttonList = {
        _G.MainMenuBarBackpackButton,
        _G.CharacterBag0Slot,
        _G.CharacterBag1Slot,
        _G.CharacterBag2Slot,
        _G.CharacterBag3Slot,
        _G.KeyRingButton
    }

    for _, buttonName in next, _G.MICRO_BUTTONS do
        local button = _G[buttonName]
        if button then
            local parent = frame
            local point = {"BOTTOMLEFT", frame, "BOTTOMLEFT", 6, 3}

            if previous then
                parent = previous
                point = {"BOTTOMLEFT", parent, "BOTTOMRIGHT", 1, 0}
            end

            AB:SetupButton(button, parent, 28, 58, point)
            previous = button

            table.insert(buttonList, button)
        end
    end

    AB:SetupButton(_G.MainMenuBarBackpackButton, frame, 40, 40, {"BOTTOMRIGHT", frame, "BOTTOMRIGHT", -6, 46})
    AB:SetupButton(_G.CharacterBag0Slot, frame, 30, 30, {"BOTTOMRIGHT", _G.MainMenuBarBackpackButton, "BOTTOMLEFT", -3, 0})
    AB:SetupButton(_G.CharacterBag1Slot, frame, 30, 30, {"BOTTOMRIGHT", _G.CharacterBag0Slot, "BOTTOMLEFT", -2, 0})
    AB:SetupButton(_G.CharacterBag2Slot, frame, 30, 30, {"BOTTOMRIGHT", _G.CharacterBag1Slot, "BOTTOMLEFT", -2, 0})
    AB:SetupButton(_G.CharacterBag3Slot, frame, 30, 30, {"BOTTOMRIGHT", _G.CharacterBag2Slot, "BOTTOMLEFT", -2, 0})

    R:FixNormalTextureSize(_G.MainMenuBarBackpackButton)
    R:FixNormalTextureSize(_G.CharacterBag0Slot)
    R:FixNormalTextureSize(_G.CharacterBag1Slot)
    R:FixNormalTextureSize(_G.CharacterBag2Slot)
    R:FixNormalTextureSize(_G.CharacterBag3Slot)

    if _G.KeyRingButton then
        AB:SetupButton(_G.KeyRingButton, frame, 16, 34, {"BOTTOMLEFT", _G.HelpMicroButton, "BOTTOMRIGHT", 2, 2})
        _G.KeyRingButton:Show()
    end

    if config.frameVisibility then
        frame.frameVisibility = config.frameVisibility
        RegisterStateDriver(frame, "visibility", config.frameVisibility)
    end

    if R.isClassic then
        _G.MainMenuMicroButton.PerformanceBar = CreateFrame("Frame", nil, _G.MainMenuMicroButton)
        _G.MainMenuMicroButton.PerformanceBar:SetSize(28, 58)
        _G.MainMenuMicroButton.PerformanceBar:SetPoint("BOTTOM", _G.MainMenuMicroButton, "BOTTOM", 0, 0)

        _G.MainMenuMicroButton.PerformanceBar.Texture = _G.MainMenuMicroButton.PerformanceBar:CreateTexture("OVERLAY")
        _G.MainMenuMicroButton.PerformanceBar.Texture:SetAllPoints()
        _G.MainMenuMicroButton.PerformanceBar.Texture:SetTexture(R.media.textures.actionBars.performanceBar)
    end

    AB:SecureHook("MicroButton_OnEnter", AB.MicroButton_OnEnter)
    AB:MainMenuMicroButton_Update()

    frame:CreateFader(config.fader, buttonList)
    R:CreateDragFrame(frame, "Micro Buttons & Bags Bar", default.point)

    return frame
end

function AB:MicroButton_OnEnter()
    if self == _G.MainMenuMicroButton then
        AB:AddSystemInfo(_G.GameTooltip)
    end
end

function AB:MainMenuMicroButton_Update()
    if R.isClassic then
        if _G.MainMenuMicroButton.hover then
            MicroButton_OnEnter(_G.MainMenuMicroButton)
        else
            R.SystemInfo:Update(false)
        end

        local latencyColor
        local latency = R.SystemInfo.homePing > R.SystemInfo.worldPing and R.SystemInfo.homePing or R.SystemInfo.worldPing
        if latency > AB.config.microButtonAndBags.mediumLatencyTreshold then
            latencyColor = AB.config.microButtonAndBags.highLatencyColor
        elseif latency > AB.config.microButtonAndBags.lowLatencyTreshold then
            latencyColor = AB.config.microButtonAndBags.mediumLatencyColor
        else
            latencyColor = AB.config.microButtonAndBags.lowLatencyColor
        end

        _G.MainMenuMicroButton.PerformanceBar.Texture:SetVertexColor(unpack(latencyColor))
    end

    AB:ScheduleTimer("MainMenuMicroButton_Update",
                     (_G.MainMenuMicroButton.hover and IsShiftKeyDown() and 1) or _G.PERFORMANCEBAR_UPDATE_INTERVAL)
end

function AB:UpdateMicroButtonAndBagsBar()
    local config = AB.config.microButtonAndBags
    local frame = AB.bars.MicroButtonAndBagsBar

    if config.enabled then
        frame:Show()

        if _G.TalentMicroButton and _G.QuestLogMicroButton then
            local widthOffset = 0
            local playerLevel = UnitLevel("player")
            if playerLevel < _G.SHOW_SPEC_LEVEL then
                _G.TalentMicroButton:Hide()
                _G.QuestLogMicroButton:SetPoint("BOTTOMLEFT", "TalentMicroButton", "BOTTOMLEFT", 0, 0)
                widthOffset = 98
            else
                _G.TalentMicroButton:Show()
                _G.QuestLogMicroButton:SetPoint("BOTTOMLEFT", "TalentMicroButton", "BOTTOMRIGHT", 1, 0)
                widthOffset = 38 -- 37
            end

            frame:SetSize(298 - widthOffset, 88)
            frame.Texture:SetTexCoord((257 + widthOffset) / 1024, (257 + 286) / 1024, 168 / 255, 255 / 255)
            frame.Texture:SetSize(286 - widthOffset, 88)
        end

        if _G.KeyRingButton and not _G.KeyRingButton:IsShown() then
            _G.KeyRingButton:Show()
        end
    else
        frame:Hide()
    end
end
