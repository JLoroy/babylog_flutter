import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('Play Console submit packet contains final handoff values', async () => {
  const packet = await readFile('docs/play-console-submit-packet.md', 'utf8');

  for (const required of [
    'com.eranova.babylog',
    '1.0.7+8',
    'build/app/outputs/bundle/release/app-release.aab',
    'dec7f6d4b94741d019a4a75ea48238eeb8e9c8911ba01a9e6ec71d357243f811',
    'Babylog',
    'privacy@lenacho.be',
    'https://babylog-flutter.web.app/privacy-policy',
    'https://babylog-flutter.web.app/delete-account',
    'Nacho',
    'test@era-nova.be',
    '.qa-secrets/play-reviewer-account.json',
    'play-reviewer-assistant',
    'Some or all functionality is restricted.',
    'BYOK-only',
    'temporary OpenAI API key is provided in the private App access notes',
    'Settings > Bring your own API key',
    'locally on-device',
    'docs/play-assets/icon-512.png',
    'docs/play-assets/feature-graphic-1024x500.png',
    'docs/play-assets/screenshots/phone-00-sign-in.png',
    'docs/play-assets/screenshots/phone-01-shared-timeline.png',
    'docs/play-assets/screenshots/phone-02-settings.png',
    'docs/play-assets/screenshots/phone-03-privacy-policy.png',
    'docs/play-assets/screenshots/phone-04-recording-permission.png',
    'docs/play-assets/screenshots/2026-05-06-local-release-screenshot-set.json',
    'docs/manual-qa-checklist.md',
  ]) {
    assert.match(packet, new RegExp(escapeRegExp(required)));
  }

  assert.doesNotMatch(packet, /privacy@eranova\.be/);
  assert.doesNotMatch(packet, /OpenAI API key: sk-/);
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
