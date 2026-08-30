-- Set entity's angle via concommand
local ANGLE_CANDIDATES = { "0", "45", "90", "180", "270" }

--[[
#################
#    COMMAND    #
#################
]]

---@param ply Player|Entity
---@param args table
local function SetEntityAngle(ply, args)
  if not IsValid(ply) or not ply:IsPlayer() then return end

  local tr = ply:GetEyeTrace()
  local ent = tr.Entity
  if not IsValid(ent) then
    ply:ChatPrint("No valid entity or model")
    return
  end

  ---@cast ent Entity
  local pitch = tonumber(args[1]) or 0
  local yaw = tonumber(args[2]) or 0
  local roll = tonumber(args[3]) or 0
  local target_ang = Angle(pitch, yaw, roll)
  ent:SetAngles(target_ang)

  local phy = ent:GetPhysicsObject()
  if IsValid(phy) then
    phy:Wake()
    phy:SetAngles(target_ang)
  end

  if ent:IsNPC() then
    ---@cast ent NPC
    ent:SetIdealYawAndUpdate(yaw)
  end

  ply:ChatPrint("Entity Angles changed: " .. tostring(target_ang))
end

--[[
##############################
#    COMMAND AUTOCOMPLETE    #
##############################
]]

---@param cmd string
---@param args string
---@return string[]
local function SetEntityAngleComplete(cmd, args)
  local prefix = args or ""
  if string.sub(string.lower(prefix), 1, #cmd) == string.lower(cmd) then prefix = string.sub(prefix, #cmd + 1) end
  prefix = string.gsub(prefix, "^%s+", "")
  local parts = string.Explode(" ", string.Trim(prefix))
  if prefix == "" then parts = {} end
  if #parts > 3 or (#parts >= 3 and string.EndsWith(prefix, " ")) then return {} end

  local base = cmd
  for i = 1, math.min(#parts, 2) do
    base = base .. " " .. parts[i]
  end

  local raw = string.EndsWith(prefix, " ") and "" or parts[#parts] or ""
  if not string.EndsWith(prefix, " ") and #parts > 0 then
    base = cmd
    for i = 1, #parts - 1 do
      base = base .. " " .. parts[i]
    end
  end

  local out = {}
  for _, value in ipairs(ANGLE_CANDIDATES) do
    if string.sub(value, 1, #raw) == raw then out[#out + 1] = base .. " " .. value end
  end

  return out
end

--[[
##########################
#    COMMAND REGISTER    #
##########################
]]

concommand.Add("set_entity_angle", function(ply, _, args, _) SetEntityAngle(ply, args) end, SetEntityAngleComplete, "Set the angle of the entity you are looking at.", { FCVAR_NONE })
