-- Register 'Resistance Turret'
local npc = {
  Category = "SC Entities",
  Class = "npc_turret_floor",
  Health = "255",
  KeyValues = { custom_turret = "1" },
  Model = "models/sc_turret_resistance/floor_turret.mdl",
  Name = "SC Resistance Turret",
  Offset = 8,
  OnFloor = true,
  Rotate = Angle(0, 180, 0),
  Skin = 2,
  TotalSpawnFlags = 640
}
list.Set("NPC", "sc_turret_resistance_floor", npc)
-- Register 'Resistance Turret' end
-- Set custom FireBullets to custom turrets
hook.Add("EntityFireBullets", "sc_turret_resistance_floor_firebullets", function(entity, data)
  if (entity:GetClass() == "npc_turret_floor") then
    local t = util.KeyValuesToTablePreserveOrder(util.GetModelInfo(entity:GetModel())["ModelKeyValues"])
    for _, v in ipairs(t) do
      if (v["Key"] == "custom_turret" and v["Value"] == 1) then
        local enemy = entity:GetEnemy()
        if IsValid(enemy) then
          local teye = entity:EyePos() -- or use 'eyes' attachment position
          -- entity:LookupAttachment("eyes") > 0
          -- entity:GetAttachment("eyes")
          local eeye = enemy:EyePos() - Vector(0, 0, 5)
          debugoverlay.Line(teye, eeye)
          data.Dir = (eeye - teye):GetNormalized()
          data.Spread = Vector(0, 0, 0)
        end
      end
    end
    return true
  end
end)
-- Set custom FireBullets to custom turrets end
