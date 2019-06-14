--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/Chat/Echo.lua

This module repeats what you say
]]

local funcs = {}

function funcs.go(modules, vars)
  local interactor = modules["Core.Interaction.PlayerInteraction"]
  table.remove(vars, 1)
  if #vars == 0 then
    interactor.tell("Ping")
  else
    if vars.flags['s'] then
      local str = "\""
      for i = 1, #vars do
        if i == 1 then
          str = str .. vars[i] .. "\""
        else
          str = str .. " \"" .. vars[i] .. "\""
        end
      end
      interactor.tell(str)
    else
      vars = table.concat(vars, " ")
      interactor.tell(vars)
    end
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
    "  Using without any message will just send a \"ping\" to the user.",
    "",
    "Flags:",
    "  s: put string quotes around each split in the string (for debug)."
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
