CreateConVar("dlight_enable", "1", bit.bor(FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE), "Toggle the Dynamic Fire script")
if CLIENT then
  local next_main_think = 0
  hook.Add("Think", "DynamicFireLight", function()
    local time = CurTime()
    if next_main_think > time or not GetConVar("dlight_enable"):GetBool() then return end
    next_main_think = time + 0.05
    for _, v in pairs(ents.GetAll()) do
      ---@cast v Entity
      if not v:IsValid() then continue end
      ---@diagnostic disable-next-line: undefined-field
      if not (v:IsPlayer() or v:IsNPC() or v.Type == "nextbot" or v:GetClass():find("prop") or v:GetClass() == "_firesmoke") then continue end
      if v:GetClass() == "_firesmoke" or v:IsOnFire() then
        local pos = v:WorldSpaceCenter() + vector_up * 8
        local dlight = DynamicLight(v:EntIndex())
        if dlight then
          local size = 128 ---@cast size number
          local rad = v:GetModelRadius()
          --if rad ~= nil then rad = size end
          if not isnumber(rad) then rad = size end
          if v:GetClass() == "_firesmoke" then
            size = 128 -- neither above work on client
          elseif v:IsPlayer() then
            size = rad
          else
            size = rad + rad / rad * 50
          end

          dlight.Pos = pos
          dlight.r = 255
          dlight.g = 100
          dlight.b = 25
          dlight.Brightness = 8
          dlight.Decay = size * 0.25
          dlight.Size = size
          dlight.DieTime = CurTime() + 0.5
          dlight.Style = 0
        end
      end
    end
  end)
end
