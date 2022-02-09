local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:CreateMicroButtonAndBagsBar()
    if not MicroButtonAndBagsBar then
        MicroButtonAndBagsBar = CreateFrame("Frame", "MicroButtonAndBagsBar", MainMenuBar, "MicroButtonAndBagsBarTemplate")
        MicroButtonAndBagsBar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
    end

    MicroButtonAndBagsBar.buttonList = {
        MainMenuBarBackpackButton,
        CharacterBag0Slot,
        CharacterBag1Slot,
        CharacterBag2Slot,
        CharacterBag3Slot,
        SettingsMicroButton
    }
	for i=1, #MICRO_BUTTONS do
		table.insert(MicroButtonAndBagsBar.buttonList, _G[MICRO_BUTTONS[i]])
	end
    AB.UpdateMicroButtonsParent(MicroButtonAndBagsBar)
    MicroButtonAndBagsBar:CreateFader(AB.config.microButtonAndBags.fader, MicroButtonAndBagsBar.buttonList)

    if not MicroButtonAndBagsBar.MicroBagBarEndCap then
        MicroButtonAndBagsBar.MicroBagBarEndCap = MicroButtonAndBagsBar:CreateTexture("MicroBagBarEndCap", "BACKGROUND", nil, 7)
        MicroButtonAndBagsBar.MicroBagBarEndCap:SetSize(96, 88)
        MicroButtonAndBagsBar.MicroBagBarEndCap:SetPoint("BOTTOMLEFT", MicroButtonAndBagsBar, "BOTTOMLEFT", -24, 0)
        MicroButtonAndBagsBar.MicroBagBarEndCap:SetTexture(R.media.textures.actionBars.mainMenuBar)
        MicroButtonAndBagsBar.MicroBagBarEndCap:SetTexCoord(0.238281, 0.332031, 0.652344, 0.996094)
    end
    
    AB:SecureHook("MoveMicroButtons", AB.MoveMicroButtons)
    AB:SecureHook("UpdateMicroButtonsParent", AB.UpdateMicroButtonsParent)
end

function AB:MoveCharacterMicroButton()
    CharacterMicroButton:ClearAllPoints()
    CharacterMicroButton:SetPoint("BOTTOMLEFT", MicroButtonAndBagsBar, "BOTTOMLEFT", -18, 3)
end

AB.MoveMicroButtons = function(anchor, anchorTo, relAnchor, x, y, isStacked)
    if (anchorTo == MicroButtonAndBagsBar or anchorTo == MainMenuBarArtFrame) then
        AB:MoveCharacterMicroButton()
    end
end

AB.UpdateMicroButtonsParent = function(parent)
    if parent == MainMenuBarArtFrame or parent == MicroButtonAndBagsBar then
        for i, button in ipairs(MicroButtonAndBagsBar.buttonList) do
            button:SetParent(MicroButtonAndBagsBar)
        end
        SettingsMicroButton:Show()
    else
        SettingsMicroButton:Hide()
    end
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

    tooltip:AddDoubleLine(L["Latency:"], R.SystemInfo.homePing, labelColor[1], labelColor[2], labelColor[3], latencyColor[1],
                          latencyColor[2], latencyColor[3])

    local fpsColor
    if R.SystemInfo.framerate > AB.config.microButtonAndBags.mediumFpsTreshold then
        fpsColor = AB.config.microButtonAndBags.highFpsColor
    elseif R.SystemInfo.framerate > AB.config.microButtonAndBags.lowFpsTreshold then
        fpsColor = AB.config.microButtonAndBags.mediumFpsColor
    else
        fpsColor = AB.config.microButtonAndBags.lowFpsColor
    end

    tooltip:AddDoubleLine(L["Framerate:"], R.SystemInfo.framerate, labelColor[1], labelColor[2], labelColor[3], fpsColor[1], fpsColor[2],
                          fpsColor[3])

    if R.SystemInfo.useIPv6 then
        tooltip:AddDoubleLine(L["Home Protocol:"], ipTypes[R.SystemInfo.ipTypeHome or 0] or UNKNOWN, labelColor[1], labelColor[2],
                              labelColor[3], valueColor[1], valueColor[2], valueColor[3])
        tooltip:AddDoubleLine(L["World Protocol:"], ipTypes[R.SystemInfo.ipTypeWorld or 0] or UNKNOWN, labelColor[1], labelColor[2],
                              labelColor[3], valueColor[1], valueColor[2], valueColor[3])
    end

    if R.SystemInfo.bandwidth ~= 0 then
        tooltip:AddDoubleLine(L["Bandwidth"], format(bandwidthString, R.SystemInfo.bandwidth), labelColor[1], labelColor[2],
                              labelColor[3], valueColor[1], valueColor[2], valueColor[3])
        tooltip:AddDoubleLine(L["Download"], format(percentageString, GetDownloadedPercentage() * 100), labelColor[1], labelColor[2],
                              labelColor[3], valueColor[1], valueColor[2], valueColor[3])
        tooltip:AddLine(" ")
    end

    tooltip:AddDoubleLine(L["Total Memory:"], R.SystemInfo:FormatMemory(R.SystemInfo.totalMemory), labelColor[1], labelColor[2],
                          labelColor[3], valueColor[1], valueColor[2], valueColor[3])
    local totalCPU
    if R.SystemInfo.cpuProfiling then
        tooltip:AddDoubleLine(L["Total CPU:"], format(homeLatencyString, R.SystemInfo.totalCPU), labelColor[1], labelColor[2],
                              labelColor[3], valueColor[1], valueColor[2], valueColor[3])
    end

    tooltip:AddLine(" ")
    if R.SystemInfo.cpuProfiling then
        for i = 1, #R.SystemInfo.cpuTable do
            if (not IsShiftKeyDown()) and (i > AB.config.microButtonAndBags.addonsToDisplay) then
                tooltip:AddLine(L["(Hold Shift) Show All Addons"]) -- TODO: Localize
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
                tooltip:AddLine(L["(Hold Shift) Show All Addons"]) -- TODO: Localize
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