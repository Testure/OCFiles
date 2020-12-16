local component = require("component")
local event = require("event")
local modem = component.modem
local name = "/mnt/2b7/122320/"
local done = false

modem.open(321)
modem.open(123)

local states = {
  ["Ampere"] = {house = {r = 0, y = 0}, president = "y"},
  ["Fermi"] = {house = {r = 0, y = 0}, president = "r"},
  ["Aquae"] = {house = {r = 0, y = 0}, president = "r"},
  ["Arbor"] = {house = {r = 0, y = 0}, president = "y"},
  ["Orbis"] = {house = {r = 0, y = 0}, president = "y"},
  ["North"] = {house = {r = 0, y = 0}, president = "r"},
  ["South"] = {house = {r = 0, y = 0}, president = "r"},
  ["West"] = {house = {r = 0, y = 0}, president = "y"},
  ["Maxwell"] = {house = {r = 0, y = 0}, president = "y"},
  ["NorthMaxwell"] = {house = {r = 0, y = 0}, president = "y"}
}

function Process(message, toget, from)
    if message == "done" then
        for i,v in pairs(states) do
            local file = io.open(name..i, "w")
            file:write(string.format("House: %s President: %s", string.format("%d/%d", v.house.r, v.house.y), v.president))
            file:close()
        end
        print("Election results have been saved to: "..name)
        done = true
        return os.exit()
    end
    if message == "get" then
        local file = io.open(name..toget, "r")
        local lines = {}
        local string = ""
        for line in io.lines(name..toget) do
            table.insert(lines, line)
        end
        for _,v in pairs(lines) do
            string = string..tostring(v)
        end
        file:close()
        modem.send(from, 123, string)
        print("processed request to get state info")
        return
    end
    local state = ""
    for i,_ in pairs(states) do
        if string.find(message, i) then
            state = i
        end
    end
    local AddTo = ""
    if string.find(message, "House") then
        AddTo = "house"
    elseif string.find(message, "President") then
        AddTo = "president"
    end
    if AddTo == "president" then
        states[state][AddTo] = (string.find(message, "President: r") and "r") or "y"
    elseif AddTo == "house" then
        local team = (string.find(message, "House: r") and "r") or "y"
        states[state][AddTo][team] = states[state][AddTo][team] + 1
    end
    print("processed message")
end

while not done do
    local _, _, from, _, _, message, state = event.pull("modem_message")
    Process(message, state, from)
end