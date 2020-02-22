--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/master/modules/Control.lua

This module is essentially the "main" function in the program.
]]

local funcs = {}

local mods = {}

local limpmods = {}

local player = false
local listenev = false

function funcs.go(modules, limp)
  print("The controller is now running.")
  -- error check
  if type(modules) ~= "table" then
    error("Bad argument (expected table, got " .. type(modules) .. ").", 2)
  end

  -- change the names of the modules to be shorter
  local function niceModules()
    local mod = {}
    for k, v in pairs(modules) do
      mod[k:match("%.(.+)")] = modules[k]
      mod[k] = nil
    end
    return mod
  end

  local mod = niceModules()

  -- set the local values for interaction between funcs
  mods.interactor = mod["Core.Interaction.PlayerInteraction"]
  mods.parser = mod["Core.Interaction.Parser"]
  mods.listener = mod["Core.Interaction.Listener"]

  -- set this chunk's stuff
  local interactor = mods.interactor
  local parse = mods.parser.parse
  local listen = mods.listener.listen
  local instants = {}

  local function terminator()
    while true do
      local ev = {os.pullEvent(listenev)}
      if listenev == "chat_message" then
        local _, p, m = table.unpack(ev)
        if p == player then
          if string.lower(m) == "terminate" then
            interactor.tell("Terminated.")
            return
          end
        end
      elseif listenev == "chat_capture" then
        local _, m, c, p = table.unpack(ev)
        if p == player then
          if string.lower(m):find("terminate") then
            interactor.tell("Terminated.")
            return
          end
        end
      end
    end
  end

  for k, v in pairs(mod) do
    if type(v) == "table" and type(v.getInstant) == "function" then
      instants[k] = v.getInstant()
    end
  end

  interactor.tell("Modu is Ready.")
  if limp then
    interactor.tell("##############################")
    interactor.tell("LIMP MODE IS ON!")
    interactor.tell("SOME MODULES ARE UNAVAILABLE")
    interactor.tell("##############################")
  end

  local cnt = 0
  for k, v in pairs(modules) do
    cnt = cnt + 1
  end
  interactor.tell(tostring(cnt) .. " modules have been loaded.")

  while true do
    local dat = parse(listen())
    if dat then
      local command = dat[1]
      print("Executing command: " .. table.concat(dat, " "))
      local r = true
      for k, v in pairs(instants) do
        if command == v then
          local function go()
            mod[k].go(mod, dat)
          end
          parallel.waitForAny(terminator, go)
          r = false
        end
      end
      if r then
        interactor.tell("No command: \"" .. tostring(command) .. "\".")
        interactor.tell("Try \"commands\".")
      end
    end
  end
  error("oh no")
end

function funcs.warn(warn)
  pcall(mods.interactor.tell, warn)
end

function funcs.err(err)
  pcall(mods.interactor.tell, "------------------------------")
  pcall(mods.interactor.tell, "Modu has stopped unexpectedly.")
  pcall(mods.interactor.tell, " ")
  pcall(mods.interactor.tell, err)
  pcall(mods.interactor.tell, " ")
  pcall(mods.interactor.tell, "Please report this to Fatboychummy#4287 on Discord")
  pcall(mods.interactor.tell, "------------------------------")
end

function funcs.terminate()
  pcall(mods.interactor.tell, "------------------------------")
  pcall(mods.interactor.tell, "Modu has been terminated.")
  pcall(mods.interactor.tell, "Have a good day.")
  pcall(mods.interactor.tell, "------------------------------")
end

function funcs.init(data)
  if type(data.listen) ~= "string" then
    return false, "Missing init value, 'listen'"
  end
  listenev  = data.listen

  if type(data.owner) ~= "string" then
    return false, "Missing init value, 'owner'"
  end
  player = data.owner

  return true
end

return funcs
