import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('Play Console evidence template covers release acceptance proof without secrets', async () => {
  const evidenceDoc = await readFile('docs/play-console-evidence.md', 'utf8');

  for (const required of [
    '# Babylog Play Console Evidence',
    'Status: pending Console capture',
    'Do not commit unredacted reviewer passwords',
    'AAB uploaded and accepted',
    'Internal testing release rolled out',
    'Production release available',
    'Public Play listing URL',
    'Privacy policy URL configured',
    'Account deletion URL configured',
    'App access notes saved',
    'Data safety accepted',
    'Content rating accepted',
    'Target audience accepted',
    'Ads declaration accepted',
    'Store listing media accepted',
    'SDK/data disclosure reviewed',
    'Developer identity/contact reviewed',
    '1000 installs/acquisitions evidence',
    'docs/release-completion-audit.md',
    'STATUS.md',
  ]) {
    assert.match(evidenceDoc, new RegExp(escapeRegExp(required)));
  }

  assert.doesNotMatch(evidenceDoc, /Password:\s*\S+/);
  assert.doesNotMatch(evidenceDoc, /sk-[A-Za-z0-9]/);
  assert.doesNotMatch(evidenceDoc, /ya29|1\/\//);
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
