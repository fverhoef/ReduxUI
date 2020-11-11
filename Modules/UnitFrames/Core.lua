local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames
local oUF = AddonTable.oUF or oUF

function UF:OnEnable()
    oUF.colors.power["MANA"] = UF.config.db.profile.colors.mana
    oUF.colors.health = UF.config.db.profile.health

    if UF.config.db.profile.colors.overrideShamanColor then
        RAID_CLASS_COLORS["SHAMAN"]["r"] = 0.0
        RAID_CLASS_COLORS["SHAMAN"]["g"] = 0.44
        RAID_CLASS_COLORS["SHAMAN"]["b"] = 0.87
        oUF.colors.class["SHAMAN"] = {0.0, 0.44, 0.87}
    end

    -- Spawn frames
    UF.frames = {}
    UF.frames.player = UF:SpawnPlayer()
    UF.frames.target = UF:SpawnTarget()
    UF.frames.targetTarget = UF:SpawnTargetTarget()
    UF.frames.pet = UF:SpawnPet()
    UF.frames.focus = UF:SpawnFocus()
    UF.frames.focusTarget = UF:SpawnFocusTarget()
    UF.frames.mouseOver = UF:SpawnMouseOver()
    UF:SpawnNameplates()
    UF.frames.partyHeader = UF:SpawnParty()
    UF:SpawnRaid()
    UF:SpawnTank()
    UF:SpawnAssist()
    UF:SpawnBoss()

    UF:RegisterEvent("PLAYER_ENTERING_WORLD", UF.SetupMasque)
    -- UF:SecureHook("AuraButton_UpdateDuration", UF.UpdateAuraCooldown)
end

function UF:OnUpdate()
end

function UF:SpawnFrame(name, unit, func, config, defaultConfig)
    oUF:RegisterStyle(AddonName .. name, func)
    oUF:SetActiveStyle(AddonName .. name)

    local frame = oUF:Spawn(unit, AddonName .. name)

    if config.fader and config.fader.enabled then
        Addon:CreateFrameFader(frame, config.fader)
    end

    Addon:CreateDragFrame(frame, name, defaultConfig and defaultConfig.point or nil)

    return frame
end
