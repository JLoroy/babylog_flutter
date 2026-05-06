import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

const PACKAGE_NAME = 'com.eranova.babylog';
const APP_NAME = 'Babylog';
const VERSION = '1.0.7+8';
const HIGHEST_KNOWN_PLAY_VERSION_CODE = 7;

test('Android release identity is stable for Play Console submission', async () => {
  const [pubspec, buildGradle, manifest, listing] = await Promise.all([
    readFile('pubspec.yaml', 'utf8'),
    readFile('android/app/build.gradle.kts', 'utf8'),
    readFile('android/app/src/main/AndroidManifest.xml', 'utf8'),
    readFile('docs/play-store-listing.md', 'utf8'),
  ]);

  assert.match(pubspec, new RegExp(`^version:\\s*${escapeRegExp(VERSION)}$`, 'm'));
  assert.equal(androidVersionCode(VERSION), 8);
  assert.ok(
    androidVersionCode(VERSION) > HIGHEST_KNOWN_PLAY_VERSION_CODE,
    `Android versionCode must be greater than the highest known Play Console version code ${HIGHEST_KNOWN_PLAY_VERSION_CODE}`,
  );
  assert.match(buildGradle, new RegExp(`namespace\\s*=\\s*"${escapeRegExp(PACKAGE_NAME)}"`));
  assert.match(buildGradle, new RegExp(`applicationId\\s*=\\s*"${escapeRegExp(PACKAGE_NAME)}"`));
  assert.match(buildGradle, /targetSdk\s*=\s*35/);
  assert.match(buildGradle, /compileSdk\s*=\s*36/);
  assert.match(manifest, new RegExp(`package="${escapeRegExp(PACKAGE_NAME)}"`));
  assert.match(manifest, new RegExp(`android:label="${escapeRegExp(APP_NAME)}"`));
  assert.match(manifest, /android\.permission\.INTERNET/);
  assert.match(manifest, /android\.permission\.RECORD_AUDIO/);
  assert.match(listing, new RegExp(`Package name:\\s*\\n${escapeRegExp(PACKAGE_NAME)}`));
  assert.match(listing, new RegExp(`Release version:\\s*\\n${escapeRegExp(VERSION)}`));
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function androidVersionCode(version) {
  const [, buildNumber] = version.split('+');
  return Number.parseInt(buildNumber, 10);
}
