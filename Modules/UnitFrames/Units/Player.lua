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
    self:CreateEnergyManaRegen()
    self:CreateRestingIndicator()

    self:CreateClassPower()
    if (select(2, UnitClass("player")) == "DEATHKNIGHT") then self:CreateRunes() end
    if (select(2, UnitClass("player")) == "SHAMAN") then self:CreateTotems() end
    if (select(2, UnitClass("player")) == "MONK") then self:CreateStagger() end

    R:CreateDragFrame(self.Castbar, "PlayerCastbar", self.defaults.castbar.point)

    self.Update = UF.UpdatePlayer
end

function UF:UpdatePlayer()
    if not self then return end

    self:ConfigureFrame()
    self:ConfigureAdditionalPower()
    self:ConfigureEnergyManaRegen()
    self:ConfigureRestingIndicator()

    self:ConfigureClassPower()
    if (select(2, UnitClass("player")) == "DEATHKNIGHT") then self:ConfigureRunes() end
    if (select(2, UnitClass("player")) == "SHAMAN") then self:ConfigureTotems() end
    if (select(2, UnitClass("player")) == "MONK") then self:ConfigureStagger() end

    if self.config.castbar.detached then
        self.Castbar:ClearAllPoints()
        self.Castbar:Point(self.config.castbar.point)
    end
end
