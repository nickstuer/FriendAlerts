# FriendAlerts
<img alt="GitHub Issues or Pull Requests" src="https://img.shields.io/github/issues/nickstuer/friendalerts">

[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

A World of Warcraft addon for Battle.net style alerts when friends change games or zones.

## Table of Contents

- [Features](https://github.com/nickstuer/blizzapi?tab=readme-ov-file#-features)
- [Install](https://github.com/nickstuer/blizzapi?tab=readme-ov-file#-install)
- [Usage](https://github.com/nickstuer/blizzapi?tab=readme-ov-file#-usage)
- [Development](https://github.com/nickstuer/blizzapi?tab=readme-ov-file#-development)
- [Contributing](https://github.com/nickstuer/blizzapi?tab=readme-ov-file#-contributing)

## Example
![Example Alert](images/example.png)

## 📖 Features

### Launching New Games
Displays a Battle.net style message in the chat window to indicate that a friend has launched a new game.

### Changes WoW Characters
Displays a Battle.net style message in the chat window to indicate that a friend has logged into a different WoW character.

### Ding WoW Level
Displays a Battle.net style message in the chat window to indicate that a friend or guild member has dinged a new level.

### Entering New Zones
Displays a message in the chat when a Battle.net friend or guild member enters a new zone in World of Warcraft.

### Easy Configuration
Quickly configure the alerts to avoid chat spam. Select between Battle.net Favorite, Battle.net Friend, Character Friends, Guild Members.

### Supported Game Notifications
| Game                                  | Status                              |
| :----------------------------------:  | :--------------------------------:  |
| World Of Warcraft (Retail)            | Supported                           |
| World Of Warcraft (Classic)           | Supported                           |
| World of Warcraft (Classic Era)       | Supported                           |
| Hearthstone                           | Supported                           |
| Heroes of the Storm                   | Supported                           |
| Overwatch                             | Supported                           |

## 🛠 Install
```
Download from CurseForge or WoWUp.
```

## 🎮 Usage

### Slash Commands
Use these commands to open up the FriendAlerts configuration.
```
/fa
/friendalerts
```

## 💻 Development

#### Useful Links
Helpful links for developing or contributing to the addon.

[Sound IDs](https://www.wowinterface.com/forums/showthread.php?t=55702)

[BNGetFriendInfo](https://warcraft.wiki.gg/wiki/API_BNGetFriendInfo)

[Sounds](https://www.wowhead.com/sounds)

[Icon String Format](https://www.wowinterface.com/forums/showthread.php?t=46221)

[Chat Icons](https://wago.tools/files?search=chaticon)

#### Deploy
This copies the addon files to the appropriate World of Warcraft addons folder.
MacOS: bash ./deploy.sh
Windows: ./deploy.sh (via bash terminal)


## 🏆 Contributing
PRs accepted.

If editing the Readme, please conform to the [standard-readme](https://github.com/RichardLitt/standard-readme) specification.

#### Bug Reports and Feature Requests
Please use the [issue tracker](https://github.com/nickstuer/friendalerts/issues) to report any bugs or request new features.

#### Contributors

<a href = "https://github.com/nickstuer/friendalerts/graphs/contributors">
  <img src = "https://contrib.rocks/image?repo=nickstuer/friendalerts"/>
</a>
