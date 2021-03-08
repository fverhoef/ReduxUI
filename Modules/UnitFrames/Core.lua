local addonName, ns = ...
local R = _G.ReduxUI
local UF = R:AddModule("UnitFrames", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local oUF = ns.oUF or oUF

UF.frames = {}
UF.headers = {}
UF.nameplates = {}
UF.forceShowRaid = false

function UF:Initialize()
    if not UF.config.enabled then
        return
    end

    UF:UpdateColors()

    UF.frames.player = UF:SpawnPlayer()
    UF.frames.target = UF:SpawnTarget()
    UF.frames.targettarget = UF:SpawnTargetTarget()
    UF.frames.pet = UF:SpawnPet()
    UF.frames.focus = UF:SpawnFocus()
    UF.frames.focustarget = UF:SpawnFocusTarget()
    UF.frames.mouseover = UF:SpawnMouseOver()

    UF.headers.party = UF:SpawnPartyHeader()
    UF.headers.raid = UF:SpawnRaidHeader()
    UF.headers.tank = UF:SpawnTankHeader()
    UF.headers.assist = UF:SpawnAssistHeader()
    UF.headers.boss = UF:SpawnBossHeader()
    UF.headers.arena = UF:SpawnArenaHeader()

    UF:SpawnNamePlates()
    UF:UpdateAll()

    _G.BuffFrame.config = UF.config.buffFrame
    _G.BuffFrame:ClearAllPoints()
    _G.BuffFrame:Point(unpack(UF.config.buffFrame.point))
    R:CreateDragFrame(_G.BuffFrame, "Buffs & Debuffs", UF.defaults.buffFrame.point, 400, 200,
                      {"TOPRIGHT", _G.BuffFrame, "TOPRIGHT"})
    UF:SecureHook(nil, "UIParent_UpdateTopFramePositions", UF.UIParent_UpdateTopFramePositions)

    UF:RegisterEvent("PLAYER_REGEN_DISABLED")
end

function UF:UpdateUnit(unit)
    local object = UF.frames[unit] or UF.headers[unit]
    if object and object.Update then
        object:Update()
    elseif unit == "nameplates" then
        UF:UpdateNamePlates()
    end
end

function UF:UpdateAll()
    UF:UpdateColors()

    for _, frame in pairs(UF.frames) do
        if frame and frame.Update then
            frame:Update()
        end
    end

    for _, header in pairs(UF.headers) do
        if header and header.Update then
            header:Update()
        end
    end

    UF.UpdateNamePlates()
end

function UF:UpdateColors()
    oUF.colors.health = UF.config.health
    oUF.colors.power["MANA"] = UF.config.colors.mana
    oUF.colors.power["RAGE"] = UF.config.colors.rage
    oUF.colors.power["ENERGY"] = UF.config.colors.energy
    oUF.colors.power["FOCUS"] = UF.config.colors.focus
    oUF.colors.power["COMBO_POINTS"] = UF.config.colors.comboPoints

    for key, value in next, UF.config.colors.class do
        if RAID_CLASS_COLORS[key] then
            RAID_CLASS_COLORS[key]["r"] = value[1]
            RAID_CLASS_COLORS[key]["g"] = value[2]
            RAID_CLASS_COLORS[key]["b"] = value[3]
        end
        oUF.colors.class[key] = value
    end
end

function UF:SpawnFrame(name, unit, func, config, defaultConfig)
    oUF:RegisterStyle(addonName .. name, func)
    oUF:SetActiveStyle(addonName .. name)

    local frame = oUF:Spawn(unit, addonName .. name)
    frame:CreateFader(config.fader)

    R:CreateDragFrame(frame, name, defaultConfig and defaultConfig.point or nil)

    return frame
end

function UF:SpawnHeader(name, func, config, defaultConfig, registerStyle, index, visibility)
    if registerStyle then
        oUF:RegisterStyle(addonName .. name, func)
        oUF:SetActiveStyle(addonName .. name)
    end

    local header = oUF:SpawnHeader(addonName .. name .. "Header" .. (index or ""), nil, config.visibility, "showPlayer",
                                   config.showPlayer, "showSolo", config.showSolo, "showParty", config.showParty, "showRaid",
                                   config.showRaid, "point", config.unitAnchorPoint, "groupFilter", index and tostring(index),
                                   "oUF-initialConfigFunction", ([[
            self:SetWidth(%d)
            self:SetHeight(%d)
            self:GetParent():SetScale(%f)
        ]]):format(config.size[1], config.size[2], config.scale))

    header:SetFrameStrata("LOW")
    header:CreateFader(config.fader)

    return header
end

function UF:SetupFrame(self)
    self:SetFrameStrata(self.unit == "nameplate" and "BACKGROUND" or "LOW")
    if not string.match(self.unit, "nameplate") then
        self:RegisterForClicks("AnyUp")
        self:SetScript("OnEnter", UnitFrame_OnEnter)
        self:SetScript("OnLeave", UnitFrame_OnLeave)
    end

    self.Overlay = CreateFrame("Frame", "$parentOverlay", self)
    self.Overlay:SetFrameLevel(self:GetFrameLevel() + 10)
    self.Overlay:SetAllPoints()

    self:CreateArtwork()
    self:CreateBorder(self.config.border.size)
    self:CreateShadow()

    self:CreateHealth()
    self:CreatePower()
    if self.config.name then
        self:CreateName()
    end
    if self.config.level then
        self:CreateLevel()
    end
    if self.config.portrait then
        self:CreatePortrait()
    end
    if self.config.combatfeedback then
        self:CreateCombatFeedback()
    end
    if self.config.castbar then
        self:CreateCastbar()
    end
    if self.config.auras then
        self:CreateAuras()
    end

    do -- indicators
        if self.config.combatIndicator then
            self:CreateCombatIndicator()
        end
        if self.config.restingIndicator then
            self:CreateRestingIndicator()
        end
        if not R.isClassic and self.config.groupRoleIndicator then
            self:CreateGroupRoleIndicator()
        end
        if self.config.raidRoleIndicator then
            self:CreateRaidRoleIndicator()
        end
        if self.config.raidTargetIndicator then
            self:CreateRaidTargetIndicator()
        end
        if self.config.readyCheckIndicator then
            self:CreateReadyCheckIndicator()
        end
        if self.config.assistantIndicator then
            self:CreateAssistantIndicator()
        end
        if self.config.leaderIndicator then
            self:CreateLeaderIndicator()
        end
        if not R.isRetail and self.config.masterLooterIndicator then
            self:CreateMasterLooterIndicator()
        end
        if self.config.pvpIndicator then
            self:CreatePvPIndicator()
        end
        if not R.isClassic and self.config.pvpClassificationIndicator then
            self:CreatePvPClassificationIndicator()
        end
        if not R.isClassic and self.config.phaseIndicator then
            self:CreatePhaseIndicator()
        end
        if not R.isClassic and self.config.questIndicator then
            self:CreateQuestIndicator()
        end
        if self.config.restingIndicator then
            self:CreateResurrectIndicator()
        end
        if not R.isClassic and self.config.summonIndicator then
            self:CreateSummonIndicator()
        end
        if self.config.offlineIcon then
            self:CreateOfflineIcon()
        end
    end

    -- highlights
    self:CreateHighlight()
    self:CreateAuraHighlight()
    self:CreateThreatIndicator()
    self:CreateTargetIndicator()

    self:UpdateHighlight()
end

function UF:UpdateFrame(self)
    if not self then
        return
    end

    if UF.config.lockTheme and self.ApplyTheme then
        self:ApplyTheme()
    end

    self:SetSize(unpack(self.config.size))
    if self.config.point and not self.isGroupUnit then
        self:ClearAllPoints()
        self:Point(unpack(self.config.point))
    end
    self:SetScale(self.config.scale or 1)
    self:SetFrameLevel(self.config.frameLevel or 10)

    self:UpdateArtwork()
    self:UpdateHealth()
    self:UpdatePower()
    self:UpdatePowerPrediction()
    self:UpdateAdditionalPower()
    self:UpdateEnergyManaRegen()
    self:UpdateName()
    self:UpdateLevel()
    self:UpdatePortrait()
    self:UpdateCombatFeedback()
    self:UpdateCastbar()
    self:UpdateAuras()
    self:UpdateAuraHighlight()
    self:UpdateThreatIndicator()
    self:UpdateTargetIndicator()

    self:UpdateCombatIndicator()
    self:UpdateRestingIndicator()
    self:UpdateGroupRoleIndicator()
    self:UpdateRaidRoleIndicator()
    self:UpdateRaidTargetIndicator()
    self:UpdateReadyCheckIndicator()
    self:UpdateAssistantIndicator()
    self:UpdateLeaderIndicator()
    self:UpdateMasterLooterIndicator()
    self:UpdatePvPIndicator()
    self:UpdatePvPClassificationIndicator()
    self:UpdatePhaseIndicator()
    self:UpdateQuestIndicator()
    self:UpdateResurrectIndicator()
    self:UpdateSummonIndicator()
    self:UpdateOfflineIcon()

    self:SetBorderSize(self.config.border.size)
    self.Border:SetShown(self.config.border.enabled)
    self.Shadow:SetShown(self.config.shadow.enabled)

    self:UpdateAllElements("OnUpdate")
end

oUF:RegisterInitCallback(function(object)
    if object.Update then
        object:Update()
    end
end)

function UF:GetAnchor(anchor)
    if anchor == "UIParent" then
        return "UIParent"
    elseif not string.find(anchor, addonName) then
        return _G[addonName .. anchor]
    end

    return _G[anchor]
end

function UF:UpdateHeaderVisibility(self, visibility)
    local type, list = string.split(" ", visibility, 2)
    if list and type == "custom" then
        RegisterAttributeDriver(self, "state-visibility", list)
        self.visibility = list
    else
        local condition = UF:GetCondition(string.split(",", visibility))
        RegisterAttributeDriver(self, "state-visibility", condition)
        -- R:Print(self:GetName() .. ": " .. visibility .. "(" .. condition .. ")")
        self.visibility = condition
    end
end

local conditions = {
    raid40 = "[@raid26,exists] show;",
    raid25 = "[@raid11,exists] show;",
    raid10 = "[@raid6,exists] show;",
    raid = "[group:raid] show;",
    party = "[group:party,nogroup:raid] show;",
    solo = "[@player,exists,nogroup:party] show;",
    show = "show;"
}

function UF:GetCondition(...)
    local cond = ""

    local short, condition
    for i = 1, select("#", ...) do
        short = select(i, ...)

        condition = conditions[short]
        if condition then
            cond = cond .. condition
        end
    end

    return cond .. "hide"
end

function UF:ForceShow(frame)
    if not frame or InCombatLockdown() then
        return
    end
    if not frame.isForced then
        frame.oldUnit = frame.unit
        frame.unit = "player"
        frame.forceShowAuras = true
        frame.isForced = true
        frame.oldOnUpdate = frame:GetScript("OnUpdate")
    end

    frame:SetScript("OnUpdate", nil)

    UnregisterUnitWatch(frame)
    RegisterUnitWatch(frame, true)

    frame:EnableMouse(false)

    frame:Show()
    if frame:IsVisible() and frame.Update then
        frame:Update()
    end

    if (_G[frame:GetName() .. "Target"]) then
        self:ForceShow(_G[frame:GetName() .. "Target"])
    end

    if (_G[frame:GetName() .. "Pet"]) then
        self:ForceShow(_G[frame:GetName() .. "Pet"])
    end
end

function UF:UnforceShow(frame)
    if not frame or not frame.isForced or InCombatLockdown() then
        return
    end

    frame.forceShowAuras = nil
    frame.isForced = nil

    UnregisterUnitWatch(frame)
    RegisterUnitWatch(frame)

    frame:EnableMouse(true)

    if frame.oldOnUpdate then
        frame:SetScript("OnUpdate", frame.oldOnUpdate)
        frame.oldOnUpdate = nil
    end

    frame.unit = frame.oldUnit or frame.unit
    if frame:IsVisible() and frame.Update then
        frame:Update()
    end

    if (_G[frame:GetName() .. "Target"]) then
        self:UnforceShow(_G[frame:GetName() .. "Target"])
    end

    if (_G[frame:GetName() .. "Pet"]) then
        self:UnforceShow(_G[frame:GetName() .. "Pet"])
    end
end

function UF:ForceShowHeader(header)
    if not header or header.isForced then
        return
    end

    header.isForced = true
    header.forceShow = true
    header:SetAttribute("startingIndex", -4)

    for i = 1, header:GetNumChildren() do
        local child = header:GetAttribute("child" .. i)
        self:ForceShow(child)
    end

    if header.Update then
        header:Update()
    end
end

function UF:UnforceShowHeader(header)
    if not header or not header.isForced then
        return
    end

    header.isForced = nil
    header.forceShow = nil
    header:SetAttribute("startingIndex", 1)

    for i = 1, header:GetNumChildren() do
        local child = header:GetAttribute("child" .. i)
        self:UnforceShow(child)
    end

    if header.Update then
        header:Update()
    end
end

function UF:ApplyTheme()
    for _, frame in pairs(UF.frames) do
        if frame and frame.ApplyTheme then
            frame:ApplyTheme()
            if frame.Update then
                frame:Update()
            end
        end
    end

    for _, header in pairs(UF.headers) do
        if header and header.ApplyTheme then
            header:ApplyTheme()
            if header.Update then
                header:Update()
            end
        end
    end
end

function UF:PLAYER_REGEN_DISABLED()
    for _, header in pairs(UF.headers) do
        if header and header.UnforceShow then
            header:UnforceShow()
        end
    end
end

function UF:UIParent_UpdateTopFramePositions()
    _G.BuffFrame:ClearAllPoints()
    _G.BuffFrame:Point(unpack(UF.config.buffFrame.point))
end
