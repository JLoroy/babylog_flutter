import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('Play reviewer access notes cover restricted auth and BYOK review path', async () => {
  const notes = await readFile('docs/play-reviewer-access.md', 'utf8');

  for (const required of [
    'Some or all functionality is restricted',
    'Firebase email/password authentication',
    'Reviewer account',
    'Email: `test@era-nova.be`',
    'reset email requested on 2026-05-06',
    'Assistant id: `play-reviewer-assistant`',
    'email verified',
    'BYOK-only',
    'Do not provide an OpenAI test key',
    "reviewer's own OpenAI API key",
    'non-AI timeline',
    'Do not enter real child data',
    'Delete Account',
    'Privacy Policy',
  ]) {
    assert.match(notes, new RegExp(escapeRegExp(required)));
  }
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
