local addonName, ns = ...
local R = _G.ReduxUI
local UF = R:AddModule("UnitFrames", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local oUF = ns.oUF or oUF

UF.frames = {}
UF.nameplates = {}
UF.forceShowRaid = false

function UF:Initialize()
    if not R.config.db.profile.modules.unitFrames.enabled then
        return
    end

    UF:UpdateColors()

    UF.frames.player = UF:SpawnPlayer()
    UF.frames.target = UF:SpawnTarget()
    UF.frames.targetTarget = UF:SpawnTargetTarget()
    UF.frames.pet = UF:SpawnPet()
    UF.frames.focus = UF:SpawnFocus()
    UF.frames.focusTarget = UF:SpawnFocusTarget()
    UF.frames.mouseover = UF:SpawnMouseOver()

    UF.frames.partyHeader = UF:SpawnPartyHeader()
    UF.frames.raidHeader = UF:SpawnRaidHeader()
    UF.frames.tankHeader = UF:SpawnTankHeader()
    UF.frames.assistHeader = UF:SpawnAssistHeader()
    UF.frames.bossHeader = UF:SpawnBossHeader()
    UF.frames.arenaHeader = UF:SpawnArenaHeader()

    UF:SpawnNamePlates()

    UF:RegisterEvent("PLAYER_ENTERING_WORLD", UF.SetupMasque)

    UF:UpdateAll()
end

function UF:UpdateAll()
    UF:UpdateColors()

    UF:UpdatePlayer(UF.frames.player)
    UF:UpdateTarget(UF.frames.target)
    UF:UpdateTargetTarget(UF.frames.targetTarget)
    UF:UpdatePet(UF.frames.pet)
    UF:UpdateFocus(UF.frames.focus)
    UF:UpdateFocusTarget(UF.frames.focusTarget)
    UF:UpdateMouseover(UF.frames.mouseover)

    UF:UpdatePartyHeader()
    UF:UpdateRaidHeader()
    UF:UpdateTankHeader()
    UF:UpdateAssistHeader()
    UF:UpdateBossHeader()
    UF:UpdateArenaHeader()

    UF:UpdateNamePlates()
end

function UF:UpdateColors()
    oUF.colors.health = R.config.db.profile.modules.unitFrames.health
    oUF.colors.power["MANA"] = R.config.db.profile.modules.unitFrames.colors.mana
    oUF.colors.power["RAGE"] = R.config.db.profile.modules.unitFrames.colors.rage
    oUF.colors.power["ENERGY"] = R.config.db.profile.modules.unitFrames.colors.energy
    oUF.colors.power["FOCUS"] = R.config.db.profile.modules.unitFrames.colors.focus
    oUF.colors.power["COMBO_POINTS"] = R.config.db.profile.modules.unitFrames.colors.comboPoints

    for key, value in next, R.config.db.profile.modules.unitFrames.colors.class do
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

    if config.fader and config.fader.enabled then
        R:CreateFrameFader(frame, config.fader)
    end

    R:CreateDragFrame(frame, name, defaultConfig and defaultConfig.point or nil)

    return frame
end

function UF:SpawnHeader(name, func, config, defaultConfig, registerStyle, index)
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

    if config.fader and config.fader.enabled then
        R:CreateFrameFader(header, config.fader)
    end

    return header
end

function UF:UpdateFrame(self)
    if not self then
        return
    end

    self:SetScale(self.cfg.scale or 1)

    self:UpdateHealth()
    self:UpdatePower()
    self:UpdatePowerPrediction()
    self:UpdateAdditionalPower()
    self:UpdateCastbar()
    self:UpdateName()
    self:UpdateAuraHighlight()
    self:UpdateAuras()
    self:UpdateCombatFeedback()

    if self.Texture then
        self.Texture:SetTexture(self.cfg.texture)
        self.Texture:SetVertexColor(unpack(self.cfg.textureColor))
    end

    self.Border:SetShown(self.cfg.border.enabled)
    self.Shadow:SetShown(self.cfg.shadow.enabled)

    self:UpdateAllElements("OnUpdate")
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

    if header:IsShown() then
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
end

function UF:UnforceShowHeader(header)
    if not header or not header.isForced then
        return
    end

    if header:IsShown() then
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
end

function UF:PLAYER_REGEN_DISABLED()
    UF:UnforceShowParty()
    UF:UnforceShowRaid()
end

UF:RegisterEvent("PLAYER_REGEN_DISABLED")
