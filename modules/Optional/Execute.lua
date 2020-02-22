--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/master/modules/Optional/Execute.lua

This module executes lua code directly.
]]

local funcs = {}

function dCopy(x)
  local ret = {}
  for k, v in pairs(x) do
    if type(v) == "table" then
      ret[k] = dCopy(v)
    else
      ret[k] = v
    end
  end
  return ret
end

function funcs.go(modules, vars)
  local interactor = modules["Core.Interaction.PlayerInteraction"]

  table.remove(vars, 1)
  for i = 1, #vars.strs do
    vars[vars.strs[i] - 1] = "\"" .. vars[vars.strs[i] - 1] .. "\""
  end

  local ok, err = pcall(load, "local say, uncap, cap = ...  " .. table.concat(vars, " "))

  if not ok then
    interactor.tell("Failed to load inputs due to:")
    interactor.tell(tostring(err))
    return
  end

  interactor.tell("Executing...")
  local out = {pcall(err, interactor.say, interactor.uncap, interactor.cap)}
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
  local out2 = dCopy(out)
  checkFuncs(out2)

  interactor.tell("RETURN:")
  interactor.tell("value -> " .. textutils.serialize(out2))
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
