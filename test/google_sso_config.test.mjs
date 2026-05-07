import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

const WEB_CLIENT_ID =
  '328975985379-h99abg1d80q59d7oe4l635lvahrmuf92.apps.googleusercontent.com';
const ANDROID_CLIENT_ID =
  '328975985379-6c14bnq4tpg7lsd1gjfcfl61ffd0f4ig.apps.googleusercontent.com';
const RELEASE_SHA1 = 'a6bf3b9362716bfac3b2f123d07ddcf1a786b25a';

test('Google SSO is wired through Firebase UI and Android Google services', async () => {
  const [
    pubspec,
    lockfile,
    main,
    authGate,
    settingsGradle,
    appGradle,
    firebaseOptions,
    googleServices,
    workflow,
    packageJsonRaw,
  ] = await Promise.all([
    readFile('pubspec.yaml', 'utf8'),
    readFile('pubspec.lock', 'utf8'),
    readFile('lib/main.dart', 'utf8'),
    readFile('lib/pages/babylogauth.dart', 'utf8'),
    readFile('android/settings.gradle.kts', 'utf8'),
    readFile('android/app/build.gradle.kts', 'utf8'),
    readFile('lib/scripts/firebase_options.dart', 'utf8'),
    readFile('android/app/google-services.json', 'utf8'),
    readFile('.github/workflows/flutter-ci.yml', 'utf8'),
    readFile('package.json', 'utf8'),
  ]);
  const packageJson = JSON.parse(packageJsonRaw);
  const googleServicesJson = JSON.parse(googleServices);
  const androidClient = googleServicesJson.client.find(
    (client) =>
      client.client_info.android_client_info?.package_name ===
      'com.eranova.babylog',
  );

  assert.match(pubspec, /firebase_ui_oauth_google:\s*\^2\.0\.1/);
  assert.match(lockfile, /firebase_ui_oauth_google:/);
  assert.match(main, /firebase_ui_oauth_google\/firebase_ui_oauth_google\.dart/);
  assert.match(main, new RegExp(escapeRegExp(WEB_CLIENT_ID)));
  assert.match(main, /GoogleProvider\(clientId: googleOAuthClientId\)/);
  assert.match(authGate, /providerIds\.contains\('password'\)/);
  assert.match(authGate, /userRequiresEmailVerification\(user\)/);
  assert.match(settingsGradle, /id\("com\.google\.gms\.google-services"\) version "4\.4\.4" apply false/);
  assert.match(appGradle, /id\("com\.google\.gms\.google-services"\)/);
  assert.match(
    firebaseOptions,
    /appId: '1:328975985379:android:8ee5f4d65cee59899af3d6'/,
  );
  assert.match(
    firebaseOptions,
    /storageBucket: 'babylog-flutter\.firebasestorage\.app'/,
  );
  assert.match(googleServices, new RegExp(escapeRegExp(WEB_CLIENT_ID)));
  assert.match(googleServices, new RegExp(escapeRegExp(ANDROID_CLIENT_ID)));
  assert.match(googleServices, new RegExp(escapeRegExp(RELEASE_SHA1)));
  assert.ok(androidClient);
  assert.equal(
    androidClient.client_info.mobilesdk_app_id,
    '1:328975985379:android:8ee5f4d65cee59899af3d6',
  );
  assert.equal(
    packageJson.scripts['test:google-sso-config'],
    'node --test test/google_sso_config.test.mjs',
  );
  assert.match(workflow, /Test Google SSO config/);
  assert.match(workflow, /npm run test:google-sso-config/);
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
