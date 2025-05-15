local addonName, addon = ...
local Utils = addon.Utils or {}
addon.Utils = Utils

function Utils.Debug(...)
    if addon.Config.DEBUG_ENABLED then
        print("|cff33ff99" .. addonName .. "|r|cffFFF468[DEBUG]|r: ", ...);
    end
end

function Utils.Print(...)
	print("|cff33ff99" .. addonName .. "|r: ", ...);
end

function Utils.GetFullPlayerName()
    local name, realm = UnitName("player")
    realm = realm or GetRealmName()
    return name .. "-" .. realm:gsub("%s+", "")
end

function Utils.Trim(s)
    if type(s) ~= "string" then return "" end
    return s:match("^%s*(.-)%s*$") or ""
end


function Utils.SplitByCommas(str)
    local results = {}

    if type(str) ~= "string" then
        return results
    end
    
    for part in string.gmatch(str, "([^,]+)") do
        local trimmed = Utils.Trim(part)
        if trimmed ~= "" then
            table.insert(results, trimmed)
        end
    end
    return results
end

return Utils