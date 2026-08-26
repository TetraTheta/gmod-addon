--[[
Mod: Precursor
Map:
- r_map7
]]

---@param ent Entity
hook.Add("OnEntityCreated", "FixMap_Precursor_OnEntityCreated", function(ent)
  if game.GetMap() ~= "r_map7" then return end
  timer.Simple(0, function()
    if not IsValid(ent) or ent:GetClass() ~= "npc_hunter" or ent:GetName() ~= "hunter_boss" then return end
    ent:Input("AddOutput", ent, ent, "OnDeath hunter_retreat_relay,Trigger,,0,1")
    ent:Input("AddOutput", ent, ent, "OnDeath fence_break,Break,,0,1")
  end)
end)
