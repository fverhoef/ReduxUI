local addonName, ns = ...
local R = _G.ReduxUI

R.Grid = CreateFrame("Frame", nil, UIParent)
R.Grid:SetFrameStrata("BACKGROUND")
R.Grid:Hide()
R.Grid.linePool = {}
R.Grid.activeLines = {}
R.Grid.gridSize = 32
R.Grid.needsDrawing = true

R.Grid.bg = R.Grid:CreateTexture(nil, "BACKGROUND", nil, -7)
R.Grid.bg:SetAllPoints()
R.Grid.bg:SetColorTexture(0, 0, 0, 0.33)

function R:GetGridLine()
    if not next(R.Grid.linePool) then table.insert(R.Grid.linePool, R.Grid:CreateTexture()) end

    local line = table.remove(R.Grid.linePool, 1)
    line:ClearAllPoints()
    line:Show()

    table.insert(R.Grid.activeLines, line)

    return line
end

function R:ReleaseGridLines()
    while next(R.Grid.activeLines) do
        local line = table.remove(R.Grid.activeLines, 1)
        line:ClearAllPoints()
        line:Hide()

        table.insert(R.Grid.linePool, line)
    end
end

function R:HideGrid() R.Grid:Hide() end

function R:ShowGrid()
    if R.Grid.needsDrawing then
        R:DrawGrid()
        R.Grid.needsDrawing = false
    end
    R.Grid:Show()
end

function R:DrawGrid()
    R:ReleaseGridLines()

    local screenWidth, screenHeight = UIParent:GetRight(), UIParent:GetTop()
    local screenCenterX, screenCenterY = UIParent:GetCenter()

    R.Grid:SetSize(screenWidth, screenHeight)
    R.Grid:SetPoint("CENTER")
    R.Grid:Show()

    local yAxis = R:GetGridLine()
    yAxis:SetDrawLayer("BACKGROUND", 1)
    yAxis:SetColorTexture(0.9, 0.1, 0.1)
    yAxis:SetPoint("TOPLEFT", R.Grid, "TOPLEFT", screenCenterX - 1, 0)
    yAxis:SetPoint("BOTTOMRIGHT", R.Grid, "BOTTOMLEFT", screenCenterX + 1, 0)

    local xAxis = R:GetGridLine()
    xAxis:SetDrawLayer("BACKGROUND", 1)
    xAxis:SetColorTexture(0.9, 0.1, 0.1)
    xAxis:SetPoint("TOPLEFT", R.Grid, "BOTTOMLEFT", 0, screenCenterY + 1)
    xAxis:SetPoint("BOTTOMRIGHT", R.Grid, "BOTTOMRIGHT", 0, screenCenterY - 1)

    local l = R:GetGridLine()
    l:SetDrawLayer("BACKGROUND", 2)
    l:SetColorTexture(0.8, 0.8, 0.1)
    l:SetPoint("TOPLEFT", R.Grid, "TOPLEFT", screenWidth / 3 - 1, 0)
    l:SetPoint("BOTTOMRIGHT", R.Grid, "BOTTOMLEFT", screenWidth / 3 + 1, 0)

    local r = R:GetGridLine()
    r:SetDrawLayer("BACKGROUND", 2)
    r:SetColorTexture(0.8, 0.8, 0.1)
    r:SetPoint("TOPRIGHT", R.Grid, "TOPRIGHT", -screenWidth / 3 + 1, 0)
    r:SetPoint("BOTTOMLEFT", R.Grid, "BOTTOMRIGHT", -screenWidth / 3 - 1, 0)

    -- horiz lines
    local tex
    for i = 1, math.floor(screenHeight / 2 / R.Grid.gridSize) do
        tex = R:GetGridLine()
        tex:SetDrawLayer("BACKGROUND", 0)
        tex:SetColorTexture(0, 0, 0)
        tex:SetPoint("TOPLEFT", R.Grid, "BOTTOMLEFT", 0, screenCenterY + 1 + R.Grid.gridSize * i)
        tex:SetPoint("BOTTOMRIGHT", R.Grid, "BOTTOMRIGHT", 0, screenCenterY - 1 + R.Grid.gridSize * i)

        tex = R:GetGridLine()
        tex:SetDrawLayer("BACKGROUND", 0)
        tex:SetColorTexture(0, 0, 0)
        tex:SetPoint("BOTTOMLEFT", R.Grid, "BOTTOMLEFT", 0, screenCenterY - 1 - R.Grid.gridSize * i)
        tex:SetPoint("TOPRIGHT", R.Grid, "BOTTOMRIGHT", 0, screenCenterY + 1 - R.Grid.gridSize * i)
    end

    -- vert lines
    for i = 1, math.floor(screenWidth / 2 / R.Grid.gridSize) do
        tex = R:GetGridLine()
        tex:SetDrawLayer("BACKGROUND", 0)
        tex:SetColorTexture(0, 0, 0)
        tex:SetPoint("TOPLEFT", R.Grid, "TOPLEFT", screenCenterX - 1 - R.Grid.gridSize * i, 0)
        tex:SetPoint("BOTTOMRIGHT", R.Grid, "BOTTOMLEFT", screenCenterX + 1 - R.Grid.gridSize * i, 0)

        tex = R:GetGridLine()
        tex:SetDrawLayer("BACKGROUND", 0)
        tex:SetColorTexture(0, 0, 0)
        tex:SetPoint("TOPRIGHT", R.Grid, "TOPLEFT", screenCenterX + 1 + R.Grid.gridSize * i, 0)
        tex:SetPoint("BOTTOMLEFT", R.Grid, "BOTTOMLEFT", screenCenterX - 1 + R.Grid.gridSize * i, 0)
    end
end