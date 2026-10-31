#!/usr/bin/env node
const fs = require('fs');
const path = require('path');
const MarkdownIt = require('markdown-it');
const md = new MarkdownIt();

const args = process.argv.slice(2);
if (args.length < 2) {
    console.error('usage: node tools/build.js <source.md> <dest.html>');
    process.exit(1);
}

const [src, dest] = args;
const content = fs.readFileSync(src, 'utf8');
const title = path.basename(src, '.md')
  .replace(/-/g, ' ')
  .replace(/\b\w/g, (c) => c.toUpperCase());
const html = `<!doctype html>\n<html lang="en">\n<meta charset="utf-8">\n<title>${title}</title>\n${md.render(content)}`;
fs.writeFileSync(dest, html);
