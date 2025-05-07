-- Save player's default speed multiplier
---@param p Player
hook.Add("PlayerSpawn", "SCTOOLS_GetOriginalSpeedValue", function(p, _)
  if IsValid(p) then
    p["SCTOOLS_DEF_CROUCH_SPD"] = p:GetCrouchedWalkSpeed()
    p["SCTOOLS_DEF_LADDER_SPD"] = p:GetLadderClimbSpeed()
  end
end)

-- KeyPress
---@param p Player
hook.Add("KeyPress", "SCTOOLS_BoostKeyPress", function(p, _)
  local mult = GetConVar("sc_boost_speed_modifier"):GetFloat()
  -- sanitize multiplier
  mult = mult > 0 and mult or 1.0
  if p:Crouching() and p:KeyPressed(IN_SPEED) then
    p:SetCrouchedWalkSpeed(p:GetCrouchedWalkSpeed() * mult)
    return
  elseif p:GetMoveType() == MOVETYPE_LADDER and p:KeyPressed(IN_SPEED) then
    p:SetLadderClimbSpeed(p:GetLadderClimbSpeed() * mult)
    return
  end

  -- safe guard
  if p["SCTOOLS_DEF_CROUCH_SPD"] == nil then
    p["SCTOOLS_DEF_CROUCH_SPD"] = 0.3
  end

  if p["SCTOOLS_DEF_LADDER_SPD"] == nil then
    p["SCTOOLS_DEF_LADDER_SPD"] = 200
  end

  p:SetCrouchedWalkSpeed(p["SCTOOLS_DEF_CROUCH_SPD"])
  p:SetLadderClimbSpeed(p["SCTOOLS_DEF_LADDER_SPD"])
end)

-- KeyRelease
---@param p Player
hook.Add("KeyRelease", "SCTOOLS_BoostKeyRelease", function(p, _)
  if p["SCTOOLS_DEF_CROUCH_SPD"] == nil then
    p["SCTOOLS_DEF_CROUCH_SPD"] = 0.3
  end

  if p["SCTOOLS_DEF_LADDER_SPD"] == nil then
    p["SCTOOLS_DEF_LADDER_SPD"] = 200
  end

  if p:Crouching() and p:KeyReleased(IN_SPEED) then
    p:SetCrouchedWalkSpeed(p["SCTOOLS_DEF_CROUCH_SPD"])
    return
  elseif p:GetMoveType() == MOVETYPE_LADDER and p:KeyReleased(IN_SPEED) then
    p:SetLadderClimbSpeed(p["SCTOOLS_DEF_LADDER_SPD"])
    return
  end

  -- safe guard
  p:SetCrouchedWalkSpeed(p["SCTOOLS_DEF_CROUCH_SPD"])
  p:SetLadderClimbSpeed(p["SCTOOLS_DEF_LADDER_SPD"])
end)
