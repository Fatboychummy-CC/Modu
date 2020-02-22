--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/master/modules/Core/Interaction/Listener.lua

This module controls the "listening"
]]

local funcs = {}
local listenFor = false
local player = false
local pattern = false

function funcs.listen()
  while true do
    local ev = {os.pullEvent(listenFor)}
    if listenFor == "chat_capture" then
      if ev[4] == player and ev[3] == pattern then
        return ev[2]
      end
    elseif listenFor == "chat_message" then
      if ev[2] == player then
        return ev[3]
      end
    end
  end
end

function funcs.help()
  return false
end

function funcs.init(data)
  if not data then
    return false, "No data!"
  end

  pattern = data.pattern or false
  if not pattern then
    return false, "Pattern not specified (edit InitData and change or add variable 'pattern'!)"
  end
  
  listenFor = data.listen or false
  if not listenFor then
    return false, "Listener not specified (edit InitData and change or add variable 'listen'!)"
  end

  player = data.owner or false
  if not player then
    return false, "Owner not specified (edit InitData and change or add variable 'owner'!)."
  end

  return true
end


return funcs
