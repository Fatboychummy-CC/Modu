--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/master/modules/Chat/Echo.lua

This module creates virtual consoles to be via chat.
]]

local funcs = {}

local owner = false
local listen = false
local runner = require("modules.Optional.Console.Runner")
local tell

local function start(flags)
  os.queueEvent("ConsoleStart",
    {
      n = flags['n'],
      o = flags['o'],
      p = flags['p']
    })

  local timeOut = os.startTimer(2)
  while true do
    local ev = {os.pullEvent()}
    if ev[1] == "ConsoleNotification" and ev[2] == "Started" then
      -- exit this loop.
      break
    elseif ev[1] == "timer" and ev[2] == timeOut then
      tell("Console failed to start after two seconds.")
    end
  end
end

local function edit(id)
  local dat = runner.getConsole(tonumber(id))
  if type(dat) == "table" then
    dat.name = vars.flags['n'] or dat.name
    dat.print = vars.flags['o'] or dat.print
    dat.prefix = vars.flags['p'] or dat.prefix
    tell("Updated console with ID " .. tostring(dat.ID))
  else
    tell("No configuration data for a console with that ID.")
  end
end

local function get(id)
  local dat = runner.getConsole(id)
  if type(dat) == "table" then
    tell("Configuration data for console " .. tostring(dat.ID) .. ':')
    tell("Name [-n]: " .. tostring(dat.name or "Not set."))
    tell("Print-To-Chat [-o]: " .. tostring(dat.print or "false") .. '.')
    tell("Prefix [-p]: '" .. tostring(dat.prefix) .. "'")
  else
    tell("No configuration data for a console with that ID.")
  end
end

local function stop(id)
  local dat = runner.getConsole(id)
  if type(dat) == "table" then
    os.queueEvent("ConsoleStop", id)
  else
    tell("No console with that ID.")
  end
end

function funcs.go(modules, vars)
  local interactor = modules["Core.Interaction.PlayerInteraction"]
  tell = interactor.tell

  local com = vars[2]

  if com == "start" then
    start(vars.flags)
  elseif com == "edit" then
    edit(tonumber(vars[3]))
  elseif com == "get" then
    get(tonumber(vars[3]))
  elseif com == "list" then

  elseif com == "stop" then
    stop(tonumber(vars[3]))
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
    "  console get <id>",
    "    Prints configuration data to chat for a console.",
    "",
    "Flags:",
    "  n <name>: set the name of the virtual console to 'name'",
    "  f: used in 'console stop'.  Immediately stops program, instead of "
              .. "sending a terminate event, then stopping.",
    "  o: Disables output to chat for this console.",
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

  runner.setup(data)
  return true, runner.go
end

return funcs
