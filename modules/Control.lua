--[[FATFILE
2
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/Control.lua

This module is essentially the "main" function in the program.
]]

local funcs = {}

local mods = {}

function funcs.go(modules)
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

  mod = niceModules()

  -- set the local values for interaction between funcs
  mods.interactor = mod["Chat.PlayerInteraction"]
  mods.parser = mod["Chat.Parser"]
  mods.listener = mod["Chat.Listener"]
  mods.help = mod["Chat.Help"]

  -- set this chunk's stuff
  local interactor = mods.interactor
  local parse = mods.parser.parse
  local listen = mods.listener.listen
  local help = mods.help.getHelp

  interactor.tell("Modu is Ready.")

  while true do
    local dat = parse(listen())
    print(textutils.serialize(dat))
    local command = dat[1]
    print(command)
    if command == "help" then
      help(mod, dat)
    elseif  then
    end
  end
  error("oh no")
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
  return true
end

return funcs
