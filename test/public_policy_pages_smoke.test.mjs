import { createHash } from 'node:crypto';
import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('public policy page smoke evidence is non-secret and browser-captured', async () => {
  const evidence = JSON.parse(
    await readFile(
      'docs/qa-evidence/2026-05-06-public-policy-pages-smoke.json',
      'utf8',
    ),
  );

  assert.equal(evidence.hostingOrigin, 'https://babylog-flutter.web.app');
  assert.equal(evidence.browser, 'Google Chrome headless');
  assert.deepEqual(evidence.viewport, { width: 1280, height: 1600 });

  for (const value of Object.values(evidence.checks)) {
    assert.equal(value, true);
  }

  assert.deepEqual(
    evidence.pages.map((page) => page.name),
    ['privacy-policy', 'delete-account'],
  );
  assert.deepEqual(
    evidence.pages.map((page) => page.url),
    [
      'https://babylog-flutter.web.app/privacy-policy',
      'https://babylog-flutter.web.app/delete-account',
    ],
  );

  for (const page of evidence.pages) {
    const image = await readFile(page.screenshot);
    assert.equal(image.toString('ascii', 1, 4), 'PNG');
    assert.equal(image.readUInt32BE(16), 1280);
    assert.equal(image.readUInt32BE(20), 1600);
    assert.equal(createHash('sha256').update(image).digest('hex'), page.sha256);
  }

  assert.match(evidence.note, /without app authentication/);
  assert.match(evidence.note, /Play Console still needs these URLs copied/);
});
