local funcs = {}

local raisin
local listen
local tell
local console = {}

if not fs.exists("/raisin.lua") then
  local h = http.get("https://raw.githubusercontent.com/hugeblank/raisin/"
                      .. "master/raisin.lua")
  if h then
    local dat = h.readAll()
    h.close()
    local h2 = io.open("/raisin.lua", 'w')
    if h2 then
      h2:write(dat):close()
    else
      error("Failed to open a local file for writing.")
    end
  else
    error("Failed to connect to GitHub to download Raisin.")
  end
end
raisin = require(".raisin")

local function runConsole(data)
  local pfx = data.prefix
  local id = data.ID
  local name = data.name
  local out = data.print
  tell("Console started with ID " .. tostring(data.ID))
  while true do
    local ev = {os.pullEvent()} -- never recieves "RunnerStop" events
    tell(tostring(ev[1]))
    tell(tostring(ev[2]))
    if ev[1] == "RunnerStop" and ev[2] == id then
      tell("Stopping Console.")
      return
    end
  end
end

local function control()
  print("Spawned Console Controller.")
  while true do
    local ev = {os.pullEvent()}
    local event = ev[1]

    if event == "ConsoleStart" then
      local flags = ev[2]
      local pos = #console + 1
      console[pos] = {}
      console[pos].name = flags.n or "Console_" .. tostring(pos)
      console[pos].print = flags.o or true
      console[pos].prefix = flags.p or '['
      console[pos].priority = flags.i or 1
      console[pos].thread = raisin.thread(function()
                                            runConsole(console[pos])
                                          end, flags.i or 1)
      console[pos].ID = pos
      os.queueEvent("ConsoleNotification", "Started", 3)
    elseif event == "ConsoleStop" then
      local id = ev[2]
      tell("CONSOLE STOP") -- this is sent to the player
      os.sleep(0.1)
      os.queueEvent("RunnerStop", id) -- should be recieved at line 33

    end
  end
end



function funcs.setup(data, mods)
  listen = require("modules.Core.Interaction.Listener")
  listen.init(data)
  listen = listen.listen
  tell = require("modules.Core.Interaction.PlayerInteraction").tell
end

function funcs.getConsole(id)
  return console[id]
end

function funcs.go()

  ----------------------------------------------Controller
  raisin.thread(control, 0)

  raisin.manager.run(os.pullEventRaw)
  print("Raisin thread manager running.")
end

return funcs
