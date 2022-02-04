local addonName, ns = ...
local R = _G.ReduxUI

local blizzardFonts = {
    normal = {
        AchievementCriteriaFont, AchievementDateFont, AchievementDescriptionFont, AchievementFont_Small, AchievementPointsFont, AchievementPointsFontSmall, ArtifactAppearanceSetHighlightFont,
        ArtifactAppearanceSetNormalFont, BossEmoteNormalHuge, CombatLogFont, CombatTextFont, CombatTextFontOutline, CommentatorCCFont, CommentatorDampeningFont, CommentatorDeadFontDefault,
        CommentatorDeadFontLarge, CommentatorDeadFontMedium, CommentatorDeadFontSmall, CommentatorTeamNameFont, CommentatorTeamScoreFont, CommentatorVictoryFanfare, CommentatorVictoryFanfareTeam,
        CoreAbilityFont, DestinyFontHuge, DestinyFontLarge, DestinyFontMed, DialogButtonHighlightText, DialogButtonNormalText, ErrorFont, Fancy12Font, Fancy14Font, Fancy16Font, Fancy18Font,
        Fancy20Font, Fancy22Font, Fancy24Font, Fancy27Font, Fancy30Font, Fancy32Font, Fancy48Font, FocusFontSmall, FriendsFont_Large, FriendsFont_Normal, FriendsFont_Small, FriendsFont_UserText,
        Game11Font, Game11Font_o1, Game120Font, Game12Font, Game12Font_o1, Game13Font, Game13Font_o1, Game13FontShadow, Game15Font, Game15Font_o1, Game16Font, Game18Font, Game20Font, Game24Font,
        Game27Font, Game32Font, Game36Font, Game42Font, Game46Font, Game48Font, Game48FontShadow, Game60Font, Game72Font, GameFont_Gigantic, GameFontBlack, GameFontBlackMedium, GameFontBlackSmall,
        GameFontBlackSmall2, GameFontBlackTiny, GameFontBlackTiny2, GameFontDarkGraySmall, GameFontDisable, GameFontDisableHuge, GameFontDisableLarge, GameFontDisableLeft, GameFontDisableMed3,
        GameFontDisableSmall, GameFontDisableSmall2, GameFontDisableSmallLeft, GameFontDisableTiny, GameFontDisableTiny2, GameFontGreen, GameFontGreenLarge, GameFontGreenSmall, GameFontHighlight,
        GameFontHighlightCenter, GameFontHighlightExtraSmall, GameFontHighlightExtraSmallLeft, GameFontHighlightExtraSmallLeftTop, GameFontHighlightHuge, GameFontHighlightHugeOutline2,
        GameFontHighlightLarge, GameFontHighlightLarge2, GameFontHighlightLeft, GameFontHighlightMed2, GameFontHighlightMedium, GameFontHighlightOutline, GameFontHighlightRight,
        GameFontHighlightSmall, GameFontHighlightSmall2, GameFontHighlightSmallLeft, GameFontHighlightSmallLeftTop, GameFontHighlightSmallOutline, GameFontHighlightSmallRight, GameFontNormal,
        GameFontNormal_NoShadow, GameFontNormalCenter, GameFontNormalGraySmall, GameFontNormalHuge, GameFontNormalHuge2, GameFontNormalHuge3, GameFontNormalHuge3Outline, GameFontNormalHugeBlack,
        GameFontNormalHugeOutline, GameFontNormalHugeOutline2, GameFontNormalLarge, GameFontNormalLarge2, GameFontNormalLargeLeft, GameFontNormalLargeLeftTop, GameFontNormalLargeOutline,
        GameFontNormalLeft, GameFontNormalLeftBottom, GameFontNormalLeftGreen, GameFontNormalLeftGrey, GameFontNormalLeftLightGreen, GameFontNormalLeftOrange, GameFontNormalLeftRed,
        GameFontNormalLeftYellow, GameFontNormalMed1, GameFontNormalMed2, GameFontNormalMed3, GameFontNormalOutline, GameFontNormalRight, GameFontNormalShadowHuge2, GameFontNormalSmall,
        GameFontNormalSmall2, GameFontNormalSmallLeft, GameFontNormalTiny, GameFontNormalTiny2, GameFontNormalWTF2, GameFontNormalWTF2Outline, GameFontRed, GameFontRedLarge, GameFontRedSmall,
        GameFontWhite, GameFontWhiteSmall, GameFontWhiteTiny, GameFontWhiteTiny2, GameNormalNumberFont, GameTooltipHeaderText, GameTooltipText, GameTooltipTextSmall, IMEHighlight, IMENormal,
        InvoiceFont_Med, InvoiceFont_Small, InvoiceTextFontNormal, InvoiceTextFontSmall, ItemTextFontNormal, MailFont_Large, MailTextFontNormal, MovieSubtitleFont, NewSubSpellFont, ObjectiveFont,
        PVPInfoTextFont, QuestDifficulty_Difficult, QuestDifficulty_Header, QuestDifficulty_Impossible, QuestDifficulty_Standard, QuestDifficulty_Trivial, QuestDifficulty_VeryDifficult, QuestFont,
        QuestFont_Enormous, QuestFont_Outline_Huge, QuestFont_Shadow_Huge, QuestFont_Shadow_Small, QuestFont_Super_Huge, QuestFont_Super_Huge_Outline, QuestFontHighlight, QuestFontLeft,
        QuestFontNormalSmall, QuestTitleFont, QuestTitleFontBlackShadow, ReputationDetailFont, SpellFont_Small, SplashHeaderFont, SubSpellFont, SubZoneTextFont, SystemFont_Huge1,
        SystemFont_Huge1_Outline, SystemFont_InverseShadow_Small, SystemFont_LargeNamePlate, SystemFont_LargeNamePlateFixed, SystemFont_NamePlate, SystemFont_NamePlateCastBar,
        SystemFont_NamePlateFixed, SystemFont_NamePlateLevel, SystemFont_Outline, SystemFont_Outline_Small, SystemFont_OutlineThick_Huge2, SystemFont_OutlineThick_Huge4, SystemFont_OutlineThick_WTF,
        TextStatusBarText, TextStatusBarTextLarge, VehicleMenuBarStatusBarText, WhiteNormalNumberFont, WorldMapTextFont, ZoneTextFont
    },
    number = {
        Number12Font_o1, -- PVPRatedTierTemplate / Ranking
        NumberFont_GameNormal, NumberFont_Normal_Med, NumberFont_Outline_Huge, NumberFont_Outline_Large, NumberFont_Outline_Med, NumberFont_OutlineThick_Mono_Small, NumberFont_Small, NumberFontNormal,
        NumberFontNormalGray, NumberFontNormalHuge, NumberFontNormalLarge, NumberFontNormalLargeRight, NumberFontNormalLargeRightGray, NumberFontNormalLargeRightRed, NumberFontNormalLargeRightYellow,
        NumberFontNormalLargeYellow, NumberFontNormalRight, NumberFontNormalRightGray, NumberFontNormalRightRed, NumberFontNormalRightYellow, NumberFontNormalSmall, NumberFontNormalSmallGray,
        NumberFontNormalYellow
    },
    chatBubble = {ChatBubbleFont}
}

function R:UpdateBlizzardFonts()
    DAMAGE_TEXT_FONT = R.config.db.profile.fonts.damage

    if R.config.db.profile.fonts.replaceBlizzardFonts then
        STANDARD_TEXT_FONT = R.config.db.profile.fonts.normal
        UNIT_NAME_FONT = R.config.db.profile.fonts.unitName

        for _, font in next, blizzardFonts.normal do
            if font then
                local fontFace, height, flags = font:GetFont()
                font:SetFont(R.config.db.profile.fonts.normal, height, flags)
            end
        end

        for _, font in next, blizzardFonts.number do
            if font then
                local fontFace, height, flags = font:GetFont()
                font:SetFont(R.config.db.profile.fonts.number, height, flags)
            end
        end

        for _, font in next, blizzardFonts.chatBubble do
            if font then
                local fontFace, height, flags = font:GetFont()
                font:SetFont(R.config.db.profile.fonts.chatBubble, height, flags)
            end
        end
    end
end
