# STATUS — Babylog

**Last updated:** 2026-05-06

## Update (2026-05-05)

### Current milestone
- Release-readiness triage after the local `feature/unbug` merge.

### What changed
- Created merge commit `4f3cd94` on `main`.
- Preserved the pre-merge dirty workspace in stash `pre-main-merge dirty workspace backup`.
- Added `plan.md` so merge and cleanup decisions have a durable place to live.
- Added `todo.md` with actionable release tasks in the requested Title / Description / Guidance / How to validate format.
- Added `.github/workflows/flutter-ci.yml` to run formatting, analysis, tests, and an Android debug APK build in GitHub Actions.
- Installed local Flutter/Android tooling through Homebrew and configured ignored local files for Android SDK and release signing.
- Updated dependencies for Flutter 3.41.9, corrected the Android Flutter source root, increased Gradle heap, and replaced the stale template counter test with Babylog event model tests.
- Implemented account deletion via `AccountDeletionService`, wired the settings delete action to it, and added focused service tests.
- Added Firebase project config, Firestore security rules, Firestore emulator rule tests, and default-deny Realtime Database rules.
- Added a GitHub Actions Firebase rules job using Node 25 and Java 21.
- Reworked OpenAI key handling so keys are kept in local secure storage, are not serialized to Firestore, and the old Firestore dev-key fallback is removed.
- Updated Android compile SDK to 36 for `flutter_secure_storage` and target SDK to 35 for current Google Play submission requirements.
- Confirmed the Android release key material is in `~/Documents/AndroidReleaseKeys` and that ignored `android/key.properties` points at `eranova_upload.jks` with alias `upload`.
- Removed the unused Firebase Analytics Android dependency so the app no longer includes an intentional analytics SDK surface.
- Added Play compliance drafts in `docs/`: data inventory, privacy policy draft, account deletion web copy, and release verification checklist.
- Removed unused `firebase_database` and `firebase_ui_database` dependencies after confirming no active app code imports Realtime Database.
- Declared `http` as a direct Flutter dependency for the existing OpenAI HTTP calls.
- Upgraded the Android Kotlin Gradle plugin to 2.1.0 and confirmed the debug APK still builds.
- Added a Settings Privacy Policy entry and dialog, plus a widget test that verifies Settings exposes privacy policy access.
- Extended account deletion to clear assistant-scoped local OpenAI key data before deleting the Firebase Auth user.
- Added ready-to-host public policy pages at `docs/public/privacy-policy.html` and `docs/public/delete-account.html`, plus `npm run test:policy`.
- Added `docs/play-store-listing.md` with draft Play Store app details, release notes, contact fields, and asset checklist.
- Updated the Android launcher label from `babylog` to `Babylog` and added a manifest check.
- Added `docs/play-console-app-content.md` with draft Play Console App content answers for app access, ads, target audience, content rating, data safety cross-reference, and microphone permission notes.
- Updated `.github/workflows/flutter-ci.yml` so GitHub Actions runs the Android manifest, App content, store listing, and policy page validators.
- Added `docs/release-completion-audit.md` to map the active objective to concrete evidence and remaining blockers.
- Added `docs/manual-qa-checklist.md` and `npm run test:manual-qa` to standardize real-device/internal-test release evidence.
- Added `docs/growth-metrics.md` and `npm run test:growth` to define how the 1000-user/download objective will be proven.
- Configured Firebase Hosting to serve `docs/public` and added `npm run test:hosting` to validate the hosting config.
- Added `.firebaserc` with default project `babylog-flutter` and `docs/firebase-hosting-deploy.md` with the deploy/post-deploy verification runbook.
- Added `docs/play-release-runbook.md` and `npm run test:play-release` to cover Play internal testing, production rollout, and post-release evidence capture.
- Added `docs/upload-key-recovery.md` and `npm run test:upload-key` after verifying the local candidate passwords do not unlock the supplied upload keystore.
- Added `npm run test:android-release-identity` and recorded package name, release version, and target API in the Play Store listing draft.
- Generated `docs/play-assets/icon-512.png` from `assets/icon/icon.png` and added `npm run test:play-assets` to verify the Play Console app icon artifact.
- Added `docs/play-reviewer-access.md` and `npm run test:play-reviewer-access` for restricted app access and BYOK reviewer notes.
- Added `docs/play-screenshots.md` and `npm run test:play-screenshots` to define the required sanitized phone screenshot set.
- Generated `docs/play-assets/feature-graphic-1024x500.png` and extended `npm run test:play-assets` to verify the Play feature graphic dimensions and no-alpha format.
- Added expected Firebase Hosting URLs to the Play listing and hosting deploy runbook, then deployed and verified them, plus `npm run test:public-urls`.
- Added `docs/play-distribution.md` and `npm run test:play-distribution` for Play category, pricing, ads/IAP, Families, and initial country rollout settings.
- Switched the public developer/privacy identity from Eranova to Nacho and `privacy@lenacho.be`; reminder: create or confirm the `privacy@lenacho.be` alias before Play submission.
- Verified the recovered Android upload keystore password without printing secrets; `keytool` opens the configured keystore and alias from ignored `android/key.properties`.
- Built signed release AAB `build/app/outputs/bundle/release/app-release.aab` on 2026-05-06.
- Deployed Firebase Hosting for the public privacy policy and account deletion pages to `babylog-flutter`.
- Recorded that the 1000-user/download objective is paused while release, security, deployment, and Play submission are prioritized.
- Imported the existing production Firestore `events` indexes into `firestore.indexes.json` and added `npm run test:firestore-indexes` so future deploys preserve them.
- Deployed tested Firestore security rules to `babylog-flutter` with `firebase deploy --only firestore:rules --project babylog-flutter`.
- Requested a Firebase Auth password reset email for the reviewer account `test@era-nova.be`; the final password remains outside git.
- Confirmed `test@era-nova.be` exists in Firebase Auth, is email-verified, and is enabled.
- Created/updated the synthetic Firestore reviewer setup: user `test@era-nova.be`, assistant `play-reviewer-assistant`, and event `play-reviewer-welcome`.
- Updated the Play release runbook preflight to include `npm run test:firestore-indexes`.
- Searched the repo for Play Developer API, Fastlane, Gradle Play Publisher, and service-account automation credentials; none were found.
- Updated the Play compliance/privacy/deletion drafts to use Nacho, `privacy@lenacho.be`, and the verified Firebase Hosting policy/deletion URLs; added `npm run test:compliance-docs`.
- Prefilled `docs/manual-qa-checklist.md` with the known release version, signed AAB path/SHA-256, Firebase project, reviewer email/assistant id, and public policy/deletion URLs.
- Documented the first-release OpenAI architecture as BYOK-only direct client calls: no shared OpenAI key in repo, Firestore, or the app bundle; optional temporary reviewer keys belong only in ignored private Play notes; backend proxy deferred unless manual QA or review blocks release.
- Added `docs/play-console-submit-packet.md` and `npm run test:play-submit-packet` as a compact Play Console handoff with exact copy/paste values.
- Updated `android/app/releasenotes.md` to match the current Play listing release notes and added `npm run test:play-release-notes`.
- Updated `docs/play-store-listing.md` so account deletion is described as published, not merely prepared for publication.
- Reviewed the freshly pulled `origin/feature/unbug` tip `63d7761` and found it still cannot be used for the next Play upload because it is `1.0.4+4`, while Play has already used version code 5.
- Bumped the hardened `main` release identity to `1.0.5+6`, rebuilt the signed release AAB, and updated the Play submit packet, listing, runbook, manual QA checklist, and release audit to reference the then-current upload candidate.
- Added a CI guard to `npm run test:android-release-identity` so the Android build number must stay above the highest known Play Console version code, currently 5.
- Updated the generated Play Console handoff manifest and README to include package `com.eranova.babylog`, version `1.0.5+6`, version name `1.0.5`, and version code 6 next to the file hashes.
- Rechecked local Android device/emulator availability: `flutter emulators` now lists `babylog_api35`, and after launch `flutter devices` sees `emulator-5554` as Android 15 / API 35.
- Installed `build/app/outputs/flutter-apk/app-release.apk` on AVD `babylog_api35`, launched `com.eranova.babylog`, confirmed it stayed running, and saved a non-private sign-in screenshot at `docs/qa-evidence/2026-05-06-release-apk-launch.png`.
- Reproduced a release APK sign-in crash on the AVD with a verified disposable Firebase Auth user: Firebase Auth succeeded, then stale Firebase Auth/UI generated-code decoding failed with `type 'List<Object?>' is not a subtype of type 'PigeonUserDetails?'`.
- Upgraded Firebase Flutter dependencies to `firebase_core 4.7.0`, `firebase_auth 6.4.0`, `firebase_ui_auth 3.0.1`, `cloud_firestore 6.3.0`, and `firebase_ui_firestore 2.0.1`, removing the discontinued `firebase_dynamic_links` transitive dependency.
- Imported a disposable verified QA user `qa202605060729068d@example.com`; its password is stored only in ignored `.qa-secrets/current-qa-account.json`.
- Rebuilt the release APK after the Firebase upgrade, signed in on AVD `babylog_api35`, reached the Babylog timeline, and saved sanitized evidence at `docs/qa-evidence/2026-05-06-release-apk-qa-timeline-after-firebase-upgrade.png`.
- Captured non-secret Firestore smoke evidence at `docs/qa-evidence/2026-05-06-disposable-qa-firestore-smoke.json`: REST sign-in, user doc, current assistant reference, assistant doc, and assistant membership all passed under deployed Firestore rules.
- Pushed commit `a7dce7e` (`Fix release Firebase auth flow`) to `main`; GitHub Actions run `25422575356` passed both Analyze/test and Firebase rules jobs.
- Imported disposable verified deletion QA user `deleteqa20260506075317ad1d03@example.com`; its password is stored only in ignored `.qa-secrets/deletion-qa-account.json`.
- Signed into the release APK on AVD `babylog_api35`, let the app create assistant `icM00h2TvBff3LU1P2Nn`, added synthetic event `delete-smoke-codexdeleteqa20260506075317ad1d03`, and deleted the account through Settings > Delete Account > Delete Everything.
- Captured account-deletion evidence in `docs/qa-evidence/2026-05-06-account-deletion-smoke.json` and screenshots under `docs/qa-evidence/2026-05-06-release-apk-account-deletion-*.png`.
- Set the `test@era-nova.be` Play reviewer password in Firebase Auth; the password is stored only in ignored `.qa-secrets/play-reviewer-account.json`.
- Captured non-secret reviewer access evidence at `docs/qa-evidence/2026-05-06-play-reviewer-access-smoke.json`.
- Signed into the release APK on AVD `babylog_api35` with `test@era-nova.be` and saved the reviewer sample timeline screenshot at `docs/qa-evidence/2026-05-06-release-apk-play-reviewer-timeline.png`.
- Captured a local Play screenshot set from the release APK on AVD `babylog_api35`: sign-in, synthetic shared timeline, Settings/BYOK, Privacy Policy dialog, and Android microphone permission. The non-secret manifest is `docs/play-assets/screenshots/2026-05-06-local-release-screenshot-set.json`.
- Updated `docs/release-completion-audit.md` with the latest green remote CI run, local screenshot evidence, and explicit remaining blockers for Play Console release, BYOK recorder QA, and 1000-user evidence.
- Added `npm run test:release-audit` and wired it into GitHub Actions so the objective-level audit is checked in CI.
- Validated BYOK key save/restart on the release APK using a non-secret fake key only; evidence at `docs/qa-evidence/2026-05-06-byok-key-save-smoke.json` confirms the key is masked after restart and Firestore has `byok: true` with no `apikey` field.
- Added `npm run test:byok-smoke` and wired it into GitHub Actions for the BYOK key-save evidence.
- Validated deleting an existing synthetic timeline event through the release APK UI with reviewer account `test@era-nova.be`; evidence at `docs/qa-evidence/2026-05-06-event-delete-ui-smoke.json` confirms temporary event `ui-delete-smoke-20260506090414` disappeared from the app and Firestore query results while `play-reviewer-welcome` remained.
- Added `npm run test:event-delete-smoke` and wired it into GitHub Actions for the event deletion UI evidence.
- Captured public Firebase Hosting browser screenshots for privacy policy and account deletion pages with Google Chrome headless; evidence at `docs/qa-evidence/2026-05-06-public-policy-pages-smoke.json` confirms both URLs load without app authentication and contain the expected Nacho/privacy/deletion content.
- Added `npm run test:public-policy-pages-smoke` and wired it into GitHub Actions for the public policy page browser evidence.
- Reviewed the exported Play Console action history in `docs/previous_actions.md`; it confirms the existing Babylog Play app, prior internal testing release, old Era Nova contact fields, Parenting category, and no-ads declaration, but it does not prove the current Nacho/privacy URL/reviewer/AAB fields are accepted.
- Added `docs/play-console-action-history.md` and `npm run test:play-console-history`, and corrected the Firebase Hosting runbook so Play Console URL fields remain explicitly unconfirmed until Console screenshots or exports exist.
- Checked official Play target API, app review, and account deletion docs on 2026-05-06; added `docs/play-policy-freshness.md` and `npm run test:play-policy-freshness` so current API 35/privacy/app-access/deletion assumptions are tracked as a dated policy snapshot.
- Added `scripts/prepare_play_console_handoff.mjs`, `docs/play-console-handoff.md`, and `npm run test:play-handoff` to generate and verify a non-secret `dist/play-console-handoff/` folder with the signed AAB, Play graphics, screenshots, and copy sources for Console upload.
- Added `scripts/prepare_play_console_private_notes.mjs` and `npm run test:play-private-notes` to generate ignored private Play Console App access notes from `.qa-secrets/play-reviewer-account.json` without committing reviewer credentials.
- Generated the ignored private Play Console App access notes at `dist/play-console-handoff/private/play-console-app-access-notes.txt`; the file is local-only and must not be committed or screenshotted without redacting the reviewer password.
- Added `docs/play-console-evidence.md` and `npm run test:play-console-evidence` to define the redacted Play Console acceptance evidence that must be captured after upload, policy setup, listing/media acceptance, internal testing, production release, and later install metrics.
- Justin uploaded the `1.0.5+6` AAB to Play Console internal testing, copied `android/app/releasenotes.md` into the release notes, left the release name as `6 (1.0.5)`, and provided a screenshot showing the release is active, available to internal testers, released on 2026-05-06 15:06, and still `Not reviewed`.
- Updated the private Play Console notes generator so an optional ignored `.qa-secrets/play-reviewer-account.json` `openaiApiKey` field is included only in the private notes, with reviewer instructions to paste it into Settings because BYOK keys are stored locally on-device.
- Aligned Play reviewer access, App content, submit packet, and handoff docs with the private-notes OpenAI key path: keys stay out of Firebase/git/app bundles, and reviewers paste any temporary key into local BYOK Settings.
- Validated the shared-assistant account deletion branch on the release APK with disposable verified Firebase Auth users `sharedprimary20260506145235@example.com` and `sharedpartner20260506145235@example.com`: after deleting the primary user from Settings, primary Auth sign-in is rejected, partner Auth still works, assistant `shared-delete-smoke-20260506145235` remains with only the partner in `users`, old shared events are deleted, and the partner can create a new event afterward. Evidence: `docs/qa-evidence/2026-05-06-shared-assistant-deletion-smoke.json` and three release APK screenshots.
- Found and fixed a real release blocker in the shared-assistant join path: the old app tried to read the target assistant before membership, which live hardened Firestore rules denied.
- Updated `firestore.rules` so a non-member can only join by adding their own signed-in email to `assistants/{id}.users`; non-member reads and unrelated assistant writes remain denied. Deployed the updated rules to `babylog-flutter`.
- Updated `AssistantManager.joinAssistant` to claim membership with `FieldValue.arrayUnion` before updating the user's `current_assistant`, avoiding the denied pre-join read.
- Bumped the next Play upload candidate to `1.0.6+7`, rebuilt the signed release APK and AAB, and updated the submit packet, listing, runbook, manual QA checklist, and release audit. AAB SHA-256: `b2c95f5489acfa076bd054e8d6733df8b9ed31eef3396f74b2d1e8f178c9d6b5`; APK SHA-256: `62adf39ff32aee776a4b4d1af4fd05f548b6368d1fc9e09fa19f392c5c77fa1d`.
- Validated the shared-assistant join UI path on AVD `babylog_api35` with release APK `1.0.6+7`: joiner `joiner20260506151008@example.com` used Settings > Join another assistant for assistant `join-ui-smoke-20260506151008`, the timeline switched to owner event `join-ui-owner-event-20260506151008`, refreshed Settings showed both synthetic users, and Firestore confirmed joiner-created event `join-ui-joiner-event-20260506151008`. Evidence: `docs/qa-evidence/2026-05-06-join-assistant-ui-smoke.json` plus four screenshots.
- Checked ignored reviewer/private notes for a temporary OpenAI key without printing secrets; `.qa-secrets/play-reviewer-account.json` currently has no `openaiApiKey`, and the ignored private Play notes file is not generated, so real BYOK transcription QA remains blocked.
- Validated restart persistence on AVD `babylog_api35` with release APK `1.0.6+7`: reviewer account `test@era-nova.be` displayed event `play-reviewer-welcome`, the app was force-stopped and relaunched, the same event remained visible, and Firestore still links the reviewer to `play-reviewer-assistant`. Evidence: `docs/qa-evidence/2026-05-06-restart-persistence-smoke.json` plus before/after screenshots.

### Verification
- `git status` was clean immediately after the merge.
- Flutter 3.41.9 and Dart 3.11.5 are now installed at `/opt/homebrew/share/flutter`.
- Android command-line tools, SDK platforms 34/36, build tools, NDK 27.0.12077973, and OpenJDK 17 are installed locally.
- `flutter doctor -v` is green for Android; Xcode/CocoaPods remain incomplete, which does not block Android Play Store release.
- `flutter pub get` passes.
- `dart format --set-exit-if-changed lib test` passes.
- `flutter analyze --no-fatal-infos` passes with 84 remaining info-level lint issues; the prior direct-`http` dependency warnings are gone.
- `flutter test` passes: 10 tests.
- `npm run test:policy` passes: 2 static policy page tests.
- `npm run test:app-content` passes: Play Console App content draft contains the required review answers.
- `npm run test:listing` passes: Play Store app name, short description, and full description limits are checked.
- `npm run test:manual-qa` passes: manual QA checklist covers release-critical flows.
- `npm run test:growth` passes: 1000-user metric source and evidence requirements are defined.
- `npm run test:hosting` passes: Firebase Hosting points to `docs/public`, uses default project `babylog-flutter`, enables clean URLs, and rewrites `/` to the privacy policy.
- `npm run test:play-release` passes: Play release runbook covers upload, internal testing, production release, monitoring, and 1000-install evidence.
- `npm run test:upload-key` passes: upload-key recovery runbook covers password recovery, Play App Signing reset, new upload key generation, and signed AAB retry steps.
- `npm run test:android-manifest` passes: Android launcher label is `Babylog`.
- `npm run test:android-release-identity` passes: package name is `com.eranova.babylog`, release version is `1.0.6+7`, target SDK is 35, compile SDK is 36, required permissions are present, and listing identity fields match the app config.
- `npm run test:play-assets` passes: `docs/play-assets/icon-512.png` is a 512 x 512 PNG, `docs/play-assets/feature-graphic-1024x500.png` is a 1024 x 500 no-alpha PNG, and both are referenced from the Play Store listing draft.
- `npm run test:play-reviewer-access` passes: reviewer notes cover Firebase email/password access, `test@era-nova.be`, `play-reviewer-assistant`, BYOK-only behavior, optional private-notes OpenAI key handling, sample-data warning, Privacy Policy, and Delete Account.
- `npm run test:release-audit` passes: the completion audit still concludes the active objective is not achieved and cites the remaining Play Console, BYOK recorder QA, and 1000-user evidence gaps.
- `npm run test:byok-smoke` passes: BYOK smoke evidence is non-secret, release-scoped, verifies all recorded checks, and keeps the real OpenAI recording gap explicit.
- `npm run test:event-delete-smoke` passes: event deletion UI smoke evidence is non-secret, release-scoped, verifies before/after screenshots, and keeps recorder-created event QA explicit as a remaining gap.
- `npm run test:public-policy-pages-smoke` passes: public policy page smoke evidence is non-secret, browser-captured, hash-checked, and still keeps Play Console URL field confirmation explicit as a remaining gap.
- `npm run test:play-console-history` passes: exported Play Console history is reviewed without treating old Era Nova Console settings as current release acceptance.
- `npm run test:play-policy-freshness` passes: the dated Play policy snapshot is present, points to official docs, verifies `targetSdk = 35` / `compileSdk = 36`, and remains explicit that Console acceptance is still required.
- `npm run test:play-handoff` passes: the generated Play handoff bundle contains the expected AAB/media/copy files, preserves the signed AAB SHA-256, and keeps secrets out of the generated manifest and README.
- `npm run test:play-private-notes` passes: the private App access notes generator is tested with a fake reviewer secret and points output at ignored `dist/play-console-handoff/private/play-console-app-access-notes.txt`.
- `npm run test:rules` passes under Homebrew OpenJDK 21: Firestore rules still deny non-member reads and unrelated writes while allowing the join-only self-email update.
- `flutter build apk --release` passes for `1.0.6+7`, producing `build/app/outputs/flutter-apk/app-release.apk` at 55.5 MB.
- `flutter build appbundle --release` passes for `1.0.6+7`, producing `build/app/outputs/bundle/release/app-release.aab` at 46.9 MB.
- `npm run prepare:play-handoff` regenerated the ignored `dist/play-console-handoff/` folder for `1.0.6+7`; the manifest reports AAB SHA-256 `b2c95f5489acfa076bd054e8d6733df8b9ed31eef3396f74b2d1e8f178c9d6b5`.
- `npm run prepare:play-handoff && npm run prepare:play-private-notes` was re-run after the restart persistence smoke; `dist/play-console-handoff/release/app-release.aab` matches the built AAB SHA-256 `b2c95f5489acfa076bd054e8d6733df8b9ed31eef3396f74b2d1e8f178c9d6b5`, and the ignored private notes include reviewer credentials plus BYOK instructions but no temporary OpenAI key.
- GitHub Actions run `25445833584` for commit `8866c25` passed both jobs after recording the current Play handoff state: Analyze/test completed in 6m28s including the Android debug APK build, and Firebase rules completed in 28s.
- Checked the local ignored reviewer secret, generated private Play notes, environment variables, and `~/Documents/secrets.yaml` without printing secret values; no OpenAI API key is present locally yet, so temporary reviewer BYOK setup remains blocked on adding `openaiApiKey` to `.qa-secrets/play-reviewer-account.json` or entering it manually on a review device.
- Added `npm run setup:play-reviewer-openai-key` to copy a temporary reviewer OpenAI key from the `OPENAI_API_KEY` environment variable into the ignored reviewer secret without printing it; the key still is not present locally until the environment variable is provided.
- GitHub Actions run `25446714861` for commit `3c584bf` passed both jobs after adding the reviewer OpenAI key setup helper: Analyze/test completed in 7m9s including the new helper test and Android debug APK build, and Firebase rules completed in 31s.
- Updated the private Play Console notes generator to include a compact reviewer instructions field that is validated to stay within Play Console's 500-character limit and includes the temporary OpenAI key when present locally.
- Focused local validation after the join fix passes: `dart format --set-exit-if-changed lib test`, `flutter analyze --no-fatal-infos`, `flutter test`, `npm run test:manual-qa`, `npm run test:release-audit`, `npm run test:play-submit-packet`, `npm run test:play-handoff`, `npm run test:play-release-notes`, `npm run test:play-console-evidence`, `npm run test:android-release-identity`, `npm run test:rules`, and `git diff --check`.
- `npm run test:play-console-evidence` passes: the Console evidence template covers the required acceptance proof items and redaction rules without embedding secrets.
- 2026-05-06 local npm script sweep passed through all non-emulator Play/docs/policy validators plus `npm run test:upload-key`; it stopped at `npm run test:rules` because the local machine currently has OpenJDK 17 only and the installed Firebase CLI requires Java 21+ for emulator tests.
- `git diff --check` passes for the private reviewer OpenAI notes slice.
- GitHub Actions run `25441543391` for commit `6ee07ad` passed both jobs after documenting the private reviewer OpenAI key flow: Analyze/test completed in 7m23s including Android debug APK build, and Firebase rules completed in 35s.
- GitHub Actions run `25426969401` failed twice on `main` only at `flutter build apk --debug` before app compilation because Gradle could not resolve Flutter's `org.gradle.kotlin.kotlin-dsl:4.5.0` plugin while the Gradle Plugin Portal artifact URL returned HTTP 503.
- GitHub Actions run `25427451856` for commit `587f230` passed both Analyze/test and Firebase rules jobs after the transient Gradle Plugin Portal issue cleared during the build window; `main` is green again.
- GitHub Actions run `25428242326` for commit `8a7bbf9` passed both jobs after adding the Play Console action-history guard: Firebase rules completed in 34s, and Analyze/test completed in 6m7s including the Android debug APK build.
- GitHub Actions run `25430047488` for commit `c287738` passed both jobs after adding the private Play App access notes generator: Analyze/test completed in 6m54s including the new `npm run test:play-private-notes` step and Android debug APK build; Firebase rules completed in 29s.
- GitHub Actions run `25430770146` for commit `661a8d0` passed both jobs after adding the Play Console evidence template: Analyze/test completed in 6m18s including the new `npm run test:play-console-evidence` step and Android debug APK build; Firebase rules completed in 26s.
- GitHub Actions run `25434086084` for commit `1ff35a4` passed both jobs after bumping the Play release version code to `1.0.5+6`: Analyze/test completed in 6m10s and Firebase rules completed in 26s.
- GitHub Actions run `25434742601` for commit `a8a4578` passed both jobs after adding the Play version-code reuse guard: Analyze/test completed in 5m52s and Firebase rules completed in 27s.
- GitHub Actions run `25435116894` for commit `67039da` passed both jobs after adding release identity metadata to the Play handoff: Analyze/test completed in 6m27s and Firebase rules completed in 26s.
- `npm run test:play-screenshots` passes: screenshot plan covers sign-in, Settings/Privacy Policy, shared timeline, recording permission, first event, Delete Account, synthetic data rules, hidden OpenAI keys, and manual QA linkage.
- `npm run test:public-urls` passes: verified Firebase Hosting privacy-policy and account-deletion URLs are recorded.
- `npm run test:play-distribution` passes: distribution draft covers free app setup, Parenting category, suggested tags, Belgium/United States initial rollout, no ads, no IAP, and not enrolling in Families.
- `keytool -list` opens `/Users/home/Documents/AndroidReleaseKeys/eranova_upload.jks` with alias `upload` using the ignored local signing config.
- `flutter build appbundle --release` passes, producing `build/app/outputs/bundle/release/app-release.aab` at 46.9 MB for `1.0.6+7`.
- Signed AAB SHA-256: `b2c95f5489acfa076bd054e8d6733df8b9ed31eef3396f74b2d1e8f178c9d6b5`.
- The bundle release manifest generated for the AAB reports package `com.eranova.babylog`, `android:versionCode="6"`, and `android:versionName="1.0.5"`.
- `jarsigner -verify build/app/outputs/bundle/release/app-release.aab` exits 0.
- `firebase projects:list` shows `babylog-flutter` as the current Firebase project.
- `firebase deploy --only hosting` succeeds for `babylog-flutter`.
- `https://babylog-flutter.web.app/privacy-policy` returns HTTP 200 and contains `Developer: Nacho`, `privacy@lenacho.be`, Firebase, and OpenAI content.
- `https://babylog-flutter.web.app/delete-account` returns HTTP 200 and contains `privacy@lenacho.be`, `Babylog account deletion request`, and `without reinstalling the app`.
- `firebase firestore:indexes --project babylog-flutter` shows two production `events` indexes: `assistant/when/__name__` and `type/when/__name__`.
- `npm run test:firestore-indexes` passes: local `firestore.indexes.json` preserves both production `events` indexes.
- `firebase deploy --only firestore:rules --project babylog-flutter` succeeds and releases `firestore.rules` to Cloud Firestore.
- `.github/workflows/flutter-ci.yml` parses as valid YAML after adding the Play metadata, policy, and release-runbook checks.
- `flutter build apk --debug` passes with Homebrew OpenJDK 17 and Kotlin Gradle plugin 2.1.0, producing `build/app/outputs/flutter-apk/app-debug.apk`.
- `npm run test:rules` passes with Homebrew OpenJDK 21: 6 Firestore rule tests.
- JSON config validation passes for `firebase.json`, `firestore.indexes.json`, `database.rules.json`, `package.json`, and `package-lock.json`.
- The Android release-key zip contains the same JKS and PEPK files already extracted under `~/Documents/AndroidReleaseKeys`.
- `rg` no longer finds `firebase-analytics` or `firebase_analytics`; only Babylog timeline event model names remain.
- `flutter pub get` removed `firebase_database`, `firebase_database_platform_interface`, `firebase_database_web`, and `firebase_ui_database` from `pubspec.lock`.
- `flutter build apk --debug` passes after the Analytics/RTDB dependency removals and Kotlin 2.1.0 upgrade when run with Homebrew OpenJDK 17 on `JAVA_HOME`.
- `flutter test` passes after the Firebase Auth/UI dependency upgrade: 10 tests.
- `flutter analyze --no-fatal-infos` exits successfully after the Firebase Auth/UI dependency upgrade with the same 84 info-level lint issues.
- `flutter build apk --release` passes after the Firebase Auth/UI dependency upgrade and produces `build/app/outputs/flutter-apk/app-release.apk` at 55.5 MB.
- AVD release sign-in with disposable verified QA user `qa202605060729068d@example.com` succeeds after the Firebase Auth/UI dependency upgrade; filtered logs show Firebase Auth token notification for uid `codexqa20260506072958350d` and no repeat of the Pigeon decode exception.
- `docs/qa-evidence/2026-05-06-release-apk-qa-timeline-after-firebase-upgrade.png` is a sanitized 1080 x 2400 PNG showing the signed-in timeline.
- `docs/qa-evidence/2026-05-06-disposable-qa-firestore-smoke.json` records only non-secret smoke evidence and points to the local ignored password store for the disposable QA account.
- GitHub Actions run `25422575356` passes on `main`: Analyze/test completed in 6m8s and Firebase rules completed in 25s.
- Account deletion release-APK smoke passes on AVD `babylog_api35`: app returned to sign-in, REST Auth sign-in was rejected afterward, `users/codexdeleteqa20260506075317ad1d03` was deleted, assistant `icM00h2TvBff3LU1P2Nn` was deleted, and event `delete-smoke-codexdeleteqa20260506075317ad1d03` was deleted.
- Play reviewer access smoke passes: REST Auth sign-in works for `test@era-nova.be`, Firestore user doc points to `play-reviewer-assistant`, assistant membership includes the reviewer email, sample event `play-reviewer-welcome` exists, and release APK sign-in reaches the sample timeline.
- `git diff --check` passes.
- `.github/workflows/flutter-ci.yml` parses as valid YAML via Ruby.
- `npm run test:policy`, `npm run test:public-urls`, `npm run test:play-release`, `npm run test:upload-key`, `npm run test:firestore-indexes`, and `npm run test:hosting` were re-run on 2026-05-06 and pass.
- `flutter test` was re-run on 2026-05-06 and passes: 10 tests.
- `flutter analyze --no-fatal-infos` was re-run on 2026-05-06 and exits successfully with the same 84 info-level lint issues.
- `git diff --check`, `.github/workflows/flutter-ci.yml` YAML parsing, and JSON parsing for `package.json`, `firebase.json`, and `firestore.indexes.json` were re-run on 2026-05-06 and pass.
- Firebase Auth password reset request for `test@era-nova.be` succeeded through the Identity Toolkit API using the app's Firebase web config.
- Temporary Firebase Auth export was parsed and deleted; it confirmed `test@era-nova.be` is email-verified and enabled.
- Firestore REST verification confirms `play-reviewer-assistant` includes `test@era-nova.be`, the reviewer user doc points to that assistant, and `play-reviewer-welcome` belongs to that assistant.
- Full lightweight Node release validator sweep was re-run on 2026-05-06 after the listing-copy update and passed: Android manifest/identity, app content, compliance docs, Firestore indexes, growth, hosting, listing, manual QA, Play assets, distribution, release runbook, release notes, reviewer access, screenshots, submit packet, policy pages, public URLs, and upload-key docs.
- `npm run test:compliance-docs` passes and is now included in GitHub Actions plus the Play release runbook preflight.
- `npm run test:manual-qa` now also validates the prefilled non-secret release evidence in the manual QA checklist.
- `docs/release-completion-audit.md` currently concludes the active objective is not achieved.
- Rechecked two prior blockers in the merged code:
  - `android/app/src/main/AndroidManifest.xml` now declares `android.permission.INTERNET`.
  - `lib/components/recorder.dart` now records to `getTemporaryDirectory()` instead of the old placeholder path.

### Next steps
1. Restore or inspect the pre-merge stash only if those local-only files are still needed.
2. Upload `build/app/outputs/bundle/release/app-release.aab` to the existing Babylog Play Console app `com.eranova.babylog`.
3. Push local `main` and inspect the GitHub Actions Flutter CI result.
4. Confirm whether Play Console developer account details can be changed from Era Nova to Nacho / `lenacho.be`.
5. Manually verify account deletion with a test account in Firebase Auth and Firestore.
6. Manually smoke-test the deployed Firestore rules with the app/internal test account, especially assistant membership, event creation, and account deletion.
7. Add/confirm the Firebase Hosting privacy-policy and account-deletion URLs in Play Console.
8. Produce final Play Console screenshots and any required graphic assets from a sanitized build.
9. Push the branch and verify the expanded GitHub Actions workflow remotely.
10. Keep `docs/release-completion-audit.md` updated with real Play Console, Firebase, and download evidence.
11. Complete `docs/manual-qa-checklist.md` during internal testing on a real Android device.
12. Keep the 1000-user/download evidence objective paused until Play release is complete.
13. Create or confirm the `privacy@lenacho.be` alias.
14. Follow `docs/play-release-runbook.md` for internal testing, production rollout, and release evidence now that signing is fixed.
15. Finish reviewer access: set the final `test@era-nova.be` password outside git and copy the final BYOK-only Play Console app-access notes without committing secrets.
16. Upload/confirm the captured phone screenshots in Play Console, and replace or extend them if Play Console rejects local AVD screenshots.
17. Provide Play Console access or Play Developer API/service-account automation if AAB upload should be done from this workspace.
18. Provide a real Android device or create an Android AVD if manual QA/screenshots should be captured locally.
19. GitHub Actions is being stabilized after the first push: Firebase rules now use project-local `firebase-tools`, and Flutter analysis now excludes generated dependency folders.

## What this is
A quick, living snapshot of where the Babylog app is at, what’s risky, and what we’re doing next.

## Product summary
Babylog is a Flutter mobile app for parents to log baby events to a shared timeline.
Core interaction: record audio → transcribe (OpenAI Whisper) → interpret into structured “events” → store in Firebase.

## Repo snapshot (today)
- **Framework:** Flutter / Dart
- **Backend services:** Firebase Auth + Firestore; Realtime Database rules remain default-deny, but unused RTDB Flutter dependencies have been removed.
- **AI:** OpenAI API calls currently done directly from the client (chat + audio transcription)
- **Android:** targetSdk 35, compileSdk 36, minSdk 23, AGP 8.8.0, Gradle 8.10.2, Kotlin 2.1.0

## Current state
The app runs in dev, but a **production-quality Android release is not safe yet**.
The Codex audit (audit/2026-02-03.md) flags multiple release blockers and compliance risks.

## Critical blockers (must fix before release)
1) **BYOK flow needs manual device validation**
   - Shared/dev key handling has been removed; OpenAI calls now require a local BYOK key stored with `flutter_secure_storage`.
   - Release decision: first Play submission uses BYOK-only direct client calls; backend proxy is deferred.
   - Remaining risk: saving a key, restarting, recording, transcription, and event creation still need real-device/internal-test validation.

2) **Play Console upload/release must be completed**
   - `android/app/build.gradle.kts` now supports `android/key.properties` and environment variables.
   - Resolved: `flutter build appbundle --release` now produces a signed AAB.
   - Remaining risk: Play Console still needs to accept the uploaded AAB and release it through testing/production.

3) **Data deletion requires manual Firebase validation**
   - Implemented: delete account now deletes assistant events, the user doc, assistant membership/doc state, assistant-scoped local OpenAI key data, and the Firebase Auth user.
   - Remaining validation: run the flow on a real test account and confirm Firebase Auth, `users`, `assistants`, and `events` state in Firebase Console.
   - Risk: Play Console account deletion requirements remain unclosed until this is manually verified and reflected in policy/disclosures.

Resolved from the earlier audit:
- `android.permission.INTERNET` is now present in the main Android manifest.
- Audio recording now uses a temporary directory path instead of a placeholder path.

## High-risk / compliance
- **Firebase security rules** are now in repo, emulator-tested, and deployed to `babylog-flutter`; they still need app-level smoke testing against real Firebase data.
- **Data Safety disclosures** now have a draft inventory in `docs/play-console-compliance.md`, Settings exposes in-app privacy-policy text, and Firebase-hosted policy/deletion pages are published and verified; final Play Console answers still need signed-AAB SDK review and Console acceptance.
- **Store listing** draft now exists in `docs/play-store-listing.md`; public URLs are published, but full signed-in screenshot coverage and final Play Console media upload are still missing.
- **App content** draft now exists in `docs/play-console-app-content.md`; reviewer credentials and BYOK review instructions still need final inputs.

## Architecture pain points (to revamp)
- **Transcription pipeline** is still client-driven, but now requires local BYOK instead of a shared Firestore dev key.
- **Cost monitoring** is currently not robust/centralized.

## Milestones (Justin’s)
- ✅ (This week) Onboard + plan tasks
- **Milestone 1:** Fix all critical findings from Codex audit
- **Milestone 2:** Revamp architecture (transcription service + cost monitoring)
- **Milestone 3:** Professional-grade quality
- **Milestone 4:** Publish a new version by **2026-03-10**

## Next actions (immediate)
- Use the actionable task list in `todo.md` as the release backlog.
- Confirm decisions:
  - Keep OpenAI features in the March 10 release or not?
  - Backend proxy vs BYOK-local-only strategy.
  - Source of truth for events storage (Firestore vs RTDB).
