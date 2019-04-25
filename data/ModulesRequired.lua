--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/ModulesRequired.lua

This module lets Modu know which modules need to be required.
List them in the order you want them initialized.
-- controller is your "main" function
]]

local data = {
  controller = "Control",
  "Chat.PlayerInteraction",
  "Chat.Listener",
  "Chat.Parser",
  "Chat.Help"
}

for k, v in pairs(data) do
  data[k] = "modules." .. v
end

return data
