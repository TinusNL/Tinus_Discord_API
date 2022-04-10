--[[
  _____   _                                 _   _   _
 |_   _| (_)  _ __    _   _   ___          | \ | | | |
   | |   | | | '_ \  | | | | / __|         |  \| | | |    
   | |   | | | | | | | |_| | \__ \         | |\  | | |___ 
   |_|   |_| |_| |_|  \__,_| |___/  _____  |_| \_| |_____|
                                   |_____|
]]--

Config.Token = "Bot "..Config.Token

local Cache = {}
local GuildRoles = {}

local Logs = {}

Citizen.CreateThread(function()
    if GetCurrentResourceName() ~= "Tinus_Discord_API" then
        print("^6[Tinus_Discord_API]^7 - ^1Error: ^3Make sure you name this resource `Tinus_Discord_API` for it to work correctly with other scripts.^7")
    end
end)

-- Base
function GetPostal(Coords)
    local RawPostals = LoadResourceFile(GetCurrentResourceName(), "postals.json")
    local Postals = json.decode(RawPostals)
    local Nearest = nil
    local CoordsX, CoordsY = table.unpack(Coords)

	local ndm = -1
	local ni = -1
	for i, p in ipairs(Postals) do
		local dm = (CoordsX - p.x) ^ 2 + (CoordsY - p.y) ^ 2
		if ndm == -1 or dm < ndm then
			ni = i
			ndm = dm
		end
	end

	if ni ~= -1 then
		local nd = math.sqrt(ndm)
		Nearest = {i = ni, d = nd}
	end

	Nearest = Postals[Nearest.i].code
	return Nearest
end

function GetIdentifier(Source, Identifier, GSub)
    if GetPlayerPing(Source) > 0 then
        local FoundIdentifier = nil

        for Index, CurrentIdentifier in pairs(GetPlayerIdentifiers(Source)) do
            if string.sub(CurrentIdentifier, 1, string.len(Identifier..":")) == Identifier..":" then
                if GSub then
                    FoundIdentifier = string.gsub(CurrentIdentifier, Identifier..":", "")
                else
                    FoundIdentifier = CurrentIdentifier
                end
                break
            end
        end

        return FoundIdentifier
    end
end

function GetDiscordInfo(DiscordId)
    if Config.Caching then
        if Cache[DiscordId] then
            return Cache[DiscordId].Info
        end
    end

    local TimeWaited = 0
    local Info = nil

    PerformHttpRequest(string.format("https://discordapp.com/api/guilds/%s/members/%s", Config.Guild, DiscordId), function(ReturnCode, ResultData, ResultHeaders)
        if ReturnCode == 401 or ReturnCode == 403 then
            print("^6[Tinus_Discord_API]^7 - ^1Error: ^3Invalid Bot Token.^7")
        else
            Info = json.decode(ResultData)
        end
    end, "GET", "", {["Authorization"] = Config.Token, ["Content-Type"] = "application/json"})

    repeat
        Citizen.Wait(100)
        TimeWaited = TimeWaited + 100
    until Info or TimeWaited >= Config.RequestTimeout * 1000

    if Config.Caching then
        Cache[DiscordId] = {
            Time = Config.CacheTime,
            Info = Info
        }
    end

    return Info
end

function UpdateGuildRoles()
    PerformHttpRequest(string.format("https://discordapp.com/api/guilds/%s/roles", Config.Guild), function(ReturnCode, ResultData, ResultHeaders)
        if ReturnCode == 401 or ReturnCode == 403 then
            print("^6[Tinus_Discord_API]^7 - ^1Error: ^3Invalid Bot Token.^7")
        else
            GuildRoles = json.decode(ResultData)
        end
    end, "GET", "", {["Authorization"] = Config.Token, ["Content-Type"] = "application/json"})
end

-- Guild Roles Timer
Citizen.CreateThread(function()
    if not Config.GuildRoles then return end
    UpdateGuildRoles()
    
    if not Config.GuildRolesUpdate then return end

    while true do
        Citizen.Wait(Config.GuildRolesTime * 1000)
        UpdateGuildRoles()
    end
end)

-- Cache Timer
Citizen.CreateThread(function()
    if not Config.Caching then return end

    while true do
        Citizen.Wait(1000)
        
        for CurrentID, CurrentInfo in pairs(Cache) do
            Cache[CurrentID].Time = CurrentInfo.Time - 1

            if Cache[CurrentID].Time <= 0 then
                Cache[CurrentID] = nil
            end
        end
    end
end)

--[[
  _____                                 _         
 | ____| __  __  _ __     ___    _ __  | |_   ___ 
 |  _|   \ \/ / | '_ \   / _ \  | '__| | __| / __|
 | |___   >  <  | |_) | | (_) | | |    | |_  \__ \
 |_____| /_/\_\ | .__/   \___/  |_|     \__| |___/
                |_|                               
]]--

-- Role Exports
function GetUserRoles(DiscordId)
    if GetPlayerPing(DiscordId) > 0 then DiscordId = GetIdentifier(DiscordId, "discord", true) end
    if DiscordId == nil then return end

    local Info = GetDiscordInfo(DiscordId)
    return Info.roles
end

function HasUserRole(DiscordId, RoleId)
    if GetPlayerPing(DiscordId) > 0 then DiscordId = GetIdentifier(DiscordId, "discord", true) end
    if DiscordId == nil then return end

    if type(RoleId) == "string" then
        if Config.GuildRoles then
            for Index, CurrentRole in pairs(GuildRoles) do
                if CurrentRole.name == RoleId then
                    RoleId = CurrentRole.id
                    break
                end
            end

            if type(RoleId) == "string" then
                print("^6[Tinus_Discord_API]^7 - ^1Error: ^3The given RoleName could not be found. Try using RoleId's instead.^7")
                return false
            end
        else
            print("^6[Tinus_Discord_API]^7 - ^1Error: ^3GuildRoles are disabled. Enable this to allow for RoleNames to be used.^7")
            return false
        end
    end

    local Info = GetDiscordInfo(DiscordId)

    for Index, CurrentRole in pairs(Info.roles) do
        if RoleId == CurrentRole then
            return true
        end
    end

    return false
end

-- Name Exports
function GetUserName(DiscordId)
    if GetPlayerPing(DiscordId) > 0 then DiscordId = GetIdentifier(DiscordId, "discord", true) end
    if DiscordId == nil then return end

    local Info = GetDiscordInfo(DiscordId)
    return Info.user.username
end

function GetUserNickname(DiscordId)
    if GetPlayerPing(DiscordId) > 0 then DiscordId = GetIdentifier(DiscordId, "discord", true) end
    if DiscordId == nil then return end

    local Info = GetDiscordInfo(DiscordId)
    return Info.nick
end

function GetUserTag(DiscordId)
    if GetPlayerPing(DiscordId) > 0 then DiscordId = GetIdentifier(DiscordId, "discord", true) end
    if DiscordId == nil then return end

    local Info = GetDiscordInfo(DiscordId)
    return Info.user.username.."#"..Info.user.discriminator
end

-- Log Exports
function CreateLog(KeyName, URL, Username, Avatar)
    if not Logs[KeyName] then
        Logs[KeyName] = {
            URL = URL,
            Username = Username or Config.LogDefaults.Username,
            Avatar = Avatar or Config.LogDefaults.Avatar
        }
    else
        print("^6[Tinus_Discord_API]^7 - ^1Error: ^3A log with the given KeyName already exists.^7")
    end
end

function SendLog(KeyName, Message, Options)
    if not Logs[KeyName] then
        print("^6[Tinus_Discord_API]^7 - ^1Error: ^3A log with the given KeyName does not exist.^7")
        return
    end

    local Log = Logs[KeyName]
    local LogEmbed = {}

    LogEmbed.color = Options.Color or Config.LogDefaults.Color
    LogEmbed.description = Message
    
    if #Options > 0 then
        LogEmbed.fields = {}
        
        for Index, CurrentOptions in pairs(Options) do
            local CurrentName = CurrentOptions[1]
            local CurrentValue = CurrentOptions[2]

            local ValidOption = true
            local CurrentField = {
                name = CurrentName,
                value = nil,
                inline = Config.LogDefaults.FieldsInline,
            }

            if CurrentOptions[3] ~= nil then
                CurrentField.inline = CurrentOptions[3]
            end
            
            if CurrentName == "PlayerId" then
                CurrentField.value = CurrentValue
            elseif CurrentName == "SteamId" then
                CurrentField.value = GetIdentifier(CurrentValue, "steam", false)
            elseif CurrentName == "DiscordId" then
                CurrentField.value = "<@"..GetIdentifier(CurrentValue, "discord", true)..">"
            elseif CurrentName == "LiveId" then
                CurrentField.value = GetIdentifier(CurrentValue, "live", false)
            elseif CurrentName == "LicenseId" then
                CurrentField.value = GetIdentifier(CurrentValue, "license", false)
            elseif CurrentName == "XblId" then
                CurrentField.value = GetIdentifier(CurrentValue, "xbl", false)
            elseif CurrentName == "Ip" then
                CurrentField.value = GetIdentifier(CurrentValue, "ip", true)
            elseif CurrentName == "Postal" then
                CurrentField.value = GetPostal(CurrentValue)
            else
                ValidOption = false
            end

            if ValidOption then
                if CurrentField.value == nil then
                    print("^6[Tinus_Discord_API]^7 - ^1Error: ^3The given value for `"..CurrentName.."` does not exist.^7")
                    return
                else
                    table.insert(LogEmbed.fields, CurrentField)
                end
            else
                print("^6[Tinus_Discord_API]^7 - ^1Error: ^3A option with the name `"..CurrentName.."` does not exist.^7")
                return
            end
        end
    end

    LogEmbed.footer = { -- Just leave your boy some credits!
        text = "Logs by: Tinus_NL",
        icon_url = "https://i.imgur.com/t79yHMq.png"
    }
    PerformHttpRequest(Log.URL, function(ReturnCode, ResultData, ResultHeaders) end, "POST", json.encode({username = Logs.Username, avatar_url = Logs.Avatar, embeds = {LogEmbed}}), {["Content-Type"] = "application/json"})
end