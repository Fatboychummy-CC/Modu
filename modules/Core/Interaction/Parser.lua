--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/Chat/Parser.lua

This module controls parsing chat data.
]]

local funcs = {}
local pattern = ""

function funcs.parse(str)
  local dat = {}
  local dats = {}

  local b = false

  if str:match(pattern) and str:match("\"") and not str:match("\".-\"") then
    return {"echo", "Unfinished string"}
  end

  for stri in str:gmatch("\".-\"") do
    local loc1, loc2 = str:find(stri)
    dats[#dats + 1] = str:sub(1, loc1 - 1)
    dats[#dats + 1] = str:sub(loc1, loc2)
    str = str:sub(loc2 + 1)
    if str:match("\"") and not str:match("\".-\"") then
      return {"echo", "Unfinished string"}
      -- yes this is double here,
      -- it needs to be checked before the loop and during.
    end
    b = true
  end
  if not b then
    dats[1] = str
  end

  if dats[1]:match(pattern) then
    for i = 1, #dats do
      if dats[i]:match("^\"") then
        dat[#dat + 1] = dats[i]
      else
        for word in dats[i]:gmatch("%S+") do
          dat[#dat + 1] = word:match(pattern .. "(.+)") or word
        end
      end
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