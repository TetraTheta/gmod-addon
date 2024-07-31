hook.Add("HUDShouldDraw", "RemoveThatShit", function(name)
  if name == "CHudDamageIndicator" and GetConVar("sc_disable_red_death"):GetBool() and LocalPlayer():Health() <= 0 then
    return false
  end
end)
