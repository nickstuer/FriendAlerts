local addonName, FR = ...

local ADDON_NAME = "FriendAlerts"
local ADDON_ID = "FriendAlerts"
local ICON_PATH = "Interface\\AddOns\\FriendAlerts\\src\\Media\\Icon"

-- Initialize MainUI namespace
local MainUI = {}
FR.MainUI = MainUI

-- Constants
local ICON_ALPHA = 0.1

-- Creates and initializes the support options panel
function MainUI:InitializeOptions()
    local panel = CreateFrame("Frame")
    panel.name = "FriendAlerts"

    panel.layoutIndex = 1
	panel.OnShow = function(self)
		return true
	end

    -- Add background image
    local largeIcon = panel:CreateTexture(nil, "BACKGROUND")
    largeIcon:SetTexture(ICON_PATH)
    largeIcon:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, 0)
    largeIcon:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", 0, 0)
    largeIcon:SetAlpha(ICON_ALPHA)

    -- Create header and description
    local titleText = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    titleText:SetPoint("TOPLEFT", 16, -16)
    titleText:SetText(ADDON_NAME)

    -- Get addon version
    local version = C_AddOns.GetAddOnMetadata(ADDON_ID, "Version") or "Unknown"
    local versionText = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    versionText:SetPoint("TOPLEFT", titleText, "BOTTOMLEFT", 0, -8)
    versionText:SetText("Version: " .. version)

    -- Support information
    local supportInfo = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    supportInfo:SetPoint("TOPLEFT", 16, -70)
    supportInfo:SetPoint("TOPRIGHT", -16, -70)
    supportInfo:SetJustifyH("LEFT")
    supportInfo:SetText("Some of the addon features of " .. ADDON_NAME .. " were inspired by Peaver's Addons. Please check out Peaver's website for some very cool WoW addons.")
    supportInfo:SetSpacing(2)

    -- Website URL as text
    local websiteLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    websiteLabel:SetPoint("TOPLEFT", 16, -120)
    websiteLabel:SetText("Website:")

    local websiteURL = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    websiteURL:SetPoint("TOPLEFT", websiteLabel, "TOPLEFT", 70, 0)
    websiteURL:SetText("https://peavers.io")
    websiteURL:SetTextColor(0.3, 0.6, 1.0)

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

function MainUI:Initialize()
    self:InitializeOptions()
end