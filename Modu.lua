--[[FATFILE
3
https://raw.githubusercontent.com/fatboychummy/Modu/Master/Modu.lua
]]

--
---------------------START: CHANGEABLE---------------------
local owner = "fatmanchummy" -- Your MC name
---------------------END: CHANGEABLE---------------------







---------------------START: Initialization---------------------

if not fs.exists("/FatFileSystem.lua") then
  error("FatFileSystem.lua was not found in the root directory.", -1)
end

local fileSystem = dofile("/FatFileSystem.lua")
-- Check/get the fat file system.
-- May be removed

local modules = {}
modules.Inventory = require("modules.Inventory")
modules.Chat = require("modules.Chat")



for k, v in pairs(modules) do
  local ok, err = v.init(owner)
  if not ok then
    error(k .. ":" .. err, -1)
  end
end
---------------------END: Initialization---------------------

---------------------START: Data Functions---------------------

-- Deep copy.  Returns a clone of the table inputted.
local function dCopy(tbl)
  local copy = {}

  for k, v in pairs(tbl) do
    if type(v) == "table" then
      copy[k] = dCopy(v)
    else
      copy[k] = v
    end
  end

  return copy
end

local function blblb()
  print("blblb")
end
---------------------END: Data Functions---------------------
