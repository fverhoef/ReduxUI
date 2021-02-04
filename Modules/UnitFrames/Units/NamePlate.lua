local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnNamePlates()
    local config = R.config.db.profile.modules.unitFrames.nameplates
    if config.enabled then
        oUF:RegisterStyle(addonName .. "Nameplate", UF.CreateNamePlate)
        oUF:SetActiveStyle(addonName .. "Nameplate")
        oUF:SpawnNamePlates(addonName, UF.NamePlate_Callback, config.cvars)
    end
end

function UF:UpdateNamePlates()
    for i, nameplate in ipairs(UF.nameplates) do
        UF:UpdateNamePlate(nameplate)
    end
end

function UF:CreateNamePlate()
    self.cfg = R.config.db.profile.modules.unitFrames.nameplates

    self:SetSize(unpack(self.cfg.size))
    self:SetPoint("CENTER")
    self:SetFrameStrata("BACKGROUND")

    -- nameplates are not part of uiparent, they must be multiplied by uiparent scale!
    self:SetScale(1 * UIParent:GetScale())

    self:CreateBorder(self.cfg.border.size)
    self:SetBorderPadding(1, 1, 0, 0)
    self:CreateShadow()
    self:SetShadowPadding(1, 1, 0, 0)

    -- health
    self:CreateHealth()
    self.Health:SetSize(self:GetWidth() - 2, 16)
    if not self.cfg.power.enabled then
        self.Health:SetPoint("CENTER", self, 0, 0)
    else
        self.Health:SetPoint("CENTER", self, 0, 4)
    end
    self.Health.Value:SetPoint("CENTER", self.Health, 0, 0)
    self.Health.colorReaction = true

    -- power
    self:CreatePower()
    if self.cfg.power.enabled then
        self.Power:SetHeight(6)
        self:SetHeight(self:GetHeight() + 8)
    end

    -- name
    self:CreateName()
    if not self.cfg.power.enabled then
        self.Name:SetPoint("LEFT", self, "LEFT", 2, 15)
        self.Name:SetPoint("RIGHT", self, "RIGHT", -16, 15)
        self.Name:SetJustifyH("LEFT")
    else
        self.Name:SetPoint("LEFT", self, "LEFT", 2, 23)
        self.Name:SetPoint("RIGHT", self, "RIGHT", -16, 23)
        self.Name:SetJustifyH("LEFT")
    end

    -- level
    self:CreateLevel()
    self.Level:SetPoint("RIGHT", self.Health, 0, 0)
    self.Level:SetFont(R.config.db.profile.modules.unitFrames.font, 12, "OUTLINE")
    if not self.cfg.power.enabled then
        self.Level:SetPoint("RIGHT", self, 0, 15)
    else
        self.Level:SetPoint("RIGHT", self, 0, 23)
    end

    -- auras
    self:CreateAuras()
    if self.cfg.auras.enabled then
        if not self.cfg.auras.showDebuffsOnTop then
            self.Auras:ClearAllPoints()
            self.Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 15)
            self.Auras.initialAnchor = "BOTTOMLEFT"
            self.Auras["growth-x"] = "RIGHT"
            self.Auras["growth-y"] = "UP"
        end
    end

    -- castbar
    self:CreateCastbar()
    if self.cfg.castbar.enabled then
        self.Castbar:ClearAllPoints()
        if self.cfg.castbar.showIcon and not self.cfg.castbar.showIconOutside then
            local _, height = unpack(self.cfg.castbar.size)
            local leftPadding = height - self.cfg.castbar.borderSize / 2 - 1
            self.Castbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", leftPadding, -5)
        else
            self.Castbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
        end
    end

    -- combo points
    if self.cfg.showComboPoints then
        self:CreateComboFrame()
    end

    self:CreateRaidTargetIndicator(self)
    self:CreateThreatIndicator()
    self:CreateTargetIndicator()

    table.insert(UF.nameplates, self)
end

function UF:UpdateNamePlate(self)
    if not self then
        return
    end

    UF:UpdateFrame(self)
end

UF.NamePlate_Callback = function(self, event, unit)
    if self then
        UF.UpdateTargetIndicator(self)
    end
end

UF.NamePlate_DebuffFilter = function(...)
    -- icons, unit, icon, name, texture, count, dispelType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll
    local _, _, _, _, _, _, _, _, _, caster, _, _, _, _, _, _, nameplateShowAll = ...
    return nameplateShowAll or (caster == "player" or caster == "pet" or caster == "vehicle")
end
