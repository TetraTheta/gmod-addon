-- original subtitles test table from subtitles_test concommand

local subtable = {
  {
    snd = "SIMPLEST_SUBTITLE_TEST_1",
    subject = "Unknown creature",
    text = "*distant howling*",
    range = 512,
    duration = 3,
    closedcaption = false,
    subjectcol = Color(255, 255, 255, 255),
    textcol = Color(255, 255, 255, 255)
  },
  {
    snd = "SIMPLEST_SUBTITLE_TEST_2",
    subject = "World",
    text = "Null",
    range = 512,
    duration = 3,
    closedcaption = false,
    subjectcol = Color(255, 255, 255, 255),
    textcol = Color(255, 255, 255, 255)
  },
  {
    snd = "SIMPLEST_SUBTITLE_TEST_3",
    subject = "",
    text = "*EXPLOSION*",
    range = 512,
    duration = 4,
    closedcaption = true,
    subjectcol = Color(255, 255, 255, 255),
    textcol = Color(255, 25, 25, 255)
  },
  {
    snd = "SIMPLEST_SUBTITLE_TEST_4",
    subject = "G-Man:",
    text = "Doctorrr freeeemaaaan \nSeems like you only just arrived",
    range = 512,
    duration = 5,
    closedcaption = false,
    subjectcol = Color(25, 25, 255, 255),
    textcol = Color(255, 255, 255, 255)
  },
  {
    snd = "SIMPLEST_SUBTITLE_TEST_5",
    subject = "M4-Sopmod II:",
    text = "*japanese talk* Shkikan *japanese talk*",
    range = 512,
    duration = 5,
    closedcaption = false,
    subjectcol = Color(25, 255, 25, 255),
    textcol = Color(255, 255, 255, 255)
  },
}

table.insert(Subtitles_Table, subtable)
