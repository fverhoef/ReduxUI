local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

AB.SettingsMicroButtonMixin = {}
ReduxSettingsMicroButtonMixin = AB.SettingsMicroButtonMixin

function AB.SettingsMicroButtonMixin:OnLoad()
    self.tooltipText = R.title
    self.newbieText = L["Click to open config dialog. Shift-click to reload UI. Alt-click to lock/unlock frames."]
    self:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    self:SetNormalTexture(R.media.textures.actionBars.vanilla.microButtonSettings_Up)
    self:SetPushedTexture(R.media.textures.actionBars.vanilla.microButtonSettings_Down)
    self:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight")
    self:SetPoint("BOTTOMLEFT", R.isRetail and MainMenuMicroButton or HelpMicroButton, "BOTTOMRIGHT", -2, 0)
end

function AB.SettingsMicroButtonMixin:OnClick()
    if IsShiftKeyDown() then
        ReloadUI()
    elseif IsAltKeyDown() then
        R:ToggleMovers()
    else
        R:ShowOptionsDialog()
    end
end

function AB.SettingsMicroButtonMixin:OnEnter()
    GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
    GameTooltip:ClearLines()
    GameTooltip:AddLine(R.title)
    GameTooltip:AddLine(L["Click: show options dialog."], 1, 1, 1)
    GameTooltip:AddLine(L["Shift-click: reload UI."], 1, 1, 1)
    GameTooltip:AddLine(L["Alt-click: lock/unlock frames."], 1, 1, 1)
    
    if IsShiftKeyDown() then
        self:AddSystemInfo(GameTooltip)
    else
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(L["Hold Shift to show system statistics."])
    end

    GameTooltip:Show()
end

function AB.SettingsMicroButtonMixin:OnLeave()
    _G.GameTooltip:Hide()
end

function AB.SettingsMicroButtonMixin:AddSystemInfo(tooltip)
    R.SystemInfo:Update(true)

    local ipTypes = {"IPv4", "IPv6"}
    local statusColors = {"|cff0CD809", "|cffE8DA0F", "|cffFF9000", "|cffD80909"}
    local fpsString = "%s%d|r"
    local bandwidthString = "%.2f Mbps"
    local percentageString = "%.2f%%"
    local homeLatencyString = "%d ms"
    local cpuString = "%d ms"
    local cpuAndMemoryString = "%d ms / %s"

    local labelColor = R.HIGHLIGHT_FONT_COLOR
    local valueColor = R.NORMAL_FONT_COLOR

    tooltip:AddLine(" ")

    local latencyColor
    local latency = R.SystemInfo.homePing > R.SystemInfo.worldPing and R.SystemInfo.homePing or R.SystemInfo.worldPing
    if latency > AB.config.systemInfo.mediumLatencyTreshold then
        latencyColor = AB.config.systemInfo.highLatencyColor
    elseif latency > AB.config.systemInfo.lowLatencyTreshold then
        latencyColor = AB.config.systemInfo.mediumLatencyColor
    else
        latencyColor = AB.config.systemInfo.lowLatencyColor
    end

    tooltip:AddDoubleLine(L["Latency:"], R.SystemInfo.homePing, labelColor[1], labelColor[2], labelColor[3], latencyColor[1],
                          latencyColor[2], latencyColor[3])

    local fpsColor
    if R.SystemInfo.framerate > AB.config.systemInfo.mediumFpsTreshold then
        fpsColor = AB.config.systemInfo.highFpsColor
    elseif R.SystemInfo.framerate > AB.config.systemInfo.lowFpsTreshold then
        fpsColor = AB.config.systemInfo.mediumFpsColor
    else
        fpsColor = AB.config.systemInfo.lowFpsColor
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
            if (not IsShiftKeyDown()) and (i > AB.config.systemInfo.addonsToDisplay) then
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
            if (not IsShiftKeyDown()) and (i > AB.config.systemInfo.addonsToDisplay) then
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