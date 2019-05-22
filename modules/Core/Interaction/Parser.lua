--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/Core/Interaction/Parser.lua

This module controls parsing chat data.
]]

local funcs = {}
local pattern = ""

function funcs.parse(str)
  local dat = {
    flags = {}
  }
  local dats = {}

  local b = false

  if str:match(pattern) and str:match("\"") and not str:match("\".-\"") then
    return {"echo", "Unfinished string"}
  end

  for stri in str:gmatch("\".-\"") do
    local loc1, loc2 = str:find(stri, 1, true)   -- str = "the big \"test\" yes"
    dats[#dats + 1] = str:sub(1, loc1 - 1)  -- dat1 = "the big "
    dats[#dats + 1] = str:sub(loc1, loc2)   -- dat2 = "\"test\""
    str = str:sub(loc2 + 1)                 -- str = " yes"
                                            -- then loop again to check for more
                                            -- strings.
    if str:match("\"") and not str:match("\".-\"") then
      return {"echo", "Unfinished string"}
      -- yes this is double here,
      -- it needs to be checked before the loop and during.
    end
    b = true
  end

  if not b then
    -- if we found a string, then dats will be populated already.
    -- if the flag, b, is false, that means dats is not populated.
    dats[1] = str
  else
    dats[#dats + 1] = str
  end

  if dats[1]:match(pattern) then
    for i = 1, #dats do
      if dats[i]:match("^\"") then  -- if the start of the string is a quote...
        dat[#dat + 1] = dats[i]:match("\"(.+)\"")  -- clone, but without quotes
      else
        for word in dats[i]:gmatch("%S+") do  --%S+ all non-space characters
          dat[#dat + 1] = word:match(pattern .. "(.+)") or word
            -- if this is the first word, remove the pattern, else just keep the
            -- word itself.
        end
      end
    end
  else
    return false
    -- otherwise just return false for nothing.
  end

  for i = 1, #dat do
    local flags = dat[i]:match("^%-(.+)") -- detects "-rf" - like command flags
    if type(flags) == "string" then
      for letter in flags:gmatch(".") do
        dat.flags[letter] = true  -- add each letter to the flags list
      end
      dat[i] = ";;REMOVE" -- mark the flag for removal.
                          -- if index is removed now, it messes up the for loop.
    end
  end

  for i = #dat, 1, -1 do
    if dat[i] and dat[i]:match(";;REMOVE") then
      table.remove(dat, i) -- if it is flagged for deletion, delete it.
    end
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
