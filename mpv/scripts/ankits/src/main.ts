// polyfills
import "core-js/full/map";
import "core-js/full/set";
import 'core-js/es/typed-array';
import "core-js/full/array";
import "core-js/full/string";
import "core-js/full/promise";

import AssDraw from "mpv-assdraw";
import { parse } from "parse5";
import HttpClient from "HttpClient";
let http = new HttpClient();
let ass = new AssDraw();

const document = parse('<!DOCTYPE html><html><head></head><body>Hi there!</body></html>');

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
