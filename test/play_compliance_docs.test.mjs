import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

const docs = [
  'docs/privacy-policy-draft.md',
  'docs/account-deletion-web-copy.md',
  'docs/play-console-compliance.md',
];

test('Play compliance docs use the current public identity and URLs', async () => {
  const content = (await Promise.all(docs.map((path) => readFile(path, 'utf8')))).join('\n');

  for (const required of [
    'Developer: Nacho',
    'privacy@lenacho.be',
    'https://babylog-flutter.web.app/privacy-policy',
    'https://babylog-flutter.web.app/delete-account',
    '18 and over',
    'not intended to be enrolled in Families',
    'First-release architecture decision: keep BYOK-only direct OpenAI calls',
  ]) {
    assert.match(content, new RegExp(escapeRegExp(required)));
  }

  assert.doesNotMatch(content, /TODO: support email/);
  assert.doesNotMatch(content, /TODO: final developer/);
  assert.doesNotMatch(content, /privacy@eranova\.be/);
  assert.doesNotMatch(content, /public web deletion request URL still\s+needs to be published/);
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
