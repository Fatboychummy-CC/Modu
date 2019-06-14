--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/data/InitData.lua

This module controls what data is passed to each of the `init` functions
]]

local data = {
  owner = "YOUR_MC_NAME",   -- who owns this device?
  listen = "chat_message",  -- what event is the parser listening for?
  pattern = "^;",           -- what should the pattern that modu listens for be?
  cacheSaveLocation = "data/Cache.fd"
                            -- where should we save the cache?
}

return data
