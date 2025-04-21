local addonName, FR = ...;

FR.version = "1.0.0";
FR.addonName = addonName;
FR.friends = {};

-- Default settings
local defaults = {
	enteringNewGames = true,
	enteringNewAreas = true,
	enteringNewGamesSound = true,
	enteringNewAreasSound = false,
	scanInterval = 3, -- in seconds
}

FR.icons = {
	["App"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-Battlenet:14:14:0:0:30:30|t",
	["BSAp"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-Battlenet:14:14:0:0:30:30|t",
	["WoW"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-WoW:14:14:0:0:30:30|t",
	["Horde"] = "|TInterface\\Common\\icon-horde:20|t",
	["Alliance"] = "|TInterface\\Common\\icon-alliance:20:20:0:0:30:30:5:25:0:30|t",
	["Friend"] = "|TInterface\\FriendsFrame\\UI-Toast-FriendOnlineIcon:17:17:0:0:30:30:2:30:2:30|t",
	["WTCG"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-WTCG:16|t",
};

FR.games = {
	["App"] = "App",
	["BSAp"] = "Mobile",
	["WoW"] = "World of Warcraft",
	["WTCG"] = "Hearthstone",
};

FR.WhisperLink = function (accountName, bnetIDAccount)
	return string.format("|HBNplayer:%s:%s|h[%s]|h", accountName, bnetIDAccount, accountName);
end

FR.Alert = function(text)
	local ChatFrame = DEFAULT_CHAT_FRAME;
	ChatFrame:AddMessage(text, BATTLENET_FONT_COLOR["r"], BATTLENET_FONT_COLOR["g"], BATTLENET_FONT_COLOR["b"] );
end

FR.Print = function(text)
	print("|cff33ff99" .. FR.addonName .. "|r: " .. text);
end

FR.Debug = function(text)
	print("|cff33ff99DEBUG|r: " .. text);
end

FR.ScanFriends = function ()
	if BNConnected() then
		--print ("Scanning Friends...");
		for index = 1, BNGetNumFriends() do
			local friendAccountInfo = C_BattleNet.GetFriendAccountInfo(index);

			if friendAccountInfo then
				local bnetIDAccount = friendAccountInfo.bnetAccountID;
				local accountName = friendAccountInfo.accountName;
				local isOnline = friendAccountInfo.gameAccountInfo.isOnline or false;
				local lastOnlineTime = friendAccountInfo.lastOnlineTime;
				local game = (friendAccountInfo.gameAccountInfo and friendAccountInfo.gameAccountInfo.clientProgram) or nil;
				local areaName = (friendAccountInfo.gameAccountInfo and friendAccountInfo.gameAccountInfo.areaName) or "Unknown";
				local characterName = (friendAccountInfo.gameAccountInfo and friendAccountInfo.gameAccountInfo.characterName) or "Unknown";
				local realmName = (friendAccountInfo.gameAccountInfo and friendAccountInfo.gameAccountInfo.realmName) or nil;
				local factionName = (friendAccountInfo.gameAccountInfo and friendAccountInfo.gameAccountInfo.factionName) or "Unknown";
				
				if game and FR.friends[bnetIDAccount] and FR.friends[bnetIDAccount]["game"] then

					if game ~= FR.friends[bnetIDAccount]["game"] and FriendAlertsDB.settings.enteringNewGames then
						if game == "WoW" then
							
							local slug = characterName;

							if realmName then
								slug = slug .. "-" .. realmName;
							end

							FR.Alert(FR.icons["Friend"] .. string.format("%s is now playing %s (%s%s).", FR.WhisperLink(accountName, bnetIDAccount), (FR.icons[game]), (FR.icons[factionName]), (slug)));
							if FriendAlertsDB.settings.enteringNewGamesSound then
								PlaySound(18019);
							end

							FR.friends[bnetIDAccount] = FR.friends[bnetIDAccount] or {};
							FR.friends[bnetIDAccount]["game"] = game;
							FR.friends[bnetIDAccount]["areaName"] = areaName;

						else
							if isOnline then  -- Don't Alert if the change is that friend went offline
								FR.Alert( FR.icons["Friend"] .. string.format("%s is now playing %s%s.", FR.WhisperLink(accountName, bnetIDAccount), (FR.icons[game] or ""), (FR.games[game] or "Unknown")));
								if not FR.icons[game] then
									FR.Debug("Game: " .. game);
								end
								if FriendAlertsDB.settings.enteringNewGamesSound then
									PlaySound(18019);
								end								
							end
						end
					end

					if game == "WoW" and FriendAlertsDB.settings.enteringNewAreas then
						if areaName ~= FR.friends[bnetIDAccount]["areaName"] then
							FR.friends[bnetIDAccount]["areaName"] = areaName;
							local slug = characterName;

							if realmName then
								slug = slug .. "-" .. realmName;
							end

							FR.Alert(FR.icons["Friend"] .. string.format("%s %s%s has entered %s.", FR.WhisperLink(accountName, bnetIDAccount), (FR.icons[factionName]), (slug), (areaName)));
							if FriendAlertsDB.settings.enteringNewAreasSound then
								PlaySound(18019);
							end
						end
					end
				end

				FR.friends[bnetIDAccount] = FR.friends[bnetIDAccount] or {};
				FR.friends[bnetIDAccount]["game"] = game;
				FR.friends[bnetIDAccount]["areaName"] = areaName;
				
			end
		end
	end

	if  FriendAlertsDB.settings.scanInterval < 1 then
		FriendAlertsDB.settings.scanInterval = 1;
	end

	C_Timer.After(FriendAlertsDB.settings.scanInterval, FR.ScanFriends);
end

local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:RegisterEvent("PLAYER_LOGIN")

initFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then

		-- Initialize the database if it doesn't exist
		if not FriendAlertsDB then
			FriendAlertsDB = {
				settings = CopyTable(defaults),
			}
		end

		for k, v in pairs(defaults) do
			if FriendAlertsDB.settings[k] == nil then
				FriendAlertsDB.settings[k] = v
			end
		end

		-- Initialize main options UI if available with a small delay
        C_Timer.After(0.2, function()
            if FR.MainUI and FR.MainUI.Initialize then
                FR.MainUI:Initialize()
            end

            -- Initialize config UI if available with a small delay
            C_Timer.After(0.1, function()
                if FR.ConfigUI and FR.ConfigUI.Initialize then
                    FR.ConfigUI:Initialize()
                end
            end)

			-- Initialize support UI if available with a small delay
            C_Timer.After(0.2, function()
                if FR.SupportUI and FR.SupportUI.Initialize then
                    FR.SupportUI:Initialize()
                end
            end)
        end)

		self:UnregisterEvent("ADDON_LOADED")
	end

	if event == "PLAYER_LOGIN" then
		C_Timer.After( 5, FR.ScanFriends );  -- Don't perform first scan until after 5 seconds
		self:UnregisterEvent("PLAYER_LOGIN")
	end
end)


-- Loading message when player enters the world
local loadingFrame = CreateFrame("Frame")
loadingFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
loadingFrame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_ENTERING_WORLD" then
        FR.Print("Addon Loaded.")
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end
end)

-- Slash Commands
SLASH_FRIENDALERTS1 = "/fa"
SLASH_FRIENDALERTS2 = "/friendalerts"
SlashCmdList["FRIENDALERTS"] = function()
    Settings.OpenToCategory("FriendAlerts")
end
