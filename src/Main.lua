local addonName, FR = ...;

FR.version = "1.0.0";
FR.addonName = addonName;
FR.friends = {};

-- Default settings
local defaults = {
	enteringNewGames = true,
	enteringNewAreas = true,
	scanInterval = 3, -- in seconds
}

FR.icons = {
	["App"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-Battlenet:14|t",
	["BSAp"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-Battlenet:14|t",
	["WoW"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-WoW:14|t",
	["Horde"] = "|TInterface\\Common\\icon-horde:16|t",
	["Alliance"] = "|TInterface\\Common\\icon-alliance:16|t",
	["Friend"] = "|TInterface\\FriendsFrame\\UI-Toast-FriendOnlineIcon:16:16:0:0:32:32:2:30:2:30|t",
	["WTCG"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-WTCG:14|t",
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
				local lastOnlineTime = friendAccountInfo.lastOnlineTime;
				local game = (friendAccountInfo.gameAccountInfo and friendAccountInfo.gameAccountInfo.clientProgram) or nil;
				local areaName = (friendAccountInfo.gameAccountInfo and friendAccountInfo.gameAccountInfo.areaName) or "Unknown";
				local characterName = (friendAccountInfo.gameAccountInfo and friendAccountInfo.gameAccountInfo.characterName) or "Unknown";
				local realmName = (friendAccountInfo.gameAccountInfo and friendAccountInfo.gameAccountInfo.realmName) or "Unknown";
				local factionName = (friendAccountInfo.gameAccountInfo and friendAccountInfo.gameAccountInfo.factionName) or "Unknown";
				
				if game and FR.friends[bnetIDAccount] and FR.friends[bnetIDAccount]["game"] then

					if game ~= FR.friends[bnetIDAccount]["game"] and FriendAlertsDB.settings.enteringNewGames then
						if game == "WoW" then							
							FR.Alert(FR.icons["Friend"] .. string.format("%s is now playing %s (%s%s-%s).", FR.WhisperLink(accountName, bnetIDAccount), (FR.icons[game]), (FR.icons[factionName]), (characterName), (realmName)));
							PlaySound(18019);

							FR.friends[bnetIDAccount] = FR.friends[bnetIDAccount] or {};
							FR.friends[bnetIDAccount]["game"] = game;
							FR.friends[bnetIDAccount]["areaName"] = areaName;

						else
							if game ~= nil then  -- Don't Alert if the change is that friend went offline (game ~= nil DOESNT WORK), trying game since LastOnlineTime doesn't return nil if online like it says it should.
								FR.Alert( FR.icons["Friend"] .. string.format("%s is now playing %s%s.", FR.WhisperLink(accountName, bnetIDAccount), (FR.icons[game] or ""), (FR.games[game] or "Unknown")));
								if not FR.icons[game] then
									FR.Debug("Game: " .. game);
								end
								PlaySound(18019);
								FR.Debug("Last Online Time: " .. lastOnlineTime or "nil");
							end
						end
					end

					if game == "WoW" and FriendAlertsDB.settings.enteringNewAreas then
						if areaName ~= FR.friends[bnetIDAccount]["areaName"] then
							FR.friends[bnetIDAccount]["areaName"] = areaName;

							FR.Alert(FR.icons["Friend"] .. string.format( "%s %s%s-%s has entered %s.", FR.WhisperLink(accountName, bnetIDAccount), (FR.icons[factionName]), (characterName), (realmName), (areaName)));
							PlaySound(18019);
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

		if not FriendAlertsDB then
			FriendAlertsDB = {
				settings = CopyTable(defaults),
			}
		end
	
		-- Ensure all settings exist
		for k, v in pairs(defaults) do
			if FriendAlertsDB.settings[k] == nil then
				FriendAlertsDB.settings[k] = v
			end
		end

		-- Initialize configuration UI if available with a small delay
        C_Timer.After(0.2, function()
            if FR.MainUI and FR.MainUI.Initialize then
                FR.MainUI:Initialize()
            end

            -- Initialize support UI if available with a small delay
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
		C_Timer.After( 5, FR.ScanFriends );  -- Don't perform first scan until after 5 seconds.
		self:UnregisterEvent("PLAYER_LOGIN")
	end
end)


-- Print a loading message once PLAYER_ENTERING_WORLD fires
local loadingFrame = CreateFrame("Frame")
loadingFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
loadingFrame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_ENTERING_WORLD" then
        FR.Print("Addon Loaded.")
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end
end)


SLASH_FRIENDALERTS1 = "/fa"
SLASH_FRIENDALERTS2 = "/friendalerts"
SlashCmdList["FRIENDALERTS"] = function()
    Settings.OpenToCategory("FriendAlerts")
end
