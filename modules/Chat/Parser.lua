--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/Chat/Parser.lua

This module controls parsing chat data.
]]

local funcs = {}

function funcs.parse(str)
  local dat = {}
  for word in str:gmatch("%S+") do
    dat[#dat+1] = word
  end
  return dat
end

function funcs.help()
  return false
end

function funcs.init(data)
  return true
end

return funcs
