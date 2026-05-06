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
    '1.0.6+7',
    'build/app/outputs/bundle/release/app-release.aab',
    'b2c95f5489acfa076bd054e8d6733df8b9ed31eef3396f74b2d1e8f178c9d6b5',
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
    'docs/qa-evidence/2026-05-06-event-delete-ui-smoke.json',
    'docs/qa-evidence/2026-05-06-release-apk-event-delete-before.png',
    'docs/qa-evidence/2026-05-06-release-apk-event-delete-after.png',
    'docs/qa-evidence/2026-05-06-shared-assistant-deletion-smoke.json',
    'docs/qa-evidence/2026-05-06-release-apk-shared-assistant-before-delete.png',
    'docs/qa-evidence/2026-05-06-release-apk-shared-assistant-delete-confirm.png',
    'docs/qa-evidence/2026-05-06-release-apk-shared-assistant-after-delete.png',
    'docs/qa-evidence/2026-05-06-join-assistant-ui-smoke.json',
    'docs/qa-evidence/2026-05-06-release-apk-join-assistant-before.png',
    'docs/qa-evidence/2026-05-06-release-apk-join-assistant-dialog.png',
    'docs/qa-evidence/2026-05-06-release-apk-join-assistant-after.png',
    'docs/qa-evidence/2026-05-06-release-apk-join-assistant-settings-after-refresh.png',
    'docs/qa-evidence/2026-05-06-public-policy-pages-smoke.json',
    'docs/qa-evidence/2026-05-06-public-privacy-policy-page.png',
    'docs/qa-evidence/2026-05-06-public-delete-account-page.png',
    'docs/qa-evidence/2026-05-06-release-apk-account-deletion-before.png',
    'docs/qa-evidence/2026-05-06-release-apk-account-deletion-confirm.png',
    'docs/qa-evidence/2026-05-06-release-apk-account-deletion-after.png',
    'docs/qa-evidence/2026-05-06-play-reviewer-access-smoke.json',
    'docs/qa-evidence/2026-05-06-release-apk-play-reviewer-timeline.png',
    '.qa-secrets/current-qa-account.json',
    '.qa-secrets/deletion-qa-account.json',
    '.qa-secrets/play-reviewer-account.json',
    'qa202605060729068d@example.com',
    'codexqa20260506072958350d',
    'deleteqa20260506075317ad1d03@example.com',
    'codexdeleteqa20260506075317ad1d03',
    'restAuthSignInRejectedAfterDeletion',
    'ui-delete-smoke-20260506090414',
    'shared-delete-smoke-20260506145235',
    'shared-delete-event-20260506145235',
    'shared-delete-partner-event-20260506145235',
    'sharedprimary20260506145235@example.com',
    'sharedpartner20260506145235@example.com',
    'join-ui-smoke-20260506151008',
    'join-ui-owner-event-20260506151008',
    'join-ui-joiner-event-20260506151008',
    'joinowner20260506151008@example.com',
    'joiner20260506151008@example.com',
    '.qa-secrets/join-assistant-qa-account.json',
    'play-reviewer-welcome',
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

  const reviewerScreenshot = await readFile(
    'docs/qa-evidence/2026-05-06-release-apk-play-reviewer-timeline.png',
  );
  assert.equal(reviewerScreenshot.toString('ascii', 1, 4), 'PNG');
  assert.equal(reviewerScreenshot.readUInt32BE(16), 1080);
  assert.equal(reviewerScreenshot.readUInt32BE(20), 2400);

  const eventDeleteSmoke = JSON.parse(
    await readFile(
      'docs/qa-evidence/2026-05-06-event-delete-ui-smoke.json',
      'utf8',
    ),
  );
  assert.equal(eventDeleteSmoke.firebaseProject, 'babylog-flutter');
  assert.equal(eventDeleteSmoke.appPackage, 'com.eranova.babylog');
  assert.equal(eventDeleteSmoke.reviewer.email, 'test@era-nova.be');
  assert.equal(eventDeleteSmoke.assistantId, 'play-reviewer-assistant');
  assert.equal(eventDeleteSmoke.eventId, 'ui-delete-smoke-20260506090414');
  assert.match(eventDeleteSmoke.reviewer.password, /not committed/);
  for (const key of [
    'restAuthSignIn',
    'syntheticEventCreatedBeforeUiDelete',
    'releaseApkDisplayedSyntheticEventBeforeDelete',
    'releaseApkDeleteMenuTapped',
    'syntheticEventHiddenAfterUiDelete',
    'reviewerSampleEventPreserved',
    'firestoreQueryAfterUiDeleteFindsNoSyntheticEvent',
  ]) {
    assert.equal(eventDeleteSmoke.checks[key], true, `${key} should pass`);
  }
  assert.deepEqual(
    eventDeleteSmoke.firestoreVerification.matchingDocumentNames,
    [],
  );
  assert.equal(
    eventDeleteSmoke.firestoreVerification.reviewerSampleDocumentNames[0],
    'projects/babylog-flutter/databases/(default)/documents/events/play-reviewer-welcome',
  );
  for (const screenshotPath of eventDeleteSmoke.screenshots) {
    const image = await readFile(screenshotPath);
    assert.equal(image.toString('ascii', 1, 4), 'PNG');
    assert.equal(image.readUInt32BE(16), 1080);
    assert.equal(image.readUInt32BE(20), 2400);
  }

  const sharedDeletionSmoke = JSON.parse(
    await readFile(
      'docs/qa-evidence/2026-05-06-shared-assistant-deletion-smoke.json',
      'utf8',
    ),
  );
  assert.equal(sharedDeletionSmoke.firebaseProject, 'babylog-flutter');
  assert.equal(sharedDeletionSmoke.appPackage, 'com.eranova.babylog');
  assert.equal(
    sharedDeletionSmoke.assistantId,
    'shared-delete-smoke-20260506145235',
  );
  assert.equal(
    sharedDeletionSmoke.eventId,
    'shared-delete-event-20260506145235',
  );
  assert.equal(
    sharedDeletionSmoke.afterEventId,
    'shared-delete-partner-event-20260506145235',
  );
  assert.equal(
    sharedDeletionSmoke.primary.email,
    'sharedprimary20260506145235@example.com',
  );
  assert.equal(
    sharedDeletionSmoke.partner.email,
    'sharedpartner20260506145235@example.com',
  );
  assert.match(sharedDeletionSmoke.primary.password, /not committed/);
  assert.match(sharedDeletionSmoke.partner.password, /not committed/);
  for (const key of [
    'primaryAuthSignInRejectedAfterDeletion',
    'partnerAuthSignInStillWorks',
    'assistantDocStillExistsForPartner',
    'assistantUsersOnlyPartnerRemain',
    'sharedAssistantEventsDeleted',
    'partnerCanCreateEventAfterPrimaryDeletion',
  ]) {
    assert.equal(sharedDeletionSmoke.checks[key], true, `${key} should pass`);
  }
  assert.deepEqual(
    sharedDeletionSmoke.firestore.assistantUsersAfterPrimaryDeletion,
    ['sharedpartner20260506145235@example.com'],
  );
  assert.deepEqual(sharedDeletionSmoke.firestore.eventIdsAfterPrimaryDeletion, []);
  assert.equal(
    sharedDeletionSmoke.firestore.partnerCreatedEventPath,
    'events/shared-delete-partner-event-20260506145235',
  );
  for (const screenshotPath of Object.values(sharedDeletionSmoke.screenshots)) {
    const image = await readFile(screenshotPath);
    assert.equal(image.toString('ascii', 1, 4), 'PNG');
    assert.equal(image.readUInt32BE(16), 1080);
    assert.equal(image.readUInt32BE(20), 2400);
  }

  const joinSmoke = JSON.parse(
    await readFile(
      'docs/qa-evidence/2026-05-06-join-assistant-ui-smoke.json',
      'utf8',
    ),
  );
  assert.equal(joinSmoke.firebaseProject, 'babylog-flutter');
  assert.equal(joinSmoke.appPackage, 'com.eranova.babylog');
  assert.equal(joinSmoke.appVersion, '1.0.6+7');
  assert.equal(joinSmoke.assistantId, 'join-ui-smoke-20260506151008');
  assert.equal(joinSmoke.ownerEventId, 'join-ui-owner-event-20260506151008');
  assert.equal(joinSmoke.joinerEventId, 'join-ui-joiner-event-20260506151008');
  assert.equal(joinSmoke.owner.email, 'joinowner20260506151008@example.com');
  assert.equal(joinSmoke.joiner.email, 'joiner20260506151008@example.com');
  assert.match(joinSmoke.owner.password, /not committed|ignored/);
  assert.match(joinSmoke.joiner.password, /not committed|ignored/);
  for (const key of [
    'releaseApkInstalledAndJoinerSignedIn',
    'joinerStartedWithOwnAssistantBeforeJoin',
    'joinDialogDisplayed',
    'joinerCurrentAssistantUpdatedByUi',
    'assistantUsersContainOwner',
    'assistantUsersContainJoiner',
    'assistantUsersContainJoinerOnce',
    'ownerSeededEventReadableAfterJoin',
    'joinerCanCreateEventAfterJoin',
    'refreshedSettingsShowsBothUsers',
  ]) {
    assert.equal(joinSmoke.checks[key], true, `${key} should pass`);
  }
  assert.deepEqual(joinSmoke.firestore.assistantUsers, [
    'joinowner20260506151008@example.com',
    'joiner20260506151008@example.com',
  ]);
  assert.deepEqual(joinSmoke.firestore.eventIdsForAssistant, [
    'join-ui-joiner-event-20260506151008',
    'join-ui-owner-event-20260506151008',
  ]);
  for (const screenshotPath of Object.values(joinSmoke.screenshots)) {
    const image = await readFile(screenshotPath);
    assert.equal(image.toString('ascii', 1, 4), 'PNG');
    assert.equal(image.readUInt32BE(16), 1080);
    assert.equal(image.readUInt32BE(20), 2400);
  }

  const publicPolicySmoke = JSON.parse(
    await readFile(
      'docs/qa-evidence/2026-05-06-public-policy-pages-smoke.json',
      'utf8',
    ),
  );
  assert.equal(publicPolicySmoke.hostingOrigin, 'https://babylog-flutter.web.app');
  for (const key of [
    'privacyPolicyUrlReturnedHttp200',
    'privacyPolicyMentionsNacho',
    'privacyPolicyMentionsPrivacyContact',
    'privacyPolicyMentionsFirebase',
    'privacyPolicyMentionsOpenAI',
    'deleteAccountUrlReturnedHttp200',
    'deleteAccountMentionsPrivacyContact',
    'deleteAccountMentionsDeletionRequestSubject',
    'deleteAccountMentionsNoReinstallRequired',
  ]) {
    assert.equal(publicPolicySmoke.checks[key], true, `${key} should pass`);
  }
  for (const page of publicPolicySmoke.pages) {
    const image = await readFile(page.screenshot);
    assert.equal(image.toString('ascii', 1, 4), 'PNG');
    assert.equal(image.readUInt32BE(16), 1280);
    assert.equal(image.readUInt32BE(20), 1600);
  }
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
