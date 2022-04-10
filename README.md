# Exports Documentation
## Roles
### GetUserRoles
Returns all the roles the account with the given `DiscordId` or `Source` has.
```lua
exports.Tinus_Discord_API:GetUserRoles(DiscordId/Source)

-- Example 1
local Roles = exports.Tinus_Discord_API:GetUserRoles(source)
print(Roles) -- {123456789123456789, 123456789123456789, 123456789123456789, 123456789123456789}

-- Example 2
local Roles = exports.Tinus_Discord_API:GetUserRoles("358676702496555008")
print(Roles) -- {123456789123456789, 123456789123456789}
```
 -  **DiscordId/Source:** The DiscordId of the account that you want the roles from. When given a Source it wil first convert it into a DiscordId.

### HasUserRole
Returns whether the given `DiscordId` or `Source` has a specific role.
```lua
exports.Tinus_Discord_API:HasUserRole(DiscordId/Source, RoleName/RoleId)

-- Example 1
local HasRole = exports.Tinus_Discord_API:HasUserRole(source, "123456789123456789")
print(HasRole) -- true

-- Example 2
local HasRole = exports.Tinus_Discord_API:HasUserRole("358676702496555008", "VIP")
print(HasRole) -- false
```
 -  **DiscordId/Source:** The DiscordId of the account that you want the roles from. When given a Source it will first convert it to a DiscordId.
 - **RoleName/RoleId:** The RoleId to check with the player role list. When given a RoleName it will first convert it to a RoleId.
> :warning: **RoleName**: RoleName only works when `Config.GuildRoles` is set to `true`!

## Names
### GetUserName
Returns the UserName of  the given `DiscordId` or `Source`.
```lua
exports.Tinus_Discord_API:GetUserName(DiscordId/Source)

-- Example 1
local UserName = exports.Tinus_Discord_API:GetUserName(source)
print(UserName) -- Tinus

-- Example 2
local UserName = exports.Tinus_Discord_API:GetUserName("358676702496555008")
print(UserName) -- Tinus 
```
 -  **DiscordId/Source:** The DiscordId of the account that you want the roles from. When given a Source it will first convert it to a DiscordId.
 
### GetUserNickname
Returns the Nickname of  the given `DiscordId` or `Source`.
```lua
exports.Tinus_Discord_API:GetUserNickname(DiscordId/Source)

-- Example 1
local Nickname = exports.Tinus_Discord_API:GetUserNickname(source)
print(Nickname) -- [Dev] Tinus

-- Example 2
local Nickname = exports.Tinus_Discord_API:GetUserNickname("358676702496555008")
print(Nickname) -- [Dev] Tinus
```
 -  **DiscordId/Source:** The DiscordId of the account that you want the roles from. When given a Source it will first convert it to a DiscordId.
 
### GetUserTag
Returns the Tag of  the given `DiscordId` or `Source`.
```lua
exports.Tinus_Discord_API:GetUserTag(DiscordId/Source)

-- Example 1
local UserTag = exports.Tinus_Discord_API:GetUserTag(source)
print(UserTag) -- Tinus#4202

-- Example 2
local UserTag = exports.Tinus_Discord_API:GetUserTag("358676702496555008")
print(UserTag) -- Tinus#4202
```
 -  **DiscordId/Source:** The DiscordId of the account that you want the roles from. When given a Source it will first convert it to a DiscordId.

## Webhook
### CreateLog
You will have to use this first to asign a `KeyName` to your Webhook URL.
```lua
exports.Tinus_Discord_API:CreateLog(KeyName, URL, Username, Avatar)

-- Example
exports.Tinus_Discord_API:CreateLog("TestLogs", "https://discord.com/api/webhooks/*/*", "Join Logs", "https://i.imgur.com/t79yHMq.png")
```

 -  **KeyName:** The KeyName to later refer to.
 -  **URL:** The Webhook URL.
 -  **Username:** (Optional) Username for the Webhook.
 -  **Avatar:** (Optional) Avatar Image for the Webhook.
 
### SendLog
Send a message to the given `KeyName` with the given `Message` and `Options`.
```lua
exports.Tinus_Discord_API:SendLog(KeyName, Message, Options)

-- Example
exports.Tinus_Discord_API:SendLog("TestLogs", "You are reading the tutorial!", {
	{"PlayerId", source},
	{"PlayerId", source2},
	{"SteamId", source, false},
	{"Postal", vector3(420.0, 420.0, 69.0), false}
})
```
 -  **KeyName:** The KeyName to that was used with `CreateLog`.
 -  **Message:** Basic description to give tot the embed.
 -  **Options:** Options to add to the embed. `{Name, Value, Inline}`
		 - **PlayerId:** Source
		 - **SteamId:** Source
		 - **DiscordId:** Source
		 - **LiveId:** Source
		 - **LicenseId:** Source
		 - **XblId:** Source
		 - **Ip:** Source
		 - **Postal:** Vector3
