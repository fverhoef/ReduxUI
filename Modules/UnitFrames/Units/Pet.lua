local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnPet()
    local config = UF.config.pet
    local default = UF.defaults.pet

    if config.enabled then
        return UF:SpawnFrame("Pet", "pet", UF.CreatePet, config, default)
    end
end

function UF:CreatePet()
    self.config = UF.config.pet
    self.defaults = UF.defaults.pet

    UF:SetupFrame(self)

    self:CreateRange()
    self:CreateAuraHighlight()

    self.Update = UF.UpdatePet
end

function UF:UpdatePet()
    if not self then
        return
    end
    
    UF:Pet_ApplyTheme(UF.config.theme)
    UF:UpdateFrame(self)
end
