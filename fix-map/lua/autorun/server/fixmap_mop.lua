hook.Add("InitPostEntity", "FixMap_MOP_ks_mop_pita3", function()
  if SERVER and game.GetMap() == "ks_mop_pita3" then
    local ax1_exists = false
    for _, v in ents.Iterator() do
      if v:GetClass() == "npc_alyx" and v:GetName() == "ax1" then ax1_exists = true end
    end

    if not ax1_exists then
      local ax1 = ents.Create("npc_alyx")
      ax1:SetName("ax1")
      ax1:SetPos(Vector(-1216, -11072, -448))
      ax1:SetAngles(Angle(0, 90, 0))
      ax1:SetKeyValue("additionalequipment", "weapon_alyxgun")
      ax1:Spawn()
      ax1:Activate()
      local aigoal = ents.Create("ai_goal_follow")
      aigoal:SetKeyValue("actor", "ax1")
      aigoal:SetKeyValue("Formation", "1")
      aigoal:SetKeyValue("goal", "!player")
      aigoal:Spawn()
      aigoal:Activate()
      aigoal:Fire("Activate")
    end
  end
end)
