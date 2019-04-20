--[[FATFILE
3
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/Inventory.lua

This module controls all inventory interaction
]]

local funcs = {}
local inventories = false

---------------------START: Inventory Functions---------------------

-- Get inventories.  Returns a table of inventories.
-- parameter: a table of peripheral types that should also be returned
-- (useful for mods, as this only supports base minecraft)
function funcs.getInventories(modInventories)
  local invTypes = {"minecraft:chest", "minecraft:shulker_box"}
  local p = peripheral.getNames()
  local invs = {}

  -- Add mod inventories to the list of inventory types we want to find.
  if modInventories then
    for i = 1, #modInventories do
      invTypes[#invTypes + 1] = modInventories[i]
    end
  end

  -- Find the inventories.
  for i = 1, #p do
    for o = 1, #invTypes do
      if peripheral.getType(p[i]) == invTypes[o] then
        invs[#invs + 1] = p[i]
      end
    end
  end

  inventories = invs
  return invs
end

-- Get items, from an inventory, to another inventory.
-- damage is optional (defaults to any damage)
function funcs.grabItemsFromAll(to, amount, itemName, itemDamage)
  local count = 0
  local invs = inventories or funcs.getInventories()
  to = peripheral.wrap(to)
  damage = damage or -1

  if to then

    for i = 1, #invs do
      local inventory = peripheral.wrap(invs[i])

      if inventory then
        local size = inventory.size()
        local items = inventory.list()

        for o = 1, size do

          if items[o] then
            local name = items[o].name
            local damage = items[o].damage

            if name == itemName and damage >= 0 and damage == itemDamage
               or name == itemName and itemDamage < 0  then
               -- if name and damage match
               -- or if damage is "ignored" and name matches

               count = count + to.pullItems(invs[i], o, amount - count)

               if count >= amount then
                 return count
               end
            end
          end
        end
      end
    end
  else
    return 0, "Failed to wrap TO (argument #1)"
  end

  return count
end

function funcs.init(data)
  return true
end
---------------------END: Inventory Functions---------------------

return funcs
