local addonName, FR = ...

local ADDON_NAME = "FriendAlerts"
local ADDON_ID = "FriendAlerts"

local AboutUI = {}
FR.AboutUI = AboutUI

local UIHelper = FR.UIHelper or {}
FR.UIHelper = UIHelper

local function CreateCopyButton(parent, anchor, url)
    local copyButton = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    copyButton:SetSize(80, 22)
    copyButton:SetPoint("LEFT", anchor, "RIGHT", 10, 0)
    copyButton:SetText("Copy")
    copyButton:SetScript("OnClick", function()
        local popup = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
        popup:SetSize(350, 100)
        popup:SetPoint("CENTER")
        popup:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true, tileSize = 32, edgeSize = 32,
            insets = { left = 8, right = 8, top = 8, bottom = 8 }
        })
        popup:SetFrameStrata("DIALOG")

        local instruction = popup:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        instruction:SetPoint("TOP", 0, -10)
        instruction:SetText("Press Ctrl + C to Copy")
        instruction:SetJustifyH("CENTER")

        local editBox = CreateFrame("EditBox", nil, popup, "InputBoxTemplate")
        editBox:SetSize(300, 30)
        editBox:SetPoint("TOP", instruction, "BOTTOM", 0, -5)
        editBox:SetAutoFocus(true)
        editBox:SetText(url)
        editBox:HighlightText()
        editBox:SetCursorPosition(0)

        local closeButton = CreateFrame("Button", nil, popup, "UIPanelButtonTemplate")
        closeButton:SetSize(80, 22)
        closeButton:SetPoint("BOTTOM", 0, 10)
        closeButton:SetText("Close")
        closeButton:SetScript("OnClick", function()
            popup:Hide()
        end)

        popup:Show()
    end)
    return copyButton
end

    

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

    -- About Text
    local subtitle = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    subtitle:SetPoint("TOPLEFT", 16, yPos)
    subtitle:SetTextColor(0.98, 0.98, 1.00)
    subtitle:SetText("Displays Battle.net style alerts when friends/guildies changes games, changes zones, or levels their World of Warcraft character.")
    subtitle:SetWidth(600)
    subtitle:SetJustifyH("LEFT")
    yPos = yPos - 50

    -- Add separator
	local _, newY = UIHelper.CreateSeparator(panel, 16, yPos)
	yPos = newY


    -- Tab header and description
	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, yPos)
	title:SetText("Support")
	title:SetTextColor(0.98, 0.98, 1.00)
	yPos = yPos - 25

    -- Support information
    local supportInfo = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    supportInfo:SetPoint("TOPLEFT", 16, yPos)
    supportInfo:SetJustifyH("LEFT")
    supportInfo:SetWidth(600)
    supportInfo:SetTextColor(0.98, 0.98, 1.00)
    supportInfo:SetText("Development takes a lot of time! If you enjoy " .. ADDON_NAME .. " please consider supporting its development. If you need help or want to request new features, stop by the Discord.")
    supportInfo:SetSpacing(2)
    yPos = yPos - 50
    
    -- Donate URL as text
    local donateLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    donateLabel:SetPoint("TOPLEFT", 16, yPos)
    donateLabel:SetText("Donate:")

    local donateURL = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    donateURL:SetPoint("TOPLEFT", donateLabel, "TOPLEFT", 70, 0)
    donateURL:SetText("buymeacoffee.com/plunger")
    donateURL:SetTextColor(0.3, 0.6, 1.0)
    CreateCopyButton(panel, donateURL, "https://www.buymeacoffee.com/plunger")

    yPos = yPos - 35

    -- Website URL as text
    local websiteLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    websiteLabel:SetPoint("TOPLEFT", 16, yPos)
    websiteLabel:SetText("Website:")

    local websiteURL = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    websiteURL:SetPoint("TOPLEFT", websiteLabel, "TOPLEFT", 70, 0)
    websiteURL:SetText("hdbyte.com")
    websiteURL:SetTextColor(0.3, 0.6, 1.0)
    CreateCopyButton(panel, websiteURL, "https://www.hdbyte.com")

    yPos = yPos - 35

    -- Discord URL as text
    local discordLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    discordLabel:SetPoint("TOPLEFT", 16, yPos)
    discordLabel:SetText("Discord:")

    local discordURL = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    discordURL:SetPoint("TOPLEFT", discordLabel, "TOPLEFT", 70, 0)
    discordURL:SetText("discord.gg/CfsQeepgGw")
    discordURL:SetTextColor(0.3, 0.6, 1.0)
    CreateCopyButton(panel, discordURL, "https://discord.gg/CfsQeepgGw")

    yPos = yPos - 50


    ---- THANK YOU ----

    -- Section Header
	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, yPos)
	title:SetText("Thank You")
	title:SetTextColor(0.98, 0.98, 1.00)
	yPos = yPos - 25

    local subtitle = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	subtitle:SetPoint("TOPLEFT", 16, yPos)
    subtitle:SetTextColor(0.98, 0.98, 1.00)
    subtitle:SetWidth(600)
    subtitle:SetJustifyH("LEFT")
	subtitle:SetText("Thank You to the following individuals for their contributions in beta testing " .. ADDON_NAME .. ":")
	yPos = yPos - 25


    local thanksText = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    thanksText:SetPoint("TOPLEFT", 16, yPos)
    thanksText:SetJustifyH("LEFT")
    thanksText:SetSpacing(2)
    thanksText:SetText("Lovestoned-Hellscream\r\nPixiè-Kel'Thuzad\r\nRiptide-Spinebreaker")
    yPos = yPos - 75

    ---- CREDITS ----
    -- Section Header
	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, yPos)
	title:SetText("Credits")
	title:SetTextColor(0.98, 0.98, 1.00)
	yPos = yPos - 25

    local subtitle = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	subtitle:SetPoint("TOPLEFT", 16, yPos)
    subtitle:SetTextColor(0.98, 0.98, 1.00)
    subtitle:SetWidth(600)
    subtitle:SetJustifyH("LEFT")
	subtitle:SetText("Some sound alerts provided by NotificationSounds.com under Creative Commons licenses.")
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