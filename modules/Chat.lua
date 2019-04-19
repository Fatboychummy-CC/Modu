--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/Chat.lua
]]

local funcs = {}
local listenFor = "chat_message"
local player = ""

function funcs.listen()
  local manip = {peripheral.find("manipulator")}

  if #manip > 1 then
    error("Too many manipulators connected to the network.\nThis program currently will not support multiple manipulators.")
  elseif #manip == 0 then
    error("No manipulator (or manipulator has no modules)!")
  else
    print("Single manipulator.")
    manip = manip[1]
  end

  local modules = manip.listModules()
  local chatPresent = false
  for i = 1, #modules do
    if modules[i] == "plethora:chat"
      or modules[i] == "plethora:chat_creative" then

      print("Chat recorder is available.")
      chatPresent = true
    end
  end
  if not chatPresent then
    error("No chat recorder present.")
  end

  while true do
    local ev = {os.pullEvent(listenFor)}
    if ev[2] == player then
      return ev[3]
    end
  end
end

function funcs.init(owner)
  player = owner or false
  if player then
    return true
  end
  return false, "Owner not specified (edit Modu and change the owner!)."
end


return funcs
