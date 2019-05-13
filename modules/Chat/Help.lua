--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/Chat/Help.lua

This module checks for help readings from other modules
]]

local funcs = {}

function funcs.go(modules, vars)
  local interactor = modules["Core.Interaction.PlayerInteraction"]
  local verbose = vars.flags["v"] or false

  local function tellHelp(mod)
    interactor.tell("")
    local dat = mod.help()
    if dat then
      for i = 1, #dat do
        if dat[i]:match(";;verbose") and not verbose then
          return  -- if not verbose, end here.
        elseif dat[i]:match(";;verbose") and verbose then
          interactor.tell("") -- if verbose, tell nothing
        else
          interactor.tell(dat[i])
        end
      end
    else
      interactor.tell("This module has nothing the user can interact with.")
    end
  end

  if not vars[2] then
    tellHelp(modules["Chat.Help"])
    return
  end

  vars[2] = vars[2]:lower()

  if vars[2] == "list" or vars[2] == "ls" then
    interactor.tell("All modules are:")
    for k, v in pairs(modules) do
      interactor.tell(type(v.getInstant) == "function" and "  " .. k
                        .. " (command: \"" .. v.getInstant() .. "\")"
                      or "  " .. k)
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
      interactor.tell("Modules are case sensitive.")
    end
  else
    interactor.tell("Unknown command: " .. vars[2])
    tellHelp(modules["Chat.Help"])
  end
end

function funcs.help()
  return {
    "Usages:",
    "  help <show> <module>",
    "  help <list>",
    ";;verbose",
    "  help show <module>:",
    "    shows information about a module",
    "",
    "  help list:",
    "    lists all modules",
    "",
    "Flags:",
    "  v: verbose, shows more information about a module."
  }
end

function funcs.getInstant()
  return "help"
end

function funcs.getInfo()
  return "Allows the user to get information on how to use a module."
end

function funcs.init(data)
  return true
end

return funcs
