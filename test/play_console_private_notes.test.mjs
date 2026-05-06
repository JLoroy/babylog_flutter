import { execFile } from 'node:child_process';
import { mkdtemp, readFile, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { promisify } from 'node:util';
import test from 'node:test';
import assert from 'node:assert/strict';

const execFileAsync = promisify(execFile);

test('private Play Console notes are generated only from a local reviewer secret', async () => {
  const tempRoot = await mkdtemp(join(tmpdir(), 'babylog-play-private-notes-'));
  const secretPath = join(tempRoot, 'reviewer.json');
  const outPath = join(tempRoot, 'notes.txt');

  try {
    await writeFile(
      secretPath,
      JSON.stringify(
        {
          email: 'test@era-nova.be',
          password: 'fake-reviewer-password-for-test-only',
          assistantId: 'play-reviewer-assistant',
          openaiApiKey: 'sk-test-openai-key-for-private-notes-only',
        },
        null,
        2,
      ),
    );

    await execFileAsync('node', [
      'scripts/prepare_play_console_private_notes.mjs',
      '--secret',
      secretPath,
      '--out',
      outPath,
    ]);

    const notes = await readFile(outPath, 'utf8');

    for (const required of [
      'WARNING: This file contains private reviewer credentials and an OpenAI API key.',
      'Play Console instructions field,',
      'Some or all functionality is restricted.',
      'Email: test@era-nova.be',
      'Password: fake-reviewer-password-for-test-only',
      'Assistant id: play-reviewer-assistant',
      'OpenAI API key: sk-test-openai-key-for-private-notes-only',
      'Enable "Bring your own API key".',
      'Babylog stores BYOK keys locally on-device, not in Firebase.',
      "Babylog is BYOK-only for OpenAI.",
      "Please do not delete the reviewer account",
    ]) {
      assert.match(notes, new RegExp(escapeRegExp(required)));
    }

    const conciseMatch = notes.match(
      /Play Console instructions field, (\d+)\/500 characters:\n(.+)\n\nReviewer instructions:/,
    );
    assert.ok(conciseMatch);
    const [, reportedLength, conciseInstructions] = conciseMatch;
    assert.equal(Number(reportedLength), conciseInstructions.length);
    assert.ok(conciseInstructions.length <= 500);
    assert.match(
      conciseInstructions,
      /Login test@era-nova\.be \/ fake-reviewer-password-for-test-only\./,
    );
    assert.match(
      conciseInstructions,
      /paste: sk-test-openai-key-for-private-notes-only/,
    );

    const [script, docs] = await Promise.all([
      readFile('scripts/prepare_play_console_private_notes.mjs', 'utf8'),
      readFile('docs/play-console-handoff.md', 'utf8'),
    ]);

    assert.match(script, /dist\/play-console-handoff\/private\/play-console-app-access-notes\.txt/);
    assert.match(script, /\.qa-secrets\/play-reviewer-account\.json/);

    for (const required of [
      'npm run prepare:play-private-notes',
      'Run `npm run prepare:play-handoff` first',
      'dist/play-console-handoff/private/play-console-app-access-notes.txt',
      'contains the reviewer password',
      'Never',
    ]) {
      assert.match(docs, new RegExp(escapeRegExp(required)));
    }
  } finally {
    await rm(tempRoot, { recursive: true, force: true });
  }
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
