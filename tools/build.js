#!/usr/bin/env node
// tools/build.js
const fs = require('fs');
const path = require('path');
const MarkdownIt = require('markdown-it');

const md = new MarkdownIt({
  html: false,
  linkify: true,
  typographer: true
});

// Convert Markdown into HTML
function renderPage(markdown, title) {
  return `<!doctype html>
<html lang="en">
<meta charset="utf-8">
<title>${title}</title>
${md.render(markdown)}</html>
`;
}

// Main build function
function main(argv) {
  const [src, dest] = argv;

  if (!src || !dest) {
    console.error('usage: build.js <source.md> <dest.html>');
    return 2;
  }

  const html = renderPage(
    fs.readFileSync(src, 'utf8'),
    path.basename(src, '.md')
  );

  fs.mkdirSync(path.dirname(dest), { recursive: true });
  fs.writeFileSync(dest, html);

  return 0;
}

// Export functions for testing
module.exports = { renderPage, main };

// Run only when executed directly
if (require.main === module) {
  process.exitCode = main(process.argv.slice(2));
}
