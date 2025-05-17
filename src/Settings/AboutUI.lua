local addonName, FR = ...

local ADDON_NAME = "FriendAlerts"
local ADDON_ID = "FriendAlerts"

local AboutUI = {}
FR.AboutUI = AboutUI

function AboutUI:InitializeOptions()
    local panel = CreateFrame("Frame")
    panel.name = "FriendAlerts"

    panel.layoutIndex = 1
	panel.OnShow = function(self)
		return true
	end

    -- header and description
    local titleText = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    titleText:SetPoint("TOPLEFT", 16, -16)
    titleText:SetText(ADDON_NAME)

    -- Get addon version
    local version = C_AddOns.GetAddOnMetadata(ADDON_ID, "Version") or "Unknown"
    local versionText = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    versionText:SetPoint("TOPLEFT", titleText, "BOTTOMLEFT", 0, -8)
    versionText:SetText("Version: " .. version)

    local yPos = -70

    -- Tab header and description
	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, yPos)
	title:SetText("About")
	title:SetTextColor(1, 0.84, 0)
	yPos = yPos - 25

    -- About Text
    
    local subtitle = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	subtitle:SetPoint("TOPLEFT", 16, yPos)
	subtitle:SetText("Displays Battle.net style alerts when friends/guildies changes games, changes zones, or levels their World of Warcraft character.")
	yPos = yPos - 25

    -- Website URL as text
    local websiteLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    websiteLabel:SetPoint("TOPLEFT", 16, yPos)
    websiteLabel:SetText("Website:")

    local websiteURL = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    websiteURL:SetPoint("TOPLEFT", websiteLabel, "TOPLEFT", 70, 0)
    websiteURL:SetText("https://www.github.com/nickstuer/friendalerts")
    websiteURL:SetTextColor(0.3, 0.6, 1.0)

    yPos = yPos - 50


    ---- THANK YOU ----

    -- Section Header
	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, yPos)
	title:SetText("Thank You")
	title:SetTextColor(1, 0.84, 0)
	yPos = yPos - 25

    local subtitle = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	subtitle:SetPoint("TOPLEFT", 16, yPos)
	subtitle:SetText("Thank You to the following individuals for their contributions in beta testing " .. ADDON_NAME .. "!")
	yPos = yPos - 25


    local thanksText = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    thanksText:SetPoint("TOPLEFT", 16, yPos)
    thanksText:SetJustifyH("LEFT")
    thanksText:SetSpacing(2)
    thanksText:SetText("Lovestoned-Hellscream\r\nPixiè-Kel'Thuzad\r\nRiptide-Spinebreaker")
    yPos = yPos - 75




    ---- INSPIRATION ----
    -- Section Header
	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, yPos)
	title:SetText("Inspiration")
	title:SetTextColor(1, 0.84, 0)
	yPos = yPos - 25

    local subtitle = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	subtitle:SetPoint("TOPLEFT", 16, yPos)
	subtitle:SetText("Some of the addon features of " .. ADDON_NAME .. " were inspired by Peaver's Addons. Please check out Peaver's website.")
	yPos = yPos - 25

    -- Website URL as text
    local websiteLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    websiteLabel:SetPoint("TOPLEFT", 16, yPos)
    websiteLabel:SetText("Website:")

    local websiteURL = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    websiteURL:SetPoint("TOPLEFT", websiteLabel, "TOPLEFT", 70, 0)
    websiteURL:SetText("https://peavers.io")
    websiteURL:SetTextColor(0.3, 0.6, 1.0)
    yPos = yPos - 50



    ---- CREDITS ----
    -- Section Header
	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, yPos)
	title:SetText("Credits")
	title:SetTextColor(1, 0.84, 0)
	yPos = yPos - 25

    local subtitle = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	subtitle:SetPoint("TOPLEFT", 16, yPos)
	subtitle:SetText("Sound alerts provided by NotificationSounds.com under Creative Commons licenses.")
	yPos = yPos - 25


    -- Additional info at bottom
    local additionalInfo = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    additionalInfo:SetPoint("BOTTOMRIGHT", -16, 16)
    additionalInfo:SetJustifyH("RIGHT")
    additionalInfo:SetText("Thank you!")

    -- Register with the Interface Options
    FR.mainCategory = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
	FR.mainCategory.ID = panel.name
	Settings.RegisterAddOnCategory(FR.mainCategory)

    -- Required callbacks
    panel.OnRefresh = function()
    end
    panel.OnCommit = function()
    end
    panel.OnDefault = function()
    end

    return panel
end

function AboutUI:Initialize()
    self:InitializeOptions()
end