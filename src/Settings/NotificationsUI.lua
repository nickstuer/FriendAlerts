local _, FR = ...

local UIHelper = FR.UIHelper or {}
FR.UIHelper = UIHelper

local NotificationsUI = {}
FR.NotificationsUI = NotificationsUI

function NotificationsUI:InitializeOptions()

    local panel = CreateFrame("Frame")
    panel.name = "Notifications"

	local yPos = -16

  	-- Create header and description
	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, yPos)
	title:SetText("FriendAlerts")
	title:SetTextColor(1, 0.84, 0)  -- Gold color for main title
	yPos = yPos - 25

	local subtitle = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	subtitle:SetPoint("TOPLEFT", 16, yPos)
	subtitle:SetText("Displays Battle.net style alert when friends start playing a new game or enter new areas in World of Warcraft.")
	yPos = yPos - 25

	-- Add separator
	local _, newY = UIHelper.CreateSeparator(panel, 16, yPos)
	yPos = newY


  -- SECTION 1: General Options
    local header, newY = UIHelper.CreateSectionHeader(panel, "Notification Options", 16, yPos)
    yPos = newY - 5

    -- Enable checkbox
    local _, newY = UIHelper.CreateCheckbox(
        panel,
        "FREnableCheckbox",
        "Battle.net Friend Launches New Game or Changes WoW Character",
        30,
        yPos,
        FriendAlertsDB.settings.enteringNewGames,
        function(self)
            FriendAlertsDB.settings.enteringNewGames = self:GetChecked()
        end
    )
    yPos = newY - 5

    -- Exclude guild members checkbox
    local _, newY = UIHelper.CreateCheckbox(
        panel,
        "FRShowNewZonesCheckbox",
        "Battle.net Friend Enters New WoW Zone",
        30,
        yPos,
        FriendAlertsDB.settings.enteringNewAreas,
        function(self)
            FriendAlertsDB.settings.enteringNewAreas = self:GetChecked()
        end
    )
    yPos = newY - 5

    -- Exclude guild members checkbox
    local _, newY = UIHelper.CreateCheckbox(
        panel,
        "FRShowNewZonesCheckboxFavorites",
        "Only Notifications for Battle.net Favorites",
        30,
        yPos,
        FriendAlertsDB.settings.favoritesOnly,
        function(self)
            FriendAlertsDB.settings.favoritesOnly = self:GetChecked()
        end
    )
    yPos = newY - 5

    -- Exclude guild members checkbox
    local _, newY = UIHelper.CreateCheckbox(
        panel,
        "FRShowNewZonesCheckboxCharacterFriend",
        "Character Friend Enters New Zone",
        30,
        yPos,
        FriendAlertsDB.settings.enteringNewAreasLocalFriends,
        function(self)
            FriendAlertsDB.settings.enteringNewAreasLocalFriends = self:GetChecked()
        end
    )
    yPos = newY - 5

     -- Exclude guild members checkbox
     local _, newY = UIHelper.CreateCheckbox(
        panel,
        "FRShowNewZonesCheckboxGuildMember",
        "Guild Member Enters New Zone",
        30,
        yPos,
        FriendAlertsDB.settings.enteringNewAreasGuildMembers,
        function(self)
            FriendAlertsDB.settings.enteringNewAreasGuildMembers = self:GetChecked()
        end
    )
    yPos = newY - 10

    -- Add separator
    local _, newY = UIHelper.CreateSeparator(panel, 16, yPos)
    yPos = newY
    
      -- SECTION 1: General Options
      local header, newY = UIHelper.CreateSectionHeader(panel, "Notification Sounds", 16, yPos)
      yPos = newY - 5
  
      -- Enable checkbox
      local _, newY = UIHelper.CreateCheckbox(
          panel,
          "FREnableCheckboxSounds",
          "Battle.net Friend Launches New Game",
          30,
          yPos,
          FriendAlertsDB.settings.enteringNewGamesSound,
          function(self)
              FriendAlertsDB.settings.enteringNewGamesSound = self:GetChecked()
          end
      )
      yPos = newY - 5
  
      -- Exclude guild members checkbox
      local _, newY = UIHelper.CreateCheckbox(
          panel,
          "FRShowNewZonesCheckboxSounds",
          "Friend Enters New WoW Zone",
          30,
          yPos,
          FriendAlertsDB.settings.enteringNewAreasSound,
          function(self)
              FriendAlertsDB.settings.enteringNewAreasSound = self:GetChecked()
          end
      )
      yPos = newY - 10

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