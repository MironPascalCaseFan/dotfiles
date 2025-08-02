import "mpv-promise";

async function sleep(t: number) {
  return new Promise((resolve) => {
    setTimeout(resolve, Math.abs(t) || 0);
  });
}

async function main() {
  while (true) {
    await sleep(1000);
    mp.osd_message(mp.get_time().toString());
    await sleep(500);
    mp.osd_message(mp.get_time().toString());
  }
}

main();
