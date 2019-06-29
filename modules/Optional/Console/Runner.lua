local funcs = {}

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

local raisin = require(".raisin")
local listen

function funcs.setup(data)
  listen = require("modules.Core.Interaction.Listener")
  listen.init(data)
  listen = listen.listen
end

function funcs.go()
  local consoles = {}

  ----------------------------------------------Controller
  raisin.thread(function()
    print("Spawned Console Controller.")
    while true do
      local ev = {os.pullEvent()}
      local event = ev[1]
      if event == "ConsoleStart" then
        os.sleep(0.5)
        os.queueEvent("ConsoleNotification", "Started", 3)
      end
    end
  end, 0)

  raisin.manager.run()
  print("Raisin thread manager running.")
end

return funcs
