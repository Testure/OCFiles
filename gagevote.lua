local args = {...}
local component = require("component")
local modem = component.modem

modem.open(321)

local message = tostring(args[1]).." "..tostring(args[2])..": "..tostring(args[3])

local states = {
    ["Ampere"] = 2,
    ["Fermi"] = 8
}

local max = states[tostring(args[1])]

local function fileExists(path)
    local f = io.open(path, "rb")
    if f then f:close() end
    return f ~= nil
end

local function read(path)
    if not fileExists(path) then return "" end
    local file = io.open(path, "r")
    local lines = {}
    local string = ""
    for line in io.lines(path) do
       table.insert(lines, line) 
    end
    for _,v in pairs(lines) do
        string = string..tostring(v)
    end
    file:close()
    return string
end

local function write(path, toWrite)
    local file = io.open(path, "w")
    file:seek("set", 0)
    file:write(toWrite)
    file:close()
end

if tostring(args[2]) == "House" and read("/home/"..tostring(args[1])) ~= "" then
    local stateData = read("/home/"..tostring(args[1]))
    local houser = string.match(stateData, "%d")
    local housey = string.match(stateData, "%d", string.len(houser) + 1)
    if (tonumber(houser) + tonumber(housey)) >= max then
       print(tostring(args[1]).." has already house voted the max amount of times")
       return os.exit()
    end
    if tostring(args[3]) == "r" then
       houser = tostring(tonumber(houser) + 1)
    else
       housey = tostring(tonumber(housey) + 1)
    end
    write("/home/"..tostring(args[1]), string.format("%d/%d", tonumber(houser), tonumber(housey)))
    modem.broadcast(321, message)
elseif tostring(args[2]) == "President" and read("/home/"..tostring(args[1]).."p") ~= "" then
    local stateData = read("/home/"..tostring(args[1]).."p")
    local pres = string.find(stateData, "g")
    if not pres then
      print(tostring(args[1]).." has already voted")
      return os.exit()
    end
    write("/home/"..tostring(args[1]).."p", tostring(args[3]))
    modem.broadcast(321, message)
else
    modem.broadcast(321, message)
    local pres = "g"
    local r = 0
    local y = 0
    if tostring(args[2]) == "House" then
        if tostring(args[3]) == "r" then r = 1 else y = 1 end
    else
        pres = tostring(args[3])
    end
    write("/home/"..tostring(args[1]), string.format("%d/%d", r, y))
    write("/home/"..tostring(args[1]).."p", pres)
end