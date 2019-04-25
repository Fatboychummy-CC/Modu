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
  for k, v in pairs(modules) do
    modules[k:match("%.(.+)")] = modules[k]
    print(k:match("%.(.+)"))
    modules[k] = nil
  end

  -- set the local values for interaction between funcs
  mods.interactor = modules["Chat.PlayerInteraction"]
  mods.parser = modules["Chat.Parser"]
  mods.listener = modules["Chat.Listener"]

  -- set this chunk's stuff
  local interactor = mods.interactor
  local parser = mods.parser
  local listener = mods.listener

  interactor.tell("Ready.")
end

function funcs.err(err)
  pcall(mods.interactor.tell, "------------------------------")
  pcall(mods.interactor.tell, "Modu has stopped unexpectedly.")
  pcall(mods.interactor.tell, err)
  pcall(mods.interactor.tell, "Please report this to Fatboychummy#4287 on Discord")
  pcall(mods.interactor.tell, "------------------------------")
end

function funcs.init(data)
  return true
end

return funcs
