local addonName, ns = ...
local R = _G.ReduxUI
local UF = R:AddModule("UnitFrames", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local oUF = ns.oUF or oUF

UF.frames = {}
UF.headers = {}
UF.nameplates = {}

function UF:Initialize()
    if not UF.config.enabled then return end

    UF:UpdateColors()
    UF:StyleBuffFrame()

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
    if R.isRetail then UF.headers.boss = UF:SpawnBossHeader() end

    UF:SpawnNamePlates()

    UF:RegisterEvent("PLAYER_REGEN_DISABLED")
end

oUF:RegisterInitCallback(function(object)
    if object.Update then object:Update() end
end)

function UF:UpdateAll()
    for _, frame in pairs(UF.frames) do frame:Update() end
    for _, header in pairs(UF.headers) do header:Update() end
    for _, nameplate in pairs(UF.nameplates) do nameplate:Update() end
end

function UF:UpdateUnit(unit)
    if UF.frames[unit] then
        UF.frames[unit]:Update()
    elseif UF.headers[unit] then
        UF.headers[unit]:Update()
    elseif unit == "nameplates" then
        for _, nameplate in pairs(UF.nameplates) do nameplate:Update() end
    end
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

function UF:PLAYER_REGEN_DISABLED()
    for _, header in pairs(UF.headers) do if header and header.UnforceShow then header:UnforceShow() end end
end
