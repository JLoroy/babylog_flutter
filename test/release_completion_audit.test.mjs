import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('release completion audit tracks objective evidence and blockers', async () => {
  const audit = await readFile('docs/release-completion-audit.md', 'utf8');

  for (const required of [
    'Make Babylog a fully released and professional app available on the Play Store',
    'downloaded by at least 1000 users',
    'Current audit result:',
    'Not achieved.',
    'green remote runs including `25424811883`',
    'commit `298e983`',
    '`25425216927` for commit `2bb528a`',
    'docs/play-assets/screenshots/2026-05-06-local-release-screenshot-set.json',
    'sign-in, synthetic shared timeline, Settings/BYOK, Privacy Policy, and microphone permission',
    'redacts reviewer email and assistant id',
    'Upload/confirm in Play Console',
    'Recorder-created first event evidence still requires BYOK/internal-test validation',
    'docs/qa-evidence/2026-05-06-byok-key-save-smoke.json',
    'shows it masked after app restart',
    'Firestore has `byok: true` with no `apikey` field',
    'Real limited OpenAI key recording/transcription',
    'No Play Console internal test, review, production release, or live listing',
    '1000-user/download target is paused',
    'The `.aab` uploaded to Play Console and accepted for the chosen track',
    'Public Google Play listing URL showing Babylog available to users',
    'Play Console/Firebase metric',
    'showing at least 1000 downloads/users',
  ]) {
    assert.match(audit, new RegExp(escapeRegExp(required)));
  }
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
