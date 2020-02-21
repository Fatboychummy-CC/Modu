--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/master/modules/Chat/Clear.lua

This module is the main module
]]

local funcs = {}

function funcs.go(modules, vars)
  local interactor = modules["Core.Interaction.PlayerInteraction"]

  for i = 1, 32 do
    interactor.tell("")
  end
end

function funcs.help()
  return {
    "Usage:",
    "  clear",
    "",
    "  clear",
    "    spams the chat full of empty messages to \"clear\" the chat"
  }
end

function funcs.getInstant()
  return "clear"
end

function funcs.getInfo()
  return "Sends many blank messages which \"clear\" the chat."
end

function funcs.init(data)
  return true
end

return funcs
