local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateRange()
    self.Range = {
        insideAlpha = 1,
        outsideAlpha = 0.5
    }
    
    return self.Range
end

oUF:RegisterMetaFunction("CreateRange", UF.CreateRange)

function UF:UpdateRange()
    if not self.Range then
        return
    end
    
    self.Range.insideAlpha = 1
    self.Range.outsideAlpha = 0.5
end

oUF:RegisterMetaFunction("UpdateRange", UF.UpdateRange)