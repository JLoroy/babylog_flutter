import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('Play Console submit packet contains final handoff values', async () => {
  const packet = await readFile('docs/play-console-submit-packet.md', 'utf8');

  for (const required of [
    'com.eranova.babylog',
    '1.0.5+6',
    'build/app/outputs/bundle/release/app-release.aab',
    'f8674c6287a0100807709da49cd70327d9457f1c51bb402f3e2bcfad8fed54a0',
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
    "reviewer's own OpenAI API key",
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
  assert.doesNotMatch(packet, /OpenAI test key/);
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
