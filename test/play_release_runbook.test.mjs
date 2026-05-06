import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('Play release runbook covers upload, internal testing, production, and monitoring', async () => {
  const runbook = await readFile('docs/play-release-runbook.md', 'utf8');

  for (const required of [
    'Prepare and roll out a release',
    'Set up an open, closed, or internal test',
    'flutter build appbundle --release',
    'build/app/outputs/bundle/release/app-release.aab',
    'npm run test:compliance-docs',
    'npm run test:firestore-indexes',
    'npm run test:play-submit-packet',
    'npm run test:play-release-notes',
    'synthetic sample assistant',
    'documented BYOK-only behavior',
    '## Internal Testing Release',
    '## Internal Testing QA',
    '## Production Release',
    '## Post-Release Monitoring',
    '1000-user acquisition target is resumed',
  ]) {
    assert.match(runbook, new RegExp(escapeRegExp(required)));
  }
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
