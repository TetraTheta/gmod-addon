hook.Add("InitPostEntity", "FixMap_ASC_InitPostEntity", function()
  if not SERVER then return end
  local gt = ents.FindByClass("game_text")
  for _, v in ipairs(gt) do
    local msg = v:GetInternalVariable("message")
    if msg == "Silent Escape_Chapter1_Title" then
      v:SetKeyValue("message", "SILENT ESCAPE")
    elseif msg == "Silent Escape_Chapter2_Title" then
      v:SetKeyValue("message", "UNSUCCESSFUL CIRCUMSTANCES")
    elseif msg == "Silent Escape_Chapter3_Title" then
      v:SetKeyValue("message", "ROUTE MINE")
    elseif msg == "Silent Escape_Chapter4_Title" then
      v:SetKeyValue("message", "DARK FOREST")
    elseif msg == "Silent Escape_Chapter5_Title" then
      v:SetKeyValue("message", "THE LAST SANCTUARY")
    elseif msg == "Silent Escape_Chapter6_Title" then
      v:SetKeyValue("message", "REVENGE")
    elseif msg == "Silent Escape_Thomas_Dead" then
      v:SetKeyValue("message", "Thomas is dead")
    elseif msg == "Silent Escape_James_Dead" then
      v:SetKeyValue("message", "James is dead")
    elseif msg == "Silent Escape_Behind" then
      v:SetKeyValue("message", "You lagged behind the team")
    elseif msg == "Silent Escape_battery" then
      v:SetKeyValue("message", "You lost battery")
    elseif msg == "Silent Escape_endtrain" then
      v:SetKeyValue("message", "The train has gone.")
    elseif msg == "Silent Escape_Title1" then
      v:SetKeyValue("message", "Leader,Game Design\n Konstantin \"Pro-Bones\" Malyavkin")
    elseif msg == "Silent Escape_Title2" then
      v:SetKeyValue("message", "Additional help\n Konstantin \"Diz4L\" Saltykov \n Roman  \"=EX-Mo=\" Mochalov\n Anatoly \"swst.Turn\" Tokarev\n Alexander \"KAJAJJJ\" Veselov")
    elseif msg == "Silent Escape_Title3" then
      v:SetKeyValue("message", "Voice Acting\n Kirill \"STiCK\" Kushnir - Thomas\n Radik \"H2x\" Hamatdinov - Kevin\n Sergey \"Derpy Claus\" Ishkov - Davis\n Konstantin \"WAReshka\" Merzlyakov - James ")
    elseif msg == "Silent Escape_Title4" then
      v:SetKeyValue("message", "English localization\n Derek Lettman - Thomas\n Jeremiah \"The Aphasian\" Britt - Kevin\n David \"CuddleChunks\" Camden-Britton - Davis\n James \"Jossi\" Rossi - James")
    elseif msg == "Silent Escape_Title5" then
      v:SetKeyValue("message", "Music\nDavid Lynch \nHajime Mizoguchi \nTakeshi Muto")
    end
  end
end)
