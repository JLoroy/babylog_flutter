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
    'found only macOS and Chrome',
    'found no Android emulator sources',
  ]) {
    assert.match(plan, new RegExp(escapeRegExp(required)));
  }
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
