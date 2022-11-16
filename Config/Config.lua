local addonName, ns = ...
local R = _G.ReduxUI

R.NORMAL_FONT_COLOR = {255 / 255, 209 / 255, 0 / 255}
R.HIGHLIGHT_FONT_COLOR = {255 / 255, 255 / 255, 255 / 255}
R.GREEN_FONT_COLOR = {25 / 255, 255 / 255, 25 / 255}
R.RED_FONT_COLOR = {255 / 255, 25 / 255, 25 / 255}
R.GRAY_FONT_COLOR = {127 / 255, 127 / 255, 127 / 255}
R.DARK_GRAY_FONT_COLOR = {89 / 255, 89 / 255, 89 / 255}

R.config = {}
R.config.defaults = {
    profile = {
        modules = {}
    },
    char = {modules = {}},
    realm = {inventory = {}, modules = {}}
}

R.config.faders = {none = nil, onShow = 1, mouseOver = 2}

function R:RegisterModuleConfig(module, profile, char, realm)
    R.config.defaults.profile.modules[module.name] = profile
    module.defaults = profile
    if char then
        R.config.defaults.char.modules[module.name] = char
        module.charDefaults = char
    end
    if realm then
        R.config.defaults.realm.modules[module.name] = realm
        module.realmDefaults = realm
    end
end

function R:SetupConfig() R.config.db = R.Libs.AceDB:New(addonName .. "_DB", R.config.defaults) end
