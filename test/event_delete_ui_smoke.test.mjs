import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('event deletion UI smoke evidence is non-secret and release-scoped', async () => {
  const evidence = JSON.parse(
    await readFile('docs/qa-evidence/2026-05-06-event-delete-ui-smoke.json', 'utf8'),
  );

  assert.equal(evidence.firebaseProject, 'babylog-flutter');
  assert.equal(evidence.appPackage, 'com.eranova.babylog');
  assert.equal(evidence.appVersion, '1.0.2+3');
  assert.equal(evidence.reviewer.uid, 'rsU7yU2TZfPmGUsLw0PXoozLd0C2');
  assert.equal(evidence.reviewer.email, 'test@era-nova.be');
  assert.equal(
    evidence.reviewer.password,
    'stored only in .qa-secrets/play-reviewer-account.json, not committed',
  );
  assert.equal(evidence.assistantId, 'play-reviewer-assistant');
  assert.match(evidence.eventId, /^ui-delete-smoke-\d{14}$/);
  assert.equal(
    evidence.eventDescription,
    'Temporary UI delete smoke event. No real child data.',
  );

  for (const value of Object.values(evidence.checks)) {
    assert.equal(value, true);
  }

  assert.equal(evidence.firestoreVerification.queryStatus, 200);
  assert.deepEqual(evidence.firestoreVerification.matchingDocumentNames, []);
  assert.equal(evidence.firestoreVerification.reviewerSampleQueryStatus, 200);
  assert.deepEqual(evidence.firestoreVerification.reviewerSampleDocumentNames, [
    'projects/babylog-flutter/databases/(default)/documents/events/play-reviewer-welcome',
  ]);

  assert.equal(evidence.screenshots.length, 2);
  for (const screenshotPath of evidence.screenshots) {
    const screenshot = await readFile(screenshotPath);
    assert.equal(screenshot.toString('ascii', 1, 4), 'PNG');
    assert.equal(screenshot.readUInt32BE(16), 1080);
    assert.equal(screenshot.readUInt32BE(20), 2400);
  }

  assert.match(
    evidence.note,
    /does not validate recorder-created event creation/,
  );
});
