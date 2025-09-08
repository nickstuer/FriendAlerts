local addonName, FR = ...;

local Utils = FR.Utils or {}
FR.Utils = Utils

FR.version = C_AddOns.GetAddOnMetadata("FriendAlerts", "Version") or "Unknown"
FR.addonName = addonName;
FR.bnetFriends = {};
FR.characterFriends = {};
FR.guildMembers = {};

FR.bNetCharacterSlugs = {}; -- To temporarily store character slugs for battle.net friends to avoid duplicate notifications

local playerFullName = Utils.GetFullPlayerName()

local lastMooTime = 0
local cooldown = 30

-- Default settings
FR.defaults = {
	notifications = {
		bnetFavorite = {
			ChangesGame = {
				Enabled = true,
				Sound = true,
				Text = "Changes Game",
				SoundFile = "that-was-quick",
				SortOrder = 1,
			},
			ChangesCharacter = {
				Enabled = true,
				Sound = true,
				Text = "Changes WoW Character",
				SoundFile = "that-was-quick",
				SortOrder = 4,
			},
			ChangesZone = {
				Enabled = true,
				Sound = false,
				Text = "Changes WoW Zone",
				SoundFile = "emergence",
				SortOrder = 5,
			},
			GoesAFK = {
				Enabled = true,
				Sound = true,
				Text = "Goes AFK",
				SoundFile = "pretty-good",
				SortOrder = 2,
			},
			NoLongerAFK = {
				Enabled = true,
				Sound = true,
				Text = "No Longer AFK",
				SoundFile = "that-was-quick",
				SortOrder = 3,
			},
			LevelsCharacter = {
				Enabled = true,
				Sound = true,
				Text = "Levels WoW Character",
				SoundFile = "so-proud",
				SortOrder = 6,
			},
		},
		bnetFriend = {
			ChangesGame = {
				Enabled = true,
				Sound = false,
				Text = "Changes Game",
				SoundFile = "that-was-quick",
				SortOrder = 1,
			},
			ChangesCharacter = {
				Enabled = true,
				Sound = false,
				Text = "Changes WoW Character",
				SoundFile = "that-was-quick",
				SortOrder = 4,
			},
			ChangesZone = {
				Enabled = true,
				Sound = false,
				Text = "Changes WoW Zone",
				SoundFile = "emergence",
				SortOrder = 5,
			},
			GoesAFK = {
				Enabled = true,
				Sound = false,
				Text = "Goes AFK",
				SoundFile = "pretty-good",
				SortOrder = 2,
			},
			NoLongerAFK = {
				Enabled = true,
				Sound = false,
				Text = "No Longer AFK",
				SoundFile = "that-was-quick",
				SortOrder = 3,
			},
			LevelsCharacter = {
				Enabled = true,
				Sound = true,
				Text = "Levels WoW Character",
				SoundFile = "so-proud",
				SortOrder = 6,
			},
		},
		friend = {
			ChangesZone = {
				Enabled = true,
				Sound = false,
				Text = "Changes WoW Zone",
				SoundFile = "emergence",
				SortOrder = 1,
			},
			LevelsCharacter = {
				Enabled = true,
				Sound = true,
				Text = "Levels WoW Character",
				SoundFile = "so-proud",
				SortOrder = 2,
			},
		},
		guildMember = {
			ChangesZone = {
				Enabled = false,
				Sound = false,
				Text = "Changes WoW Zone",
				SoundFile = "emergence",
				SortOrder = 1,
			},
			LevelsCharacter = {
				Enabled = true,
				Sound = true,
				Text = "Levels WoW Character",
				SoundFile = "so-proud",
				SortOrder = 2,
			},
		},
	},

	options = {
		scanInterval = 3, -- in seconds
		onLoginMessage = true,
		easterEggs = true
	},

	config = {
		databaseVersion = 5,
	}
}

FR.sounds = {
	["bnet-toast"] = "Interface/Addons/FriendAlerts/Media/Sounds/ui_bnettoast.ogg",
	["achievement"] = "Interface/Addons/FriendAlerts/Media/Sounds/achievement-message-tone.ogg",
	["bubbling-up"] = "Interface/Addons/FriendAlerts/Media/Sounds/bubbling-up-530.ogg",
	["emergence"] = "Interface/Addons/FriendAlerts/Media/Sounds/emergence-ringtone.ogg",
	["hey"] = "Interface/Addons/FriendAlerts/Media/Sounds/girl-hey-ringtone.ogg",
	["hmm"] = "Interface/Addons/FriendAlerts/Media/Sounds/hmm-second-alternative-ringtone.ogg",
	["its-me-again"] = "Interface/Addons/FriendAlerts/Media/Sounds/its-me-again-girl-ringtone.ogg",
	["jokingly"] = "Interface/Addons/FriendAlerts/Media/Sounds/jokingly-notification.ogg",
	["just-saying"] = "Interface/Addons/FriendAlerts/Media/Sounds/just-saying-593.ogg",
	["light"] = "Interface/Addons/FriendAlerts/Media/Sounds/light-562.ogg",
	["pretty-good"] = "Interface/Addons/FriendAlerts/Media/Sounds/notification-pretty-good.ogg",
	["swift-gesture"] = "Interface/Addons/FriendAlerts/Media/Sounds/notification-tone-swift-gesture.ogg",
	["piece-of-cake"] = "Interface/Addons/FriendAlerts/Media/Sounds/piece-of-cake-611.ogg",
	["served"] = "Interface/Addons/FriendAlerts/Media/Sounds/served-504.ogg",
	["slick"] = "Interface/Addons/FriendAlerts/Media/Sounds/slick-notification.ogg",
	["so-proud"] = "Interface/Addons/FriendAlerts/Media/Sounds/so-proud-notification.ogg",
	["that-was-quick"] = "Interface/Addons/FriendAlerts/Media/Sounds/that-was-quick-606.ogg",
	["when"] = "Interface/Addons/FriendAlerts/Media/Sounds/when-604.ogg",
	};

FR.icons = {
	["App"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-Battlenet:14:14:0:0:30:30|t",
	["BSAp"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-armorychat-awaymobile:14:14:0:0:30:30|t",
	["WoW"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-WoW:14:14:0:0:30:30|t",
	["Horde"] = "|TInterface\\Common\\icon-horde:20|t",
	["Alliance"] = "|TInterface\\Common\\icon-alliance:20:20:0:0:30:30:5:25:0:30|t",
	["Friend"] = "|TInterface\\FriendsFrame\\UI-Toast-FriendOnlineIcon:17:17:0:0:30:30:2:30:2:30|t",
	["WTCG"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-WTCG:16|t",
	["Hero"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-HotS:16|t",
	["Pro"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-Overwatch:16|t",
	["D3"] = "|Tinterface/chatframe/ui-chaticon-d3.blp:16|t",
	["Fen"] = "|Tinterface/chatframe/ui-chaticon-diabloimmortal.blp:16|t",
	["Neutral"] = "|Tinterface/characterframe/temporaryportrait-male-pandaren.blp:16|t"
};

FR.games = {
	["App"] = "App",
	["BSAp"] = "Mobile",
	["WoW"] = "World of Warcraft",
	["WTCG"] = "Hearthstone",
	["Hero"] = "Heroes of the Storm",
	["Pro"] = "Overwatch",
	["D3"] = "Diablo III",
	["Fen"] = "Diablo IV",
};

--wowProjectID
FR.WoWVersions = {
	[1] = "Retail WoW",
	[2] = "Classic WoW",
	[3] = "Plunderstorm",
	[5] = "BC Classic",
	[11] = "Wrath Classic",
	[14] = "Cata Classic",
};

FR.WhisperLink = function (accountName, bnetIDAccount)
	return string.format("|HBNplayer:%s:%s|h[%s]|h", accountName, bnetIDAccount, accountName);
end

FR.Alert = function(text)
	local ChatFrame = DEFAULT_CHAT_FRAME;
	ChatFrame:AddMessage(text, BATTLENET_FONT_COLOR["r"], BATTLENET_FONT_COLOR["g"], BATTLENET_FONT_COLOR["b"]);
end

FR.Scan = function ()

	--
	-- battle.net Friends
	--
	if BNConnected() then
		--print ("Scanning battle.net Friends...");
		--print(FriendAlertsDB.settings.notifications.bnetFriendChangesGame)
		for index = 1, BNGetNumFriends() do
			exit = true;
			local friendAccountInfo = C_BattleNet.GetFriendAccountInfo(index);

			if friendAccountInfo then
				local bnetIDAccount = friendAccountInfo.bnetAccountID;
				local accountName = friendAccountInfo.accountName;
				local isOnline = friendAccountInfo.gameAccountInfo.isOnline or false;
				local isFavorite = friendAccountInfo.isFavorite or false;
				local isDND = friendAccountInfo.isDND or false;
				local note = friendAccountInfo.note or "";

				local game = (friendAccountInfo.gameAccountInfo and friendAccountInfo.gameAccountInfo.clientProgram) or nil;
				local areaName = (friendAccountInfo.gameAccountInfo and friendAccountInfo.gameAccountInfo.areaName) or "Unknown";
				local characterName = (friendAccountInfo.gameAccountInfo and friendAccountInfo.gameAccountInfo.characterName) or "Unknown";
				local characterLevel = (friendAccountInfo.gameAccountInfo and friendAccountInfo.gameAccountInfo.characterLevel) or nil;
				local realmName = (friendAccountInfo.gameAccountInfo and friendAccountInfo.gameAccountInfo.realmName) or nil;
				local factionName = (friendAccountInfo.gameAccountInfo and friendAccountInfo.gameAccountInfo.factionName) or "Unknown";
				local gameAccountID = friendAccountInfo.gameAccountInfo.wowProjectID or nil; -- WoW Project ID aka version
				local isAFK = (friendAccountInfo.gameAccountInfo and friendAccountInfo.gameAccountInfo.isGameAFK) or false;
				local playerGuid = friendAccountInfo.gameAccountInfo.playerGuid;
				local slug = characterName;
				if realmName then
					slug = slug .. "-" .. realmName;
				end
				
				repeat
					-- Ensure the bnetIDAccount is valid or skip
					if not FR.bnetFriends[bnetIDAccount] then break end

					-- Ensure the game/client is not nil
					if not game then break end

					-- Check if friend is online and skip if not
					if (isOnline == false) then break end

					-- Check if 'frignore' is in the note and skip if it is. (keeping this for backwards compatibility)
					if string.find(note, "frignore") then break end

					-- Check if 'fa_ignore' is in the note and skip if it is
					if string.find(note, "fa_ignore") then break end

					-- Changes Game
					if game ~= FR.bnetFriends[bnetIDAccount]["game"] and FR.bnetFriends[bnetIDAccount]["isOnline"] and game ~= "WoW" then
						if isFavorite and FriendAlertsDB.settings.notifications.bnetFavorite.ChangesGame.Enabled then
							FR.Alert(FR.icons["Friend"] .. string.format("%s is now playing %s%s.", FR.WhisperLink(accountName, bnetIDAccount), (FR.icons[game] or ""), (FR.games[game] or "Unknown")));

							if FriendAlertsDB.settings.notifications.bnetFavorite.ChangesGame.Sound then PlaySoundFile(FR.sounds[FriendAlertsDB.settings.notifications.bnetFavorite.ChangesGame.SoundFile], "Effects") end
						end

						if not isFavorite and FriendAlertsDB.settings.notifications.bnetFriend.ChangesGame.Enabled then
							FR.Alert(FR.icons["Friend"] .. string.format("%s is now playing %s%s.", FR.WhisperLink(accountName, bnetIDAccount), (FR.icons[game] or ""), (FR.games[game] or "Unknown")));
							if FriendAlertsDB.settings.notifications.bnetFriend.ChangesGame.Sound then PlaySoundFile(FR.sounds[FriendAlertsDB.settings.notifications.bnetFriend.ChangesGame.SoundFile], "Effects") end
						end

						if not FR.icons[game] then
							Utils.Debug("Unknown Game: " .. game);
						end
						break
					end

					-- Changes AFK Status
					if isAFK ~= FR.bnetFriends[bnetIDAccount]["isAFK"] then
						if isAFK then
							if isFavorite and FriendAlertsDB.settings.notifications.bnetFavorite.GoesAFK.Enabled then
								FR.Alert(FR.icons["Friend"] .. string.format("%s is now AFK.", FR.WhisperLink(accountName, bnetIDAccount)));
								if FriendAlertsDB.settings.notifications.bnetFavorite.GoesAFK.Sound then PlaySoundFile(FR.sounds[FriendAlertsDB.settings.notifications.bnetFavorite.GoesAFK.SoundFile], "Effects") end
							end

							if not isFavorite and FriendAlertsDB.settings.notifications.bnetFriend.GoesAFK.Enabled then
								FR.Alert(FR.icons["Friend"] .. string.format("%s is now AFK.", FR.WhisperLink(accountName, bnetIDAccount)));
								if FriendAlertsDB.settings.notifications.bnetFriend.GoesAFK.Sound then PlaySoundFile(FR.sounds[FriendAlertsDB.settings.notifications.bnetFriend.GoesAFK.SoundFile], "Effects") end
							end
						else
							if isFavorite and FriendAlertsDB.settings.notifications.bnetFavorite.NoLongerAFK.Enabled then
								FR.Alert(FR.icons["Friend"] .. string.format("%s is no longer AFK.", FR.WhisperLink(accountName, bnetIDAccount)));
								if FriendAlertsDB.settings.notifications.bnetFavorite.NoLongerAFK.Sound then PlaySoundFile(FR.sounds[FriendAlertsDB.settings.notifications.bnetFavorite.NoLongerAFK.SoundFile], "Effects") end
							end

							if not isFavorite and FriendAlertsDB.settings.notifications.bnetFriend.NoLongerAFK.Enabled then
								FR.Alert(FR.icons["Friend"] .. string.format("%s is no longer AFK.", FR.WhisperLink(accountName, bnetIDAccount)));
								if FriendAlertsDB.settings.notifications.bnetFriend.NoLongerAFK.Sound then PlaySoundFile(FR.sounds[FriendAlertsDB.settings.notifications.bnetFriend.NoLongerAFK.SoundFile], "Effects") end
							end
						end
						break
					end

					-- Changes Character in WoW
					if game ~= "WoW" then break end

					if slug ~= FR.bnetFriends[bnetIDAccount]["characterSlug"] then
						FR.bNetCharacterSlugs[playerGuid] = true
						if isFavorite and FriendAlertsDB.settings.notifications.bnetFavorite.ChangesCharacter.Enabled then
							FR.Alert(FR.icons["Friend"] .. string.format("%s is now playing %s (%s%s).", FR.WhisperLink(accountName, bnetIDAccount), (FR.icons[game]), (FR.icons[factionName]), (slug)));
							if FriendAlertsDB.settings.notifications.bnetFavorite.ChangesCharacter.Sound then PlaySoundFile(FR.sounds[FriendAlertsDB.settings.notifications.bnetFavorite.ChangesCharacter.SoundFile], "Effects") end
						end

						if not isFavorite and FriendAlertsDB.settings.notifications.bnetFriend.ChangesCharacter.Enabled then
							FR.Alert(FR.icons["Friend"] .. string.format("%s is now playing %s (%s%s).", FR.WhisperLink(accountName, bnetIDAccount), (FR.icons[game]), (FR.icons[factionName]), (slug)));
							if FriendAlertsDB.settings.notifications.bnetFriend.ChangesCharacter.Sound then PlaySoundFile(FR.sounds[FriendAlertsDB.settings.notifications.bnetFriend.ChangesCharacter.SoundFile], "Effects") end
						end
						break
					end

					-- Changes Zone in WoW
					if areaName ~= FR.bnetFriends[bnetIDAccount]["areaName"] then
						FR.bNetCharacterSlugs[playerGuid] = true
						if isFavorite and FriendAlertsDB.settings.notifications.bnetFavorite.ChangesZone.Enabled then
							FR.Alert(FR.icons["Friend"] .. string.format("%s %s%s has entered %s.", FR.WhisperLink(accountName, bnetIDAccount), (FR.icons[factionName]), (slug), (areaName)));
							if FriendAlertsDB.settings.notifications.bnetFavorite.ChangesZone.Sound then PlaySoundFile(FR.sounds[FriendAlertsDB.settings.notifications.bnetFavorite.ChangesZone.SoundFile], "Effects") end
						end

						if not isFavorite and FriendAlertsDB.settings.notifications.bnetFriend.ChangesZone.Enabled then
							FR.Alert(FR.icons["Friend"] .. string.format("%s %s%s has entered %s.", FR.WhisperLink(accountName, bnetIDAccount), (FR.icons[factionName]), (slug), (areaName)));
							if FriendAlertsDB.settings.notifications.bnetFriend.ChangesZone.Sound then PlaySoundFile(FR.sounds[FriendAlertsDB.settings.notifications.bnetFriend.ChangesZone.SoundFile], "Effects") end
						end
						break
					end

					-- Levels Character in WoW
					if characterLevel ~= FR.bnetFriends[bnetIDAccount]["characterLevel"] and characterLevel > 1 then
						FR.bNetCharacterSlugs[slug] = true
						if isFavorite and FriendAlertsDB.settings.notifications.bnetFavorite.LevelsCharacter.Enabled then
							FR.Alert(FR.icons["Friend"] .. string.format("%s %s%s has reached level %d!", FR.WhisperLink(accountName, bnetIDAccount), (FR.icons[factionName]), (slug), (characterLevel)));
							if FriendAlertsDB.settings.notifications.bnetFavorite.LevelsCharacter.Sound then PlaySoundFile(FR.sounds[FriendAlertsDB.settings.notifications.bnetFavorite.LevelsCharacter.SoundFile], "Effects") end
						end

						if not isFavorite and FriendAlertsDB.settings.notifications.bnetFriend.LevelsCharacter.Enabled then
							FR.Alert(FR.icons["Friend"] .. string.format("%s %s%s has reached level %d!", FR.WhisperLink(accountName, bnetIDAccount), (FR.icons[factionName]), (slug), (characterLevel)));
							if FriendAlertsDB.settings.notifications.bnetFriend.LevelsCharacter.Sound then PlaySoundFile(FR.sounds[FriendAlertsDB.settings.notifications.bnetFriend.LevelsCharacter.SoundFile], "Effects") end
						end
						break
					end

				until true

				FR.bnetFriends[bnetIDAccount] = FR.bnetFriends[bnetIDAccount] or {};
				FR.bnetFriends[bnetIDAccount]["game"] = game;
				FR.bnetFriends[bnetIDAccount]["isOnline"] = isOnline;
				FR.bnetFriends[bnetIDAccount]["isAFK"] = isAFK;
				FR.bnetFriends[bnetIDAccount]["areaName"] = areaName;
				FR.bnetFriends[bnetIDAccount]["characterSlug"] = slug;
				FR.bnetFriends[bnetIDAccount]["characterLevel"] = characterLevel;

				if playerGuid then
					FR.bNetCharacterSlugs[playerGuid] = true
				end
			
			end
		end
	end

	--
	-- Character Friends --
	--
	numberOfFriends = C_FriendList.GetNumFriends();
	--FR.Debug("Number of Friends: " .. numberOfFriends);

	if FriendAlertsDB.settings.notifications.friend.ChangesZone.Enabled or FriendAlertsDB.settings.notifications.friend.LevelsCharacter.Enabled then
		for index = 1, numberOfFriends do

			local friendInfo = C_FriendList.GetFriendInfoByIndex(index);
			local isOnline = friendInfo.connected or nil;
			local characterName = friendInfo.name or nil;
			local areaName = friendInfo.area or nil;
			local characterLevel = friendInfo.level or nil;
			--local slug = characterName;
			local guid = friendInfo.guid;

			if isOnline and characterName then
				if FR.characterFriends[characterName] then
					-- Changes Zone in WoW
					if FR.characterFriends[characterName]["area"] ~= areaName and FriendAlertsDB.settings.notifications.friend.ChangesZone.Enabled and not FR.bNetCharacterSlugs[guid] then
						FR.Alert(string.format("|cffffff00%s has entered %s.", characterName, areaName));
						if FriendAlertsDB.settings.notifications.friend.ChangesZone.Sound then PlaySoundFile(FR.sounds[FriendAlertsDB.settings.notifications.friend.ChangesZone.SoundFile], "Effects") end
					end

					-- Levels Character in WoW
					if characterLevel ~= FR.characterFriends[characterName]["level"] and FriendAlertsDB.settings.notifications.friend.LevelsCharacter.Enabled and not FR.bNetCharacterSlugs[guid] and characterLevel > 1  then
						FR.Alert(string.format("|cffffff00%s has reached %d!", characterName, characterLevel));
						if FriendAlertsDB.settings.notifications.friend.LevelsCharacter.Sound then PlaySoundFile(FR.sounds[FriendAlertsDB.settings.notifications.friend.LevelsCharacter.SoundFile], "Effects") end
					end
				end
				FR.characterFriends[characterName] = friendInfo or {};
				FR.characterFriends[characterName]["area"] = areaName;
				FR.characterFriends[characterName]["level"] = characterLevel;
			end
		end
	end

	--
	-- Guild Members --
	--
	if FriendAlertsDB.settings.notifications.guildMember.ChangesZone.Enabled or FriendAlertsDB.settings.notifications.guildMember.LevelsCharacter.Enabled then
		C_GuildInfo.GuildRoster();
		numTotal, numOnline = GetNumGuildMembers();

		for index = 1, numTotal do
			local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile, isSoREligible, standingID, playerGuid = GetGuildRosterInfo(index);

			if name and online and FR.guildMembers[name] and not FR.bNetCharacterSlugs[playerGuid] and (playerFullName ~= name) then
				-- Changes Zone in WoW
				if zone ~= FR.guildMembers[name]["zone"] and FriendAlertsDB.settings.notifications.guildMember.ChangesZone.Enabled then
					FR.Alert(string.format("\124c0000FF98%s has entered %s.\124r", name, zone)); 
					if FriendAlertsDB.settings.notifications.guildMember.ChangesZone.Sound then PlaySoundFile(FR.sounds[FriendAlertsDB.settings.notifications.guildMember.ChangesZone.SoundFile], "Effects") end
				end

				-- Levels Character in WoW
				if level ~= FR.guildMembers[name]["level"] and FriendAlertsDB.settings.notifications.guildMember.LevelsCharacter.Enabled and level > 1 then
					FR.Alert(string.format("\124c0000FF98%s has reached %d!\124r", name, level)); 
					if FriendAlertsDB.settings.notifications.guildMember.LevelsCharacter.Sound then PlaySoundFile(FR.sounds[FriendAlertsDB.settings.notifications.guildMember.LevelsCharacter.SoundFile], "Effects") end
				end
			end

			if name then
				FR.guildMembers[name] = FR.guildMembers[name] or {};
				FR.guildMembers[name]["zone"] = zone;
				FR.guildMembers[name]["level"] = level;
			end
		end
	end

	C_Timer.After(FriendAlertsDB.settings.options.scanInterval, FR.Scan);
end


local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

initFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then

		-- Initialize the database if it doesn't exist
		--FriendAlertsDB = nil
		if not FriendAlertsDB then
			FriendAlertsDB = {
				settings = CopyTable(FR.defaults),
			}
		end

		-- Upgrade database if needed (currently just erase database if using an old version of the database, but allow for future upgrades by checking version number)
		if not FriendAlertsDB.settings.config then
			FriendAlertsDB = {
				settings = CopyTable(FR.defaults),
			}
		end

		-- Upgrade from database version 1 to 2
		-- this version added custom sound choices for notifications
		if FriendAlertsDB.settings.config.databaseVersion < 2 then
			for k, v in pairs(FriendAlertsDB.settings.notifications) do
				for kk, vv in pairs(v) do
					FriendAlertsDB.settings.notifications[k][kk]["SoundFile"] = FR.defaults.notifications[k][kk]["SoundFile"]
				end
			end
			FriendAlertsDB.settings.config.databaseVersion = 2
		end

		-- Upgrade from database version 2 to 3
		-- added option to enable/disable the 'Addon Loaded' message at login
		if FriendAlertsDB.settings.config.databaseVersion < 3 then
			FriendAlertsDB.settings.options.onLoginMessage = FriendAlertsDB.settings.options.onLoginMessage or FR.defaults.options.onLoginMessage
			FriendAlertsDB.settings.config.databaseVersion = 3
		end

		-- Upgrade from database version 3 to 4
		-- added option to enable/disable the 'Addon Loaded' message at login
		if FriendAlertsDB.settings.config.databaseVersion < 4 then
			FriendAlertsDB.settings.notifications.bnetFavorite["GoesAFK"] = FR.defaults.notifications.bnetFavorite.GoesAFK
			FriendAlertsDB.settings.notifications.bnetFavorite["NoLongerAFK"] = FR.defaults.notifications.bnetFavorite.NoLongerAFK
			FriendAlertsDB.settings.notifications.bnetFriend["GoesAFK"] = FR.defaults.notifications.bnetFriend.GoesAFK
			FriendAlertsDB.settings.notifications.bnetFriend["NoLongerAFK"] = FR.defaults.notifications.bnetFriend.NoLongerAFK
			FriendAlertsDB.settings.config.databaseVersion = 4
		end

		-- Upgrade from database version 4 to 5
		-- added option to enable/disable easter eggs
		if FriendAlertsDB.settings.config.databaseVersion < 5 then
			FriendAlertsDB.settings.options["easterEggs"] = FR.defaults.options.easterEggs
			FriendAlertsDB.settings.config.databaseVersion = 5
		end

		-- useful during development when adding new settings to database, be cautious though when adding new settings to an existing dictionary.
		-- perhaps expand this to check for specific keys that are missing
		for k, v in pairs(FR.defaults) do
			if FriendAlertsDB.settings[k] == nil then
				FriendAlertsDB.settings[k] = v
			end
		end

		-- Initialize main options UI if available with a small delay
        C_Timer.After(0.2, function()
            if FR.AboutUI and FR.AboutUI.Initialize then
                FR.AboutUI:Initialize()
            end

            C_Timer.After(0.1, function()
                if FR.NotificationsUI and FR.NotificationsUI.Initialize then
                    FR.NotificationsUI:Initialize()
                end

				C_Timer.After(0.1, function()
					if FR.OptionsUI and FR.OptionsUI.Initialize then
						FR.OptionsUI:Initialize()
					end

					C_Timer.After(0.1, function()
						if FR.SupportUI and FR.SupportUI.Initialize then
							FR.SupportUI:Initialize()
						end
					end)
				end)
            end)
        end)

		initFrame:UnregisterEvent("ADDON_LOADED")
	end

	if event == "PLAYER_ENTERING_WORLD" then
		if FriendAlertsDB.settings.options.onLoginMessage then
			Utils.Print("Addon Loaded. Version: " .. FR.version)
		end
		
		Utils.Debug("Debug Mode is Enabled");

		C_Timer.After(8, FR.Scan); -- Start scanning after a short delay
		initFrame:UnregisterEvent("PLAYER_LOGIN")
		initFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end)

-- Whisper frame
local whisperFrame = CreateFrame("Frame")
whisperFrame:RegisterEvent("CHAT_MSG_WHISPER")
whisperFrame:RegisterEvent("CHAT_MSG_BN_WHISPER")

whisperFrame:SetScript("OnEvent", function(self, event, msg, sender, _, _, _, _, _, _, _, _, _, presenceID)
    if msg:lower() == "moo" then

		local currentTime = time()
		if currentTime - lastMooTime >= cooldown and FriendAlertsDB.settings.options.easterEggs then
			PlaySoundFile("Interface/Addons/FriendAlerts/Media/Sounds/moo_custom_2.ogg", "Effects")
			lastMooTime = currentTime
		end

    end
end)

-- Slash Commands
SLASH_FRIENDALERTS1 = "/fa"
SLASH_FRIENDALERTS2 = "/friendalerts"
SlashCmdList["FRIENDALERTS"] = function(msg)
	if msg == "reset" then
		FriendAlertsDB = nil
		FriendAlertsDB = {
			settings = CopyTable(FR.defaults),
		}
		Utils.Print("Settings have been reset to defaults. Please reload the UI to apply changes!")
		return
	end
    Settings.OpenToCategory("FriendAlerts")
end
