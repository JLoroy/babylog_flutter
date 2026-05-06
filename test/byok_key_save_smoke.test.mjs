import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('BYOK key-save smoke evidence is non-secret and release-scoped', async () => {
  const evidence = JSON.parse(
    await readFile('docs/qa-evidence/2026-05-06-byok-key-save-smoke.json', 'utf8'),
  );

  assert.equal(evidence.firebaseProject, 'babylog-flutter');
  assert.equal(evidence.appPackage, 'com.eranova.babylog');
  assert.equal(evidence.appVersion, '1.0.2+3');
  assert.equal(evidence.reviewer.email, 'test@era-nova.be');
  assert.equal(
    evidence.reviewer.password,
    'stored only in .qa-secrets/play-reviewer-account.json, not committed',
  );
  assert.equal(evidence.assistantId, 'play-reviewer-assistant');
  assert.equal(
    evidence.byokInput,
    'non-secret fake key used only to validate local save/restart storage path',
  );

  for (const value of Object.values(evidence.checks)) {
    assert.equal(value, true);
  }

  assert.equal(evidence.screenshots.length, 1);
  const screenshot = await readFile(evidence.screenshots[0]);
  assert.equal(screenshot.toString('ascii', 1, 4), 'PNG');
  assert.equal(screenshot.readUInt32BE(16), 1080);
  assert.equal(screenshot.readUInt32BE(20), 2400);

  assert.match(
    evidence.remainingGap,
    /real limited OpenAI key is still required/,
  );
});

test('OpenAI reviewer BYOK endpoint smoke is redacted and app-scoped', async () => {
  const evidence = JSON.parse(
    await readFile(
      'docs/qa-evidence/2026-05-07-openai-byok-endpoint-smoke.json',
      'utf8',
    ),
  );

  assert.equal(evidence.firebaseProject, 'babylog-flutter');
  assert.equal(evidence.appPackage, 'com.eranova.babylog');
  assert.equal(evidence.appVersion, '1.0.7+8');
  assert.match(evidence.scope, /no key material recorded/);
  assert.doesNotMatch(JSON.stringify(evidence), /sk-/);

  assert.equal(evidence.transcription.endpoint, '/v1/audio/transcriptions');
  assert.equal(evidence.transcription.model, 'whisper-1');
  assert.equal(evidence.transcription.status, 200);
  assert.equal(evidence.transcription.containsMilkVolume, true);

  assert.equal(evidence.interpretation.endpoint, '/v1/chat/completions');
  assert.equal(evidence.interpretation.model, 'gpt-4o-mini');
  assert.equal(evidence.interpretation.promptMatchesAppTaxonomy, true);
  assert.equal(evidence.interpretation.status, 200);
  assert.equal(evidence.interpretation.parsedJson, true);
  assert.equal(evidence.interpretation.eventCount, 1);
  assert.deepEqual(evidence.interpretation.eventTypes, ['bottle']);
  assert.equal(evidence.interpretation.includesBottleEvent, true);

  assert.match(evidence.remainingGap, /not a full in-app microphone/);
});
