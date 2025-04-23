local _, FR = ...

local OptionsUI = {}
FR.OptionsUI = OptionsUI

-- Helper functions for UI creation
local function CreateSeparator(parent, xOffset, yPos, width)
    local separator = parent:CreateTexture(nil, "ARTWORK")
    separator:SetHeight(1)
    separator:SetPoint("TOPLEFT", xOffset, yPos)
    if width then
        separator:SetWidth(width)
    else
        separator:SetPoint("TOPRIGHT", -xOffset, yPos)
    end
    separator:SetColorTexture(0.3, 0.3, 0.3, 0.9)
    return separator, yPos - 15
end

local function CreateSectionHeader(parent, text, xOffset, yPos)
    local header = parent:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    header:SetPoint("TOPLEFT", xOffset, yPos)
    header:SetText(text)
    header:SetTextColor(1, 0.82, 0)
    return header, yPos - 20
end

local function CreateLabel(parent, text, xOffset, yPos, fontStyle)
    local label = parent:CreateFontString(nil, "ARTWORK", fontStyle or "GameFontNormal")
    label:SetPoint("TOPLEFT", xOffset, yPos)
    label:SetText(text)
    return label, yPos - 15
end

local function CreateCheckbox(parent, name, text, xOffset, yPos, checked, onClick)
    local checkbox = CreateFrame("CheckButton", name, parent, "InterfaceOptionsCheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", xOffset, yPos)

    -- Set the text
    local checkboxText = _G[checkbox:GetName() .. "Text"]
    if checkboxText then
        checkboxText:SetText(text)
    end

    -- Set the initial state
    checkbox:SetChecked(checked)

    -- Set the click handler
    checkbox:SetScript("OnClick", onClick)

    return checkbox, yPos - 25
end

local function CreateSlider(parent, name, label, min, max, step, defaultVal, xOffset, yPos, width, callback)
    local container = CreateFrame("Frame", nil, parent)
    container:SetSize(width or 400, 50)
    container:SetPoint("TOPLEFT", xOffset, yPos)

    local labelText = container:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    labelText:SetPoint("TOPLEFT", 0, 0)
    labelText:SetText(label .. ": " .. defaultVal)

    local slider = CreateFrame("Slider", name, container, "OptionsSliderTemplate")
    slider:SetPoint("TOPLEFT", 0, -20)
    slider:SetWidth(width or 400)
    slider:SetHeight(16)
    slider:SetMinMaxValues(min, max)
    slider:SetValueStep(step)
    slider:SetValue(defaultVal)

    -- Hide default slider text
    local sliderName = slider:GetName()
    if sliderName then
        local lowText = _G[sliderName .. "Low"]
        local highText = _G[sliderName .. "High"]
        local valueText = _G[sliderName .. "Text"]

        if lowText then lowText:SetText("") end
        if highText then highText:SetText("") end
        if valueText then valueText:SetText("") end
    end

    -- Set the change handler
    slider:SetScript("OnValueChanged", function(self, value)
        local roundedValue
        if step < 1 then
            roundedValue = math.floor(value * (1 / step) + 0.5) / (1 / step)
        else
            roundedValue = math.floor(value + 0.5)
        end

        labelText:SetText(label .. ": " .. roundedValue)

        if callback then
            callback(roundedValue)
        end
    end)

    return slider, yPos - 50
end

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
	local _, newY = CreateSeparator(panel, 16, yPos)
	yPos = newY


  -- SECTION 1: General Options
    local header, newY = CreateSectionHeader(panel, "Notification Options", 16, yPos)
    yPos = newY - 5

    -- Enable checkbox
    local _, newY = CreateCheckbox(
        panel,
        "FREnableCheckbox",
        "Friend Launched New Game",
        30,
        yPos,
        FriendAlertsDB.settings.enteringNewGames,
        function(self)
            FriendAlertsDB.settings.enteringNewGames = self:GetChecked()
        end
    )
    yPos = newY - 5

    -- Exclude guild members checkbox
    local _, newY = CreateCheckbox(
        panel,
        "FRShowNewZonesCheckbox",
        "Friend Entered New Zone (WoW Only)",
        30,
        yPos,
        FriendAlertsDB.settings.enteringNewAreas,
        function(self)
            FriendAlertsDB.settings.enteringNewAreas = self:GetChecked()
        end
    )
    yPos = newY - 10

    -- Add separator
    local _, newY = CreateSeparator(panel, 16, yPos)
    yPos = newY
    
      -- SECTION 1: General Options
      local header, newY = CreateSectionHeader(panel, "Notification Sounds", 16, yPos)
      yPos = newY - 5
  
      -- Enable checkbox
      local _, newY = CreateCheckbox(
          panel,
          "FREnableCheckboxSounds",
          "Friend Launched New Game",
          30,
          yPos,
          FriendAlertsDB.settings.enteringNewGamesSound,
          function(self)
              FriendAlertsDB.settings.enteringNewGamesSound = self:GetChecked()
          end
      )
      yPos = newY - 5
  
      -- Exclude guild members checkbox
      local _, newY = CreateCheckbox(
          panel,
          "FRShowNewZonesCheckboxSounds",
          "Friend Entered New Zone (WoW Only)",
          30,
          yPos,
          FriendAlertsDB.settings.enteringNewAreasSound,
          function(self)
              FriendAlertsDB.settings.enteringNewAreasSound = self:GetChecked()
          end
      )
      yPos = newY - 10
  
      -- Add separator
      local _, newY = CreateSeparator(panel, 16, yPos)
      yPos = newY

    -- SECTION 2: Notification Settings
    local header, newY = CreateSectionHeader(panel, "Scan Rate Settings", 16, yPos)
    yPos = newY - 5

    -- slider
    local _, newY = CreateSlider(
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

    -- Add separator
    local _, newY = CreateSeparator(panel, 16, yPos)
    yPos = newY

    -- SECTION 3: Database Management
    local header, newY = CreateSectionHeader(panel, "Database Management", 16, yPos)
    yPos = newY - 15

    -- Reset button
    local resetBtn = CreateFrame("Button", "FRResetButton", panel, "UIPanelButtonTemplate")
    resetBtn:SetPoint("TOPLEFT", 30, yPos)
    resetBtn:SetWidth(150)
    resetBtn:SetHeight(25)
    resetBtn:SetText("Reset Database")
    resetBtn:SetScript("OnClick", function()
        StaticPopup_Show("FR_CONFIRM_RESET")
    end)
    yPos = yPos - 40

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