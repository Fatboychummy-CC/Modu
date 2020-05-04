--[[FATFILE
1
https://raw.githubusercontent.com/Fatboychummy-CC/Modu/master/modules/Item/ItemModules/Manipulators.lua

This module controls manipulator stuff
]]

local funcs = {}

function funcs.getFunctionFromManip(func)
  local manips = {peripheral.find("manipulator")}
  if #manips > 0 then
    for i = 1, #manips do
      local manip = manips[i]
      for k, v in pairs(manip) do
        if k == func then
          return v
        end
      end
    end
  else
    error("No manipulators connected.")
  end
  return false
end

function funcs.getFunctionsFromManip(funcs)
  local all = {}
  for i = 1, #funcs do
    all[i] = funcs.getFunctionFromManip(funcs[i])
  end
  return all
end

return funcs
