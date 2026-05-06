import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('Play Console action history review distinguishes old Console state from current release tasks', async () => {
  const [history, review, hostingRunbook, audit] = await Promise.all([
    readFile('docs/previous_actions.md', 'utf8'),
    readFile('docs/play-console-action-history.md', 'utf8'),
    readFile('docs/firebase-hosting-deploy.md', 'utf8'),
    readFile('docs/release-completion-audit.md', 'utf8'),
  ]);

  for (const requiredHistory of [
    'Babylog',
    'com.eranova.babylog',
    'Internal testing 4',
    'justin@era-nova.be',
    'https://www.era-nova.be',
    'Contains ads',
    'Changed to\n\nNo',
  ]) {
    assert.match(history, new RegExp(escapeRegExp(requiredHistory)));
  }

  for (const requiredReview of [
    'Store contact email was `justin@era-nova.be`',
    'Store contact website was `https://www.era-nova.be`',
    'does not prove the current Play Console state has been updated',
    'Replace the old contact email with `privacy@lenacho.be`',
    'https://babylog-flutter.web.app/privacy-policy',
    'https://babylog-flutter.web.app/delete-account',
    '.qa-secrets/play-reviewer-account.json',
    'Screenshot or export showing Store settings contact email and website',
  ]) {
    assert.match(review, new RegExp(escapeRegExp(requiredReview)));
  }

  assert.doesNotMatch(hostingRunbook, /Play Console fields updated with both URLs/);
  assert.match(
    hostingRunbook,
    /Play Console fields still need confirmation with Console evidence/,
  );
  assert.match(audit, /Play Console fields still need confirmation/);
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
