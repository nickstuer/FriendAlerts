local _, FR = ...

local UIHelper = FR.UIHelper or {}
FR.UIHelper = UIHelper

local OptionsUI = {}
FR.OptionsUI = OptionsUI

local Utils = FR.Utils or {}
FR.Utils = Utils

function OptionsUI:InitializeOptions()

    local panel = CreateFrame("Frame")
    panel.name = "Options"

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

    -- SECTION 2: Scan Rate Settings
    local header, newY = UIHelper.CreateSectionHeader(panel, "Scan Rate Settings", 16, yPos)
    yPos = newY - 5

    -- slider
    local _, newY = UIHelper.CreateSlider(
        panel,
        "FRScanIntervalSlider",
        "Scan Interval (seconds)",
        1, 10, 1,
        FriendAlertsDB.settings.options.scanInterval,
        30, yPos, 400,
        function(value)
            FriendAlertsDB.settings.options.scanInterval = value
        end
    )
    yPos = newY - 10

    -- Add separator
	local _, newY = UIHelper.CreateSeparator(panel, 16, yPos)
	yPos = newY - 10

    -- SECTION: General Settings
     -- Battle.net Friend Notifications
    local header, newY = UIHelper.CreateSectionHeader(panel, "General Settings", 16, yPos)
    yPos = newY - 5

    local onLoginText = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    onLoginText:SetPoint("TOPLEFT", 36, yPos)
    onLoginText:SetText("Display 'Addon Loaded' Message")
     -- Text Notification Checkbox
    local _, _ = UIHelper.CreateCheckbox(
        panel,
        "CheckboxBNetFriendText" ,
        "",
        250,
        yPos + 7,
        FriendAlertsDB.settings.options.onLoginMessage,
        function(self)
            FriendAlertsDB.settings.options.onLoginMessage = self:GetChecked()
        end
    )

    yPos = yPos - 35
    -- Add separator
	local _, newY = UIHelper.CreateSeparator(panel, 16, yPos)
	yPos = newY - 50

    local button = CreateFrame("Button", "MyAddonButton", panel, "GameMenuButtonTemplate")
    button:SetPoint("TOPLEFT", 150, yPos)
    button:SetSize(200, 30)
    button:SetText("Reset All Settings to Defaults")

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

function OptionsUI:Initialize()
	self:InitializeOptions()
end