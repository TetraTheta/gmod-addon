surface.CreateFont("RavenholmNCZ_MessageFont", {
  font = "Roboto",
  extended = true,
  size = 22
})

net.Receive("FixMap_RavenholmNCZ", function(_, _)
  local resTitle = net.ReadString()
  local resLangKey = net.ReadString()
  --
  local frame = vgui.Create("DFrame")
  frame:SetSize(ScrW() * 0.4167, ScrH() * 0.5556) -- 800x600 in 1920x1080
  frame:Center()
  frame:SetDraggable(false)
  frame:ShowCloseButton(true)
  frame:SetTitle(resTitle)
  --
  local txt = vgui.Create("RichText", frame)
  txt:Dock(FILL)
  txt:InsertColorChange(128, 128, 128, 255)
  txt:AppendText(language.GetPhrase(resLangKey))
  ---@diagnostic disable-next-line: inject-field
  function txt:PerformLayout()
    if (self:GetFont() ~= "RavenholmNCZ_MessageFont") then
      self:SetFontInternal("RavenholmNCZ_MessageFont")
    end
  end

  --
  frame:SetVisible(true)
  frame:MakePopup()
end)
