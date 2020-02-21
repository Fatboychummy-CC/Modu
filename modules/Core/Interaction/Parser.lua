--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/Core/Interaction/Parser.lua

This module controls parsing chat data.
]]

local funcs = {}
local pattern = ""

function funcs.parse(str)
  local dat = {
    flags = {},
    strs = {}
  }
  local dats = {}

  local b = false

  if str:match(pattern) and str:match("\"") and not str:match("\".-\"") then
    return {"echo", "Unfinished string"}
  end

  local function combine(strg)
    local dats = {}
    local f = false
    for stri in strg:gmatch("\".-\"") do
      print(stri)
      local loc1, loc2 = strg:find(stri, 1, true)   -- str = "the big \"test\" yes"
      dats[#dats + 1] = strg:sub(1, loc1 - 1)  -- dat1 = "the big "
      dats[#dats + 1] = strg:sub(loc1, loc2)   -- dat2 = "\"test\""
      strg = strg:sub(loc2 + 1)                 -- str = " yes"
                                              -- then loop again to check for more
                                              -- strings.
      if strg:match("\"") and not strg:match("\".-\"") then
        return false, {"echo", "Unfinished string"}
        -- yes this is double here,
        -- it needs to be checked before the loop and during.
      end
      f = true
    end
    if not f then
      dats[1] = strg
    else
      dats[#dats + 1] = strg
    end
    return true, dats
  end

  b, dats = combine(str)
  if not b then
    return dats
  end

  if dats[1]:match(pattern) then
    for i = 1, #dats do
      if dats[i]:match("^\"") then  -- if the start of the string is a quote...
        dat[#dat + 1] = dats[i]:match("\"(.+)\"")  -- clone, but without quotes
        dat.strs[#dat.strs + 1] = #dat
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
      local ls = {}
      for letter in flags:gmatch(".") do
        ls[#ls + 1] = letter
        dat.flags[letter] = true  -- add each letter to the flags list
      end
      dat.flags[ls[#ls]] = dat[i + 1] or true

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
