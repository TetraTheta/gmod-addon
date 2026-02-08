local b_bor = bit.bor
local u_GetPlayerTrace = util.GetPlayerTrace
local u_TraceLine = util.TraceLine
--
local cv = GetConVar("pr_shoot_button_use")

local candidate = {
  func_button = "Press",
  func_rot_button = "Press",
  func_door = "Toggle",
  func_door_rotating = "Toggle",
  prop_door_rotating = "Toggle"
}

local function _GetTraceEntity(ply)
  if not IsValid(ply) then return NULL end
  local tr = u_GetPlayerTrace(ply)
  -- MASK_SOLID(33570827): CONTENTS_SOLID(1) + CONTENTS_WINDOW(2) + CONTENTS_GRATE(8) + CONTENTS_MOVEABLE(16384) + CONTENTS_MONSTER(33554432)
  tr.mask = b_bor(MASK_SOLID, CONTENTS_AUX, CONTENTS_DEBRIS)
  local trace = u_TraceLine(tr) ---@cast trace TraceResult
  if trace.Hit then
    return trace.Entity
  else
    return NULL
  end
end

--[[
################
#     HOOK     #
################
]]
--
hook.Add("KeyPress", "PR_Shoot_Press_Button", function(ply, key)
  if key ~= IN_ATTACK then return end

  if not cv then cv = GetConVar("pr_shoot_button_use") end
  local cvv = cv:GetInt()
  if cvv <= 0 or not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() then return end

  local ent = _GetTraceEntity(ply)
  if not IsValid(ent) then return end
  ---@cast ent Entity

  local class = ent:GetClass()
  local action = candidate[class]

  if not action then return end

  ply["_PRNextButtonShoot"] = ply["_PRNextButtonShoot"] or 0
  if CurTime() < ply["_PRNextButtonShoot"] then return end
  ply["_PRNextButtonShoot"] = CurTime() + 0.5

  if cvv == 2 then
    ent:Fire("Unlock")
  end

  ent:Fire(action)
end)
