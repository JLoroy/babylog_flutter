import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('Play Console app content draft includes required review answers', async () => {
  const draft = await readFile('docs/play-console-app-content.md', 'utf8');

  for (const required of [
    '## App Access',
    'Some or all functionality is restricted.',
    '## Ads Declaration',
    'No, this app does not contain ads.',
    '## Target Audience And Content',
    '18 and over.',
    'not primarily child-directed',
    "reviewer's own OpenAI API key",
    'OpenAI BYOK test key: none',
    '## Content Rating Questionnaire Draft',
    'Utility, Productivity, Communication, or Other.',
    'android.permission.RECORD_AUDIO',
  ]) {
    assert.match(draft, new RegExp(escapeRegExp(required)));
  }
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
