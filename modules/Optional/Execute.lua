--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/master/modules/Optional/Execute.lua

This module executes lua code directly.
]]

local funcs = {}

function funcs.go(modules, vars)
  local interactor = modules["Core.Interaction.PlayerInteraction"]

  table.remove(vars, 1)
  for i = 1, #vars.strs do
    vars[vars.strs[i] - 1] = "\"" .. vars[vars.strs[i] - 1] .. "\""
  end

  interactor.tell(tostring(table.concat(vars, " ")))

  local ok, err = pcall(load, table.concat(vars, " "))

  if not ok then
    interactor.tell("Failed to load inputs due to:")
    interactor.tell(tostring(err))
    return
  end

  interactor.tell(type(err))
  interactor.tell("Executing.")
  local ok2, err2 = pcall(err)
  if not ok2 then
    interactor.tell("Runtime error in chunk:")
    interactor.tell(tostring(err2))
    return
  end
  interactor.tell("-----RETURN:")
  interactor.tell(tostring(err2))
  interactor.tell("Type: " .. type(err2))
end

function funcs.help()
  return {
    "Usage:",
    "  execute <lua code>",
    "",
    "  execute return 32",
    "    Executes the code inserted, then displays the return value",
    "    In this case, it will output 32."
  }
end

function funcs.getInstant()
  return "execute"
end

function funcs.getInfo()
  return "Executes lua code."
end

function funcs.init(data)
  return true
end

return funcs
