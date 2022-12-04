local addonName, ns = ...
local R = _G.ReduxUI
local UF = R:AddModule("UnitFrames", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
local oUF = ns.oUF or oUF

UF.frames = {}
UF.headers = {}
UF.nameplates = {}

function UF:Initialize()
end

function UF:Enable()
    if not UF.config.enabled then return end

    UF:UpdateColors()
    UF:StyleAuraFrames()

    UF.frames.player = UF:SpawnPlayer()
    UF.frames.target = UF:SpawnTarget()
    UF.frames.targettarget = UF:SpawnTargetTarget()
    UF.frames.pet = UF:SpawnPet()
    UF.frames.focus = UF:SpawnFocus()
    UF.frames.focustarget = UF:SpawnFocusTarget()

    UF.headers.party = UF:SpawnPartyHeader()
    UF.headers.raid = UF:SpawnRaidHeader()
    UF.headers.assist = UF:SpawnAssistHeader()
    UF.headers.tank = UF:SpawnTankHeader()
    UF.headers.arena = UF:SpawnArenaHeader()
    UF.headers.boss = UF:SpawnBossHeader()

    UF:SpawnNamePlates()

    UF:RegisterEvent("PLAYER_REGEN_DISABLED")
end

oUF:RegisterInitCallback(function(object)
    if object.Configure then object:Configure() end
end)

function UF:UpdateAll()
    for _, frame in pairs(UF.frames) do frame:Configure() end
    for _, header in pairs(UF.headers) do header:Configure() end
    for _, nameplate in pairs(UF.nameplates) do nameplate:Configure() end
end

function UF:UpdateUnit(unit)
    if UF.frames[unit] then
        UF.frames[unit]:Configure()
    elseif UF.headers[unit] then
        UF.headers[unit]:Configure()
    elseif unit == "nameplates" then
        for _, nameplate in pairs(UF.nameplates) do nameplate:Configure() end
    end
end

function UF:UpdateColors()
    oUF.colors.health = UF.config.health
    oUF.colors.power["MANA"] = UF.config.colors.mana
    oUF.colors.power["RAGE"] = UF.config.colors.rage
    oUF.colors.power["ENERGY"] = UF.config.colors.energy
    oUF.colors.power["FOCUS"] = UF.config.colors.focus
    oUF.colors.power["COMBO_POINTS"] = UF.config.colors.comboPoints
    oUF.colors.power["RUNIC_POWER"] = UF.config.colors.runicPower

    for key, value in next, UF.config.colors.class do
        oUF.colors.class[key] = value
    end
end

function UF:PLAYER_REGEN_DISABLED()
    for _, header in pairs(UF.headers) do if header and header.UnforceShow then header:UnforceShow() end end
end
