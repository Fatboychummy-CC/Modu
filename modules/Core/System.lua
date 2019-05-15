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

  local function doUpdate() -- function for return control. (ie: goto end)

    local function grabFile(fileName, url)
      -- Check if the file exists, and download it if not.
      if not fs.exists(tostring(fileName) .. ".lua")
         and not fs.exists(fileName) then

        interactor.tell(tostring(fileName) .. " was not found.  Attempting to "
                        .. "download from " .. tostring(url))

        local dat = http.get(url)

        if dat then
          -- if the server sent a response
          local f = io.open("/" .. tostring(fileName) .. ".lua", 'w')
          if f then
            -- if the file is opened
            f:write(dat.readAll()):close()
            dat.close()
            interactor.tell("")
            interactor.tell(tostring(fileName) .. " successfully downloaded.")
          else
            -- if the file failed to open.
            dat.close()
            error("Failed to open " .. tostring(fileName) .. " for writing")
          end
        else
          -- if no response
          interactor.tell("Failed to open URL " .. tostring(url))
          interactor.tell("Cannot update.")
          return
        end
      end
    end

    grabFile("FatFileUpdateHandler", "https://raw.githubusercontent.com/"
                                      .. "fatboychummy/CCmedia/master/"
                                      .. "helpfulthings/"
                                      .. "FatFileUpdateHandler.lua")
    grabFile("FatFileSystem", "https://raw.githubusercontent.com/fatboychummy/"
                              .. "CCmedia/master/FatFileSystem.lua")

    -- Update.
      -- Require the files, check for errors.
    local ffs = require("/FatFileSystem")
    local ffuh = require("/FatFileUpdateHandler")
  end

  if vars[2] == "update" then
    doUpdate()
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
  elseif not vars[2] or vars[2] ~= "update" then
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
