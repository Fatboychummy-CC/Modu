--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/Chat/Parser.lua

This module controls parsing chat data.
]]

local funcs = {}
local pattern = ""

function funcs.parse(str)
  local dat = {}
  if str:match(pattern) then
    for word in str:gmatch("%S+") do
      dat[#dat+1] = word:match(pattern .. "(.+)") or word
    end
  else
    return false
  end
  return dat
end

function funcs.help()
  return false
end

function funcs.init(data)
  if data.pattern then
    if type(data.pattern) == "string" then
      pattern = data.pattern
      return true
    else
      return false, "InitData: pattern: expected string, got "
                  .. type(data.pattern)
    end
  else
    return false, "Pattern not specified (edit InitData and change or add variable 'pattern'!)."
  end
  return false, "Unknown error!"
end

return funcs
