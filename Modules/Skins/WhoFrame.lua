local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

function S:StyleWhoFrame()
    if R.isRetail or not S.config.who.enabled then return end

    local button, level, name, class

    for i = 1, _G.WHOS_TO_DISPLAY do
        button = _G["WhoFrameButton" .. i]
        class = _G["WhoFrameButton" .. i .. "Class"]

        button.icon = button:CreateTexture("$parentIcon", "ARTWORK")
        button.icon:SetPoint("LEFT", class, "LEFT", -20, 0)
        button.icon:SetSize(15, 15)
        button.icon:SetTexture([[Interface\WorldStateFrame\Icons-Classes]])
    end

    S:SecureHook("WhoList_Update", function()
        local numWhos = C_FriendList.GetNumWhoResults()
        if numWhos == 0 then
            return
        end

        local playerZone = GetRealZoneText()

        numWhos = numWhos > WHOS_TO_DISPLAY and WHOS_TO_DISPLAY or numWhos

        local button, buttonText, classTextColor, levelTextColor, info

        for i = 1, numWhos do
            button = _G["WhoFrameButton" .. i]
            class = _G["WhoFrameButton" .. i .. "Class"]
            info = C_FriendList.GetWhoInfo(button.whoIndex)

            if info.filename then
                classTextColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[info.filename] or RAID_CLASS_COLORS[info.filename]
                button.icon:Show()
                button.icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[info.filename]))

                class:Offset(20, 0)
            else
                classTextColor = HIGHLIGHT_FONT_COLOR
                button.icon:Hide()

                class:Offset(0, 0)
            end

            levelTextColor = GetQuestDifficultyColor(info.level)

            buttonText = _G["WhoFrameButton" .. i .. "Name"]
            buttonText:SetTextColor(classTextColor.r, classTextColor.g, classTextColor.b)
            buttonText = _G["WhoFrameButton" .. i .. "Level"]
            buttonText:SetTextColor(levelTextColor.r, levelTextColor.g, levelTextColor.b)
            buttonText = _G["WhoFrameButton" .. i .. "Class"]
            buttonText:SetTextColor(1, 1, 1)
            buttonText = _G["WhoFrameButton" .. i .. "Variable"]
            buttonText:SetTextColor(1, 1, 1)

            if info.area == playerZone then
                buttonText:SetTextColor(0, 1, 0)
            end
        end
    end)
end
