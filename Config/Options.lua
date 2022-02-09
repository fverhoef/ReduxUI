local addonName, ns = ...
local R = _G.ReduxUI
local L = R.L

local function FindPanel(name, parent)
    for i, button in next, InterfaceOptionsFrameAddOns.buttons do
        if button.element then
            if name and button.element.name == name then
                return button
            elseif parent and button.element.parent == parent then
                return button
            end
        end
    end
end

local function AddLogo(frame)
    local logo = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
    logo:SetFrameLevel(4)
    logo:SetSize(64, 64)
    logo:SetPoint("TOPRIGHT", 8, 24)
    logo:SetBackdrop({bgFile = R.media.textures.logo})

    frame.logo = logo
end

function R:SetupOptions()
    R.config.options.args.profiles = R.Libs.AceDBOptions:GetOptionsTable(R.config.db)
    R.config.options.args.profiles.order = 99

    R.Libs.AceConfigRegistry:RegisterOptionsTable(R.name, R.config.options)
    R.config.dialog = R.Libs.AceConfigDialog:AddToBlizOptions(R.name, R.title)
    R.config.dialog:HookScript("OnShow", function()
        local p = FindPanel(R.name)
        if p and p.element.collapsed then OptionsListButtonToggle_OnClick(p.toggle) end
    end)

    AddLogo(R.config.dialog)
    R.Libs.AceConfigDialog:SetDefaultSize(R.name, 900, 700)
end

function R:RegisterModuleOptions(module, options)
    options.order = 100 + #R.config.options.args
    R.config.options.args[module.name] = options
    module.options = options
end

function R:ShowOptionsDialog()
    R.Libs.AceConfigDialog:Open(addonName)
end

R.config.options = {
    type = "group",
    name = R.title,
    args = {
        general = {
            type = "group",
            name = "General",
            order = 1,
            args = {
                header = {type = "header", name = R.title .. " > General", order = 0},
                desc = {order = 1, type = "description", name = L["These are features that apply to every module."]},
                toggleFrameLock = {
                    order = 2,
                    type = "execute",
                    name = function() return R.framesLocked and L["Unlock Frames"] or L["Lock Frames"] end,
                    desc = L["Lock/unlock all movable frames."],
                    func = function()
                        if R.framesLocked then
                            R:ShowDragFrames()
                        else
                            R:HideDragFrames()
                        end
                    end
                },
                resetFrames = {order = 3, type = "execute", name = L["Reset Frames"], desc = L["Reset the position of all movable frames."], func = function() R:ResetFrames() end},
                fonts = {
                    type = "group",
                    name = L["Fonts"],
                    order = 10,
                    inline = true,
                    args = {
                        normal = R:CreateFontOption(L["Standard Text"], nil, 1, nil, function() return R.config.db.profile.fonts.normal end,
                                                    function(value) R.config.db.profile.fonts.normal = value end, R.UpdateBlizzardFonts),
                        number = R:CreateFontOption(L["Numbers"], nil, 2, nil, function() return R.config.db.profile.fonts.number end, function(value)
                            R.config.db.profile.fonts.number = value
                        end, R.UpdateBlizzardFonts),
                        -- TODO: warn that changing this option requires a relog
                        damage = R:CreateFontOption(L["Damage"], nil, 3, nil, function() return R.config.db.profile.fonts.damage end, function(value)
                            R.config.db.profile.fonts.damage = value
                        end, R.UpdateBlizzardFonts),
                        -- TODO: warn that changing this option requires a relog
                        unitName = R:CreateFontOption(L["Unit Names"], nil, 4, nil, function() return R.config.db.profile.fonts.unitName end,
                                                      function(value) R.config.db.profile.fonts.unitName = value end, R.UpdateBlizzardFonts),
                        chatBubble = R:CreateFontOption(L["Chat Bubbles"], nil, 5, nil, function() return R.config.db.profile.fonts.chatBubble end,
                                                        function(value) R.config.db.profile.fonts.chatBubble = value end, R.UpdateBlizzardFonts)
                    }
                },
                screenSaver = {
                    type = "group",
                    name = L["Screen Saver"],
                    order = 30,
                    inline = true,
                    hidden = function() return R.Modules.ScreenSaver and true or false end,
                    args = {
                        enabled = R:CreateToggleOption(L["Enabled"], nil, 1, nil, nil, function() return R.Modules.ScreenSaver.config.enabled end,
                                                       function(value) R.Modules.ScreenSaver.config.enabled = value end,
                                                       function() (not R.Modules.ScreenSaver.config.enabled and ReloadUI or R.Modules.ScreenSaver.Initialize)() end,
                                                       function() return R.Modules.ScreenSaver.config.enabled and L["Disabling this module requires a UI reload. Proceed?"] end)
                    }
                },
                inventoryDatabase = {
                    type = "group",
                    name = L["Inventory Database"],
                    order = 40,
                    inline = true,
                    args = {
                        character = {
                            type = "select",
                            name = L["Characters"],
                            desc = L["Characters in the inventory database."],
                            order = 1,
                            values = R.Modules.InventoryDatabase.GetCharacterKeys,
                            get = function() return R.Modules.InventoryDatabase.selectedCharacter end,
                            set = function(_, key) R.Modules.InventoryDatabase.selectedCharacter = key end
                        },
                        clear = {
                            order = 2,
                            type = "execute",
                            name = L["Clear Character Database"],
                            disabled = function() return R.Modules.InventoryDatabase.selectedCharacter == nil end,
                            func = function() R.Modules.InventoryDatabase:ClearCharacterDatabase(R.Modules.InventoryDatabase.selectedCharacter) end
                        }
                    }
                }
            }
        }
    }
}
