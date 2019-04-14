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



local fe
if isRunningViaGit then
  fe = fileSystem.betterFind("FatErrors.lua", "", false, {"/Modu","/rom"})
  -- ignore the /Modu folder
else
  fe = fileSystem.betterFind("FatErrors.lua")
end
if #fe == 1 then
  fe = fe[1]
  fe = dofile(fe)
elseif #fe > 1 then
  error("Multiple copies of FatErrors.lua exist!")
else
  error("FatErrors.lua does not exist anywhere!")
end

local bassert = fe.bassert
local er = fe.er
fe = nil

---------------------END: Initialization---------------------
