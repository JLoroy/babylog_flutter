# Babylog Play Console Release Runbook

Last updated: 2026-05-06

Purpose:
Move Babylog from a signed Android App Bundle to internal testing, then
production on Google Play.

Official references:

- Prepare and roll out a release:
  https://support.google.com/googleplay/android-developer/answer/9859348
- Set up an open, closed, or internal test:
  https://support.google.com/googleplay/android-developer/answer/9845334
- Review your app's data per release:
  https://support.google.com/googleplay/android-developer/answer/7383463
- Release app updates with staged rollouts:
  https://support.google.com/googleplay/android-developer/answer/6346149

## Preconditions

- Correct Android upload keystore password is available.
- `flutter build appbundle --release` succeeds.
- The generated `.aab` is signed with the intended upload key.
- GitHub Actions is green on the release branch.
- Firebase rules have been production-data-reviewed.
- Production Firestore indexes are preserved in `firestore.indexes.json`.
- Public privacy policy URL is live.
- Public account deletion URL is live.
- Reviewer Firebase Auth account exists, is verified, and is linked to a
  synthetic sample assistant.
- BYOK review path is documented BYOK-only behavior; no OpenAI test key is
  committed or provided in repo docs.
- `docs/manual-qa-checklist.md` is complete for the internal testing build.

## Local Preflight

Run the automated gate from `docs/release-verification.md`.

Minimum commands before Play upload:

```bash
flutter pub get
dart format --set-exit-if-changed lib test
flutter analyze --no-fatal-infos
flutter test
npm run test:android-manifest
npm run test:android-release-identity
npm run test:app-content
npm run test:compliance-docs
npm run test:growth
npm run test:hosting
npm run test:listing
npm run test:play-distribution
npm run test:play-assets
npm run test:play-reviewer-access
npm run test:play-screenshots
npm run test:play-submit-packet
npm run test:public-urls
npm run test:firestore-indexes
npm run test:manual-qa
npm run test:policy
npm run test:play-release
npm run test:play-release-notes
npm run test:upload-key
JAVA_HOME=/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home \
PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH" \
npm run test:rules
JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home \
PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH" \
flutter build appbundle --release
```

Expected release artifact:

```text
build/app/outputs/bundle/release/app-release.aab
```

Current status:
Release AAB is built and signed:
`build/app/outputs/bundle/release/app-release.aab`.

Artifact SHA-256 captured on 2026-05-06:
`ac9b27ec22bb4d6c963a2c38eb3b274f9c539ea508b566fccab8d3f4ba8b226b`.

`jarsigner -verify build/app/outputs/bundle/release/app-release.aab` exits 0.

## Play Console Setup Checklist

Complete these before production rollout:

- Main store listing using `docs/play-store-listing.md`.
- Screenshots from a sanitized build using `docs/play-screenshots.md`.
- Graphics from a sanitized build.
- Privacy policy URL.
- Account deletion URL.
- App access instructions using `docs/play-console-app-content.md` and
  `docs/play-reviewer-access.md`.
- Ads declaration.
- Target audience and content.
- Content rating questionnaire.
- Data safety form using `docs/play-console-compliance.md`.
- Countries/regions and pricing/distribution settings using
  `docs/play-distribution.md`.

## Internal Testing Release

1. Open Play Console.
2. Select Babylog.
3. Go to Testing > Internal testing.
4. Create or select the internal testing track.
5. Create a new release.
6. Upload `build/app/outputs/bundle/release/app-release.aab`.
7. Set release name to the version/build, for example `1.0.2+3`.
8. Use release notes from `docs/play-store-listing.md`.
9. Add internal testers or tester email list.
10. Review the release for Play warnings.
11. Roll out to internal testing.
12. Share the internal test link with testers.

Evidence to capture:

- Uploaded AAB version code/name.
- Track name.
- Tester list or tester group.
- Internal testing opt-in URL.
- Screenshot of release status.

## Internal Testing QA

Complete `docs/manual-qa-checklist.md` against the internal testing install.

Do not proceed to production until:

- Account deletion is manually verified in Firebase Auth and Firestore.
- Recording/transcription works with a reviewer-provided or tester-provided
  BYOK key.
- Privacy policy and account deletion pages load without authentication.
- No Play pre-launch/report blockers remain.
- No unacceptable crashes or ANRs are visible for the internal release.

## Production Release

1. Resolve every required Play Console task.
2. Go to Production.
3. Create a new release.
4. Add the approved AAB or promote from testing if appropriate.
5. Reuse final release notes.
6. Review countries/regions.
7. Review Play warnings and policy declarations.
8. Start rollout to production when every blocker is resolved.

For a first public release, do not rely on staged rollout as a substitute for
manual QA. Google Play staged rollouts are for updates, not the first production
release.

Evidence to capture:

- Production release name/version.
- Release status.
- Public Google Play listing URL.
- Date/time rollout started.
- Countries/regions selected.

## Post-Release Monitoring

Use Play Console release data to review installs, uninstalls, ratings, reviews,
crashes, and ANRs for the latest release.

Capture:

- Play Console release dashboard screenshot.
- Android vitals status.
- Crash/ANR count.
- User acquisition/install count for `docs/growth-metrics.md`.
- Firebase Auth user count as supporting evidence.

Update after release:

- `STATUS.md`
- `docs/release-completion-audit.md`
- `docs/growth-metrics.md` if metric sources or thresholds change

## Do Not Mark Complete Until

- The app is live on Google Play production.
- Public Play listing URL is captured.
- The 1000-user acquisition target is resumed and Play Console shows at least
  1000 installs/acquisitions.
- Firebase/Auth/Firestore deletion behavior has real evidence.
- Public policy/deletion URLs are configured in Play Console.
