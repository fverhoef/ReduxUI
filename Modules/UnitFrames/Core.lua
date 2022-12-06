local addonName, ns = ...
local R = _G.ReduxUI
local UF = R:AddModule("UnitFrames", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
local oUF = ns.oUF or oUF

local FRAMES = { player = "SpawnPlayer", target = "SpawnTarget", targettarget = "SpawnTargetTarget", pet = "SpawnPet", focus = "SpawnFocus", focustarget = "SpawnFocusTarget" }
local HEADERS = { party = "SpawnPartyHeader", raid = "SpawnRaidHeader", assist = "SpawnAssistHeader", tank = "SpawnTankHeader", arena = "SpawnArenaHeader", boss = "SpawnBossHeader" }

UF.frames = {}
UF.headers = {}
UF.nameplates = {}

function UF:Initialize()
end

function UF:Enable()
    if not UF.config.enabled then
        return
    end

    UF:UpdateColors()
    UF:StyleAuraFrames()

    for unit, func in pairs(FRAMES) do
        UF.frames[unit] = UF[func]()
    end
    for unit, func in pairs(HEADERS) do
        UF.headers[unit] = UF[func]()
    end

    UF:SpawnNamePlates()

    UF:RegisterEvent("PLAYER_REGEN_DISABLED")
end

oUF:RegisterInitCallback(function(object)
    if object.Configure then
        object:Configure()
    end
end)

function UF:UpdateAll()
    for unit, func in pairs(FRAMES) do
        if not UF.frames[unit] then
            UF.frames[unit] = UF[func]()
        end
    end
    for unit, func in pairs(HEADERS) do
        if not UF.headers[unit] then
            UF.headers[unit] = UF[func]()
        end
    end

    for _, frame in pairs(UF.frames) do
        frame:Configure()
    end
    for _, header in pairs(UF.headers) do
        header:Configure()
    end
    UF:UpdateNamePlates()
end

function UF:UpdateNamePlates()
    for cvar, value in pairs(UF.config.nameplates.cvars) do
        SetCVar(cvar, value)
    end

    for _, nameplate in ipairs(UF.nameplates) do
        nameplate:Configure()
    end
end

function UF:UpdateUnit(unit)
    if FRAMES[unit] and not UF.frames[unit] then
        UF.frames[unit] = UF[FRAMES[unit]]()
        if FRAMES[unit .. "target"] then
            UF:UpdateUnit(unit .. "target")
        end
    elseif HEADERS[unit] and not UF.headers[unit] then
        UF.headers[unit] = UF[HEADERS[unit]]()
    end

    if UF.frames[unit] then
        UF.frames[unit]:Configure()
    elseif UF.headers[unit] then
        UF.headers[unit]:Configure()
    elseif unit == "nameplates" or unit == "friendlyPlayer" or unit == "friendlyNpc" or unit == "enemyPlayer" or unit == "enemyNpc" then
        UF:UpdateNamePlates()
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
    for _, header in pairs(UF.headers) do
        if header and header.UnforceShow then
            header:UnforceShow()
        end
    end
end
