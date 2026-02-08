--[[
################
#     HOOK     #
################
]]
--
hook.Add("PostEntityFireBullets", "PR_Shoot_Press_Button", function(shooter, data)
  local cv = GetConVar("pr_shoot_button_use"):GetInt()
  if cv <= 0 then return end
  if not IsValid(shooter) or not shooter:IsPlayer() then return end
  local tr = data.Trace
  if not tr or not IsValid(tr.Entity) then return end
  local ent = tr.Entity
  ---@cast ent Entity
  local class = ent:GetClass()
  if class ~= "func_button" and class ~= "func_rot_button" then return end
  shooter["_PRNextButtonShoot"] = shooter["_PRNextButtonShoot"] or 0
  if CurTime() < shooter["_PRNextButtonShoot"] then return end
  if cv == 2 then ent:Fire("Unlock", nil) end
  ent:Use(shooter, shooter)
end)
