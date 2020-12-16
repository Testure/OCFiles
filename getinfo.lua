local args = {...}
local component = require("component")
local event = require("event")
local modem = component.modem

modem.open(123)

modem.broadcast(321, "get", tostring(args[1]))
local _, _, _, port, _, message = event.pull("modem_message")
if port == 123 then
    print(message)
end