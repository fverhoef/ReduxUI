local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateRange = function(self)
    self.Range = {
        insideAlpha = 1,
        outsideAlpha = 0.5
    }
    
    return self.Range
end

oUF:RegisterMetaFunction("CreateRange", UF.CreateRange)