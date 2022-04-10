--[[
  _____   _                                 _   _   _
 |_   _| (_)  _ __    _   _   ___          | \ | | | |
   | |   | | | '_ \  | | | | / __|         |  \| | | |    
   | |   | | | | | | | |_| | \__ \         | |\  | | |___ 
   |_|   |_| |_| |_|  \__,_| |___/  _____  |_| \_| |_____|
                                   |_____|
]]--

fx_version 'adamant'
game 'gta5'

author 'Tinus_NL'
description 'Tinus Discord API'

server_scripts { 
    -- Configuration
    'Config.lua',
    -- Code
    'Server/API.lua'
}

server_exports {
    -- Role Exports
    'GetUserRoles',
    'HasUserRole',
    -- Name Exports
    'GetUserName',
    'GetUserNickname',
    'GetUserTag',
    -- Webhook Exports
    'CreateLog',
    'SendLog'
}