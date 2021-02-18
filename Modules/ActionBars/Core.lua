local addonName, ns = ...
local R = _G.ReduxUI
local AB = R:AddModule("ActionBars", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local CS = R.Modules.CharacterStats

AB.bars = {}

function AB:Initialize()
    if not AB.config.enabled then
        return
    end

    _G.SHOW_MULTI_ACTIONBAR_1 = AB.config.multiBarBottomLeft.enabled
    _G.SHOW_MULTI_ACTIONBAR_2 = AB.config.multiBarBottomRight.enabled
    _G.SHOW_MULTI_ACTIONBAR_3 = AB.config.multiBarLeft.enabled
    _G.SHOW_MULTI_ACTIONBAR_4 = AB.config.multiBarRight.enabled

    AB.bars.Artwork = AB:CreateArtwork()
    AB.bars.MainMenuBar = AB:CreateMainMenuBar()
    AB.bars.MultiBarBottomLeft = AB:CreateMultiBarBottomLeft()
    AB.bars.MultiBarBottomRight = AB:CreateMultiBarBottomRight()
    AB.bars.MultiBarRight = AB:CreateMultiBarRight()
    AB.bars.MultiBarLeft = AB:CreateMultiBarLeft()
    AB.bars.StanceBar = AB:CreateStanceBar()
    AB.bars.PetActionBar = AB:CreatePetActionBar()
    AB.bars.VehicleExitBar = AB:CreateVehicleExitBar()
    AB.bars.ExperienceBar = AB:CreateExperienceBar()
    AB.bars.ReputationBar = AB:CreateReputationBar()
    AB.bars.MaxLevelBar = AB:CreateMaxLevelBar()
    AB.bars.MicroButtonAndBagsBar = AB:CreateMicroButtonAndBagsBar()

    if R.isClassic then
        AB.bars.MageBar = CS.class == "MAGE" and AB:CreateMageBar() or nil
        AB.bars.ShamanBar = CS.class == "SHAMAN" and AB:CreateShamanBar() or nil
    end

    AB:RegisterEvent("PLAYER_ENTERING_WORLD")
    AB:RegisterEvent("ACTIONBAR_SHOW_BOTTOMLEFT")
    AB:RegisterEvent("BAG_UPDATE")
    AB:SecureHook("MainMenuBar_UpdateExperienceBars", AB.UpdateAll)

    AB:UpdateAll()
end

function AB:UpdateAll()
    AB:UpdateArtwork()
    AB:UpdateMainMenuBar()
    AB:UpdateMultiBarBottomLeft()
    AB:UpdateMultiBarBottomRight()
    AB:UpdateMultiBarLeft()
    AB:UpdateMultiBarRight()
    AB:UpdateStanceBar()
    AB:UpdatePetActionBar()
    AB:UpdateExperienceBar()
    AB:UpdateReputationBar()
    AB:UpdateMaxLevelBar()
    AB:UpdateMicroButtonAndBagsBar()
    AB:UpdateClassBars()
end

function AB:PLAYER_ENTERING_WORLD()
    AB:UpdateAll()
end

function AB:ACTIONBAR_SHOW_BOTTOMLEFT()
    AB:UpdateAll()
end

function AB:BAG_UPDATE()
    _G.MainMenuBarBackpackButtonCount:Show()
    _G.MainMenuBarBackpackButtonCount:ClearAllPoints()
    _G.MainMenuBarBackpackButtonCount:SetPoint("BOTTOMRIGHT", _G.MainMenuBarBackpackButton, "BOTTOMRIGHT", -2, 4)
    _G.MainMenuBarBackpackButtonCount:SetFont(_G.STANDARD_TEXT_FONT, 11, "OUTLINE")
    _G.MainMenuBarBackpackButtonCount:SetText(format("(%d)", _G.MainMenuBarBackpackButton.freeSlots))
end

function AB:HideBlizzardBar(framesToHide, framesToDisable)
    if framesToHide and type(framesToHide == "table") then
        for _, frame in next, framesToHide do
            frame:SetParent(R.HiddenFrame)
        end
    end
    if framesToDisable and type(framesToDisable == "table") then
        for _, frame in next, framesToDisable do
            frame:UnregisterAllEvents()
            frame:DisableScripts()
        end
    end
end

function AB:UpdateBar(frame)
    local buttons = frame.config.buttons
    local buttonsPerRow = frame.config.buttonsPerRow
    local width = frame.config.buttonSize[1]
    local height = frame.config.buttonSize[2]
    local columnDirection = frame.config.columnDirection
    local columnSpacing = frame.config.columnSpacing
    local rowDirection = frame.config.rowDirection
    local rowSpacing = frame.config.rowSpacing

    local columnMultiplier, columnAnchor, relativeColumnAnchor, rowMultiplier, rowAnchor, relativeRowAnchor
    if columnDirection == AB.COLUMN_DIRECTIONS.Right then
        columnMultiplier = 1
        columnAnchor = "TOPLEFT"
        relativeColumnAnchor = "TOPRIGHT"

        if rowDirection == AB.ROW_DIRECTIONS.Down then
            rowMultiplier = -1
            rowAnchor = "TOPLEFT"
            relativeRowAnchor = "BOTTOMLEFT"
        else
            rowMultiplier = 1
            rowAnchor = "BOTTOMLEFT"
            relativeRowAnchor = "TOPLEFT"
        end
    elseif columnDirection == AB.COLUMN_DIRECTIONS.Left then
        columnMultiplier = 1
        columnAnchor = "TOPRIGHT"
        relativeColumnAnchor = "TOPLEFT"

        if rowDirection == AB.ROW_DIRECTIONS.Down then
            rowMultiplier = -1
            rowAnchor = "TOPRIGHT"
            relativeRowAnchor = "BOTTOMRIGHT"
        else
            rowMultiplier = 1
            rowAnchor = "BOTTOMRIGHT"
            relativeRowAnchor = "TOPRIGHT"
        end
    end

    local rowCount, columnCount = 0, 0
    for i, button in next, frame.buttons do
        local parent = frame

        local point
        if i == 1 then
            point = {columnAnchor, frame, columnAnchor, 0, 0}
        elseif (i - 1) % buttonsPerRow == 0 then
            parent = frame.buttons[rowCount * buttonsPerRow + 1]
            point = {rowAnchor, parent, relativeRowAnchor, 0, rowMultiplier * rowSpacing}
            rowCount = rowCount + 1
        else
            parent = frame.buttons[i - 1]
            point = {columnAnchor, parent, relativeColumnAnchor, columnMultiplier * columnSpacing, 0}
        end

        AB:SetupButton(button, frame, width, height, point)

        if i > buttons then
            button:Hide()
        else
            button:Show()
        end

        columnCount = columnCount + 1
        if columnCount > buttonsPerRow then
            columnCount = buttonsPerRow
        end
    end

    frame:SetSize(columnCount * width + (columnCount - 1) * columnSpacing, (rowCount + 1) * height + rowCount * rowSpacing)
end

function AB:SetupButton(button, frame, width, height, point)
    if not frame.__blizzardBar then
        button:SetParent(frame)
    end
    button:SetSize(width, height)
    button:ClearAllPoints()
    button:SetPoint(unpack(point))
end

function AB:AddSystemInfo(tooltip)
    R.SystemInfo:Update(true)

    local ipTypes = {"IPv4", "IPv6"}
    local statusColors = {"|cff0CD809", "|cffE8DA0F", "|cffFF9000", "|cffD80909"}
    local fpsString = "%s%d|r"
    local bandwidthString = "%.2f Mbps"
    local percentageString = "%.2f%%"
    local homeLatencyString = "%d ms"
    local cpuString = "%d ms"
    local cpuAndMemoryString = "%d ms / %s"

    local labelColor = R.config.db.profile.colors.highlightFont
    local valueColor = R.config.db.profile.colors.normalFont

    tooltip:AddLine(" ")

    local latencyColor
    local latency = R.SystemInfo.homePing > R.SystemInfo.worldPing and R.SystemInfo.homePing or R.SystemInfo.worldPing
    if latency > AB.config.microButtonAndBags.mediumLatencyTreshold then
        latencyColor = AB.config.microButtonAndBags.highLatencyColor
    elseif latency > AB.config.microButtonAndBags.lowLatencyTreshold then
        latencyColor = AB.config.microButtonAndBags.mediumLatencyColor
    else
        latencyColor = AB.config.microButtonAndBags.lowLatencyColor
    end

    tooltip:AddDoubleLine("Latency:", R.SystemInfo.homePing, labelColor[1], labelColor[2], labelColor[3], latencyColor[1],
                          latencyColor[2], latencyColor[3])

    local fpsColor
    if R.SystemInfo.framerate > AB.config.microButtonAndBags.mediumFpsTreshold then
        fpsColor = AB.config.microButtonAndBags.highFpsColor
    elseif R.SystemInfo.framerate > AB.config.microButtonAndBags.lowFpsTreshold then
        fpsColor = AB.config.microButtonAndBags.mediumFpsColor
    else
        fpsColor = AB.config.microButtonAndBags.lowFpsColor
    end

    tooltip:AddDoubleLine("FPS:", R.SystemInfo.framerate, labelColor[1], labelColor[2], labelColor[3], fpsColor[1], fpsColor[2],
                          fpsColor[3])

    if R.SystemInfo.useIPv6 then
        tooltip:AddDoubleLine("Home Protocol:", ipTypes[R.SystemInfo.ipTypeHome or 0] or UNKNOWN, labelColor[1], labelColor[2],
                              labelColor[3], valueColor[1], valueColor[2], valueColor[3])
        tooltip:AddDoubleLine("World Protocol:", ipTypes[R.SystemInfo.ipTypeWorld or 0] or UNKNOWN, labelColor[1], labelColor[2],
                              labelColor[3], valueColor[1], valueColor[2], valueColor[3])
    end

    if R.SystemInfo.bandwidth ~= 0 then
        tooltip:AddDoubleLine("Bandwidth", format(bandwidthString, R.SystemInfo.bandwidth), labelColor[1], labelColor[2],
                              labelColor[3], valueColor[1], valueColor[2], valueColor[3])
        tooltip:AddDoubleLine("Download", format(percentageString, GetDownloadedPercentage() * 100), labelColor[1], labelColor[2],
                              labelColor[3], valueColor[1], valueColor[2], valueColor[3])
        tooltip:AddLine(" ")
    end

    tooltip:AddDoubleLine("Total Memory:", R.SystemInfo:FormatMemory(R.SystemInfo.totalMemory), labelColor[1], labelColor[2],
                          labelColor[3], valueColor[1], valueColor[2], valueColor[3])
    local totalCPU
    if R.SystemInfo.cpuProfiling then
        tooltip:AddDoubleLine("Total CPU:", format(homeLatencyString, R.SystemInfo.totalCPU), labelColor[1], labelColor[2],
                              labelColor[3], valueColor[1], valueColor[2], valueColor[3])
    end

    tooltip:AddLine(" ")
    if R.SystemInfo.cpuProfiling then
        for i = 1, #R.SystemInfo.cpuTable do
            if (not IsShiftKeyDown()) and (i > AB.config.microButtonAndBags.addonsToDisplay) then
                tooltip:AddLine("(Hold Shift) Show All Addons") -- TODO: Localize
                break
            end

            local cpu = R.SystemInfo.cpuTable[i]
            if cpu and IsAddOnLoaded(cpu[1]) then
                local addonCpuUsage = cpu[3] -- / R.SystemInfo.elapsed
                local red = addonCpuUsage / R.SystemInfo.totalCPU
                local green = 1 - red

                local mem
                for j = 1, #R.SystemInfo.memoryTable do
                    if R.SystemInfo.memoryTable[j][1] == cpu[1] then
                        mem = R.SystemInfo.memoryTable[j][1]
                        break
                    end
                end
                if mem then
                    tooltip:AddDoubleLine(cpu[2], format(cpuAndMemoryString, addonCpuUsage, R.SystemInfo:FormatMemory(mem)),
                                          labelColor[1], labelColor[2], labelColor[3], red, green + .5, 0)
                else
                    tooltip:AddDoubleLine(cpu[2], format(cpuString, addonCpuUsage), labelColor[1], labelColor[2], labelColor[3],
                                          red, green + .5, 0)
                end
            end
        end
    else
        for i = 1, #R.SystemInfo.memoryTable do
            if (not IsShiftKeyDown()) and (i > AB.config.microButtonAndBags.addonsToDisplay) then
                tooltip:AddLine("(Hold Shift) Show All Addons") -- TODO: Localize
                break
            end

            local ele = R.SystemInfo.memoryTable[i]
            if ele and IsAddOnLoaded(ele[1]) then
                local red = ele[3] / R.SystemInfo.totalMemory
                local green = 1 - red
                tooltip:AddDoubleLine(ele[2], R.SystemInfo:FormatMemory(ele[3]), labelColor[1], labelColor[2], labelColor[3], red,
                                      green + .5, 0)
            end
        end
    end

    tooltip:Show()
end
