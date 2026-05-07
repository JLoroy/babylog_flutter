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
    'Firebase Google Sign-In Checklist',
    'Authentication > Sign-in method',
    'A6:BF:3B:93:62:71:6B:FA:C3:B2:F1:23:D0:7D:DC:F1:A7:86:B2:5A',
    '4A:CA:E5:0B:D3:5D:37:5F:03:63:C6:47:FC:32:7B:0B:35:D0:4D:A3:09:BA:E6:05:E6:0E:F5:F4:C4:9F:05:CA',
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
