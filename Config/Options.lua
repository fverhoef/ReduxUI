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
                        normal = {
                            name = L["Standard Text"],
                            type = "select",
                            order = 1,
                            dialogControl = "LSM30_Font",
                            values = R.Libs.SharedMedia:HashTable("font"),
                            get = function()
                                for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do if R.config.db.profile.fonts.normal == font then return key end end
                            end,
                            set = function(_, key)
                                R.config.db.profile.fonts.normal = R.Libs.SharedMedia:Fetch("font", key)
                                R:UpdateBlizzardFonts()
                            end
                        },
                        number = {
                            name = L["Numbers"],
                            type = "select",
                            order = 2,
                            dialogControl = "LSM30_Font",
                            values = R.Libs.SharedMedia:HashTable("font"),
                            get = function()
                                for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do if R.config.db.profile.fonts.number == font then return key end end
                            end,
                            set = function(_, key)
                                R.config.db.profile.fonts.number = R.Libs.SharedMedia:Fetch("font", key)
                                R:UpdateBlizzardFonts()
                            end
                        },
                        -- TODO: warn that changing this option requires a relog
                        damage = {
                            name = L["Damage"],
                            type = "select",
                            order = 3,
                            dialogControl = "LSM30_Font",
                            values = R.Libs.SharedMedia:HashTable("font"),
                            get = function()
                                for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do if R.config.db.profile.fonts.damage == font then return key end end
                            end,
                            set = function(_, key)
                                R.config.db.profile.fonts.damage = R.Libs.SharedMedia:Fetch("font", key)
                                R:UpdateBlizzardFonts()
                            end
                        },
                        -- TODO: warn that changing this option requires a relog
                        unitName = {
                            name = L["Unit Names"],
                            type = "select",
                            order = 4,
                            dialogControl = "LSM30_Font",
                            values = R.Libs.SharedMedia:HashTable("font"),
                            get = function()
                                for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do if R.config.db.profile.fonts.unitName == font then return key end end
                            end,
                            set = function(_, key)
                                R.config.db.profile.fonts.unitName = R.Libs.SharedMedia:Fetch("font", key)
                                R:UpdateBlizzardFonts()
                            end
                        },
                        chatBubble = {
                            name = L["Chat Bubbles"],
                            type = "select",
                            order = 5,
                            dialogControl = "LSM30_Font",
                            values = R.Libs.SharedMedia:HashTable("font"),
                            get = function()
                                for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do if R.config.db.profile.fonts.chatBubble == font then return key end end
                            end,
                            set = function(_, key)
                                R.config.db.profile.fonts.chatBubble = R.Libs.SharedMedia:Fetch("font", key)
                                R:UpdateBlizzardFonts()
                            end
                        }
                    }
                },
                screenSaver = {
                    type = "group",
                    name = L["Screen Saver"],
                    order = 30,
                    inline = true,
                    hidden = function() R.Modules.ScreenSaver and true or false end,
                    args = {
                        type = "toggle",
                        name = L["Enabled"],
                        order = 1,
                        confirm = function()
                            if R.Modules.ScreenSaver.config.enabled then
                                return L["Disabling the screen saver requires a UI reload. Proceed?"]
                            else
                                return false
                            end
                        end,
                        get = function()
                            return R.Modules.ScreenSaver.config.enabled
                        end,
                        set = function(_, val)
                            R.Modules.ScreenSaver.config.enabled = val
                            if not val then
                                ReloadUI()
                            else
                                SS:Initialize()
                            end
                        end
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
