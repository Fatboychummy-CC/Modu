--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/Chat/Help.lua

This module checks for help readings from other modules
]]

local funcs = {}

function funcs.go(modules, vars)
  local interactor = modules["Chat.PlayerInteraction"]
  if not vars[2] then
    local h = funcs.help()
    for i = 1, #h do
      interactor.tell(h[i])
    end
    return
  end
  vars[2] = vars[2]:lower()

  local function tellHelp(mod)
    interactor.tell("")
    local dat = mod.help()
    if dat then
      for i = 1, #dat do
        interactor.tell(dat[i])
      end
    else
      interactor.tell("This module has nothing the user can interact with.")
    end
  end

  if vars[2] == "list" or vars[2] == "ls" then
    interactor.tell("All modules are:")
    for k, v in pairs(modules) do
      interactor.tell("  " .. k)
    end
  elseif vars[2] == "show" or vars[2] == "s" then
    if modules[vars[3]] then
      if modules[vars[3]].help then
        interactor.tell("Displaying help for " .. vars[3])
        tellHelp(modules[vars[3]])
      else
        interactor.tell("No module help function: " .. tostring(vars[3]))
      end
    else
      interactor.tell("No module: " .. tostring(vars[3]))
    end
  else
    interactor.tell("Unknown command: " .. vars[2])
    tellHelp(modules["Chat.Help"])
  end
end

function funcs.help()
  return {
    "Usage:",
    "  help <show/list> [module]",
    "",
    "  help show <module>:",
    "    shows information about a module",
    "",
    "  help list:",
    "    lists all modules"
  }
end

function funcs.getInstant()
  return "help"
end

function funcs.init(data)
  return true
end

return funcs
