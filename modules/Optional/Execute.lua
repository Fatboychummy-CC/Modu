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

  local ok, err = pcall(load, "local args = {...} local say = args[1]  " .. table.concat(vars, " "))

  if not ok then
    interactor.tell("Failed to load inputs due to:")
    interactor.tell(tostring(err))
    return
  end

  interactor.tell("Executing...")
  local out = {pcall(err, interactor.say)}
  if not out[1] then
    interactor.tell("Runtime error in chunk:")
    interactor.tell(tostring(out[2]))
    return
  end
  local function checkFuncs(x)
    for k, v in pairs(x) do
      if type(v) == "table" then
        checkFuncs(v)
      end
      if type(v) == "function" then
        x[k] = "FUNCTION"
      end
    end
  end
  table.remove(out, 1)

  checkFuncs(out)

  interactor.tell("RETURN:")
  interactor.tell("value -> " .. textutils.serialize(out))
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
