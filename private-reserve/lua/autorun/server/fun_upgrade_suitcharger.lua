hook.Add("OnEntityCreated", "PR_Upgrade_SuitCharger", function(e)
  timer.Simple(0.01, function()
    if not IsValid(e) then return end
    if e:GetClass() == "item_suitcharger" then
      if e:HasSpawnFlags(16384) then e:RemoveSpawnFlags(16384) end -- Kleiner's recharger
      if not e:HasSpawnFlags(8192) then e:AddSpawnFlags(8192) end -- Citadel recharger
      e:Fire("SetCharge", "1000")
    end

    if e:GetClass() == "func_recharge" then
      if not e:HasSpawnFlags(8192) then e:AddSpawnFlags(8192) end -- Citadel recharger
      e:Fire("SetCharge", "1000")
    end
  end)
end)
