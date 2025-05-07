require("sctools")
local GetPlayerByName = sctools.command.GetPlayerByName
local IsSuperAdmin = sctools.IsSuperAdmin
local SuggestPlayer = sctools.command.SuggestPlayer
local SendMessage = sctools.SendMessage
--
local function DropWeaponComplete(_, args)
  return SuggestPlayer("sc_drop_weapon", args)
end
local function RemoveWeaponComplete(_, args)
  return SuggestPlayer("sc_remove_weapon", args)
end

---@param ply Player
---@param args table
concommand.Add("sc_drop_weapon", function(ply, _, args, _)
  if not IsSuperAdmin(ply) then return end
  if #args > 1 then SendMessage("[SC Drop Weapon] Only first player will be processed.", ply) end
  local p = #args == 1 and GetPlayerByName(args[1]) or ply
  if IsValid(p) and p:IsPlayer() then
    local wep = p:GetActiveWeapon()
    if IsValid(wep) then
      p:DropWeapon(wep)
      if p ~= ply then SendMessage(Format("[SC Drop Weapon] Dropped weapon that %s was holding.", p:GetName()), ply) end
    end
  end
end, DropWeaponComplete, "Drop weapon that given player is currently holding.", { FCVAR_NONE })

---@param ply Player
---@param args table
concommand.Add("sc_remove_weapon", function(ply, _, args, _)
  if not IsSuperAdmin(ply) then return end
  if #args > 1 then SendMessage("[SC Remove Weapon] Only first player will be processed.", ply) end
  local p = #args == 1 and GetPlayerByName(args[1]) or ply
  if IsValid(p) and p:IsPlayer() then
    local wep = p:GetActiveWeapon()
    if IsValid(wep) then
      p:StripWeapon(wep:GetClass())
      if p ~= ply then SendMessage(Format("[SC Remove Weapon] Removed weapon that %s was holding.", p:GetName()), ply) end
    end
  end
end, RemoveWeaponComplete, "Remove weapon that given player is currently holding.", { FCVAR_NONE })
