import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('Firebase Hosting serves the public policy pages', async () => {
  const firebaseConfig = JSON.parse(await readFile('firebase.json', 'utf8'));
  const firebaseRc = JSON.parse(await readFile('.firebaserc', 'utf8'));

  assert.equal(firebaseRc.projects.default, 'babylog-flutter');

  assert.equal(firebaseConfig.hosting.public, 'docs/public');
  assert.equal(firebaseConfig.hosting.cleanUrls, true);
  assert.deepEqual(firebaseConfig.hosting.ignore, [
    'firebase.json',
    '**/.*',
    '**/node_modules/**',
  ]);

  const rewrites = firebaseConfig.hosting.rewrites ?? [];
  assert.deepEqual(rewrites, [
    { source: '/', destination: '/privacy-policy.html' },
  ]);
});
