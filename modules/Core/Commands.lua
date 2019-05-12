--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/Core/Commands.lua

This module is the main module
]]

local funcs = {}

function funcs.go(modules, vars)
  local interactor = modules["Core.Interaction.PlayerInteraction"]

  local coms = {}
  local infs = {}

  for k, v in pairs(modules) do
    if type(v) == "table" and type(v.getInstant) == "function" then
      coms[#coms + 1] = v.getInstant()
      if type(v.getInfo) == "function" then
        infs[#infs + 1] = v.getInfo()
      else
        infs[#infs + 1] = "No information available."
      end
    end
  end

  interactor.tell("Command, one of the following:")
  for i = 1, #coms do
    interactor.tell("  " .. tostring(coms[i]))
    interactor.tell("    " .. tostring(infs[i]))
  end
end

function funcs.help()
  return {
    "Usage:",
    "  commands",
    "",
    "  commands",
    "    Returns all available commands"
  }
end

function funcs.getInstant()
  return "commands"
end

function funcs.getInfo()
  return "Returns all available commands"
end

function funcs.init(data)
  return true
end

return funcs
