import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('Android manifest uses the Play Store brand name', async () => {
  const manifest = await readFile(
    'android/app/src/main/AndroidManifest.xml',
    'utf8',
  );

  assert.match(manifest, /android:label="Babylog"/);
});
