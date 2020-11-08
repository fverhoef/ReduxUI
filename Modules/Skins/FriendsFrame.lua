local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local S = Addon.Modules.Skins

function S:StyleFriendsFrame()
    S:SecureHook("FriendsFrame_UpdateFriends", function()
        local scrollFrame = FriendsFrameFriendsScrollFrame
        local buttons = scrollFrame.buttons
        local numButtons = #buttons

        for i = 1, numButtons do
            local button = buttons[i]
            if button.index and button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
                local info = C_FriendList.GetFriendInfoByIndex(button.id)
                local classFileName = Addon:UnlocalizedClassName(info.className)
                local classTextColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[classFileName] or RAID_CLASS_COLORS[classFileName]
                if classTextColor then
                    button.name:SetTextColor(classTextColor.r, classTextColor.g, classTextColor.b)

                    if not button.icon then
                        button.icon = button:CreateTexture("$parentIcon", "ARTWORK")
                        button.icon:SetPoint("LEFT", 20, 0)
                        button.icon:SetSize(25, 25)
                        button.icon:SetTexture([[Interface\WorldStateFrame\Icons-Classes]])
                        button.icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFileName]))
                    end

                    Addon:OffsetFrame(button.name, 30, 0)
                end
            end
        end
    end)
end
