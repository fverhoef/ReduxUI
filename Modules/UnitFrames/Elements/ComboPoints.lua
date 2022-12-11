local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = select(2, ...).oUF or oUF

function UF:CreateComboPointBar()
    if not self.config.comboPoints.enabled or R.isRetail then
        return
    end

    self.ComboPointBar = CreateFrame("Frame", "$parentComboPoints", self)
    self.ComboPointBar:SetParent(self.Overlay)
    self.ComboPointBar.PostUpdate = UF.ComboPointBar_PostUpdate
    self.ComboPointBar.PostCreateComboPoint = UF.ComboPointBar_PostCreateComboPoint

    return self.ComboPointBar
end

oUF:RegisterMetaFunction("CreateComboPointBar", UF.CreateComboPointBar)

function UF:ConfigureComboPointBar()
    local config = self.config.comboPoints
    if not config.enabled or R.isRetail then
        self:DisableElement("ComboPointBar")
        return
    elseif not self.ComboPointBar then
        self:CreateComboPointBar()
    end

    self:EnableElement("ComboPointBar")

    self.ComboPointBar:ClearAllPoints()
    self.ComboPointBar:SetNormalizedPoint(config.point)
    self.ComboPointBar.size = config.size
    self.ComboPointBar.spacing = config.spacing
    self.ComboPointBar:ForceUpdate()
end

oUF:RegisterMetaFunction("ConfigureComboPointBar", UF.ConfigureComboPointBar)

function UF:ComboPointBar_PostUpdate()
    local config = self.__owner.config.comboPoints
    local portrait = self.__owner.Portrait

    if config.attachToPortrait and portrait then
        local radius = portrait:GetWidth() / 2 + 2
        local x, y
        for i, comboPoint in ipairs(self.ComboPoints) do
            x, y = R:PolarToXY(30 * i, radius)
            comboPoint:SetParent(self.__owner.Overlay)
            comboPoint:ClearAllPoints()
            comboPoint:SetPoint("CENTER", portrait, "CENTER", x, y)
        end
    end
end

function UF:ComboPointBar_PostCreateComboPoint(comboPoint)
    comboPoint.Background:SetTexture(R.media.textures.unitFrames.comboPointBackground)
    comboPoint.Background:SetTexCoord(0, 1, 0, 1)
    comboPoint.Background:SetAllPoints()

    comboPoint.Fill:SetTexture(R.media.textures.unitFrames.comboPointFill)
    comboPoint.Fill:SetTexCoord(0, 1, 0, 1)
    comboPoint.Fill:SetAllPoints()
end
