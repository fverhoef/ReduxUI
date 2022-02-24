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
    R.config.options.args.general.args.profiles = R.Libs.AceDBOptions:GetOptionsTable(R.config.db)
    R.config.options.args.general.args.profiles.inline = true
    R.config.options.args.general.args.profiles.order = 99

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
    module.CreateOptions = function()
        options = type(options) == "function" and options() or options
        options.order = 100 + #R.config.options.args
        R.config.options.args[module.name] = options
        module.options = options
    end
end

function R:ShowOptionsDialog() if not InCombatLockdown() then R.Libs.AceConfigDialog:Open(addonName) end end

function R:CloseOptionsDialog() R.Libs.AceConfigDialog:Close(addonName) end

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
                frameMovers = {
                    type = "group",
                    name = L["Frame Movers"],
                    order = 2,
                    inline = true,
                    args = {
                        toggleFrameLock = {
                            order = 2,
                            type = "execute",
                            name = function() return R.framesLocked and L["Unlock Frames"] or L["Lock Frames"] end,
                            desc = L["Lock/unlock all movable frames."],
                            func = function()
                                if R.framesLocked then
                                    R:ShowMovers()
                                else
                                    R:HideMovers()
                                end
                            end
                        },
                        resetFrames = {order = 3, type = "execute", name = L["Reset Frames"], desc = L["Reset the position of all movable frames."], func = function()
                            R:ResetMovers()
                        end}
                    }
                },
                inventoryDatabase = {
                    type = "group",
                    name = L["Inventory Database"],
                    order = 4,
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
