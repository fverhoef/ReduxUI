local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnFrame(name, unit, func, config, defaultConfig)
    oUF:RegisterStyle(addonName .. name, func)
    oUF:SetActiveStyle(addonName .. name)

    local frame = oUF:Spawn(unit, addonName .. name)
    frame:CreateFader(config and config.fader or R.config.faders.onShow)
    frame:CreateMover(name, defaultConfig and defaultConfig.point or nil)

    return frame
end

function UF:InitializeFrame()
    local isNameplate = string.match(self.unit, "nameplate")
    self:SetFrameStrata(isNameplate and "BACKGROUND" or "LOW")

    if not isNameplate then
        self:RegisterForClicks("AnyUp")
        self:SetScript("OnEnter", UnitFrame_OnEnter)
        self:SetScript("OnLeave", UnitFrame_OnLeave)
    end

    self.Overlay = CreateFrame("Frame", "$parentOverlay", self)
    self.Overlay:SetFrameLevel(self:GetFrameLevel() + 100)
    self.Overlay:SetAllPoints()

    self:CreateBorder()
    self:CreateInlay()
    self:CreateShadow()

    self.Range = {insideAlpha = 1, outsideAlpha = 0.5}

    self:CreateHealth()
    self:CreatePower()
    self:CreateName()
    self:CreateLevel()
    self:CreatePortrait()
    self:CreateCastbar()
    self:CreateAuras()

    self:CreateHighlight()
    self:CreateAuraHighlight()
    self:CreateAuraWatch()
    self:CreateThreatIndicator()
    self:CreateTargetIndicator()

    self:CreateAssistantIndicator()
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
    local isNameplate = string.match(self.unit, "nameplate")
    self:SetSize(unpack(self.config.size))
    self:SetScale(self.config.scale)

    if not self.isGroupUnit then
        self:ClearAllPoints()
        self:SetNormalizedPoint(unpack(self.config.point))
    end

    if not isNameplate then
        self:SetAttribute("type3", UF.config.middleClickFocus and "focus" or nil)
    end

    self.Range = {insideAlpha = 1, outsideAlpha = 0.5}

    self.Inlay:SetShown(self.config.inlay.enabled or false)

    self:ConfigureHealth()
    self:ConfigurePower()
    self:ConfigureName()
    self:ConfigureLevel()
    self:ConfigurePortrait()
    self:ConfigureCastbar()
    self:ConfigureAuras()

    self:ConfigureAuraHighlight()
    self:ConfigureAuraWatch()
    self:ConfigureThreatIndicator()
    self:ConfigureTargetIndicator()

    self:ConfigureAssistantIndicator()
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
