import { execFile } from 'node:child_process';
import { mkdtemp, readFile, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { promisify } from 'node:util';
import test from 'node:test';
import assert from 'node:assert/strict';

const execFileAsync = promisify(execFile);

test('Play Console handoff bundle contains expected non-secret release files', async () => {
  const outDir = await mkdtemp(join(tmpdir(), 'babylog-play-handoff-'));

  try {
    await execFileAsync('node', ['scripts/prepare_play_console_handoff.mjs', '--out', outDir]);

    const [manifestRaw, readme, handoffDoc] = await Promise.all([
      readFile(join(outDir, 'manifest.json'), 'utf8'),
      readFile(join(outDir, 'README.md'), 'utf8'),
      readFile('docs/play-console-handoff.md', 'utf8'),
    ]);
    const manifest = JSON.parse(manifestRaw);

    assert.deepEqual(
      manifest.files.map((file) => file.target).sort(),
      [
        'assets/feature-graphic-1024x500.png',
        'assets/icon-512.png',
        'copy/play-console-app-content.md',
        'copy/play-console-compliance.md',
        'copy/play-console-submit-packet.md',
        'copy/play-reviewer-access.md',
        'copy/play-store-listing.md',
        'copy/releasenotes.md',
        'release/app-release.aab',
        'screenshots/2026-05-06-local-release-screenshot-set.json',
        'screenshots/phone-00-sign-in.png',
        'screenshots/phone-01-shared-timeline.png',
        'screenshots/phone-02-settings.png',
        'screenshots/phone-03-privacy-policy.png',
        'screenshots/phone-04-recording-permission.png',
      ],
    );

    const aab = manifest.files.find((file) => file.target === 'release/app-release.aab');
    assert.equal(
      aab.sha256,
      '11ccb6bd27a564f9772725b8ef10fdd1762c55cb1e2a38abffa7d78d1572f283',
    );
    assert.ok(aab.bytes > 40_000_000);

    for (const text of [manifestRaw, readme]) {
      assert.doesNotMatch(text, /access_token|refresh_token|id_token|ya29|1\/\/|sk-[A-Za-z0-9]/);
      assert.doesNotMatch(text, /"password"\s*:/);
    }

    for (const required of [
      'npm run prepare:play-handoff',
      'dist/play-console-handoff/',
      'manifest.json',
      '.qa-secrets/play-reviewer-account.json',
      'does not prove Play Console accepted',
    ]) {
      assert.match(handoffDoc, new RegExp(escapeRegExp(required)));
    }
  } finally {
    await rm(outDir, { recursive: true, force: true });
  }
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
