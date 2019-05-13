--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/Core/Item.lua

This module is the main module
]]

local funcs = {}

local inv = require("modules.Item.ItemModules.Inventory")

function funcs.go(modules, vars)
  local interactor = modules["Core.Interaction.PlayerInteraction"]

  local function tAssert(statement, error)
    if not statement then
      interactor.tell("Error:" .. error)
      return true
    end
    return false
  end

  local item = vars[2]
  local count = vars[3]
  local dd = vars[4]
  local searchTypeFlag = true

  if type(vars[4]) == "string" and vars[4]:lower() == "true" then
    searchTypeFlag = false
  end

  if searchTypeFlag then
    -- if using modname:item_id + damage search type ...
  else
    -- if using "The item's name" search type ...
  end

end

function funcs.help()
  return {
    "Usage:",
    "  get <item> <count> [damage]",
    ";;verbose",
    "  get minecraft:iron_ingot 32",
    "    transfers 32 iron ingots to the player's inventory.",
    "",
    "  get minecraft:dye 32 4",
    "    transfers lapis lazuli to your inventory.",
    "",
    "  get \"lapis lazuli\" 10 -v",
    "    transfers an item via it's screen name.  Note that this is very slow.",
    "",
    "  This module accepts the following as numbers: \"all\" and \"every\".",
    "  Example:",
    "    get minecraft:dye all",
    "  Will grab every single item in the storage network named minecraft:dye."
      .. " This is the similar to:",
    "    get \"lapis lazuli\" all -v",
    "  As the above will grab all items named \"lapis lazuli\".",
    "",
    "Flags:",
    "  s: Switch between indexing by an item's 'modname:item_name' "
      .. "and 'full name'"
  }
end

function funcs.getInstant()
  return "get"
end

function funcs.getInfo()
  return "Retrieves items from a storage network and sends them to the user."
end

function funcs.init(data)
  return true
end

return funcs
