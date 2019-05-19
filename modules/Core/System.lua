--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/Core/System.lua

This module is the main module
]]

-- TODO: finish conversion to flags.

local funcs = {}

local listen = false
local player = false

function funcs.go(modules, vars)
  local interactor = modules["Core.Interaction.PlayerInteraction"]
  local tell = interactor.tell

  for i = 1, #vars do
    vars[i] = vars[i]:lower()
  end

    -- Require the files, check for errors.
  local ffs
  local ffuh
  local m = vars.flags['m']
  local f = vars.flags['f']

  local function doUpdate() -- function for return control. (ie: goto end)

    local function grabFile(fileName, url)
      -- Check if the file exists, and download it if not.
      if not fs.exists(tostring(fileName) .. ".lua")
         and not fs.exists(fileName) then

        if not m then
          tell(tostring(fileName) .. " was not found.  Attempting to "
                          .. "download from " .. tostring(url))
        end

        local dat = http.get(url)

        if dat then
          -- if the server sent a response
          local f = io.open("/" .. tostring(fileName) .. ".lua", 'w')
          if f then
            -- if the file is opened
            f:write(dat.readAll()):close()
            dat.close()
            if not m then
              tell("")
              tell(tostring(fileName) .. " successfully downloaded.")
            end
            if m then
              tell("A required file was not present, downloaded it.")
            end
          else
            -- if the file failed to open.
            dat.close()
            error("Failed to open " .. tostring(fileName) .. " for writing")
          end
        else
          -- if no response
          tell("Failed to open URL " .. tostring(url))
          tell("Cannot update.")
          return
        end
      end
    end

    local function listenFor(things, tm)
      tm = tm or 10

      for i = 1, #things do
        tell(tostring(i) .. ": " .. tostring(things[i]))
      end
      tell("Say the number in chat.  After " .. tostring(tm)
            .. " seconds the update will be cancelled.")

      local tmr = os.startTimer(1)
      while tm > 0 do
        local ev = {os.pullEvent()}
        local event = ev[1]
        if event == "timer" then
          if ev[2] == tmr then
            tm = tm - 1
            tmr = os.startTimer(1)
          end
        elseif event == listen and ev[2] == player then
          local n = tonumber(ev[3])
          if type(n) == "number" then
            if n >= 1 and n <= #things and n % 1 == 0 then
              return true, n
            end
          end
        end
      end
      return false
    end

    local function updateFiles(files)
      local g = 0
      local b = 0
      for i = 1, #files do
        if not m then
          tell("Updating " .. tostring(files[i].file))
        end
        local ok, info = ffuh.updateFile(files[i])
        if ok then
          g = g + 1
        else
          b = b + 1
        end
        if not m then
          tell(tostring(files[i].file) .. ": " .. tostring(info))
        end
        if b > 0 then
          tell(b == 1 and "Failed to update 1 file."
                or "Failed to update " .. tostring(b) .. " files.")
        end
        if g > 0 then
          tell(g == 1 and "Updated 1 file."
                or "Updated " .. tostring(b) .. " files.")
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
    ffs = require("/FatFileSystem")
    ffuh = require("/FatFileUpdateHandler")
    tell("Reading files...")
    local fats = ffs.getFATS()

    tell("Checking for updates...")
    local updates = {}

    for i = 1, #fats do
      -- vars.flags[f] == true then force update without questions
      if not m then
        tell("Checking file " .. tostring(fats[i].file))
      end
      local rq, rsn = ffuh.updateCheck(fats[i])
      if rq then
        updates[#updates + 1] = fats[i]
      else
        if not m then
          tell(tostring(fats[i].file) .. ": " .. tostring(rsn))
        end
      end
    end

    -- actually update
    if #updates > 0 and not f then
      tell("--------------------")
      tell(#updates == 1 and tostring(#updates) .. " update found."
           or tostring(#updates) .. " updates found.")

      local heard, result = listenFor({
          "Update all.",
          "Choose which updates to install.",
          "Exit."
        }, 15)
      if heard then
        if result == 1 then -- update all
          updateFiles(updates)
        elseif result == 2 then -- choose updates.
          while true do
            local d = {}
            for i = 1, #updates do
              d[i] = tostring(updates[i].file)
            end
            d[#d + 1] = "Exit."
            local heard, result = listenFor(d, 15)
            if heard then
              tell(tostring(result))
              if result == #updates + 1 then
                tell("Update cancelled.")
                break
              end
            else
              tell("Update cancelled.")
              break
            end
          end
        elseif result == 3 then
          tell("Update cancelled.")
        end
      else
        tell("Update cancelled.")
      end
    elseif f then
      updateFiles(updates)
    else
      tell("No updates found.")
    end
  end

  if vars[2] == "update" then
    doUpdate()
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
    tell("Unknown command: " .. vars[2])
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
    "  m: Mute output (not fully muted, just less spammy)."
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
