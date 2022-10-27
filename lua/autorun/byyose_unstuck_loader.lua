--[[
    Addons : ByYoSe - Unstuck system
]]

local folderName = "byyose_unstuck_system"
local name = "ByYoSe - Unstuck System"

if SERVER then

    AddCSLuaFile(folderName.."/config.lua")
    include(folderName.."/config.lua")

    local files = file.Find(folderName.."/shared/*.lua", "LUA")
    for _, file in ipairs(files) do
        AddCSLuaFile(folderName.."/shared/"..file)
        include(folderName.."/shared/"..file)
    end

    local files = file.Find(folderName.."/client/*.lua", "LUA")
    for _, file in ipairs(files) do
        AddCSLuaFile(folderName.."/client/"..file)
    end

    local files = file.Find(folderName.."/server/*.lua", "LUA")
    for _, file in ipairs(files) do
        include(folderName.."/server/"..file)
    end

    local materials = file.Find("materials/"..folderName.."/*", "GAME")
    for _, file in ipairs(materials) do
        resource.AddSingleFile("materials/"..folderName.."/"..file)
    end

    local resources = file.Find("resource/fonts/*", "GAME")
    for _, file in ipairs(resources) do
        resource.AddSingleFile("resource/fonts/"..file)
    end
    
    MsgC("["..name.."] Fichiers (server) charges avec succès !\n")

else

    include(folderName.."/config.lua")

    local files = file.Find(folderName.."/shared/*.lua", "LUA")
    for _, file in ipairs(files) do
        include(folderName.."/shared/"..file)
    end

    local files = file.Find(folderName.."/client/*.lua", "LUA")
    for _, file in ipairs(files) do
        include(folderName.."/client/"..file)
    end
    
    MsgC("["..name.."] Fichiers (client) charges avec succès !\n")
end

