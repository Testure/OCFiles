local component = require("component")
local event = require("event")
local modem = component.modem
local gpu = component.gpu

modem.open(456)
modem.open(123)

local states = {
  ["Ampere"] = {fullName = "Ampere", votes = "2", normal = "Yellow"},
  ["Fermi"] = {fullName = "Fermi", votes = "8", normal = "Mixed"},
  ["Aquae"] = {fullName = "Aquae Terras", votes = "3", normal = "Red"},
  ["Arbor"] = {fullName = "Arbor Tenebris", votes = "4", normal = "Yellow"},
  ["Orbis"] = {fullName = "Orbis Petram", votes = "3", normal = "Yellow"},
  ["North"] = {fullName = "North Savanna", votes = "5", normal = "Red"},
  ["South"] = {fullName = "South Savanna", votes = "5", normal = "Red"},
  ["West"] = {fullName = "West Maxwell", votes = "2", normal = "Yellow"},
  ["Maxwell"] = {fullName = "Maxwell", votes = "6", normal = "Yellow"},
  ["NorthMaxwell"] = {fullName = "North Maxwell", votes = "2", normal = "Yellow"}
}

local function displayInfo(state)
    local w, h = gpu.getResolution()
    gpu.set(w/2 - 5, 1, states[state].fullName)
    gpu.set(w/2 - 5, 3, "Historically: "..states[state].normal)
    gpu.set(w/2 - 5, 5, "Total Votes: "..states[state].votes)
    modem.broadcast(321, "get", state)
    local _, _, _, port, _, stateData = event.pull("modem_message")
    if port == 123 then
        local Pres = string.sub(stateData, 5)
        local House = string.sub(stateData, 0, 4)
        local strin = ""
        if Pres == "r" then
            strin = "Red"
        elseif Pres == "y" then
            strin = "Yellow"
        else
            strin = "Unknown"
        end
        gpu.set(w/2 - 5, 7, "House Votes: "..House)
        gpu.set(3, 9, "Presidential Vote: "..strin)
    end
end

while true do
    local _, _, _, port, _, message, e = event.pull("modem_message")
    if port == 456 then
        gpu.setBackground(0, false)
        gpu.setForeground(16777215, false)
        gpu.setResolution(30, 9)
        local w, h = gpu.getResolution()
        gpu.fill(1, 1, w, h, " ")
        displayInfo(e)
    end
end