local _, FR = ...

local UIHelper = FR.UIHelper or {}
FR.UIHelper = UIHelper

local NotificationsUI = {}
FR.NotificationsUI = NotificationsUI

local Utils = FR.Utils or {}
FR.Utils = Utils

local settingsName = {
	["bnetFavoriteChangesGame"] = "Battle.net Favorite Changes Game",
	["bnetFavoriteChangesCharacter"] = "Battle.net Favorite Changes Character",
	["bnetFavoriteChangesCharacterZone"] = "Battle.net Favorite Changes Character Zone",
	["bnetFavoriteLevelsCharacter"] = "Battle.net Favorite Levels Character",
	["bnetFriendChangesGame"] = "Battle.net Friend Changes Game",
	["bnetFriendChangesCharacter"] = "Battle.net Friend Changes Character",
	["bnetFriendChangesCharacterZone"] = "Battle.net Friend Changes Character Zone",
	["bnetFriendLevelsCharacter"] = "Battle.net Friend Levels Character",
	["friendChangesCharacterZone"] = "Character Friend Enters New Zone",
	["friendLevelsCharacter"] = "Character Friend Levels Character",
	["guildMemberChangesCharacterZone"] = "Guild Member Enters New Zone",
	["guildMemberLevelsCharacter"] = "Guild Member Levels Character",
}


function NotificationsUI:InitializeOptions()

    local panel = CreateFrame("Frame")
    panel.name = "Notifications"

	local yPos = -16

  	-- Tab header and description
	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, yPos)
	title:SetText("Notifications Settings")
	title:SetTextColor(1, 0.84, 0)
	yPos = yPos - 25

	local subtitle = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	subtitle:SetPoint("TOPLEFT", 16, yPos)
	subtitle:SetText("Allows you to configure notifications for friends/guildies entering new games or zones.")
	yPos = yPos - 25

	-- Add separator
	local _, newY = UIHelper.CreateSeparator(panel, 16, yPos)
	yPos = newY

    -- Battle.net Favorite Notifications
    local headerBNetFavorite1 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	headerBNetFavorite1:SetPoint("TOPLEFT", 16, yPos)
	headerBNetFavorite1:SetText("Battle.net Favorite")

    local headerBNetFavorite2 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	headerBNetFavorite2:SetPoint("TOPLEFT", 300, yPos)
	headerBNetFavorite2:SetText("Text")

    local headerBNetFavorite3 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	headerBNetFavorite3:SetPoint("TOPLEFT", 350, yPos)
	headerBNetFavorite3:SetText("Sound")

    local headerBNetFavorite4 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	headerBNetFavorite4:SetPoint("TOPLEFT", 420, yPos)
	headerBNetFavorite4:SetText("Sound File")

    yPos = yPos - 25

    local bnetFavoriteChangesGameText = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    bnetFavoriteChangesGameText:SetPoint("TOPLEFT", 16, yPos)
    bnetFavoriteChangesGameText:SetText(settingsName[k] or k)

    for k, v in pairs(FriendAlertsDB.settings.notifications.bnetFavorite) do
        local option = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        option:SetPoint("TOPLEFT", 16, yPos)
        option:SetText(FriendAlertsDB.settings.notifications.bnetFavorite[k]["Text"])

        -- Text Notification Checkbox
        local _, _ = UIHelper.CreateCheckbox(
            panel,
            "CheckboxBNetFavoriteText" .. k,
            "",
            300,
            yPos + 7,
            FriendAlertsDB.settings.notifications.bnetFavorite[k]["Enabled"],
            function(self)
                FriendAlertsDB.settings.notifications.bnetFavorite[k]["Enabled"] = self:GetChecked()
            end
        )

        -- Sound Checkbox
        local _, newY = UIHelper.CreateCheckbox(
            panel,
            "CheckboxBNetFavoriteSound" .. k,
            "",
            350,
            yPos + 7,
            FriendAlertsDB.settings.notifications.bnetFavorite[k]["Sound"],
            function(self)
                FriendAlertsDB.settings.notifications.bnetFavorite[k]["Sound"] = self:GetChecked()
            end
        )

        -- Sound Notification Dropdown
        local category = "bnetFavorite"
        local options = {}
        for soundName, soundPath in pairs(FR.sounds) do
            table.insert(options, { text = soundName, value = soundPath })
        end
        local defaultValue = FriendAlertsDB.settings.notifications[category][k]["SoundFile"]

        local dropdown =nil
        dropdown = UIHelper.CreateDropdown(panel, "Dropdown"..category..k, options, defaultValue, 400, yPos + 8, function(self)
            UIDropDownMenu_SetSelectedID(dropdown, self:GetID())

            PlaySoundFile(self.value, "Effects")
            for kk, vv in pairs(FR.sounds) do
                if vv == self.value then
                    FriendAlertsDB.settings.notifications[category][k]["SoundFile"] = kk
                    break
                end
            end
        end)
        yPos = newY - 5
    end
    yPos = yPos - 10

    -- Add separator
	local _, newY = UIHelper.CreateSeparator(panel, 16, yPos)
	yPos = newY

    -- Battle.net Friend Notifications
    local headerBNetFriend1 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	headerBNetFriend1:SetPoint("TOPLEFT", 16, yPos)
	headerBNetFriend1:SetText("Battle.net Friend")

    local headerBNetFriend2 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	headerBNetFriend2:SetPoint("TOPLEFT", 300, yPos)
	headerBNetFriend2:SetText("Text")

    local headerBNetFriend3 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	headerBNetFriend3:SetPoint("TOPLEFT", 350, yPos)
	headerBNetFriend3:SetText("Sound")

    local headerBNetFriend4 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	headerBNetFriend4:SetPoint("TOPLEFT", 420, yPos)
	headerBNetFriend4:SetText("Sound File")

    yPos = yPos - 25

    local bnetFriendChangesGameText = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    bnetFriendChangesGameText:SetPoint("TOPLEFT", 16, yPos)
    bnetFriendChangesGameText:SetText(settingsName[k] or k)

    for k, v in pairs(FriendAlertsDB.settings.notifications.bnetFriend) do
        local option = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        option:SetPoint("TOPLEFT", 16, yPos)
        option:SetText(FriendAlertsDB.settings.notifications.bnetFriend[k]["Text"])

        -- Text Notification Checkbox
        local _, _ = UIHelper.CreateCheckbox(
            panel,
            "CheckboxBNetFriendText" .. k,
            "",
            300,
            yPos + 7,
            FriendAlertsDB.settings.notifications.bnetFriend[k]["Enabled"],
            function(self)
                FriendAlertsDB.settings.notifications.bnetFriend[k]["Enabled"] = self:GetChecked()
            end
        )

        -- Sound Checkbox
        local _, newY = UIHelper.CreateCheckbox(
            panel,
            "CheckboxBNetFriendSound" .. k,
            "",
            350,
            yPos + 7,
            FriendAlertsDB.settings.notifications.bnetFriend[k]["Sound"],
            function(self)
                FriendAlertsDB.settings.notifications.bnetFriend[k]["Sound"] = self:GetChecked()
            end
        )

        -- Sound Notification Dropdown
        local category = "bnetFriend"
        local options = {}
        for soundName, soundPath in pairs(FR.sounds) do
            table.insert(options, { text = soundName, value = soundPath })
        end
        local defaultValue = FriendAlertsDB.settings.notifications[category][k]["SoundFile"]

        local dropdown =nil
        dropdown = UIHelper.CreateDropdown(panel, "Dropdown"..category..k, options, defaultValue, 400, yPos + 8, function(self)
            UIDropDownMenu_SetSelectedID(dropdown, self:GetID())

            PlaySoundFile(self.value, "Effects")
            for kk, vv in pairs(FR.sounds) do
                if vv == self.value then
                    FriendAlertsDB.settings.notifications[category][k]["SoundFile"] = kk
                    break
                end
            end
        end)

        yPos = newY - 5
    end
    yPos = yPos - 10

    -- Add separator
	local _, newY = UIHelper.CreateSeparator(panel, 16, yPos)
	yPos = newY

    -- Character Friend Notifications
    local headerFriend1 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	headerFriend1:SetPoint("TOPLEFT", 16, yPos)
	headerFriend1:SetText("Character Friend")

    local headerFriend2 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	headerFriend2:SetPoint("TOPLEFT", 300, yPos)
	headerFriend2:SetText("Text")

    local headerFriend3 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	headerFriend3:SetPoint("TOPLEFT", 350, yPos)
	headerFriend3:SetText("Sound")

    local headerFriend4 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	headerFriend4:SetPoint("TOPLEFT", 420, yPos)
	headerFriend4:SetText("Sound File")

    yPos = yPos - 25

    local friendChangesGameText = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    friendChangesGameText:SetPoint("TOPLEFT", 16, yPos)
    friendChangesGameText:SetText(settingsName[k] or k)

    for k, v in pairs(FriendAlertsDB.settings.notifications.friend) do
        local option = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        option:SetPoint("TOPLEFT", 16, yPos)
        option:SetText(FriendAlertsDB.settings.notifications.friend[k]["Text"])

        -- Text Notification Checkbox
        local _, _ = UIHelper.CreateCheckbox(
            panel,
            "CheckboxFriendText" .. k,
            "",
            300,
            yPos + 7,
            FriendAlertsDB.settings.notifications.friend[k]["Enabled"],
            function(self)
                FriendAlertsDB.settings.notifications.friend[k]["Enabled"] = self:GetChecked()
            end
        )

        -- Sound Checkbox
        local _, newY = UIHelper.CreateCheckbox(
            panel,
            "CheckboxFriendSound" .. k,
            "",
            350,
            yPos + 7,
            FriendAlertsDB.settings.notifications.friend[k]["Sound"],
            function(self)
                FriendAlertsDB.settings.notifications.friend[k]["Sound"] = self:GetChecked()
            end
        )

        -- Sound Notification Dropdown
        local category = "friend"
        local options = {}
        for soundName, soundPath in pairs(FR.sounds) do
            table.insert(options, { text = soundName, value = soundPath })
        end
        local defaultValue = FriendAlertsDB.settings.notifications[category][k]["SoundFile"]

        local dropdown =nil
        dropdown = UIHelper.CreateDropdown(panel, "Dropdown"..category..k, options, defaultValue, 400, yPos + 8, function(self)
            UIDropDownMenu_SetSelectedID(dropdown, self:GetID())

            PlaySoundFile(self.value, "Effects")
            for kk, vv in pairs(FR.sounds) do
                if vv == self.value then
                    FriendAlertsDB.settings.notifications[category][k]["SoundFile"] = kk
                    break
                end
            end
        end)
        yPos = newY - 5
    end
    yPos = yPos - 10

    -- Add separator
	local _, newY = UIHelper.CreateSeparator(panel, 16, yPos)
	yPos = newY

    -- Guild Member Notifications
    local headerGuildMember1 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	headerGuildMember1:SetPoint("TOPLEFT", 16, yPos)
	headerGuildMember1:SetText("Guild Member")

    local headerGuildMember2 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	headerGuildMember2:SetPoint("TOPLEFT", 300, yPos)
	headerGuildMember2:SetText("Text")

    local headerGuildMember3 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	headerGuildMember3:SetPoint("TOPLEFT", 350, yPos)
	headerGuildMember3:SetText("Sound")

    local headerGuildMember4 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	headerGuildMember4:SetPoint("TOPLEFT", 420, yPos)
	headerGuildMember4:SetText("Sound File")

    yPos = yPos - 25

    local guildMemberChangesGameText = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    guildMemberChangesGameText:SetPoint("TOPLEFT", 16, yPos)
    guildMemberChangesGameText:SetText(settingsName[k] or k)

    for k, v in pairs(FriendAlertsDB.settings.notifications.guildMember) do
        local option = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        option:SetPoint("TOPLEFT", 16, yPos)
        option:SetText(FriendAlertsDB.settings.notifications.guildMember[k]["Text"])

        -- Text Notification Checkbox
        local _, _ = UIHelper.CreateCheckbox(
            panel,
            "CheckboxGuildMemberText" .. k,
            "",
            300,
            yPos + 7,
            FriendAlertsDB.settings.notifications.guildMember[k]["Enabled"],
            function(self)
                FriendAlertsDB.settings.notifications.guildMember[k]["Enabled"] = self:GetChecked()
            end
        )

        -- Sound Checkbox
        local _, newY = UIHelper.CreateCheckbox(
            panel,
            "CheckboxGuildMemberSound" .. k,
            "",
            350,
            yPos + 7,
            FriendAlertsDB.settings.notifications.guildMember[k]["Sound"],
            function(self)
                FriendAlertsDB.settings.notifications.guildMember[k]["Sound"] = self:GetChecked()
            end
        )

        -- Sound Notification Dropdown
        local category = "guildMember"
        local options = {}
        for soundName, soundPath in pairs(FR.sounds) do
            table.insert(options, { text = soundName, value = soundPath })
        end
        local defaultValue = FriendAlertsDB.settings.notifications[category][k]["SoundFile"]

        local dropdown =nil
        dropdown = UIHelper.CreateDropdown(panel, "Dropdown"..category..k, options, defaultValue, 400, yPos + 8, function(self)
            UIDropDownMenu_SetSelectedID(dropdown, self:GetID())

            PlaySoundFile(self.value, "Effects")
            for kk, vv in pairs(FR.sounds) do
                if vv == self.value then
                    FriendAlertsDB.settings.notifications[category][k]["SoundFile"] = kk
                    break
                end
            end
        end)

        yPos = newY - 5
    end
    yPos = yPos - 10

    local button = CreateFrame("Button", "MyAddonButton", panel, "GameMenuButtonTemplate")
    button:SetPoint("TOPLEFT", 200, yPos)
    button:SetSize(140, 30)
    button:SetText("Reset to Defaults")

    button:SetScript("OnClick", function()
        Utils.Print("Settings have been reset to defaults. Please reload the UI to apply changes!")
        FriendAlertsDB = {
            settings = CopyTable(FR.defaults),
        }
    end)

    -- Register with the Interface Options
    local supportCategory = Settings.RegisterCanvasLayoutSubcategory(FR.mainCategory, panel, panel.name)
    FR.supportCategory = supportCategory
    FR.supportCategory.ID = panel.name

	panel.OnRefresh = function()
	end
	panel.OnCommit = function()
	end
	panel.OnDefault = function()
	end

	return panel
end

function NotificationsUI:Initialize()
	self:InitializeOptions()
end