-- Fade out client ragdoll after 3 seconds (rather than removing it immediately)
hook.Add("CreateClientsideRagdoll", "PR_FadeoutClientCorpses", function(_, ragdoll)
  timer.Simple(3, function()
    if IsValid(ragdoll) then
      ragdoll:SetSaveValue("m_bFadingOut", true)
    end
  end)
end)
