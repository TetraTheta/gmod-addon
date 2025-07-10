require("sctools")
local GetTraceEntity = sctools.GetTraceEntity
local IsSuperAdmin = sctools.IsSuperAdmin
local u_Effect = util.Effect

---@param ent Entity
local function FreezeEffect(ent)
  local ed = EffectData()
  ed:SetOrigin(ent:GetPos())
  ed:SetEntity(ent)
  ed:SetMagnitude(ed:GetMagnitude() * 5)
  ed:SetScale(ed:GetScale() * 5)
  u_Effect("phys_freeze", ed, true, true)
end

---@param ent Entity
local function UnfreezeEffect(ent)
  local ed = EffectData()
  ed:SetOrigin(ent:GetPos())
  ed:SetEntity(ent)
  ed:SetMagnitude(ed:GetMagnitude() * 5)
  ed:SetScale(ed:GetScale() * 5)
  u_Effect("phys_unfreeze", ed, true, true)
end

concommand.Add("sc_toggle_freeze", function(ply, _, _, _)
  if not IsSuperAdmin(ply) then return end
  local ent = GetTraceEntity(ply)
  if not ent:IsValid() then return end

  if ent:IsPlayer() then
    -- Player
    ---@cast ent Player
    local frozen = ent:IsFlagSet(FL_FROZEN)
    if frozen then
      ent:Freeze(false)
      UnfreezeEffect(ent)
    else
      ent:Freeze(true)
      FreezeEffect(ent)
    end
  elseif ent:IsNPC() or ent:IsNextBot() then
    -- NPC
    ---@cast ent NPC
    local frozen = ent:IsEFlagSet(EFL_NO_THINK_FUNCTION)
    if frozen then
      ent:RemoveEFlags(EFL_NO_THINK_FUNCTION)
      timer.Simple(0.001, function()
        local pos = ent["SCTOOLS_SAVED_POS"]
        ent:SetPos(pos)
        ent:GetPhysicsObject():SetPos(pos)
      end)
      UnfreezeEffect(ent)
    else
      ent["SCTOOLS_SAVED_POS"] = ent:GetPos()
      ent:NavSetGoalPos(ent:GetPos())
      ent:AddEFlags(EFL_NO_THINK_FUNCTION)
      FreezeEffect(ent)
    end
  else
    -- Physics Object (+ Vehicle, Weapon, etc.)
    local p = ent:GetPhysicsObject()
    if not p:IsValid() then return end
    local mt = ent:GetMoveType()
    local m = p:IsMotionEnabled()
    if m then
      ent["SCTOOLS_MOVETYPE"] = mt
      ent:SetMoveType(MOVETYPE_NONE)
      p:EnableMotion(false)
      FreezeEffect(ent)
    else
      ent:SetMoveType(ent["SCTOOLS_MOVETYPE"])
      ent["SCTOOLS_MOVETYPE"] = nil
      p:EnableMotion(true)
      UnfreezeEffect(ent)
    end
  end
end, nil, "Freeze the entity you are looking at.", { FCVAR_NONE })
