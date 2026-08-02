local cv = GetConVar("sk_suitcharger_citadel_maxarmor")

hook.Add("PlayerSpawn", "PR_PlayerMaxArmor", function(ply, is_transition)
  local max_health = 200
  local max_armor = cv:GetInt() > 100 and cv:GetInt() or 500
  timer.Simple(0, function()
    ply:SetMaxHealth(max_health)
    if not is_transition then ply:SetHealth(max_health) end
    ply:SetMaxArmor(max_armor)
  end)
  -- print("maxarmor: " .. max_armor)
end)
