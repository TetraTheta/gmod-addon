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

local function ToggleFreezeAutocomplete() end

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
    local frozen = ent:IsFlagSet(FL_FROZEN)
    -- FL_FROZEN is ignored for NPC, so I'll use it as a placeholder
    if frozen then
      ent:RemoveFlags(FL_FROZEN)
      ent:NextThink(CurTime())
      UnfreezeEffect(ent)
    else
      ent:AddFlags(FL_FROZEN)
      ent:NavSetGoalPos(ent:GetPos())
      ent:NextThink(CurTime() + 9999999999)
      FreezeEffect(ent)
    end
  else
    -- Physics Object (+ Vehicle, Weapon, etc.)
    local p = ent:GetPhysicsObject()
    if not p:IsValid() then return end
    local m = p:IsMotionEnabled()
    if m then
      p:EnableMotion(false)
      FreezeEffect(ent)
    else
      p:EnableMotion(true)
      UnfreezeEffect(ent)
    end
  end
end, nil, "Freeze the entity you are looking at.", { FCVAR_NONE })
