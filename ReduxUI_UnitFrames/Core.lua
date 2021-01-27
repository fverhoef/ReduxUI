local AddonName, AddonTable = ...
local R = _G.ReduxUI
local UF = R:AddModule("UnitFrames", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local oUF = AddonTable.oUF or oUF

UF.frames = {}

function UF:Initialize()
    if R.IsClassic then
        R:AddLib("ClassicDurations", "LibClassicDurations")
        R.Libs.ClassicDurations:Register(AddonName)
        R.Libs.ClassicDurations:Register(R.name)
    end
    
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

    UF:UpdateAll()
end

function UF:UpdateAll()
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
    oUF:RegisterStyle(AddonName .. name, func)
    oUF:SetActiveStyle(AddonName .. name)

    local frame = oUF:Spawn(unit, AddonName .. name)

    if config.fader and config.fader.enabled then
        R:CreateFrameFader(frame, config.fader)
    end

    R:CreateDragFrame(frame, name, defaultConfig and defaultConfig.point or nil)

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

    if self.Texture then
        self.Texture:SetVertexColor(unpack(self.cfg.textureColor))
    end

    self:UpdateAllElements("OnUpdate")
end
