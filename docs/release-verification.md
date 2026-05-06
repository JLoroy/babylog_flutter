# Babylog Android Release Verification

Last updated: 2026-05-05

Run and record this gate before uploading a Play Console release artifact.

## Local automated gate

```bash
flutter pub get
dart format --set-exit-if-changed lib test
flutter analyze --no-fatal-infos
flutter test
npm run test:android-manifest
npm run test:android-release-identity
npm run test:app-content
npm run test:growth
npm run test:hosting
npm run test:firestore-indexes
npm run test:listing
npm run test:play-distribution
npm run test:play-assets
npm run test:play-handoff
npm run test:play-private-notes
npm run test:play-reviewer-access
npm run test:play-policy-freshness
npm run test:play-screenshots
npm run test:public-urls
npm run test:manual-qa
npm run test:policy
npm run test:play-release
npm run test:upload-key
JAVA_HOME=/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home \
PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH" \
npm run test:rules
JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home \
PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH" \
flutter build apk --debug
JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home \
PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH" \
flutter build appbundle --release
```

Expected status today:

- Everything through `flutter build appbundle --release` passes with the Java
  paths above.
- The current signed release artifact is
  `build/app/outputs/bundle/release/app-release.aab`.
- Artifact SHA-256 captured on 2026-05-06:
  `11ccb6bd27a564f9772725b8ef10fdd1762c55cb1e2a38abffa7d78d1572f283`.
- `npm run prepare:play-handoff` creates the optional non-secret upload folder
  at `dist/play-console-handoff/`.

## Artifact inspection

After the release AAB builds:

```bash
JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home \
PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH" \
keytool -list -v \
  -keystore ~/Documents/AndroidReleaseKeys/eranova_upload.jks \
  -alias upload
```

Confirm the generated AAB is signed with the intended upload key before
uploading to Play Console.

Current artifact verification:

- `keytool -list` opens the configured keystore and alias from ignored
  `android/key.properties`.
- `jarsigner -verify build/app/outputs/bundle/release/app-release.aab` exits 0.

## Manual QA gate

- Complete `docs/manual-qa-checklist.md` with screenshots or notes.
- First install and launch on a real Android device.
- New user email/password sign-up.
- Email verification flow.
- Assistant creation.
- Add and save a BYOK OpenAI API key.
- Record audio, send transcription, and create the first timeline event.
- Confirm the event appears after app restart.
- Join another assistant with a test account.
- Delete an event.
- Delete account and verify Firebase Auth, `users`, `assistants`, and `events`
  state in Firebase Console.
- Confirm the in-app privacy policy link/text is present.
- Confirm Settings > Privacy Policy matches the published privacy policy.
- Confirm `docs/public/privacy-policy.html` and
  `docs/public/delete-account.html` are published at public URLs and load
  without authentication.
- Publish the static policy pages with `firebase deploy --only hosting` after
  confirming Firebase credentials and `docs/firebase-hosting-deploy.md`.
- Confirm the public account deletion URL works without app access.

## Play Console gate

- Upload signed AAB to internal testing first.
- Follow `docs/play-release-runbook.md`.
- Review Play Console SDK/data disclosure output for the uploaded artifact.
- Complete Data safety form using `docs/play-console-compliance.md`.
- Complete Main store listing using `docs/play-store-listing.md`.
- Complete App content answers using `docs/play-console-app-content.md`.
- Add public privacy policy URL.
- Add public account deletion request URL.
- Complete app access, content rating, target audience, and ads declarations.
- Run internal testing and fix crashes or policy warnings before production.
