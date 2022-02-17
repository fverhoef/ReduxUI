local addonName, ns = ...
local R = _G.ReduxUI
local C = R:AddModule("Chat", "AceEvent-3.0", "AceHook-3.0")

C.HyperlinkTypes = {
    achievement = true,
    apower = true,
    currency = true,
    enchant = true,
    glyph = true,
    instancelock = true,
    item = true,
    keystone = true,
    quest = true,
    spell = true,
    talent = true,
    unit = true
}

function C:Initialize()
    if not C.config.enabled then return end

    C.chatMessages = C.charConfig.chatMessages

    CHAT_FONT_HEIGHTS = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}

    CHAT_TAB_HIDE_DELAY = 1
    CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1
    CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
    CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
    CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
    CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1
    CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 1

    CHAT_WHISPER_GET = "From %s "
    CHAT_WHISPER_INFORM_GET = "To %s "
    CHAT_BN_WHISPER_GET = "From %s "
    CHAT_BN_WHISPER_INFORM_GET = "To %s "
    CHAT_YELL_GET = "%s "
    CHAT_SAY_GET = "%s "
    CHAT_BATTLEGROUND_GET = "|Hchannel:Battleground|hBG.|h %s: "
    CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:Battleground|hBGL.|h %s: "
    CHAT_GUILD_GET = "|Hchannel:Guild|hG.|h %s: "
    CHAT_OFFICER_GET = "|Hchannel:Officer|hGO.|h %s: "
    CHAT_PARTY_GET = "|Hchannel:Party|hP.|h %s: "
    CHAT_PARTY_LEADER_GET = "|Hchannel:Party|hPL.|h %s: "
    CHAT_PARTY_GUIDE_GET = "|Hchannel:Party|hPG.|h %s: "
    CHAT_RAID_GET = "|Hchannel:Raid|hR.|h %s: "
    CHAT_RAID_LEADER_GET = "|Hchannel:Raid|hRL.|h %s: "
    CHAT_RAID_WARNING_GET = "|Hchannel:RaidWarning|hRW.|h %s: "
    CHAT_INSTANCE_CHAT_GET = "|Hchannel:Battleground|hI.|h %s: "
    CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:Battleground|hIL.|h %s: "
    -- CHAT_MONSTER_PARTY_GET       = CHAT_PARTY_GET
    -- CHAT_MONSTER_SAY_GET         = CHAT_SAY_GET
    -- CHAT_MONSTER_WHISPER_GET     = CHAT_WHISPER_GET
    -- CHAT_MONSTER_YELL_GET        = CHAT_YELL_GET
    CHAT_FLAG_AFK = "<AFK> "
    CHAT_FLAG_DND = "<DND> "
    CHAT_FLAG_GM = "<[GM]> "

    YOU_LOOT_MONEY_GUILD = YOU_LOOT_MONEY
    LOOT_MONEY_SPLIT_GUILD = LOOT_MONEY_SPLIT

    BNToastFrame:SetClampedToScreen(true)
    BNToastFrame:SetClampRectInsets(-15, 15, 15, -15)

    for i = 1, NUM_CHAT_WINDOWS do
        local chatframe = _G["ChatFrame" .. i]
        chatframe:SetSize(unpack(C.config.size))
        chatframe:SetPoint(unpack(C.config.point))

        if (i ~= 2) then
            chatframe.AddMessage_Base = chatframe.AddMessage
            chatframe.AddMessage = C.ChatFrame_AddMessage
        end

        C:LoadChatHistory(chatframe)
    end

    C:SecureHook("FCF_OpenTemporaryWindow", C.FloatingChatFrame_OpenTemporaryWindow)
    C:SecureHook("FloatingChatFrame_UpdateBackgroundAnchors", C.FloatingChatFrame_UpdateBackgroundAnchors)

    FloatingChatFrame_OnMouseScroll = C.FloatingChatFrame_OnMouseScroll

    C:UpdateChatFrames()
end

local function FormatChannelNames(text)
    return text:gsub("(|h%[%d+%. .-%]|h)", function(s)
        local index = s:match("|h%[(%d+)%.")
        local channel = s:match("|h%[%d+%. (.-)%]|h")

        -- replace "General - Orgrimmar" with "General", and similarly for Trade, LocalDefense etc
        local general = channel:match("(.+) %- .+")
        if general then
            channel = general
        else
            -- abbreviate channel names using only their uppercased letters
            local abbr = ""
            for letter in string.gmatch(channel, "%u") do abbr = abbr .. letter end
            if abbr ~= "" then
                channel = abbr
            else
                channel = channel:sub(1, 1):upper()
            end
        end

        return "|h" .. index .. ". " .. channel .. "|h"
    end)
end

local function FormatUrls(text) return text:gsub("([wWhH][wWtT][wWtT][%.pP]%S+[^%p%s])", "|cffffffff|Hurl:%1|h[%1]|h|r") end

function C:ChatFrame_AddMessage(text, ...)
    C:StoreChatMessage(self, text, ...)

    text = FormatChannelNames(text)
    text = FormatUrls(text)

    -- TODO: support emojis
    -- TODO: support [inv] links

    return self.AddMessage_Base(self, text, ...)
end

local SetHyperlink = _G.ItemRefTooltip.SetHyperlink
function _G.ItemRefTooltip:SetHyperlink(data, ...)
    local type, value = data:match("(%a+):(.+)")
    if type == "url" then
        C:SetEditBoxMessage(value)
    else
        SetHyperlink(self, data, ...)
    end
end

function C:FloatingChatFrame_OpenTemporaryWindow()
    for _, name in next, CHAT_FRAMES do
        local chatframe = _G[name]
        if (chatframe.isTemporary) then C:SkinChatFrame(chatframe) end
    end
end

function C:FloatingChatFrame_UpdateBackgroundAnchors() self:SetClampRectInsets(0, 0, 0, 0) end

function C:FloatingChatFrame_OnMouseScroll(dir)
    if (dir > 0) then
        if (IsShiftKeyDown()) then
            self:ScrollToTop()
        else
            self:ScrollUp()
        end
    else
        if (IsShiftKeyDown()) then
            self:ScrollToBottom()
        else
            self:ScrollDown()
        end
    end
end

function C:UpdateChatFrames()
    ChatFontNormal:SetFont(C.config.font, C.config.fontSize or 13, C.config.fontOutline or "OUTLINE")
    if ChatFontNormal.SetShadowOffset then ChatFontNormal:SetShadowOffset(C.config.fontShadow and 1 or 0, C.config.fontShadow and -1 or 0) end

    ChatFrameMenuButton:HookScript("OnShow", function() if C.config.hideMenuButton then ChatFrameMenuButton:Hide() end end)
    if C.config.hideMenuButton then
        ChatFrameMenuButton:Hide()
    else
        ChatFrameMenuButton:Show()
    end

    ChatFrameChannelButton:HookScript("OnShow", function() if C.config.hideChannelButton then ChatFrameChannelButton:Hide() end end)
    if C.config.hideChannelButton then
        ChatFrameChannelButton:Hide()
    else
        ChatFrameChannelButton:Show()
    end

    if QuickJoinToastButton then
        QuickJoinToastButton:HookScript("OnShow", function() if C.config.hideSocialButton then QuickJoinToastButton:Hide() end end)
        if C.config.hideSocialButton then
            QuickJoinToastButton:Hide()
        else
            QuickJoinToastButton:Show()
        end
    end

    if C.config.showClassColors then
        SetCVar("chatClassColorOverride", 0)
    else
        SetCVar("chatClassColorOverride", 1)
    end

    for i = 1, NUM_CHAT_WINDOWS do
        local chatframe = _G["ChatFrame" .. i]
        C:SkinChatFrame(chatframe)
    end

    for _, name in next, CHAT_FRAMES do
        local chatframe = _G[name]
        if (chatframe.isTemporary) then C:SkinChatFrame(chatframe) end
    end
end

function C:SkinChatFrame(frame)
    if not frame then return end

    local name = frame:GetName()

    frame:SetClampRectInsets(0, 0, 0, 0)
    frame:SetMaxResize(UIParent:GetWidth() / 2, UIParent:GetHeight() / 2)
    frame:SetMinResize(100, 50)
    frame:SetFont(C.config.font, C.config.fontSize or 13, C.config.fontOutline or "OUTLINE")
    if frame.SetShadowOffset then frame:SetShadowOffset(C.config.fontShadow and 1 or 0, C.config.fontShadow and -1 or 0) end

    frame:SetFading(true)

    local buttonFrame = _G[name .. "ButtonFrame"]
    buttonFrame:HookScript("OnShow", buttonFrame.Hide)
    buttonFrame:Hide()

    local editBox = _G[name .. "EditBox"]
    editBox:SetAltArrowKeyMode(false)

    _G[name .. "EditBoxLeft"]:Hide()
    _G[name .. "EditBoxMid"]:Hide()
    _G[name .. "EditBoxRight"]:Hide()

    editBox:ClearAllPoints()
    if name == "ChatFrame2" then
        editBox:SetPoint("BOTTOM", frame, "TOP", 0, 22 + 24)
    else
        editBox:SetPoint("BOTTOM", frame, "TOP", 0, 22)
    end
    editBox:SetPoint("LEFT", frame, -5, 0)
    editBox:SetPoint("RIGHT", frame, 10, 0)

    frame:SetMaxLines(C.config.maxMessageCount)

    if not frame.scriptsSet then
        C:HookScript(frame, "OnHyperlinkEnter")
        C:HookScript(frame, "OnHyperlinkLeave")
        C:HookScript(frame, "OnMouseWheel")

        frame.scriptsSet = true
    end
end

function C:GetFrameHistory(frame)
    local frameName = frame:GetName()
    if not C.chatMessages[frameName] then C.chatMessages[frameName] = {} end

    return C.chatMessages[frameName]
end

function C:LoadChatHistory(frame)
    local db = C:GetFrameHistory(frame)

    if db and #db > 0 then
        frame.isLoadingHistory = true
        for i, message in next, db do if message.text then frame.AddMessage(frame, message.text, unpack(message.args)) end end
        frame.isLoadingHistory = false
    end
end

function C:ClearChatHistory()
    C.charConfig.chatMessages = {}
    C.chatMessages = C.charConfig.chatMessages
end

function C:StoreChatMessage(frame, text, ...)
    if frame.isLoadingHistory then return end

    local patterns = {
        "|Hplayer:", -- Say/Yell/Whisper
        "|Hchannel:" -- Channel messages
    }

    local matchesPattern = false
    for i, pattern in next, patterns do
        if strfind(text, pattern) then
            matchesPattern = true
            break
        end
    end

    if not matchesPattern then return end

    local message = {text = text, time = time(), args = {...}}
    local db = C:GetFrameHistory(frame)
    table.insert(db, message)

    local count = #db
    local countOverMax = count - C.config.maxHistoryCount
    if countOverMax > 0 then for i = 1, countOverMax do table.remove(db, 1) end end
end

function C:OnHyperlinkEnter(frame, refString)
    if InCombatLockdown() then return end

    local linkToken = strmatch(refString, "^([^:]+)")
    if C.HyperlinkTypes[linkToken] then
        _G.GameTooltip:SetOwner(frame, "ANCHOR_CURSOR")
        _G.GameTooltip:SetHyperlink(refString)
        _G.GameTooltip:Show()
        C.HyperLinkFrame = frame
    end
end

function C:OnHyperlinkLeave()
    if C.HyperLinkFrame then
        C.HyperLinkFrame = nil
        _G.GameTooltip:Hide()
    end
end

function C:OnMouseWheel(self, delta)
    if C.HyperLinkFrame == self then
        C.HyperLinkFrame = nil
        _G.GameTooltip:Hide()
    end

    local numScrollMessages = 3
    if delta < 0 then
        if IsShiftKeyDown() then
            self:ScrollToBottom()
        elseif IsAltKeyDown() then
            self:ScrollDown()
        else
            for _ = 1, numScrollMessages do self:ScrollDown() end
        end
    elseif delta > 0 then
        if IsShiftKeyDown() then
            self:ScrollToTop()
        elseif IsAltKeyDown() then
            self:ScrollUp()
        else
            for _ = 1, numScrollMessages do self:ScrollUp() end
        end
    end
end

function C:SetEditBoxMessage(message)
    local editBox = LAST_ACTIVE_CHAT_EDIT_BOX or ChatFrame1EditBox
    if not editBox then return end
    editBox:SetText(message)
    editBox:SetFocus()
    editBox:HighlightText()
    if not editBox:IsShown() then editBox:Show() end
end
