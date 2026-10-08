local prop_classes = {
  func_physbox = true,
  func_pushable = true,
  prop_physics = true,
  prop_physics_respawnable = true
}
--
---@param ent Entity
---@param pos Vector
---@param ang Angle
---@param vel Vector
local function FinishPropClimbing(ent, pos, ang, vel)
  if not IsValid(ent) then return end
  local phys = ent:GetPhysicsObject()
  if IsValid(phys) then
    phys:EnableMotion(true)
    phys:SetVelocity(vel)
  end
  ent:SetAbsVelocity(vector_origin)
  ent:SetPos(pos)
  ent:SetAngles(ang)
end
--
---@param p Player
---@param mv CMoveData
local function HandlePropClimbing(p, mv)
  if p:GetInfo("sc_prop_climbing") ~= "1" or not mv:KeyDown(IN_JUMP) then return end
  local ent = p:GetGroundEntity()
  if not IsValid(ent) or not prop_classes[ent:GetClass()] then return end
  local phys = ent:GetPhysicsObject()
  if not IsValid(phys) or not phys:IsMotionEnabled() then return end
  local ang = ent:GetAngles()
  local pos = ent:GetPos()
  local vel = phys:GetVelocity()
  phys:EnableMotion(false)
  ent:SetAbsVelocity(vector_origin)
  p:SetPos(p:GetPos() + Vector(0, 0, 1))
  timer.Simple(0.05, function() FinishPropClimbing(ent, pos, ang, vel) end)
end
--
--[[
##############
#    HOOK    #
##############
]]

hook.Add("Move", "SCTOOLS_PropClimbing", HandlePropClimbing)
