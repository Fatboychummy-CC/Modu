--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/Chat/Echo.lua

This module repeats what you say
]]

local funcs = {}

function funcs.go(modules, vars)
  local interactor = modules["Chat.PlayerInteraction"]
  table.remove(vars, 1)
  if #vars == 0 then
    interactor.tell("Ping")
  else
    vars = table.concat(vars, " ")
    interactor.tell(vars)
  end
end

function funcs.help()
  return {
    "Usage:",
    "  echo [message]",
    "",
    "  echo some_message",
    "    tells the user, \"some_message\".",
    "",
    "  Using without any message will just send a \"ping\" to the user."
  }
end

function funcs.getInstant()
  return "echo"
end

function funcs.getInfo()
  return "Echoes a statement back to you."
end

function funcs.init(data)
  return true
end

return funcs
