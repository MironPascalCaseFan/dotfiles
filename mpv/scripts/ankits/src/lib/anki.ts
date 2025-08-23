import { Config, RecordingContext } from "../types";
import { createAudio, createSnapshot, generate_media_name } from "./media";

export function anki_connect(opts: {
  action: string,
  t_params: any,
  url: string,
}): void {

  let req = {
    action: opts.action,
    version: 6,
    params: opts.t_params,
  }

  let json = JSON.stringify(req);
  let cmd = ["curl", opts.url, "-X", "POST", "-d", json]
  let result = mp.command_native({
    name: 'subprocess',
    args: cmd,
    capture_stdout: true,
    capture_stderr: true,
  })

  let response = JSON.parse(result.stdout);

  return response.result, response.error

}

export function create_anki_note(cfg: Config, ctx: RecordingContext): void {
  let filename_prefix = generate_media_name();

  let filename_audio = createAudio({
    mediaPath: cfg.media_path,
    filenamePrefix: filename_prefix,
    startTime: ctx.start_time,
    endTime: ctx.end_time,
  })

  let filename_snapshot = createSnapshot({
    mediaPath: cfg.media_path,
    filenamePrefix: filename_prefix,
    snapshotTime: ctx.snapshot_time,
  })
  print(`filename snapshot: ${filename_snapshot}`);
  let fields = {};
  fields[cfg.field_audio] = `[sound:${filename_audio}]`;
  fields[cfg.field_snapshot] = `<img src="${filename_snapshot}">`;
  fields[cfg.field_subtitle1] = ctx.subtitles.main.join("\n");
  fields[cfg.field_subtitle2] = ctx.subtitles.secondary.join("\n");
  fields[cfg.field_title] = "word not defiend yet";

  let params = {
    note: {
      deckName: cfg.deckname,
      modelName: cfg.modelName,
      fields: fields,
    }
  }

  print("ready to export http post: ");
  dump(params);

  anki_connect({
    action: "guiAddCards",
    t_params: params,
    url: cfg.anki_url,
  })

}





