local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames
local oUF = AddonTable.oUF or oUF

UF.frames = {}

function UF:OnEnable()
    UF:UpdateColors()

    UF.frames.player = UF:SpawnPlayer()
    UF.frames.target = UF:SpawnTarget()
    UF.frames.targetTarget = UF:SpawnTargetTarget()
    UF.frames.pet = UF:SpawnPet()
    UF.frames.focus = UF:SpawnFocus()
    UF.frames.focusTarget = UF:SpawnFocusTarget()
    UF.frames.mouseover = UF:SpawnMouseOver()

    UF.frames.partyHeader = UF:SpawnParty()
    UF:SpawnRaid()
    UF:SpawnTank()
    UF:SpawnAssist()
    UF:SpawnBoss()
    UF:SpawnArena()

    UF:SpawnNamePlates()

    UF:RegisterEvent("PLAYER_ENTERING_WORLD", UF.SetupMasque)
    -- UF:SecureHook("AuraButton_UpdateDuration", UF.UpdateAuraCooldown)

    UF:OnUpdate()
end

function UF:OnUpdate()
    UF:UpdateColors()

    UF:UpdatePlayer()
    UF:UpdateTarget()
    UF:UpdateTargetTarget()
    UF:UpdatePet()
    UF:UpdateFocus()
    UF:UpdateFocusTarget()
    UF:UpdateMouseover()

    UF:UpdateParty()
    UF:UpdateRaid()
    UF:UpdateTank()
    UF:UpdateAssist()
    UF:UpdateBoss()
    UF:UpdateArena()

    UF:UpdateNamePlates()
end

function UF:UpdateColors()
    oUF.colors.health = UF.config.db.profile.health
    oUF.colors.power["MANA"] = UF.config.db.profile.colors.mana
    oUF.colors.power["RAGE"] = UF.config.db.profile.colors.rage
    oUF.colors.power["ENERGY"] = UF.config.db.profile.colors.energy
    oUF.colors.power["FOCUS"] = UF.config.db.profile.colors.focus
    oUF.colors.power["COMBO_POINTS"] = UF.config.db.profile.colors.comboPoints

    for key, value in next, UF.config.db.profile.colors.class do
        if RAID_CLASS_COLORS[key] then
            RAID_CLASS_COLORS[key]["r"] = value[1]
            RAID_CLASS_COLORS[key]["g"] = value[2]
            RAID_CLASS_COLORS[key]["b"] = value[3]
        end
        oUF.colors.class[key] = value
    end
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

function UF:UpdateFrame(self)
    if not self then
        return
    end

    self:SetScale(self.cfg.scale or 1)

    UF.UpdateHealth(self)
    UF.UpdatePower(self)
    UF.UpdatePowerPrediction(self)
    UF.UpdateAdditionalPower(self)
    UF.UpdateCastbar(self)
    UF.UpdateAuraHighlight(self)
    UF.UpdateAuras(self)
    UF.UpdateCombatFeedback(self)

    self:UpdateAllElements("OnUpdate")
end
