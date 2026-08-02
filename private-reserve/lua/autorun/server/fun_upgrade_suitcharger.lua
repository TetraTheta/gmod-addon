hook.Add("OnEntityCreated", "PR_Upgrade_SuitCharger", function(e)
  timer.Simple(0.01, function()
    if not IsValid(e) then return end
    if e:GetClass() == "item_suitcharger" then
      if e:HasSpawnFlags(16384) then -- Kleiner's recharger
        e:RemoveSpawnFlags(16384)
      end
      if not e:HasSpawnFlags(8192) then -- Citadel recharger
        e:AddSpawnFlags(8192)
      end
      e:Fire("SetCharge", "1000")
    end
    if e:GetClass() == "func_recharge" then
      if not e:HasSpawnFlags(8192) then -- Citadel recharger
        e:AddSpawnFlags(8192)
      end
      e:Fire("SetCharge", "1000")
    end
  end)
end)
