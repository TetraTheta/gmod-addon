-- original subtitles test table from subtitles_test concommand

local sub_tbl = {
  {
    duration = 3,
    range = 512,
    snd = "SIMPLEST_SUBTITLE_TEST_1",
    subject = "Unknown creature",
    text = "*distant howling*"
  },
  {
    duration = 3,
    range = 512,
    snd = "SIMPLEST_SUBTITLE_TEST_2",
    subject = "World",
    text = "Null"
  },
  {
    closedcaption = true,
    duration = 4,
    range = 512,
    snd = "SIMPLEST_SUBTITLE_TEST_3",
    subject = "",
    text = "*EXPLOSION*",
    textcol = Color(255, 25, 25, 255)
  },
  {
    duration = 5,
    range = 512,
    snd = "SIMPLEST_SUBTITLE_TEST_4",
    subject = "G-Man",
    subjectcol = Color(25, 25, 255, 255),
    text = "Doctorrr freeeemaaaan \nSeems like you only just arrived"
  },
  {
    duration = 5,
    range = 512,
    snd = "SIMPLEST_SUBTITLE_TEST_5",
    subject = "M4-Sopmod II",
    subjectcol = Color(25, 255, 25, 255),
    text = "*japanese talk* Shkikan *japanese talk*"
  }
}

table.insert(Subtitles_Table, sub_tbl)
