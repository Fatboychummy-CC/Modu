--[[FATFILE
1
https://raw.githubusercontent.com/Fatboychummy-CC/Modu/master/modules/Core/Interaction/PlayerInteraction.lua

This module controls how the machine speaks to the player
]]

local funcs = {}
local listenFor = "chat_message"
local player = ""
local manip = false
local pattern

function funcs.tell(info)
  if type(info) ~= "string" then
    error("Expected string, got " .. type(info), 2)
  end

  local strings = {}

  -- populate strings table, by splitting by control characters.
  local flg = true
  for str in info:gmatch("%C+") do
    flg = false
    strings[#strings + 1] = str
  end
  -- if no control characters, set strings[1] to the string inputted
  if flg then
    strings[1] = info
  end

  if #strings[1] > 100 then
    -- if the length of the string is too long, split it into multiple strings
    for i = 1, #strings[1] / 100 + 1 do
      strings[i + 1] = strings[1]:sub(i * 100 - 99, i * 100)
    end
    table.remove(strings, 1)
  end

  -- tell the player each string
  for i = 1, #strings do
    manip.tell(strings[i])
    sleep(0)
  end
end

function funcs.say(info)
  if type(info) ~= "string" then
    error("Expected string, got " .. type(info), 2)
  end

  local strings = {}

  -- populate strings table, by splitting by control characters.
  local flg = true
  for str in info:gmatch("%C+") do
    flg = false
    strings[#strings + 1] = str
  end
  -- if no control characters, set strings[1] to the string inputted
  if flg then
    strings[1] = info
  end

  if #strings[1] > 100 then
    -- if the length of the string is too long, split it into multiple strings
    for i = 1, #strings[1] / 100 + 1 do
      strings[i + 1] = strings[1]:sub(i * 100 - 99, i * 100)
    end
    table.remove(strings, 1)
  end

  -- tell the player each string
  for i = 1, #strings do
    manip.say(strings[i])
    sleep(0)
  end
end

function funcs.cap()
  manip.capture(pattern)
end

function funcs.uncap()
  manip.uncapture(pattern)
end

function funcs.help()
  return false
end

function funcs.init(data)
  data = data or false
  if not data then
    return false, "No data given to init!"
  end
  -- handle the owner
  player = data.owner or false
  if not player then
    return false, "Owner not specified (edit InitData and change or add variable 'owner'!)."
  end


  -- handle the manipulator
  manip = {peripheral.find("manipulator")}

  if #manip > 1 then
    return false, "Too many manipulators connected to the network. This program currently will not support multiple manipulators."
  elseif #manip == 0 then
    return false, "No manipulator (or manipulator has no modules)!"
  else
    manip = manip[1]
  end

  -- handle the manipulator modules
  local modules = manip.listModules()
  if data.listen == "chat_capture" then
    pattern = data.pattern
    funcs.cap()
  end

  for i = 1, #modules do
    if modules[i] == "plethora:chat"
      or modules[i] == "plethora:chat_creative" then
      return true
    end
  end

  return false, "No chat recorder present."
end


return funcs
