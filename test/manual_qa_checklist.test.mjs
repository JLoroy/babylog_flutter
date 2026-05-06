import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('manual QA checklist covers release-critical flows', async () => {
  const checklist = await readFile('docs/manual-qa-checklist.md', 'utf8');

  for (const required of [
    '## Test Environment',
    '## Test Data Rules',
    'Install and launch',
    'Sign up',
    'Email verification',
    'Assistant creation',
    'Privacy Policy access',
    'BYOK key save',
    'Recording permission',
    'First recording',
    'First event creation',
    'Restart persistence',
    'Shared assistant join',
    'Delete event',
    'Delete account',
    'Reauthentication edge',
    'Public deletion page',
    'Public privacy page',
    '## Firebase Console Evidence',
    '## Play Review Inputs',
    '1.0.2+3',
    'build/app/outputs/bundle/release/app-release.aab',
    '11ccb6bd27a564f9772725b8ef10fdd1762c55cb1e2a38abffa7d78d1572f283',
    'babylog-flutter',
    'flutter devices',
    'Android 15 / API 35',
    'flutter emulators',
    'babylog_api35',
    'adb install -r',
    'docs/qa-evidence/2026-05-06-release-apk-launch.png',
    'docs/qa-evidence/2026-05-06-release-apk-qa-timeline-after-firebase-upgrade.png',
    'docs/qa-evidence/2026-05-06-disposable-qa-firestore-smoke.json',
    'docs/qa-evidence/2026-05-06-account-deletion-smoke.json',
    'docs/qa-evidence/2026-05-06-release-apk-account-deletion-before.png',
    'docs/qa-evidence/2026-05-06-release-apk-account-deletion-confirm.png',
    'docs/qa-evidence/2026-05-06-release-apk-account-deletion-after.png',
    '.qa-secrets/current-qa-account.json',
    '.qa-secrets/deletion-qa-account.json',
    'qa202605060729068d@example.com',
    'codexqa20260506072958350d',
    'deleteqa20260506075317ad1d03@example.com',
    'codexdeleteqa20260506075317ad1d03',
    'restAuthSignInRejectedAfterDeletion',
    'current assistant reference',
    'test@era-nova.be',
    'play-reviewer-assistant',
    'documented BYOK-only review',
    'https://babylog-flutter.web.app/privacy-policy',
    'https://babylog-flutter.web.app/delete-account',
    '## Sign-Off',
  ]) {
    assert.match(checklist, new RegExp(escapeRegExp(required)));
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

  const smoke = JSON.parse(
    await readFile(
      'docs/qa-evidence/2026-05-06-disposable-qa-firestore-smoke.json',
      'utf8',
    ),
  );
  assert.equal(smoke.firebaseProject, 'babylog-flutter');
  assert.equal(smoke.appPackage, 'com.eranova.babylog');
  assert.equal(smoke.qaUser.email, 'qa202605060729068d@example.com');
  assert.equal(smoke.qaUser.uid, 'codexqa20260506072958350d');
  assert.equal(smoke.qaUser.emailVerified, true);
  assert.match(smoke.qaUser.password, /not committed/);
  for (const key of [
    'restAuthSignIn',
    'userDocExists',
    'userDocEmailMatches',
    'currentAssistantReferenceCreated',
    'assistantDocExists',
    'assistantUsersContainsQaEmail',
  ]) {
    assert.equal(smoke.checks[key], true, `${key} should pass`);
  }
  assert.equal(
    smoke.screenshots[0],
    'docs/qa-evidence/2026-05-06-release-apk-qa-timeline-after-firebase-upgrade.png',
  );

  const deletionSmoke = JSON.parse(
    await readFile(
      'docs/qa-evidence/2026-05-06-account-deletion-smoke.json',
      'utf8',
    ),
  );
  assert.equal(deletionSmoke.firebaseProject, 'babylog-flutter');
  assert.equal(deletionSmoke.appPackage, 'com.eranova.babylog');
  assert.equal(
    deletionSmoke.qaUser.email,
    'deleteqa20260506075317ad1d03@example.com',
  );
  assert.equal(
    deletionSmoke.qaUser.uid,
    'codexdeleteqa20260506075317ad1d03',
  );
  assert.match(deletionSmoke.qaUser.password, /not committed/);
  for (const key of [
    'restAuthSignIn',
    'userDocExists',
    'currentAssistantReferenceExists',
    'assistantDocExists',
    'assistantUsersContainsQaEmail',
    'syntheticEventCreated',
  ]) {
    assert.equal(deletionSmoke.beforeDeletion[key], true, `${key} should pass`);
  }
  for (const key of [
    'appReturnedToSignInScreen',
    'restAuthSignInRejectedAfterDeletion',
    'userDocDeleted',
    'assistantDocDeleted',
    'syntheticEventDeleted',
  ]) {
    assert.equal(deletionSmoke.afterDeletion[key], true, `${key} should pass`);
  }
  for (const screenshotPath of Object.values(deletionSmoke.screenshots)) {
    const image = await readFile(screenshotPath);
    assert.equal(image.toString('ascii', 1, 4), 'PNG');
    assert.equal(image.readUInt32BE(16), 1080);
    assert.equal(image.readUInt32BE(20), 2400);
  }
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
