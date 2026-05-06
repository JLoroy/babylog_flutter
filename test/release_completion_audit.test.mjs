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
    '`25427451856` for commit `587f230`',
    '`25428242326` for commit `8a7bbf9`',
    'remote CI runs `25427451856` and `25428242326` built the debug APK on `main`',
    'docs/play-assets/screenshots/2026-05-06-local-release-screenshot-set.json',
    'sign-in, synthetic shared timeline, Settings/BYOK, Privacy Policy, and microphone permission',
    'redacts reviewer email and assistant id',
    'docs/qa-evidence/2026-05-06-public-policy-pages-smoke.json',
    'Published and browser-smoke-tested',
    'public policy page browser screenshots',
    'Upload/confirm in Play Console',
    'Recorder-created first event evidence still requires BYOK/internal-test validation',
    'docs/qa-evidence/2026-05-06-byok-key-save-smoke.json',
    'shows it masked after app restart',
    'Firestore has `byok: true` with no `apikey` field',
    'event deletion UI smoke JSON/screenshots',
    'restart persistence smoke JSON/screenshots',
    'docs/qa-evidence/2026-05-06-restart-persistence-smoke.json',
    'shared-assistant deletion smoke JSON/screenshots',
    'shared-assistant join UI smoke JSON/screenshots',
    'docs/qa-evidence/2026-05-06-shared-assistant-deletion-smoke.json',
    'docs/qa-evidence/2026-05-06-join-assistant-ui-smoke.json',
    'leaves the assistant doc with only the partner in `users`',
    'allows the partner to create a new event afterward',
    'deletion of a recorder-created event',
    'account deletion, shared-assistant join, and restart persistence',
    'Account deletion, existing-event UI deletion, and shared-assistant join are smoke-tested on the release APK',
    'Real limited OpenAI key recording/transcription',
    'Play Console internal testing evidence exists',
    'release `6 (1.0.5)` is active',
    'A local `1.0.6+7` / version code 7 AAB now supersedes it',
    'not reviewed',
    'production release, and live listing evidence still do not',
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
