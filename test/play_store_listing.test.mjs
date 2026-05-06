import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('Play Store listing draft stays within Google Play text limits', async () => {
  const listing = await readFile('docs/play-store-listing.md', 'utf8');

  const appName = extractBlock(listing, 'App name:', 'Short description:');
  const shortDescription = extractBlock(
    listing,
    'Short description:',
    'Full description:',
  );
  const fullDescription = extractBlock(
    listing,
    'Full description:',
    '## Release Notes',
  );

  assert.equal(appName, 'Babylog');
  assert.ok(appName.length <= 30, 'App name must be 30 chars or less');
  assert.ok(
    shortDescription.length <= 80,
    'Short description must be 80 chars or less',
  );
  assert.ok(
    fullDescription.length <= 4000,
    'Full description must be 4000 chars or less',
  );
  assert.doesNotMatch(fullDescription, /#1|best|free|limited time/i);
  assert.match(fullDescription, /published web\s+deletion request page/);
  assert.doesNotMatch(fullDescription, /prepared for Play Console publication/);
  assert.match(listing, /https:\/\/babylog-flutter\.web\.app\/privacy-policy/);
  assert.match(listing, /https:\/\/babylog-flutter\.web\.app\/delete-account/);
});

function extractBlock(markdown, start, end) {
  const startIndex = markdown.indexOf(start);
  const endIndex = markdown.indexOf(end, startIndex + start.length);

  assert.notEqual(startIndex, -1, `Missing ${start}`);
  assert.notEqual(endIndex, -1, `Missing ${end}`);

  return markdown
    .slice(startIndex + start.length, endIndex)
    .trim()
    .replace(/\n+/g, '\n');
}
