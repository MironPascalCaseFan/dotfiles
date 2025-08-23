import AssDraw from "./lib/assdraw";

export interface Config {
  media_path: string;
  deckname: string;
  modelName: string;
  field_audio: string;
  field_snapshot: string;
  field_subtitle1: string;
  field_subtitle2: string;
  field_title: string;
  font_size: number;
  shortcuts: {
    menu_open: string;
    word_lookup: string;
    menu_close: string,
    start_recording: string,
    set_screenshot: string,
    create_ankicard: string,
    create_ankicard_gui: string,
  };
  anki_url: string;
  audio_bitrate: string;
  snapshot_height: string | number; // you might prefer string if you always use '480'
}

export interface RecordingContext {
  start_time: number;
  end_time: number;
  snapshot_time: number;
  subtitles: {
    main: string[];       // replace `any` with your subtitle type if you have one
    secondary: string[];
  };
}

export interface App {
  ctx: RecordingContext,
  cfg: Config,
  overlay: mp.OSDOverlay,
  ass: AssDraw,
}
