import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('Play Console submit packet contains final handoff values', async () => {
  const packet = await readFile('docs/play-console-submit-packet.md', 'utf8');

  for (const required of [
    'com.eranova.babylog',
    '1.0.8+9',
    'build/app/outputs/bundle/release/app-release.aab',
    '4d001263246659d6c442a3685fbdaa8500d99183100cbd5d62bafdac2932deb2',
    'Babylog',
    'privacy@lenacho.be',
    'https://babylog-flutter.web.app/privacy-policy',
    'https://babylog-flutter.web.app/delete-account',
    'Nacho',
    'Google Sign-In Firebase Setup',
    'Firebase Authentication > Sign-in',
    '1:328975985379:android:8ee5f4d65cee59899af3d6',
    '328975985379-6c14bnq4tpg7lsd1gjfcfl61ffd0f4ig.apps.googleusercontent.com',
    '328975985379-h99abg1d80q59d7oe4l635lvahrmuf92.apps.googleusercontent.com',
    'A6:BF:3B:93:62:71:6B:FA:C3:B2:F1:23:D0:7D:DC:F1:A7:86:B2:5A',
    '4A:CA:E5:0B:D3:5D:37:5F:03:63:C6:47:FC:32:7B:0B:35:D0:4D:A3:09:BA:E6:05:E6:0E:F5:F4:C4:9F:05:CA',
    'test@era-nova.be',
    '.qa-secrets/play-reviewer-account.json',
    'play-reviewer-assistant',
    'Some or all functionality is restricted.',
    '500-character instructions field',
    'Template length without real secrets: 253/500 characters.',
    'Login with the reviewer credentials in this field.',
    'paste the temporary OpenAI key in this field',
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

  const templateMatch = packet.match(
    /Public template for the 500-character instructions field:\n\n```text\n(.+)\n```/,
  );
  assert.ok(templateMatch);
  assert.equal(templateMatch[1].length, 253);
  assert.ok(templateMatch[1].length <= 500);
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
