// polyfills
import "core-js/full/map";
import "core-js/full/set";
import 'core-js/es/typed-array';
import "core-js/full/array";
import "core-js/full/string";
import "core-js/full/promise";

import AssDraw from "./lib/assdraw";
import { parse } from "parse5";
import HttpClient from "HttpClient";
import { App, Config, RecordingContext } from "./types";
import { get_current_subtitles } from "./lib/media";
import { create_anki_note } from "./lib/anki";
let http = new HttpClient();

// then you can type your object
const config: Config = {
  media_path: '/home/miron/.local/share/Anki2/User 1/collection.media/',
  deckname: 'TestDeck',
  modelName: 'Refold Sentence Miner: Word Only',
  field_audio: 'sentence_audio',
  field_snapshot: 'image',
  field_subtitle1: 'Example Sentence',
  field_subtitle2: 'Sentence Translation',
  field_title: 'Word',
  font_size: 20,
  shortcuts: {
    menu_open: 'shift+f',
    word_lookup: "G",
    menu_close: "ESC",
    start_recording: "1",
    set_screenshot: "s",
    create_ankicard: "e",
    create_ankicard_gui: "shift+e"
  },
  anki_url: 'localhost:8765',
  audio_bitrate: '128k',
  snapshot_height: '480',
};


let ctx: RecordingContext = {
  start_time: -1,
  end_time: -1,
  snapshot_time: -1,
  subtitles: {
    main: [],
    secondary: [],
  }
};

let app: App = {
  overlay: mp.create_osd_overlay("ass-events"),
  ctx: ctx,
  ass: new AssDraw(),
  cfg: config,
}

function resetRecording(ctx: RecordingContext) {
  ctx.start_time = -1;
  ctx.end_time = -1;
  ctx.snapshot_time = -1;
  ctx.subtitles.main = [];
  ctx.subtitles.secondary = [];
}

function startRecording(ctx: RecordingContext) {
  let time = mp.get_property_number("time-pos");
  ctx.start_time = time;
  ctx.snapshot_time = time;
  addCurrentSubtitles(ctx);
}

function addCurrentSubtitles(ctx: RecordingContext) {
  const [main, secondary] = get_current_subtitles();
  if (main) ctx.subtitles.main.push(main);
  if (secondary) ctx.subtitles.secondary.push(secondary);
}

function renderMenu(app: App) {
  app.ass.text = "";
  const { width, height } = mp.get_osd_size();
  app.overlay.res_x = width;
  app.overlay.res_y = height;
  app.ass.setsize(36);
  app.ass.bold("KEYMAPS:").newline();
  app.ass.tab().append(`${app.cfg.shortcuts.start_recording} - start recording`).newline();
  app.ass.tab().append(`${app.cfg.shortcuts.word_lookup} - enter and lookup word in dictionary`).newline();
  app.ass.tab().append(`${app.cfg.shortcuts.menu_close} - close menu`).newline();
  app.ass.tab().append(`${app.cfg.shortcuts.set_screenshot} - set screenshot`).newline();
  app.ass.tab().append(`${app.cfg.shortcuts.create_ankicard} - create ankicard`).newline();
  app.ass.tab().append(`${app.cfg.shortcuts.create_ankicard_gui} - create ankicard from anki gui`).newline();
  app.ass.bold(`Captured context:`).newline();
  app.ass.tab().append(`Recording start time: ${app.ctx.start_time.toFixed(1)}`).newline();
  app.ass.tab().append(`Recording end time: ${app.ctx.end_time.toFixed(1)}`).newline();
  app.ass.tab().append(`Main subtitles: `).newline();
  app.ass.setsize(25);
  for (let s of app.ctx.subtitles.main) {
    app.ass.tab().tab().append(s).newline();
  }

  app.overlay.data = app.ass.text;
  app.overlay.update();
}

function clearMenu(app: App) {
  app.overlay.data = "";
  app.ass.text = "";
  app.overlay.update();
}

async function main() {
  mp.register_event("seek", function() {
    resetRecording(ctx);
    renderMenu(app);
    print("RECORDING ABORTED");
  })

  mp.add_key_binding(config.shortcuts.start_recording, "start_recording", function() {
    startRecording(app.ctx);
  });

  mp.add_key_binding(config.shortcuts.menu_open, "menu_open", function() {
    renderMenu(app);
  });

  mp.add_key_binding(config.shortcuts.menu_close, "menu_close", function() {
    clearMenu(app)
  });

  mp.add_key_binding(config.shortcuts.create_ankicard, "create_ankicard", function() {
    create_anki_note(config, ctx);
  });


  mp.observe_property("sub-text", "string", function() {
    if (app.ctx.start_time == -1) {
      return;
    }
    addCurrentSubtitles(app.ctx);
    renderMenu(app);
  });

  mp.observe_property("time-pos", "number", function() {
    if (app.ctx.start_time == -1) {
      return;
    }
    let time = mp.get_property_number("time-pos");
    app.ctx.end_time = time;
    renderMenu(app);
  })

  mp.add_key_binding(config.shortcuts.word_lookup, "word_lookup", function() {
    mp.input.get({
      prompt: "Enter word for dictionary lookup and export: ",
      submit: function(value) {
        mp.input.terminate();
      },
    })
  });

};

main();
