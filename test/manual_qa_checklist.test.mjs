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
    'ac9b27ec22bb4d6c963a2c38eb3b274f9c539ea508b566fccab8d3f4ba8b226b',
    'babylog-flutter',
    'flutter devices',
    'found only macOS and Chrome',
    'flutter emulators',
    'found no Android emulator sources',
    'test@era-nova.be',
    'play-reviewer-assistant',
    'documented BYOK-only review',
    'https://babylog-flutter.web.app/privacy-policy',
    'https://babylog-flutter.web.app/delete-account',
    '## Sign-Off',
  ]) {
    assert.match(checklist, new RegExp(escapeRegExp(required)));
  }
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
