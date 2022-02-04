local addonName, ns = ...
local R = _G.ReduxUI
local UF = R:AddModule("UnitFrames", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local oUF = ns.oUF or oUF

UF.Frames = {}
UF.Headers = {}

function UF:Initialize()
    if not UF.config.enabled then return end

    UF:UpdateColors()
    UF:StyleBuffFrame()

    UF.Frames.Player = UF:SpawnPlayer()
    UF.Frames.Target = UF:SpawnTarget()

    UF:RegisterEvent("PLAYER_REGEN_DISABLED")
end

oUF:RegisterInitCallback(function(object)
    if object.Update then object:Update() end
end)

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
    for _, header in pairs(UF.Headers) do if header and header.UnforceShow then header:UnforceShow() end end
end
