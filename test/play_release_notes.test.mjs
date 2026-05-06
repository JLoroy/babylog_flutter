import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('Android release notes match the current Play release scope', async () => {
  const [notes, listing] = await Promise.all([
    readFile('android/app/releasenotes.md', 'utf8'),
    readFile('docs/play-store-listing.md', 'utf8'),
  ]);

  for (const required of [
    '<en-US>',
    '<fr-FR>',
  ]) {
    assert.match(notes, new RegExp(escapeRegExp(required)));
  }

  for (const required of [
    'safer account deletion',
    'local-only OpenAI key handling',
    'tested Firebase security rules',
    'Play policy pages',
    'Android release signing',
  ]) {
    assert.match(notes, new RegExp(escapeRegExp(required)));
    assert.match(listing, new RegExp(escapeRegExp(required)));
  }

  assert.doesNotMatch(notes, /advanced Generative AI/);
  assert.doesNotMatch(notes, /Propulsé par une IA générative avancée/);
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
