import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('growth metrics plan defines proof for the 1000-user objective', async () => {
  const plan = await readFile('docs/growth-metrics.md', 'utf8');

  for (const required of [
    'Google Play Console user acquisitions / installs',
    'At least 1000 Play Store user acquisitions or installs',
    'Firebase Auth unique user count',
    'supporting evidence, not a replacement',
    'Current completion status:',
    'Not achieved.',
    'Update `STATUS.md` and `docs/release-completion-audit.md`',
    'Do not use repository stars, website visits, debug APK installs',
  ]) {
    assert.match(plan, new RegExp(escapeRegExp(required)));
  }
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
