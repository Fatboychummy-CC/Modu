--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/master/modules/Core/System.lua

This module controls direct access to the system (mostly just rebooting/etc)
]]

-- TODO: finish conversion to flags.

local funcs = {}

local interactor = require("modules.Core.Interaction.PlayerInteraction")
local util = require("modules.Util")
local tell = interactor.tell

local listen = false
local player = false

local function doUpdate(modules, force, mute) -- function for return control. (ie: goto end)
  -- TODO: Update
  -- TODO: Get user input from new functions in PlayerInteraction
  local fh = io.open("files", 'r')
  if fh then
    local dat = fh:read("*a")
    fh:close()
    fh = nil

    local lines = {n = 0}
    for line in io.lines("files") do
      lines.n = lines.n + 1
      lines[n] = line
    end

    local lines2 = {n = 0}
    local function is(x)
      lines2.n = lines2.n + 1
      lines2[n] = x
    end
    for i = 1, lines.n do
      local out = util.split(lines[i], ",")
      is(out[1])
      is(out[2])
    end
    for k, v in pairs(lines2) do
      tell(tostring(k) .. " " .. tostring(v))
    end
  else
    error("Updater: Failed to open file-list for reading.", 0)
  end
end -------------------------------------end doupdate

function funcs.go(modules, vars)
    -- Require the files, check for errors.
  local ffs
  local ffuh
  local m = vars.flags['m']
  local f = vars.flags['f']

  if vars[2] == "update" then
    doUpdate(modules, vars.flags['f'], vars.flags['m'])
  end

  if vars.flags['s'] then
    tell("Shutting down...")
    os.shutdown()
  elseif vars.flags['r'] then
    tell("Rebooting...")
    os.reboot()
  elseif vars.flags['h'] then
    error("Modu halted.", -1)
  elseif vars.flags['e'] then
    error("Initializing Limp Mode.")
  elseif not vars[2] or vars[2] ~= "update" then
    tell("Unknown command: " .. tostring(vars[2]))
  end
end

function funcs.help()
  return {
    "Usage:",
    "  system -<r/s/h/e>",
    "  system <update> [-m/f]",
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
    "The above flags can be used in conjunction with any of the below commands.",
    "The flags will be executed after running the command.",
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
    "  f: Force. Used for updates to update without confirmation.",
    "  m: Mute output, used with f."
  }
end

function funcs.getInstant()
  return "system"
end

function funcs.getInfo()
  return "Gives the player the ability to reboot/shutdown/stop Modu."
end

function funcs.init(data)
  if type(data.listen) ~= "string" then
    return false, "Missing init data value 'listen'"
  end
  listen = data.listen
  if type(data.owner) ~= "string" then
    return false, "Missing init data value 'owner'"
  end
  player = data.owner
  return true
end

return funcs
