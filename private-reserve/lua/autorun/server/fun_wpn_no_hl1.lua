-- Replace HL1 weapons to HL2 weapons because I don't play Half-Life: Source
local replacements = {
  weapon_357_hl1 = "weapon_357",
  weapon_crowbar_hl1 = "weapon_crowbar",
  weapon_shotgun_hl1 = "weapon_shotgun",
}

---@param ent Entity
local function ReplaceHL1Weapon(ent)
  if not IsValid(ent) then return end
  if ent["PR_ReplaceHL1Weapons_Replaced"] then return end
  local cls = ent:GetClass()
  local new_cls = replacements[cls]
  if not new_cls then return end
  ent["PR_ReplaceHL1Weapons_Replaced"] = true
  local new_ent = ents.Create(new_cls)
  if not IsValid(new_ent) then
    ent["PR_ReplaceHL1Weapons_Replaced"] = nil
    return
  end
  new_ent:SetPos(ent:GetPos())
  new_ent:SetAngles(ent:GetAngles())
  new_ent:SetKeyValue("spawnflags", tostring(ent:GetSpawnFlags()))
  new_ent:Spawn()
  new_ent:Activate()
  ent:Remove()
end

--[[
################
#     HOOK     #
################
]]

hook.Add("InitPostEntity", "PR_ReplaceHL1Weapons_InitPostEntity", function()
  for cls in pairs(replacements) do
    for _, ent in ipairs(ents.FindByClass(cls)) do
      ReplaceHL1Weapon(ent)
    end
  end
end)

---@param ent Entity
hook.Add("OnEntityCreated", "PR_ReplaceHL1Weapons_OnEntityCreated", function(ent)
  timer.Simple(0, function() ReplaceHL1Weapon(ent) end)
end)
