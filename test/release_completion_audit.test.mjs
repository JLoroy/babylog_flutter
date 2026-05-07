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
    'green remote runs including `25467216242` for commit `fb74fc3`',
    'green v9 run `25479382853` for commit `01890e5`',
    'current green docs/blocker run `25479856820` for commit `db5f3af`',
    'Audited CI `25467216242` passed Firebase rules in 30s',
    'audited CI `25479382853` passed Firebase rules in 26s',
    'audited CI `25479856820` passed Firebase rules in 25s',
    'Analyze/test in 6m34s',
    'Analyze/test in 7m44s',
    'Google SSO config validation',
    'Analyze/test in 7m09s',
    'Android debug APK build',
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
    'docs/qa-evidence/2026-05-07-design-refresh-smoke.json',
    'leaves the assistant doc with only the partner in `users`',
    'allows the partner to create a new event afterward',
    'deletion of a recorder-created event',
    'account deletion, shared-assistant join, and restart persistence',
    'Account deletion, existing-event UI deletion, and shared-assistant join are smoke-tested on the release APK',
    'Google sign-in Firebase setup',
    'App-side implemented; Firebase Console unverified',
    'Firebase CLI and gcloud are both blocked by expired interactive credentials',
    'Enable Google provider in Firebase Authentication',
    'redownload `google-services.json`',
    'updated copy pending redeploy',
    'no `Google sign-in` text',
    'direct redacted endpoint smoke',
    'docs/qa-evidence/2026-05-07-openai-byok-endpoint-smoke.json',
    'Full in-app microphone recording/transcription',
    'Play Console internal testing evidence exists',
    'release `6 (1.0.5)` is active',
    'version code 7, that App access notes were added',
    'redacted committed evidence',
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
