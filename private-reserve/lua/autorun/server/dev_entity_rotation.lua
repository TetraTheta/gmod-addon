concommand.Add("set_entity_angle", function(ply, _, args)
  if not IsValid(ply) then return end
  local tr = ply:GetEyeTrace()
  local ent = tr.Entity
  if IsValid(ent) then
    ---@cast ent Entity
    local pitch = tonumber(args[1]) or 0
    local yaw = tonumber(args[2]) or 0
    local roll = tonumber(args[3]) or 0
    local targetAng = Angle(pitch, yaw, roll)
    ent:SetAngles(targetAng)
    local phy = ent:GetPhysicsObject()
    if IsValid(phy) then
      phy:Wake()
      phy:SetAngles(targetAng)
    end
    if ent:IsNPC() then
      ---@cast ent NPC
      ent:SetIdealYawAndUpdate(yaw)
    end
    ply:ChatPrint("Entity Angles changed: " .. tostring(targetAng))
  else
    ply:ChatPrint("No valid entity or model")
  end
end)
