#!/usr/bin/env node

const args = process.argv.slice(2);

if (args.length !== 2) {
  throw new Error("Invalid number of arguments");
}

function colourLog(text:string, bg?:Array<number>, fg:string='') {
  let bgStr = '';
  if (!!bg) bgStr = `\x1b[48;2;${bg[0]};${bg[1]};${bg[2]}m`;
  console.log(`${bgStr+fg}%s\x1b[0m`, text);
}

function boldLog(text:string) {
  console.log('\x1b[1m%s\x1b[0m', text);
}

const hex = args[0].replace('#', '');
const tintFactor = parseInt(args[1], 10) / 100;
const shadeFactor = 1 - tintFactor;

let rgb = [];
for (let i=0; i<3; i++) {
  rgb.push(parseInt(hex.slice(i*2,i*2+2), 16));
}

function shade(value:number) {
  return Math.round(value*shadeFactor);
}

function tint(value:number) {
  return Math.round(value + ((255 - value) * tintFactor));
}

let rgbs = []; let hexs = '#';
let rgbt = []; let hext = '#';

for (let i=0; i<rgb.length; i++) {
  // Generate tint and shade
  const shaded = shade(rgb[i]);
  const tinted = tint(rgb[i]);

  // RGB
  rgbs.push(shaded); rgbt.push(tinted);

  // HEX
  let hs = shaded.toString(16).toUpperCase(); let ht = tinted.toString(16).toUpperCase();
  const hsCount = (hs.length === 1) ? 2 : 1;
  const htCount = (ht.length === 1) ? 2 : 1;
  hexs+=hs.repeat(hsCount); hext+=ht.repeat(htCount);
}

let rgbsStr = `rgb(${rgbs[0]}, ${rgbs[1]}, ${rgbs[2]})`;
let rgbtStr = `rgb(${rgbt[0]}, ${rgbt[1]}, ${rgbt[2]})`;

function textColour(rgb:Array<number>) {
  // Formula from https://www.w3.org/TR/AERT/#color-contrast
  const brightness = Math.round( ((rgb[0] * 299) + (rgb[1] * 587) + (rgb[2] * 114)) / 1000 );
  return (brightness > 125) ? '\x1b[30m' : '\x1b[37m';
}

let fg = textColour(rgbs);
let tbPadding = ' '.repeat(rgbsStr.length + 4);  // 4 is for side padding
let hexPadding = ' '.repeat(rgbsStr.length - 7);  // 7 is the length of a hex colour code
boldLog("Shade:");
colourLog(`${tbPadding}\n  ${hexs+hexPadding}  \n  ${rgbsStr}  \n${tbPadding}`, rgbs, fg);

console.log('');

fg = textColour(rgbt);
tbPadding = ' '.repeat(rgbtStr.length + 4);  // See comments above
hexPadding = ' '.repeat(rgbtStr.length - 7);
boldLog("Tint:");
colourLog(`${tbPadding}\n  ${hext+hexPadding}  \n  ${rgbtStr}  \n${tbPadding}`, rgbt, fg);

