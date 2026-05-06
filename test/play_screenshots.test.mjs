import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';
import { createHash } from 'node:crypto';

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
    'babylog_api35',
    'Android 15 / API 35',
    'docs/qa-evidence/2026-05-06-release-apk-launch.png',
    'docs/qa-evidence/2026-05-06-release-apk-qa-timeline-after-firebase-upgrade.png',
    'docs/qa-evidence/2026-05-06-release-apk-account-deletion-before.png',
    'docs/qa-evidence/2026-05-06-release-apk-account-deletion-confirm.png',
    'docs/qa-evidence/2026-05-06-release-apk-account-deletion-after.png',
    'Firebase Auth/UI upgrade',
    'timeline shell loads',
    'Account deletion release APK smoke screenshots',
    'docs/play-assets/screenshots/2026-05-06-local-release-screenshot-set.json',
    'docs/play-assets/screenshots/phone-00-sign-in.png',
    'docs/play-assets/screenshots/phone-01-shared-timeline.png',
    'docs/play-assets/screenshots/phone-02-settings.png',
    'docs/play-assets/screenshots/phone-03-privacy-policy.png',
    'docs/play-assets/screenshots/phone-04-recording-permission.png',
    'recorder-created event validation still needs a real BYOK key',
  ]) {
    assert.match(plan, new RegExp(escapeRegExp(required)));
  }

  const screenshotSet = JSON.parse(
    await readFile(
      'docs/play-assets/screenshots/2026-05-06-local-release-screenshot-set.json',
      'utf8',
    ),
  );
  assert.equal(screenshotSet.device.avd, 'babylog_api35');
  assert.equal(screenshotSet.device.android, 'Android 15 / API 35');
  assert.equal(screenshotSet.app.package, 'com.eranova.babylog');
  assert.equal(screenshotSet.app.version, '1.0.2+3');
  assert.equal(screenshotSet.dataReview.usesSyntheticBabyName, true);
  assert.equal(screenshotSet.dataReview.usesTestReviewerAccountOnly, true);
  assert.equal(screenshotSet.dataReview.showsOpenAiApiKey, false);
  assert.equal(screenshotSet.dataReview.showsPassword, false);
  assert.equal(
    screenshotSet.dataReview.redactsReviewerEmailAndAssistantId,
    true,
  );
  assert.equal(screenshotSet.dataReview.containsRealChildData, false);
  assert.deepEqual(
    screenshotSet.screenshots.map((screenshot) => screenshot.purpose),
    [
      'signIn',
      'sharedTimeline',
      'settingsAndByok',
      'privacyPolicy',
      'recordingPermission',
    ],
  );

  for (const screenshot of screenshotSet.screenshots) {
    const image = await readFile(screenshot.path);
    const sha256 = createHash('sha256').update(image).digest('hex');
    assert.equal(sha256, screenshot.sha256);
  }

  const screenshot = await readFile(
    'docs/qa-evidence/2026-05-06-release-apk-launch.png',
  );
  assert.equal(screenshot.toString('ascii', 1, 4), 'PNG');
  assert.equal(screenshot.readUInt32BE(16), 1080);
  assert.equal(screenshot.readUInt32BE(20), 2400);

  const timelineScreenshot = await readFile(
    'docs/qa-evidence/2026-05-06-release-apk-qa-timeline-after-firebase-upgrade.png',
  );
  assert.equal(timelineScreenshot.toString('ascii', 1, 4), 'PNG');
  assert.equal(timelineScreenshot.readUInt32BE(16), 1080);
  assert.equal(timelineScreenshot.readUInt32BE(20), 2400);

  for (const screenshotPath of [
    'docs/play-assets/screenshots/phone-00-sign-in.png',
    'docs/play-assets/screenshots/phone-01-shared-timeline.png',
    'docs/play-assets/screenshots/phone-02-settings.png',
    'docs/play-assets/screenshots/phone-03-privacy-policy.png',
    'docs/play-assets/screenshots/phone-04-recording-permission.png',
    'docs/qa-evidence/2026-05-06-release-apk-account-deletion-before.png',
    'docs/qa-evidence/2026-05-06-release-apk-account-deletion-confirm.png',
    'docs/qa-evidence/2026-05-06-release-apk-account-deletion-after.png',
  ]) {
    const image = await readFile(screenshotPath);
    assert.equal(image.toString('ascii', 1, 4), 'PNG');
    assert.equal(image.readUInt32BE(16), 1080);
    assert.equal(image.readUInt32BE(20), 2400);
  }
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
