# Babylog Release Completion Audit

Last updated: 2026-05-07

Objective under audit:
Make Babylog a fully released and professional app available on the Play Store
and downloaded by at least 1000 users.

Current user direction:
The 1000-user/download target is paused while release, security, deployment,
and Play submission are prioritized.

Current audit result:
Not achieved.

## Success Criteria

1. The Android app is production-ready and professional enough for public users.
2. A signed Android App Bundle is built with the intended upload key.
3. The app is submitted to and available on Google Play.
4. Play Console policy, store listing, App content, Data safety, privacy policy,
   and account deletion requirements are complete and accurate.
5. Firebase/Auth/Firestore behavior is safe for production.
6. Users can create accounts, use the core timeline/recording flow, and delete
   their accounts/data.
7. The app has at least 1000 verified downloads/users. This criterion is paused
   by current user direction, but remains tracked for the original objective.

## Prompt-To-Artifact Checklist

| Requirement | Evidence inspected | Status | Gap |
| --- | --- | --- | --- |
| Track decisions in `plan.md` | `plan.md` contains release decisions through Play metadata/policy CI checks and the Play release runbook. | In progress | Continue updating for every material decision. |
| Track progress in `STATUS.md` | `STATUS.md` has current milestone, changes, verification, and blockers. | In progress | Continue updating after each work chunk. |
| Professional release gate | `docs/release-verification.md`, `docs/play-release-runbook.md`, `.github/workflows/flutter-ci.yml`, local tests, and green remote runs including `25465751579` for commit `79fe822`. Audited CI `25465751579` passed Firebase rules in 33s and Analyze/test in 6m07s, including formatting, analyzer, Flutter tests, Play/docs validators, and Android debug APK build. | Passing for current main | Continue keeping remote CI green after each release slice. |
| Flutter formatting | `dart format --set-exit-if-changed lib test` passed locally and in latest remote CI run `25465751579`. | Passing | Keep enforced in CI. |
| Flutter analyzer | `flutter analyze --no-fatal-infos` passed locally with 25 info-level issues and in latest remote CI run `25465751579`. | Passing locally and remotely | Info-level lint debt remains. |
| Flutter tests | `flutter test` passed locally with 10 tests and in latest remote CI run `25465751579`. | Passing locally and remotely | Expand coverage as release risk changes. |
| Android debug build | `flutter build apk --debug` passed in latest remote CI run `25465751579`; local release APK/AAB builds for `1.0.7+8` also passed. | Passing locally and remotely | Keep remote CI green before each rollout. |
| Android release signing | `keytool` opens the configured keystore/alias; after the shared-assistant join fix, `flutter build appbundle --release` produced `build/app/outputs/bundle/release/app-release.aab` for `1.0.6+7`; SHA-256 `b2c95f5489acfa076bd054e8d6733df8b9ed31eef3396f74b2d1e8f178c9d6b5`; `jarsigner -verify` exits 0. Justin uploaded the previous `1.0.5+6` AAB to Play internal testing and provided a Play Console screenshot showing active release `6 (1.0.5)`, `1 version code`, released on 2026-05-06 15:06, and `Available to internal testers`. Justin later reported in chat that version code 7 was accepted and deployed to his phone. Version `1.0.7+8` is built as the next design-refresh candidate; AAB SHA-256 `dec7f6d4b94741d019a4a75ea48238eeb8e9c8911ba01a9e6ec71d357243f811`; `jarsigner -verify` exits 0. | Version 7 user-reported accepted; version 8 candidate built locally | Capture redacted version 7 Play acceptance evidence, then upload version 8 if design QA passes. |
| Upload key recovery | `docs/upload-key-recovery.md` exists; `npm run test:upload-key` passes; recovered password is configured only in ignored `android/key.properties`. | Resolved locally | Keep signing secrets out of git and mirror into secure release storage if needed. |
| Upload key material | `~/Documents/AndroidReleaseKeys/eranova_upload.jks` and PEPK file exist; `android/key.properties` is ignored. | Present and usable | Final Play upload must confirm Play accepts the upload key. |
| Google Play target API | `android/app/build.gradle.kts` targets SDK 35 and compiles SDK 36; Play Console internal testing accepted release `6 (1.0.5)`. | Implemented and accepted for internal testing | Production review/release still required. |
| Android release identity | `npm run test:android-release-identity` checks package `com.eranova.babylog`, version `1.0.7+8`, target SDK 35, compile SDK 36, permissions, and listing identity fields. Play Console internal testing previously showed release `6 (1.0.5)`; Justin reported in chat that version code 7 was accepted and deployed to his phone. | Version 8 candidate prepared locally | Capture redacted Play acceptance evidence for version code 7 and upload evidence for version code 8 if submitted. |
| Play policy freshness | `docs/play-policy-freshness.md` records the 2026-05-06 official-doc check for target API 35+, privacy policy, ads, app access, and account deletion requirements; `npm run test:play-policy-freshness` verifies the snapshot and CI wiring. | Reviewed | Re-check immediately before any submission after 2026-08-01 and confirm Play Console accepts the uploaded AAB. |
| Android launcher brand | `android/app/src/main/AndroidManifest.xml` label is `Babylog`; `npm run test:android-manifest` passes. | Implemented | Needs final artifact check. |
| Firebase security rules | `firestore.rules`, `database.rules.json`, `npm run test:rules` passing under Java 21; `firebase deploy --only firestore:rules --project babylog-flutter` succeeded after adding a narrow join-only update rule; disposable AVD smoke created/loaded user and assistant data under deployed rules. Account deletion, existing-event UI deletion, and shared-assistant join are smoke-tested on the release APK. | Deployed and smoke-tested for release-critical data branches | Event creation through the recorder and BYOK recording still require app-level smoke evidence. |
| Account deletion implementation | `AccountDeletionService` and focused tests cover event/user/assistant/auth/local-key deletion order; `docs/qa-evidence/2026-05-06-account-deletion-smoke.json` confirms release APK single-user deletion returned to sign-in and removed Firebase Auth access, `users/{uid}`, assistant doc, and a synthetic event. `docs/qa-evidence/2026-05-06-shared-assistant-deletion-smoke.json` confirms release APK shared-assistant deletion rejects primary Auth sign-in afterward, preserves partner Auth sign-in, leaves the assistant doc with only the partner in `users`, deletes old shared events, and allows the partner to create a new event afterward. | Implemented and device-validated for single-user and shared-assistant branches | Local BYOK cleanup is test-covered and exercised with a fake key before deletion, but device secure storage is not directly introspected. |
| In-app privacy policy access | Settings exposes Privacy Policy; widget test passes. | Implemented | Must align with published policy URL/content before submission. |
| Public privacy policy | `https://babylog-flutter.web.app/privacy-policy` returned HTTP 200 and contains Nacho/privacy/Firebase/OpenAI content; `docs/qa-evidence/2026-05-06-public-policy-pages-smoke.json` records a public browser screenshot; `npm run test:policy` and `npm run test:public-policy-pages-smoke` pass. | Published and browser-smoke-tested | Add URL to Play Console if not already updated. |
| Public account deletion resource | `https://babylog-flutter.web.app/delete-account` returned HTTP 200 and contains deletion request instructions; `docs/qa-evidence/2026-05-06-public-policy-pages-smoke.json` records a public browser screenshot; `npm run test:policy` and `npm run test:public-policy-pages-smoke` pass. | Published and browser-smoke-tested | Add URL to Play Console if not already updated. |
| Static page hosting config | `firebase deploy --only hosting` succeeded for `babylog-flutter`; `npm run test:hosting` passes; browser screenshots are captured in `docs/qa-evidence/2026-05-06-public-policy-pages-smoke.json`. | Deployed and browser-smoke-tested | Play Console fields still need confirmation. |
| Public URLs | `docs/play-store-listing.md` and `docs/firebase-hosting-deploy.md` contain verified Firebase Hosting URLs; `npm run test:public-urls` passes. | Verified | Play Console fields still need confirmation. |
| Play Console action history | `docs/previous_actions.md` confirms the existing Play app `Babylog` / `com.eranova.babylog`, internal testing release `4`, Parenting category, no ads, and old Era Nova contact fields; `docs/play-console-action-history.md` maps that exported history to required Nacho/privacy URL/release updates. | Reviewed | Play Console fields still need confirmation with screenshots or exports after update. |
| Play Console evidence capture | `docs/play-console-evidence.md` defines the redacted evidence checklist for AAB acceptance, internal testing, production availability, public listing URL, policy fields, App access, Data safety, content rating, target audience, ads, store media, SDK disclosure, developer contact, and later 1000 installs; `npm run test:play-console-evidence` verifies required proof items. Justin provided a Play Console screenshot in chat showing internal testing release `6 (1.0.5)` active and available to internal testers. | Partially captured | Need committed/redacted evidence files or screenshots for remaining Console fields, production availability, and install metrics. |
| Data safety inventory | `docs/play-console-compliance.md` exists and `npm run test:compliance-docs` verifies current Nacho/privacy identity and public policy/deletion URLs. | Drafted | Final Play Console SDK/data disclosure review still required. |
| Store listing | `docs/play-store-listing.md` exists; `npm run test:listing` passes and verifies published policy/deletion URL references. | Drafted | Screenshots and final Play Console entry still required. |
| Play distribution | `docs/play-distribution.md` exists; `npm run test:play-distribution` passes. | Drafted | Final Play Console pricing/category/country settings still required. |
| Play Store graphics | `docs/play-assets/icon-512.png` and `docs/play-assets/feature-graphic-1024x500.png` exist; `npm run test:play-assets` verifies the app icon is 512 x 512 and the feature graphic is a 1024 x 500 no-alpha PNG, both listed in `docs/play-store-listing.md`. | Prepared | Final Play Console upload must accept the graphics. |
| Play screenshots | `docs/play-screenshots.md` exists; `npm run test:play-screenshots` verifies required sanitized phone screenshot coverage and the manifest `docs/play-assets/screenshots/2026-05-06-local-release-screenshot-set.json`. Local release APK screenshots exist for sign-in, synthetic shared timeline, Settings/BYOK, Privacy Policy, and microphone permission; the Settings screenshot redacts reviewer email and assistant id. | Locally prepared | Upload/confirm in Play Console, and replace or extend if Play rejects local AVD screenshots. Recorder-created first event evidence still requires BYOK/internal-test validation. |
| App content answers | `docs/play-console-app-content.md` exists; `npm run test:app-content` passes; BYOK-only review path is documented. | Drafted | Final Play Console copy/paste and acceptance still required. |
| Reviewer access notes | `docs/play-reviewer-access.md` records `test@era-nova.be`, assistant id `play-reviewer-assistant`, BYOK-only reviewer instructions, and local ignored password storage; `docs/qa-evidence/2026-05-06-play-reviewer-access-smoke.json` confirms REST sign-in and Firestore access; `docs/qa-evidence/2026-05-06-release-apk-play-reviewer-timeline.png` confirms release APK sign-in to the sample timeline; `npm run test:play-reviewer-access` passes. | Prepared locally | Copy the password into Play Console app-access notes and confirm the uploaded/internal-test build accepts it. |
| Play release runbook | `docs/play-release-runbook.md` exists; `npm run test:play-release` passes. | Prepared | Must be followed now that signing is fixed and Play Console access is ready. |
| Play release notes | `android/app/releasenotes.md` matches the current listing release notes; `npm run test:play-release-notes` passes. | Prepared | Must be accepted or copied into Play Console release notes. |
| Play Console submit packet | `docs/play-console-submit-packet.md` exists; `npm run test:play-submit-packet` verifies artifact, identity, URLs, reviewer, BYOK, and asset values. | Prepared | Must be copied into Play Console and accepted there. |
| Play Console handoff bundle | `scripts/prepare_play_console_handoff.mjs` builds `dist/play-console-handoff/` with the signed AAB, graphics, screenshots, copy sources, README, and manifest; `npm run test:play-handoff` verifies the expected files, AAB hash, and no secret-like manifest/README content. Justin reported that the current upload appears as version code 7 in Play Console. | Used for internal testing upload; redacted evidence pending | Handoff files and chat reports still are not production release or policy-field acceptance evidence. |
| Private App access notes | `scripts/prepare_play_console_private_notes.mjs` reads ignored `.qa-secrets/play-reviewer-account.json` and writes `dist/play-console-handoff/private/play-console-app-access-notes.txt`; `npm run test:play-private-notes` verifies the generator with a fake temp secret. | Prepared locally | Must be generated locally, pasted into Play Console, and captured only with secrets redacted. |
| Manual QA evidence | `docs/manual-qa-checklist.md` exists, is prefilled with known release artifact/reviewer/public URL details, records local AVD `babylog_api35`, release APK install success, launch screenshot, disposable verified sign-in, timeline screenshot, restart persistence smoke JSON/screenshots (`docs/qa-evidence/2026-05-06-restart-persistence-smoke.json`), Firestore smoke JSON, account deletion smoke JSON/screenshots, shared-assistant deletion smoke JSON/screenshots, shared-assistant join UI smoke JSON/screenshots (`docs/qa-evidence/2026-05-06-join-assistant-ui-smoke.json`), event deletion UI smoke JSON/screenshots, public policy page browser screenshots, the version `1.0.7+8` design-refresh smoke (`docs/qa-evidence/2026-05-07-design-refresh-smoke.json`), and direct redacted OpenAI BYOK endpoint smoke (`docs/qa-evidence/2026-05-07-openai-byok-endpoint-smoke.json`); `npm run test:manual-qa` passes. | Partially started | Full in-app BYOK microphone recording, event creation through the recorder, deletion of a recorder-created event, and final Play Console media/reviewer acceptance still require manual evidence. |
| 1000-user metric plan | `docs/growth-metrics.md` exists; `npm run test:growth` passes. | Paused / metric defined | Actual Play Console/Firebase metric evidence intentionally deferred until after release. |
| Ads/analytics surface | Firebase Analytics and RTDB Flutter dependencies removed; searches recorded clean in `STATUS.md`. | Improved | Final Play SDK/data disclosure must verify uploaded artifact. |
| OpenAI key handling | Firestore dev/shared key fallback removed; BYOK local secure storage implemented and tested; first-release decision is BYOK-only direct client calls with backend proxy deferred. `docs/qa-evidence/2026-05-06-byok-key-save-smoke.json` confirms the release APK saves a non-secret fake key locally, shows it masked after app restart, and Firestore has `byok: true` with no `apikey` field. `docs/qa-evidence/2026-05-07-openai-byok-endpoint-smoke.json` confirms the ignored temporary reviewer OpenAI key reaches Whisper transcription and `gpt-4o-mini` event interpretation with synthetic audio/text, producing a parsed `bottle` event without recording key material. | Improved, key-save smoke-tested, and direct endpoint-smoke-tested | Full in-app microphone recording/transcription and recorder-created event QA still required. |
| Production availability on Play Store | Play Console internal testing reached at least release `6 (1.0.5)`, and Justin reported that version code 7 was accepted and deployed to his phone, but no production release or public listing URL exists in this workspace. | Not achieved | Complete review, policy setup, and production release. |
| 1000 downloads/users | `docs/growth-metrics.md` defines Play Console installs as primary evidence, but no metric capture exists. | Paused / not achieved | Resume after release and verify at least 1000 Play Console installs/acquisitions. |

## Current Hard Blockers

- Play Console internal testing evidence exists from Justin's 2026-05-06
  screenshot: release `6 (1.0.5)` is active, available to internal testers, and
  not reviewed. Justin later reported that the current `1.0.6+7` AAB appears as
  version code 7, that App access notes were added, and on 2026-05-07 that the
  release was accepted and deployed to his phone; redacted committed evidence for
  version code 7, production release, and live listing evidence still do not
  exist in this workspace.
- No Play Developer API, Fastlane, Gradle Play Publisher, or service-account
  automation credentials were found in the repo.
- Reviewer Firebase Auth account, password, sample Firestore assistant, REST
  evidence, and release-APK sign-in evidence are prepared locally; Play Console
  notes still must be copied into the Console without committing secrets.
- Single-user and shared-assistant account deletion have release-APK smoke
  evidence against real Firebase Auth and Firestore data; local BYOK cleanup is
  test-covered and exercised with a fake key before deletion, but device secure
  storage is not directly introspected.
- Local AVD `babylog_api35` can install/launch the release APK, sign in with
  reviewer/test users, capture sanitized screenshots, and validate single-user
  account deletion, shared-assistant join, and restart persistence; BYOK
  recording and final Play Console media acceptance remain open.
- Firebase rules are deployed and smoke-tested for disposable
  sign-in/user/assistant data, account deletion, event writes/deletes, and
  sharing. BYOK recording is not fully validated yet.
- BYOK-only direct OpenAI architecture is the first-release decision. Local
  fake-key save/restart/no-Firestore-key evidence exists, and the temporary
  reviewer OpenAI key has direct redacted endpoint smoke evidence for Whisper
  transcription plus `gpt-4o-mini` event interpretation. Full
  device/internal-test BYOK microphone recording validation remains open.
- The 1000-user/download target is paused by user direction; no Play Console or
  Firebase evidence shows 1000 downloads/users yet.

## Completion Rule

Do not mark the active objective complete until the audit can cite concrete
evidence for all of the following:

- A signed release `.aab` built with the intended upload key.
- The `.aab` uploaded to Play Console and accepted for the chosen track.
- Public Google Play listing URL showing Babylog available to users.
- Published privacy-policy and account-deletion URLs configured in Play Console.
- App content, Data safety, content rating, target audience, and ads
  declarations accepted in Play Console.
- Manual account deletion validation evidence from Firebase Auth and Firestore,
  including any shared-assistant case required for the final Play risk decision.
- Completed manual QA evidence from `docs/manual-qa-checklist.md`.
- Production Firebase rules deployed and smoke-tested with the app/internal test
  account after deployment.
- If/when the paused growth target resumes, a Play Console/Firebase metric
  showing at least 1000 downloads/users.
