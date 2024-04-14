net.Receive("SCCleanResult", function(_, _)
  local resJsonCompLen = net.ReadUInt(16)
  local resJsonComp = net.ReadData(resJsonCompLen)
  local resTable = util.JSONToTable(util.Decompress(resJsonComp))
  local playSound = false
  if resTable.ammo and math.floor(resTable.ammo) > 0 then
    notification.AddLegacy("Cleaned " .. resTable.ammo .. " Ammos", NOTIFY_GENERIC, 2)
    playSound = true
  end

  if resTable.vitality and math.floor(resTable.vitality) > 0 then
    notification.AddLegacy("Cleaned " .. resTable.vitality .. " Batteries and Healthkits", NOTIFY_GENERIC, 2)
    playSound = true
  end

  if resTable.debris and math.floor(resTable.debris) > 0 then
    notification.AddLegacy("Cleaned " .. resTable.debris .. " Debris", NOTIFY_GENERIC, 2)
    playSound = true
  end

  if resTable.gibs and math.floor(resTable.gibs) > 0 then
    notification.AddLegacy("Cleaned " .. resTable.gibs .. " Gibs", NOTIFY_GENERIC, 2)
    playSound = true
  end

  if resTable.ragdoll and math.floor(resTable.ragdoll) > 0 then
    notification.AddLegacy("Cleaned " .. resTable.ragdoll .. " Ragdolls", NOTIFY_GENERIC, 2)
    playSound = true
  end

  if resTable.small and math.floor(resTable.small) > 0 then
    notification.AddLegacy("Cleaned " .. resTable.small .. " Small objects", NOTIFY_GENERIC, 2)
    playSound = true
  end

  if resTable.weapon and math.floor(resTable.weapon) > 0 then
    notification.AddLegacy("Cleaned " .. resTable.weapon .. " Weapons", NOTIFY_GENERIC, 2)
    playSound = true
  end

  -- Check decal last because I don't want to be spammed with 'Cleaned Decals' only
  if playSound == true and resTable.decal and resTable.decal == true then notification.AddLegacy("Cleaned Decals", NOTIFY_GENERIC, 2) end
  if playSound then surface.PlaySound("garrysmod/ui_hover.wav") end
end)
