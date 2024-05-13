-- Record player's default speed
hook.Add("PlayerSpawn", "SCBoostSpeedInitialValue", function(p, _)
  ---@cast p Player
  if IsValid(p) then
    ---@diagnostic disable-next-line: inject-field
    p.sc_default_crouch_speed = p:GetCrouchedWalkSpeed()
    ---@diagnostic disable-next-line: inject-field
    p.sc_default_ladder_speed = p:GetLadderClimbSpeed()
  end
end)

-- KeyPress
hook.Add("KeyPress", "SCBoostSpeedKeyPress", function(p, _)
  local mult = GetConVar("sc_boost_speed_modifier"):GetFloat() > 0 and GetConVar("sc_boost_speed_modifier"):GetFloat() or 1.0
  if p:Crouching() and p:KeyPressed(IN_SPEED) then
    p:SetCrouchedWalkSpeed(p:GetCrouchedWalkSpeed() * mult)
    return
  elseif p:GetMoveType() == MOVETYPE_LADDER and p:KeyPressed(IN_SPEED) then
    p:SetLadderClimbSpeed(p:GetLadderClimbSpeed() * mult)
    return
  end

  -- Safe guard
  if p.sc_default_crouch_speed == nil then p.sc_default_crouch_speed = 0.3 end
  if p.sc_default_ladder_speed == nil then p.sc_default_ladder_speed = 200 end
  p:SetCrouchedWalkSpeed(p.sc_default_crouch_speed)
  p:SetLadderClimbSpeed(p.sc_default_ladder_speed)
end)

-- KeyRelease
hook.Add("KeyRelease", "SCBoostSpeedKeyRelease", function(p, _)
  if p.sc_default_crouch_speed == nil then p.sc_default_crouch_speed = 0.3 end
  if p.sc_default_ladder_speed == nil then p.sc_default_ladder_speed = 200 end
  if p:Crouching() and p:KeyReleased(IN_SPEED) then
    p:SetCrouchedWalkSpeed(p.sc_default_crouch_speed)
    return
  elseif p:GetMoveType() == MOVETYPE_LADDER and p:KeyReleased(IN_SPEED) then
    p:SetLadderClimbSpeed(p.sc_default_ladder_speed)
    return
  end

  -- Safe guard
  p:SetCrouchedWalkSpeed(p.sc_default_crouch_speed)
  p:SetLadderClimbSpeed(p.sc_default_ladder_speed)
end)
