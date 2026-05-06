import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('upload key recovery runbook covers password recovery and Play reset paths', async () => {
  const runbook = await readFile('docs/upload-key-recovery.md', 'utf8');

  for (const required of [
    'Correct password found',
    'Password cannot be recovered',
    'Test and release > Setup > App signing',
    'keytool -genkeypair',
    'upload_certificate.pem',
    'Resetting the upload key does not affect the app signing key',
    'flutter build appbundle --release',
  ]) {
    assert.match(runbook, new RegExp(escapeRegExp(required)));
  }
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
