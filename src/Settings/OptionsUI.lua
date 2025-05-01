local _, FR = ...

local UIHelper = FR.UIHelper or {}
FR.UIHelper = UIHelper

local OptionsUI = {}
FR.OptionsUI = OptionsUI

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

    -- SECTION 2: Notification Settings
    local header, newY = UIHelper.CreateSectionHeader(panel, "Scan Rate Settings", 16, yPos)
    yPos = newY - 5

    -- slider
    local _, newY = UIHelper.CreateSlider(
        panel,
        "FRScanIntervalSlider",
        "Scan Interval (seconds)",
        1, 10, 1,
        FriendAlertsDB.settings.scanInterval,
        30, yPos, 400,
        function(value)
            FriendAlertsDB.settings.scanInterval = value
        end
    )
    yPos = newY

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