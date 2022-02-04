local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnFrame(name, unit, func, config, defaultConfig)
    oUF:RegisterStyle(addonName .. name, func)
    oUF:SetActiveStyle(addonName .. name)

    local frame = oUF:Spawn(unit, addonName .. name)
    frame:CreateFader(config and config.fader or R.config.faders.onShow)

    R:CreateDragFrame(frame, name, defaultConfig and defaultConfig.point or nil)

    return frame
end

function UF:InitializeFrame()
    self:SetFrameStrata(self.unit == "nameplate" and "BACKGROUND" or "LOW")

    if not string.match(self.unit, "nameplate") then
        self:RegisterForClicks("AnyUp")
        self:SetScript("OnEnter", UnitFrame_OnEnter)
        self:SetScript("OnLeave", UnitFrame_OnLeave)
    end

    self.Overlay = CreateFrame("Frame", "$parentOverlay", self)
    self.Overlay:SetFrameLevel(self:GetFrameLevel() + 10)
    self.Overlay:SetAllPoints()

    self:CreateBackdrop({edgeFile = R.media.textures.edgeFiles.borderThickTooltip, edgeSize = 16})
    self.Backdrop:SetOutside(self, 3, 3)
    self.Backdrop:SetFrameLevel(self:GetFrameLevel())

    self:CreateInlay({edgeFile = R.media.textures.edgeFiles.inlay, edgeSize = 12})
    self.Inlay:SetOutside(self, 6, 6)

    self.Range = {insideAlpha = 1, outsideAlpha = 0.5}

    self:CreateHealth()
    self:CreatePower()
    self:CreateName()
    self:CreatePortrait()
    self:CreateCastbar()
    self:CreateAuras()

    self:CreateHighlight()
    self:CreateAuraHighlight()
    self:CreateThreatIndicator()
    self:CreateTargetIndicator()

    self:CreateAssistantIndicator()
    self:CreateCombatIndicator()
    self:CreateLeaderIndicator()
    self:CreatePvPIndicator()
    self:CreateRaidRoleIndicator()
    self:CreateRaidTargetIndicator()
    self:CreateReadyCheckIndicator()
    self:CreateResurrectIndicator()

    if R.isRetail then
        self:CreateGroupRoleIndicator()
        self:CreatePhaseIndicator()
        self:CreatePvPClassificationIndicator()
        self:CreateQuestIndicator()
        self:CreateSummonIndicator()
    else
        self:CreateMasterLooterIndicator()
    end
end

oUF:RegisterMetaFunction("InitializeFrame", UF.InitializeFrame)

function UF:ConfigureFrame()
    self:SetSize(unpack(self.config.size))
    self:SetScale(self.config.scale)
    self:ClearAllPoints()
    self:Point(unpack(self.config.point))

    self.Range = {insideAlpha = 1, outsideAlpha = 0.5}

    self:ConfigureHealth()
    self:ConfigurePower()
    self:ConfigureName()
    self:ConfigurePortrait()
    self:ConfigureCastbar()
    self:ConfigureAuras()

    self:ConfigureAuraHighlight()
    self:ConfigureThreatIndicator()
    self:ConfigureTargetIndicator()

    self:ConfigureAssistantIndicator()
    self:ConfigureCombatIndicator()
    self:ConfigureLeaderIndicator()
    self:ConfigurePvPIndicator()
    self:ConfigureRaidRoleIndicator()
    self:ConfigureRaidTargetIndicator()
    self:ConfigureReadyCheckIndicator()
    self:ConfigureResurrectIndicator()

    if R.isRetail then
        self:ConfigureGroupRoleIndicator()
        self:ConfigurePhaseIndicator()
        self:ConfigurePvPClassificationIndicator()
        self:ConfigureQuestIndicator()
        self:ConfigureSummonIndicator()
    else
        self:ConfigureMasterLooterIndicator()
    end
end

oUF:RegisterMetaFunction("ConfigureFrame", UF.ConfigureFrame)

function UF:ForceShow()
    if not self or InCombatLockdown() then return end
    if not self.isForced then
        self.oldUnit = self.unit
        self.unit = "player"
        self.forceShowAuras = true
        self.isForced = true
        self.oldOnUpdate = self:GetScript("OnUpdate")
    end

    self:SetScript("OnUpdate", nil)

    UnregisterUnitWatch(self)
    RegisterUnitWatch(self, true)

    self:EnableMouse(false)

    self:Show()
    if self:IsVisible() and self.Update then self:Update() end

    local target = _G[self:GetName() .. "Target"]
    if target then target:ForceShow() end

    local pet = _G[self:GetName() .. "Pet"]
    if pet then pet:ForceShow() end
end

oUF:RegisterMetaFunction("ForceShow", UF.ForceShow)

function UF:UnforceShow()
    if not self or not self.isForced or InCombatLockdown() then return end

    self.forceShowAuras = nil
    self.isForced = nil

    UnregisterUnitWatch(self)
    RegisterUnitWatch(self)

    self:EnableMouse(true)

    if self.oldOnUpdate then
        self:SetScript("OnUpdate", self.oldOnUpdate)
        self.oldOnUpdate = nil
    end

    self.unit = self.oldUnit or self.unit
    if self:IsVisible() and self.Update then self:Update() end

    local target = _G[self:GetName() .. "Target"]
    if target then target:UnforceShow() end

    local pet = _G[self:GetName() .. "Pet"]
    if pet then pet:UnforceShow() end
end

oUF:RegisterMetaFunction("UnforceShow", UF.UnforceShow)
