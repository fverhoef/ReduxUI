local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnPlayer()
    local config = UF.config.player
    if not config.enabled then return end

    return UF:SpawnFrame("Player", "player", UF.CreatePlayer, config, UF.defaults.player)
end

function UF:CreatePlayer()
    self.config = UF.config.player
    self.defaults = UF.defaults.player

    self:InitializeFrame()
    self:CreateAdditionalPower()
    if not R.isRetail then self:CreateEnergyManaRegen() end
    self:CreatePowerPrediction()
    self:CreateCombatIndicator()
    self:CreateRestingIndicator()

    self:CreateClassPower()
    if (select(2, UnitClass("player")) == "DEATHKNIGHT") then self:CreateRunes() end
    if (select(2, UnitClass("player")) == "SHAMAN") then self:CreateTotems() end
    if (R.isRetail and select(2, UnitClass("player")) == "MONK") then self:CreateStagger() end

    R:CreateDragFrame(self.Power, "PlayerPower", self.defaults.power.point)
    R:CreateDragFrame(self.Castbar, "PlayerCastbar", self.defaults.castbar.point)

    self.Update = UF.UpdatePlayer
end

function UF:UpdatePlayer()
    if not self then return end

    self:ConfigureFrame()
    self:ConfigureAdditionalPower()
    if not R.isRetail then self:ConfigureEnergyManaRegen() end
    self:ConfigurePowerPrediction()
    self:ConfigureCombatIndicator()
    self:ConfigureRestingIndicator()

    self:ConfigureClassPower()
    if (select(2, UnitClass("player")) == "DEATHKNIGHT") then self:ConfigureRunes() end
    if (select(2, UnitClass("player")) == "SHAMAN") then self:ConfigureTotems() end
    if (R.isRetail and select(2, UnitClass("player")) == "MONK") then self:ConfigureStagger() end

    if self.config.power.detached then
        R:UnlockDragFrame(self.Power)
    else
        R:LockDragFrame(self.Power, true)
    end

    if self.config.castbar.detached then
        R:UnlockDragFrame(self.Castbar)
    else
        R:LockDragFrame(self.Castbar, true)
    end
end
