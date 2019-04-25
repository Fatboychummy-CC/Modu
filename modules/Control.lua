--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/Control.lua

This module is essentially the "main" function in the program.
]]

local funcs = {}

function funcs.go(modules)
  if type(modules) ~= "table" then
    error("Bad argument (expected table, got " .. type(modules) .. ").", 2)
  end

end

function funcs.err(err)
  -- none of this will work.
  pcall(modules.Chat.tell, "------------------------------")
  pcall(modules.Chat.tell, "Modu has stopped unexpectedly.")
  pcall(modules.Chat.tell, err)
  pcall(modules.Chat.tell, "Please report this to Fatboychummy#4287 on Discord")
  pcall(modules.Chat.tell, "------------------------------")
end

function funcs.init(data)
  return true
end

return funcs
