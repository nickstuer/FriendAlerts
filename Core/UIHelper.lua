local addonName, addon = ...
local UIHelper = addon.UIHelper or {}
addon.UIHelper = UIHelper

function UIHelper.CreateSeparator(parent, xOffset, yPos, width)
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

function UIHelper.CreateSectionHeader(parent, text, xOffset, yPos)
    local header = parent:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    header:SetPoint("TOPLEFT", xOffset, yPos)
    header:SetText(text)
    header:SetTextColor(1, 0.82, 0)
    return header, yPos - 20
end

function UIHelper.CreateLabel(parent, text, xOffset, yPos, fontStyle)
    local label = parent:CreateFontString(nil, "ARTWORK", fontStyle or "GameFontNormal")
    label:SetPoint("TOPLEFT", xOffset, yPos)
    label:SetText(text)
    return label, yPos - 15
end

function UIHelper.CreateCheckbox(parent, name, text, xOffset, yPos, checked, onClick)
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

function UIHelper.CreateSlider(parent, name, label, min, max, step, defaultVal, xOffset, yPos, width, callback)
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

        if lowText then lowText:SetText(min) end
        if highText then highText:SetText(max) end
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

function UIHelper.CreateDropdown(parent, name, options, defaultValue, xPos, yPos, callback)
  
    local dropdown = CreateFrame("Frame", name, parent, "UIDropDownMenuTemplate")
    dropdown:SetPoint("TOPLEFT", xPos, yPos)
    
    local function Initialize(self, level)
        for i, option in ipairs(options) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = option.text
            info.value = option.value
            info.func = callback
            UIDropDownMenu_AddButton(info, level)
        end
    end

    UIDropDownMenu_Initialize(dropdown, Initialize)

    -- Find the matching index to set the default value
    for i, option in ipairs(options) do
        if option.text == defaultValue then
            UIDropDownMenu_SetSelectedID(dropdown, i)
            selectedValue = option.value
            break
        end
    end

    return dropdown
end