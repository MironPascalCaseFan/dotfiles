
export function generate_media_name() {
  let name = mp.get_property("filename/no-ext");
  return name
}


function timeToString(seconds: number): string {
  return seconds.toString();
}

export function createAudio(opts: {
  mediaPath: string;
  filenamePrefix: string;
  startTime: number;
  endTime: number;
  aid?: number;
}): string {
  if (opts.startTime < 0 || opts.endTime < 0 || opts.startTime === opts.endTime) {
    return "";
  }

  // Swap if reversed
  if (opts.startTime > opts.endTime) {
    const tmp = opts.startTime;
    opts.startTime = opts.endTime;
    opts.endTime = tmp;
  }

  const filename = `${opts.filenamePrefix}_(${timeToString(opts.startTime)}-${timeToString(opts.endTime)}).mp3`;

  const encodeArgs = [
    "mpv",
    mp.get_property("path"),
    `--start=${opts.startTime}`,
    `--end=${opts.endTime}`,
    `--aid=${mp.get_property("aid")}`,
    "--vid=no",
    "--loop-file=no",
    `-o=${opts.mediaPath}${filename}`,
  ];
    print("audio capture params: ");
    dump(encodeArgs);

  const result = mp.command_native(({
    name: "subprocess",
    capture_stdout: true,
    capture_stderr: true,
    args: encodeArgs,
  }));
  print("audio captured: ");
  dump(result)

  return filename;
}

export function createSnapshot(opts: {
  mediaPath: string;
  filenamePrefix: string;
  snapshotTime: number;
  height?: number;
}): string {
  if (opts.snapshotTime <= 0) {
    return "";
  }

  const filename = `${opts.filenamePrefix}_${opts.snapshotTime.toFixed(0)}.png`;

  // https://github.com/mpv-player/mpv/issues/3735
  const encodeArgs = [
    "mpv",
    mp.get_property("path"),
    `--start=${opts.snapshotTime}`,
    "--frames=1",
    "--no-sub",
    // https://github.com/mpv-player/mpv/issues/9053
    `-o=${opts.mediaPath}${filename}`,
  ];
  print("snapshot params: ")
  dump(encodeArgs);

  const result = mp.command_native({
    name: "subprocess",
    args: encodeArgs,
    capture_stdout: true,
    capture_stderr: true,
  });

  mp.msg.info("snapshot result: ");
  dump(result);

  return filename;
}

export function get_current_subtitles() {
  let subs = (mp.get_property('sub-text') || "").replace(/\n/g, ' ');
  let secondary = (mp.get_property('secondary-sub-text') || "").replace(/\n/g, ' ');
  return [subs, secondary];
}
