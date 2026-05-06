import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('Play policy freshness notes current official release-sensitive requirements', async () => {
  const [freshness, buildGradle, audit, workflow, verification] = await Promise.all([
    readFile('docs/play-policy-freshness.md', 'utf8'),
    readFile('android/app/build.gradle.kts', 'utf8'),
    readFile('docs/release-completion-audit.md', 'utf8'),
    readFile('.github/workflows/flutter-ci.yml', 'utf8'),
    readFile('docs/release-verification.md', 'utf8'),
  ]);

  for (const required of [
    'Last checked: 2026-05-06',
    'https://developer.android.com/google/play/requirements/target-sdk?hl=en',
    'https://support.google.com/googleplay/android-developer/answer/9859455',
    'https://support.google.com/googleplay/android-developer/answer/13327111',
    'Android 15 / API level 35 or higher',
    'active privacy policy URL',
    'no ads',
    'local-only reviewer password file',
    'without reinstalling the app',
    '`targetSdk = 35`',
    '`compileSdk = 36`',
    'not release evidence',
  ]) {
    assert.match(freshness, new RegExp(escapeRegExp(required), 'i'));
  }

  assert.match(buildGradle, /targetSdk\s*=\s*35/);
  assert.match(buildGradle, /compileSdk\s*=\s*36/);
  assert.match(audit, /docs\/play-policy-freshness\.md/);
  assert.match(workflow, /npm run test:play-policy-freshness/);
  assert.match(verification, /npm run test:play-policy-freshness/);
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
