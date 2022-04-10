--[[
  _____   _                                 _   _   _
 |_   _| (_)  _ __    _   _   ___          | \ | | | |
   | |   | | | '_ \  | | | | / __|         |  \| | | |    
   | |   | | | | | | | |_| | \__ \         | |\  | | |___ 
   |_|   |_| |_| |_|  \__,_| |___/  _____  |_| \_| |_____|
                                   |_____|
]]--

Config = {}

Config.Guild = "PLACE_YOUR_MAIN_GUILD_ID_HERE" -- Discord Guild ID
Config.Token = "PLACE_YOUR_BOT_TOKEN_HERE" -- Bot Token (https://discordapp.com/developers/applications/me)

Config.RequestTimeout = 5 -- Seconds to wait for a response from the Discord API before giving up and returning nil (Default: 5)

Config.Caching = true -- Enable/Disable Caching (Recommended: true)
Config.CacheTime = 60 -- Seconds (Recommended: 60)

Config.GuildRoles = true -- Enable/Disable Guild Roles (Allows for the use of RoleNames instead of RoleId's) (Recommended: true)
Config.GuildRolesUpdate = false -- Enable/Disable Guild Roles Update (Update the guild roles? Otherwise it wil only be run once the script starts.) (Recommended: false)
Config.GuildRolesTime = 600 -- Seconds (Recommended: 600)

Config.LogDefaults = {
    Username = "Tinus Discord API", -- Default Username to use when using CreateLog (Default: "Tinus Discord API")
    Avatar = "https://i.imgur.com/t79yHMq.png", -- Default Avatar to use when using CreateLog (Default: "https://i.imgur.com/t79yHMq.png")

    Color = 15105570, -- Default Color to use when using SendLog (Default: 15105570)
    FieldsInline = true -- Enable/Disable inline Embed Fields (Default: true)
}