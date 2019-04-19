--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/Modu.lua
]]

--
---------------------START: CHANGEABLE---------------------
local isRunningViaGit = true
---------------------END: CHANGEABLE---------------------







---------------------START: Initialization---------------------

if not fs.exists("/FatFileSystem.lua") then
  error("FatFileSystem.lua was not found in the root directory.", -1)
end

local fileSystem = dofile("/FatFileSystem.lua")
-- Check/get the fat file system.
-- May be removed

local inv = require("modules.Inventory")
local chat = require("modules.Chat")


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
