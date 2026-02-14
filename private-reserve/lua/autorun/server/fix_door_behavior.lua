--[[
################
#     HOOK     #
################
]]
hook.Add("PlayerUse", "PR_DoorUse", function(ply, _)
  local door = ply:GetUseEntity()
  if IsValid(door) and door:GetClass() == "prop_door_rotating" and door:GetInternalVariable("m_eDoorState") == 2 then
    if door:GetInternalVariable("m_hMaster") ~= NULL then
      door:GetInternalVariable("m_hMaster"):Fire("Close")
      return false
    else
      door:Fire("Close")
      return false
    end
  end
end)
