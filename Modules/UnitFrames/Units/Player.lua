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
    self:CreatePowerPrediction()
    self:CreateCombatIndicator()
    self:CreateRestingIndicator()

    self:CreateClassPower()
    if (R.PlayerInfo.class == "DEATHKNIGHT") then self:CreateRunes() end
    if (R.PlayerInfo.class == "SHAMAN") then self:CreateTotems() end
    if (R.PlayerInfo.class == "MONK") then self:CreateStagger() end

    self.Power:CreateMover("PlayerPower", self.defaults.power.point)
    self.Castbar:CreateMover("PlayerCastbar", self.defaults.castbar.point)

    self.Update = UF.UpdatePlayer
end

function UF:UpdatePlayer()
    if not self then return end

    self:ConfigureFrame()
    self:ConfigureAdditionalPower()
    self:ConfigurePowerPrediction()
    self:ConfigureCombatIndicator()
    self:ConfigureRestingIndicator()

    self:ConfigureClassPower()
    if (R.PlayerInfo.class == "DEATHKNIGHT") then self:ConfigureRunes() end
    if (R.PlayerInfo.class == "SHAMAN") then self:ConfigureTotems() end
    if (R.PlayerInfo.class == "MONK") then self:ConfigureStagger() end

    if self.config.power.detached then
        self.Power.Mover:Unlock()
    else
        self.Power.Mover:Lock(true)
    end

    if self.config.castbar.detached then
        self.Castbar.Mover:Unlock()
    else
        self.Castbar.Mover:Lock(true)
    end
end
