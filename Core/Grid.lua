local addonName, ns = ...
local R = _G.ReduxUI

R.grid = CreateFrame("Frame", nil, UIParent)
R.grid:SetFrameStrata("BACKGROUND")
R.grid:Hide()
R.grid.linePool = {}
R.grid.activeLines = {}
R.grid.gridSize = 32
R.grid.needsDrawing = true

R.grid.bg = R.grid:CreateTexture(nil, "BACKGROUND", nil, -7)
R.grid.bg:SetAllPoints()
R.grid.bg:SetColorTexture(0, 0, 0, 0.33)

function R:GetGridLine()
    if not next(R.grid.linePool) then table.insert(R.grid.linePool, R.grid:CreateTexture()) end

    local line = table.remove(R.grid.linePool, 1)
    line:ClearAllPoints()
    line:Show()

    table.insert(R.grid.activeLines, line)

    return line
end

function R:ReleaseGridLines()
    while next(R.grid.activeLines) do
        local line = table.remove(R.grid.activeLines, 1)
        line:ClearAllPoints()
        line:Hide()

        table.insert(R.grid.linePool, line)
    end
end

function R:HideGrid() R.grid:Hide() end

function R:ShowGrid()
    if R.grid.needsDrawing then
        R:DrawGrid()
        R.grid.needsDrawing = false
    end
    R.grid:Show()
end

function R:DrawGrid()
    R:ReleaseGridLines()

    local screenWidth, screenHeight = UIParent:GetRight(), UIParent:GetTop()
    local screenCenterX, screenCenterY = UIParent:GetCenter()

    R.grid:SetSize(screenWidth, screenHeight)
    R.grid:SetPoint("CENTER")
    R.grid:Show()

    local yAxis = R:GetGridLine()
    yAxis:SetDrawLayer("BACKGROUND", 1)
    yAxis:SetColorTexture(0.9, 0.1, 0.1)
    yAxis:SetPoint("TOPLEFT", R.grid, "TOPLEFT", screenCenterX - 1, 0)
    yAxis:SetPoint("BOTTOMRIGHT", R.grid, "BOTTOMLEFT", screenCenterX + 1, 0)

    local xAxis = R:GetGridLine()
    xAxis:SetDrawLayer("BACKGROUND", 1)
    xAxis:SetColorTexture(0.9, 0.1, 0.1)
    xAxis:SetPoint("TOPLEFT", R.grid, "BOTTOMLEFT", 0, screenCenterY + 1)
    xAxis:SetPoint("BOTTOMRIGHT", R.grid, "BOTTOMRIGHT", 0, screenCenterY - 1)

    local l = R:GetGridLine()
    l:SetDrawLayer("BACKGROUND", 2)
    l:SetColorTexture(0.8, 0.8, 0.1)
    l:SetPoint("TOPLEFT", R.grid, "TOPLEFT", screenWidth / 3 - 1, 0)
    l:SetPoint("BOTTOMRIGHT", R.grid, "BOTTOMLEFT", screenWidth / 3 + 1, 0)

    local r = R:GetGridLine()
    r:SetDrawLayer("BACKGROUND", 2)
    r:SetColorTexture(0.8, 0.8, 0.1)
    r:SetPoint("TOPRIGHT", R.grid, "TOPRIGHT", -screenWidth / 3 + 1, 0)
    r:SetPoint("BOTTOMLEFT", R.grid, "BOTTOMRIGHT", -screenWidth / 3 - 1, 0)

    -- horiz lines
    local tex
    for i = 1, math.floor(screenHeight / 2 / R.grid.gridSize) do
        tex = R:GetGridLine()
        tex:SetDrawLayer("BACKGROUND", 0)
        tex:SetColorTexture(0, 0, 0)
        tex:SetPoint("TOPLEFT", R.grid, "BOTTOMLEFT", 0, screenCenterY + 1 + R.grid.gridSize * i)
        tex:SetPoint("BOTTOMRIGHT", R.grid, "BOTTOMRIGHT", 0, screenCenterY - 1 + R.grid.gridSize * i)

        tex = R:GetGridLine()
        tex:SetDrawLayer("BACKGROUND", 0)
        tex:SetColorTexture(0, 0, 0)
        tex:SetPoint("BOTTOMLEFT", R.grid, "BOTTOMLEFT", 0, screenCenterY - 1 - R.grid.gridSize * i)
        tex:SetPoint("TOPRIGHT", R.grid, "BOTTOMRIGHT", 0, screenCenterY + 1 - R.grid.gridSize * i)
    end

    -- vert lines
    for i = 1, math.floor(screenWidth / 2 / R.grid.gridSize) do
        tex = R:GetGridLine()
        tex:SetDrawLayer("BACKGROUND", 0)
        tex:SetColorTexture(0, 0, 0)
        tex:SetPoint("TOPLEFT", R.grid, "TOPLEFT", screenCenterX - 1 - R.grid.gridSize * i, 0)
        tex:SetPoint("BOTTOMRIGHT", R.grid, "BOTTOMLEFT", screenCenterX + 1 - R.grid.gridSize * i, 0)

        tex = R:GetGridLine()
        tex:SetDrawLayer("BACKGROUND", 0)
        tex:SetColorTexture(0, 0, 0)
        tex:SetPoint("TOPRIGHT", R.grid, "TOPLEFT", screenCenterX + 1 + R.grid.gridSize * i, 0)
        tex:SetPoint("BOTTOMLEFT", R.grid, "BOTTOMLEFT", screenCenterX - 1 + R.grid.gridSize * i, 0)
    end
end