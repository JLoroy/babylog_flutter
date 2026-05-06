import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

const HOSTING_ORIGIN = 'https://babylog-flutter.web.app';

test('public policy URLs are prepared for Firebase Hosting and Play Console', async () => {
  const [listing, deployRunbook] = await Promise.all([
    readFile('docs/play-store-listing.md', 'utf8'),
    readFile('docs/firebase-hosting-deploy.md', 'utf8'),
  ]);

  for (const required of [
    `${HOSTING_ORIGIN}/privacy-policy`,
    `${HOSTING_ORIGIN}/delete-account`,
    'Deployment verified: 2026-05-06',
    'privacy@lenacho.be',
    'firebase deploy --only hosting',
  ]) {
    assert.match(`${listing}\n${deployRunbook}`, new RegExp(escapeRegExp(required)));
  }
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
