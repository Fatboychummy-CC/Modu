--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/ModulesRequired.lua

This module lets Modu know which modules need to be required.
List them in the order you want them initialized.
-- controller is your "main" function
]]

local data = {
  controller = "Control",
  modules = {
    "Chat.Help",
    "Chat.Clear",
    "Chat.Echo",

    "Item.Grab",

    "Core.Interaction.PlayerInteraction",
    "Core.Interaction.Listener",
    "Core.Interaction.Parser",
    "Core.System",
    "Core.Commands"
  },
  limpModules = {
    "Core.Interaction.PlayerInteraction",
    "Core.Interaction.Listener",
    "Core.Interaction.Parser",
    "Core.System",
    "Core.Commands"
  }
}

for k, v in pairs(data.modules) do
  data.modules[k] = "modules." .. v
end

for k, v in pairs(data.limpModules) do
  data.limpModules[k] = "modules." .. v
end

for k, v in pairs(data) do
  if type(v) == "string" then
    data[k] = "modules." .. v
  end
end

return data
