import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('Play screenshot plan covers required sanitized phone screenshots', async () => {
  const plan = await readFile('docs/play-screenshots.md', 'utf8');

  for (const required of [
    'Sign in',
    'Settings and Privacy Policy',
    'Shared timeline',
    'Recording permission',
    'First event',
    'Delete Account',
    'synthetic baby names only',
    'Do not show OpenAI API keys',
    'docs/manual-qa-checklist.md',
    'Final Android build',
    'babylog_api35',
    'Android 15 / API 35',
    'docs/qa-evidence/2026-05-06-release-apk-launch.png',
  ]) {
    assert.match(plan, new RegExp(escapeRegExp(required)));
  }

  const screenshot = await readFile(
    'docs/qa-evidence/2026-05-06-release-apk-launch.png',
  );
  assert.equal(screenshot.toString('ascii', 1, 4), 'PNG');
  assert.equal(screenshot.readUInt32BE(16), 1080);
  assert.equal(screenshot.readUInt32BE(20), 2400);
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
