--[[FATFILE
4
https://raw.githubusercontent.com/fatboychummy/Modu/Master/Modu.lua
]]

--
---------------------START: CHANGEABLE---------------------
local owner = nil -- Your MC name
---------------------END: CHANGEABLE---------------------

---------------------START: Initialization---------------------

local modules = {}
local initData = require("data.InitData")
modules.Inventory = require("modules.Inventory")
modules.Chat = require("modules.Chat")
for k, v in pairs(modules) do
  v._initialized = false
end

local function initialize(mod)
  local ok, err = mod.init(initData)
  if not ok then
    return false, err
  end
  mod._initialized = true
  return true
end

-- Always initialize the chat module first.
initialize(modules.Chat)
modules.Chat.tell("Chat module initialized.")

for k, v in pairs(modules) do
  if not v._initialized then
    local ok, err = initialize(v)
    if not ok then
      modules.Chat.tell("Failed to initialize module \'" .. k .. "\' due to: "
              .. err)
      error(k .. ":" .. err, -1)
    end
    modules.Chat.tell(k .. " module initialized.")
  end
end
modules.Chat.tell("All modules initialized.")

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

---------------------START: MAIN---------------------
local function main()

end
---------------------END: MAIN---------------------

---------------------START: Pcall---------------------

---------------------END: Pcall---------------------
