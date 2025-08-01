-- either modify your options here or create a config file in ~/.config/mpv/script-opts/mpv2anki.conf
---@class am.Config
return {
  -- absolute path to where anki saves its media on linux this is usually the form of
  -- '/home/$user/.local/share/Anki2/$ankiprofile/collection.media/'
  -- relative paths (e.g. ~ for home dir) do NOT work.
  media_path = '/home/miron/.local/share/Anki2/User 1/collection.media/',
  -- The anki deck where to put the cards
  deckname = 'TestDeck',
  -- The note type
  modelName = 'Refold Sentence Miner: Word Only',
  -- You can use these options to remap the fields
  field_audio = 'sentence_audio',
  field_snapshot = 'image',
  field_subtitle1 = 'Example Sentence',
  field_subtitle2 = 'Sentence Translation',
  field_title = 'Word',
  -- The font size used in the menu.
  font_size = 20,
  shortcut = 'shift+f',
  -- In case you changed it
  anki_url = 'localhost:8765',
  audio_bitrate = '128k',
  snapshot_height = '480',
}
