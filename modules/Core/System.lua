--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/Core/System.lua

This module is the main module
]]

-- TODO: finish conversion to flags.

local funcs = {}

function funcs.go(modules, vars)
  local interactor = modules["Core.Interaction.PlayerInteraction"]

  for i = 1, #vars do
    vars[i] = vars[i]:lower()
  end

  if vars[2] == "update" then
    error("Not yet implemented.", -1)

    local ok, updater = pcall(require, "/FatFileSystem")
    if not ok then
      interactor.tell("FatFileSystem not found at the root!")
    end
  end

  if vars.flags['s'] then
    interactor.tell("Shutting down...")
    os.shutdown()
  elseif vars.flags['r'] then
    interactor.tell("Rebooting...")
    os.reboot()
  elseif vars.flags['h'] then
    error("Modu halted.", -1)
  elseif vars.flags['e'] then
    error("Initializing Limp Mode.")
  else
    interactor.tell("Unknown command: " .. vars[2])
  end
end

function funcs.help()
  return {
    "Usage:",
    "  system -<r/s/h/e>",
    "  system <update>",
    ";;verbose",
    "  system -s",
    "    Shuts down the computer (And thus, Modu stops).",
    "",
    "  system -r",
    "    Reboots the computer (Modu will be unavailable for a few moments).",
    "",
    "  system -h",
    "    Stops Modu by forcing an error (Skipping limp mode).",
    "",
    "  system -e",
    "    Stops Modu by forcing an error (Enters limp mode).",
    "",
    "  system update",
    "    Checks for updates for each individual file.",
    "    Requires FatFileSystem at root, and FatFileUpdateHandler.",
    "",
    "Note that if Modu is not set as a startup program, running "
    .. "\"system restart\" will not run Modu again.",
    "",
    "Flags:",
    "  s: Shutdown.",
    "  r: Reboot.",
    "  h: Halt, skipping limp mode.",
    "  e: Halt, entering limp mode.",
    "The above flags can be used in conjunction with the \"update\" command, "
      .. "and will be executed AFTER the update is complete."
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
