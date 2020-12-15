local component = require("component")
local event = require("event")
local modem = component.modem
local name = "/mnt/2b7/"..tostring(os.time())

modem.open(321)

local file = io.open(name, "rw")

local returned = file:read("*a")
print(returned)

local Coroutine = coroutine.create(function()

end)

while true do
    event.pull("modem_message")
end