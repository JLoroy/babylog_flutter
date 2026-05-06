import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('Play reviewer access notes cover restricted auth and BYOK review path', async () => {
  const notes = await readFile('docs/play-reviewer-access.md', 'utf8');

  for (const required of [
    'Some or all functionality is restricted',
    'Firebase email/password authentication',
    'Reviewer account',
    'Email: `test@era-nova.be`',
    '.qa-secrets/play-reviewer-account.json',
    'docs/qa-evidence/2026-05-06-release-apk-play-reviewer-timeline.png',
    'docs/qa-evidence/2026-05-06-play-reviewer-access-smoke.json',
    'Assistant id: `play-reviewer-assistant`',
    'email verified',
    'BYOK-only',
    'Do not provide an OpenAI test key',
    "reviewer's own OpenAI API key",
    'non-AI timeline',
    'Do not enter real child data',
    'Delete Account',
    'Privacy Policy',
  ]) {
    assert.match(notes, new RegExp(escapeRegExp(required)));
  }

  const smoke = JSON.parse(
    await readFile(
      'docs/qa-evidence/2026-05-06-play-reviewer-access-smoke.json',
      'utf8',
    ),
  );
  assert.equal(smoke.firebaseProject, 'babylog-flutter');
  assert.equal(smoke.appPackage, 'com.eranova.babylog');
  assert.equal(smoke.reviewer.email, 'test@era-nova.be');
  assert.equal(smoke.reviewer.uid, 'rsU7yU2TZfPmGUsLw0PXoozLd0C2');
  assert.match(smoke.reviewer.password, /not committed/);
  assert.equal(smoke.assistantId, 'play-reviewer-assistant');
  assert.equal(smoke.eventId, 'play-reviewer-welcome');
  for (const key of [
    'restAuthSignIn',
    'releaseApkSignIn',
    'userDocExists',
    'userDocPointsToReviewerAssistant',
    'assistantDocExists',
    'assistantUsersContainsReviewerEmail',
    'sampleEventExists',
    'sampleEventBelongsToReviewerAssistant',
  ]) {
    assert.equal(smoke.checks[key], true, `${key} should pass`);
  }

  const screenshot = await readFile(
    'docs/qa-evidence/2026-05-06-release-apk-play-reviewer-timeline.png',
  );
  assert.equal(screenshot.toString('ascii', 1, 4), 'PNG');
  assert.equal(screenshot.readUInt32BE(16), 1080);
  assert.equal(screenshot.readUInt32BE(20), 2400);
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
