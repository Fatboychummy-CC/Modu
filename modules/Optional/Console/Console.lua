--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/Chat/Echo.lua

This module creates virtual consoles to be via chat.
]]

local funcs = {}

local owner = false
local listen = false

function funcs.go(modules, vars)
  local interactor = modules["Core.Interaction.PlayerInteraction"]
  local tell = interactor.tell

  local com = vars[2]

  if com == "start" then
    os.queueEvent("ConsoleStart",
      {
        n = vars.flags['n'],
        o = vars.flags['o'],
        p = vars.flags['p']
      })

    local timeOut = os.startTimer(2)
    while true do
      local ev = {os.pullEvent()}
      if ev[1] == "ConsoleNotification" and ev[2] == "Started" then
        tell("Console successfully started, with ID " .. tostring(ev[3]))
        break
      elseif ev[1] == "timer" and ev[2] == timeOut then
        tell("Console failed to start after two seconds.")
      end
    end
  elseif com == "edit" then

  elseif com == "list" then

  elseif com == "stop" then

  end
end

function funcs.help()
  return {
    "Usage:",
    "  console <start/edit/list/stop> [id] [options]",
    ";;verbose",
    "  console start [options]",
    "    Starts a new console (similar to running 'bg shell').",
    "",
    "  console edit <id> [options]",
    "    Changes options of a virtual console.",
    "",
    "  console list",
    "    Lists the ids [and names, if applicable] of all running consoles.",
    "",
    "  console stop <id>",
    "    Shuts down a virtual console "
        .. "(Similar to running 'exit' in the shell).",
    "",
    "Flags:",
    "  n <name>: set the name of the virtual console to 'name'",
    "  f: used in 'console stop'.  Immediately stops program, instead of "
              .. "sending a terminate event, then stopping.",
    "  o <true/false>: set whether a virtual console should output to chat.",
    "  p <prefix>: Set the prefix for the console.  Defaults to '['."
  }
end

function funcs.getInstant()
  return "console"
end

function funcs.getInfo()
  return "Runs a virtual console that works similarly to CraftOS."
end

function funcs.init(data)
  owner = data.owner or error("No initData field 'owner'.", 0)
  listen = data.listen or error("No initData field 'listen'.", 0)
  local a = require("modules.Optional.Console.Runner")
  a.setup(data)
  return true, a.go
end

return funcs
