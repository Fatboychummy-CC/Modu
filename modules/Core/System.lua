--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/Core/System.lua

This module is the main module
]]

local funcs = {}

function funcs.go(modules, vars)
  local interactor = modules["Core.Interaction.PlayerInteraction"]

  for i = 1, #vars do
    vars[i] = vars[i]:lower()
  end

  if vars[2] == "shutdown" or vars[2] == "poweroff" then
    interactor.tell("Shutting down...")
    os.shutdown()
  elseif vars[2] == "restart" or vars[2] == "reboot" then
    interactor.tell("Rebooting...")
    os.reboot()
  elseif vars[2] == "halt" or vars[2] == "stop" then
    error("Modu halted.", -1)
  else
    interactor.tell("Unknown command: " .. vars[2])
  end
end

function funcs.help()
  return {
    "Usage:",
    "  system <shutdown/poweroff>",
    "  system <restart/reboot>",
    "  system <halt/stop>",
    "",
    "  system shutdown",
    "    Shuts down the computer (And thus, Modu stops).",
    "",
    "  system restart",
    "    Reboots the computer (Modu will be unavailable for a few moments).",
    "",
    "  system halt",
    "    Stops Modu by forcing an error.",
    "",
    "Note that if Modu is not set as a startup program, running "
    .. "\"system restart\" will not run Modu again."
  }
end

function funcs.getInstant()
  return "system"
end

function funcs.getInfo()
  return "Gives the player the ability to reboot/shutdown/stop Modu."
end

function funcs.init(data)
  return true
end

return funcs
