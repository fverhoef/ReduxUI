local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnNamePlates()
    local config = UF.config.nameplates
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
    self.cfg = UF.config.nameplates

    self:SetSize(unpack(self.cfg.size))
    self:SetPoint("CENTER")
    self:SetFrameStrata("BACKGROUND")

    self:CreateBorder(self.cfg.border.size)
    self:CreateShadow()

    self:CreateHealth()
    self:CreatePower()
    self:CreateName()
    self:CreateLevel()

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

    self:CreateCastbar()

    -- combo points
    if self.cfg.showComboPoints then
        self:CreateComboFrame()
    end

    self:CreateRaidTargetIndicator()
    self:CreateThreatIndicator()
    self:CreateTargetIndicator()

    table.insert(UF.nameplates, self)

    self.Update = function(self)
        UF:UpdateNamePlate(self)
    end
end

function UF:UpdateNamePlate(self)
    if not self then
        return
    end

    UF:UpdateFrame(self)
    self:SetScale((self.cfg.scale or 1) * UIParent:GetScale())
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
