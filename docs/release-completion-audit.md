# Babylog Release Completion Audit

Last updated: 2026-05-06

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
| Professional release gate | `docs/release-verification.md`, `docs/play-release-runbook.md`, `.github/workflows/flutter-ci.yml`, local tests, and green remote runs including `25424811883` for commit `298e983`, `25425216927` for commit `2bb528a`, `25427451856` for commit `587f230`, `25428242326` for commit `8a7bbf9`, `25430047488` for commit `c287738`, and `25430770146` for commit `661a8d0`. | Passing for current main | Continue keeping remote CI green after each release slice. |
| Flutter formatting | `dart format --set-exit-if-changed lib test` is recorded passing in `STATUS.md`; remote CI run `25422575356` passed formatting. | Passing | Keep enforced in CI. |
| Flutter analyzer | `flutter analyze --no-fatal-infos` is recorded passing with 84 info-level issues. | Passing locally | Info-level lint debt remains. |
| Flutter tests | `flutter test` is recorded passing with 10 tests; remote CI run `25422575356` passed tests. | Passing | Expand coverage as release risk changes. |
| Android debug build | `flutter build apk --debug` is recorded passing locally; remote CI runs `25427451856` and `25428242326` built the debug APK on `main`. | Passing locally and remotely | Release AAB still must be uploaded to Play Console. |
| Android release signing | `keytool` opens the configured keystore/alias; `flutter build appbundle --release` produced `build/app/outputs/bundle/release/app-release.aab` for `1.0.5+6`; SHA-256 `f8674c6287a0100807709da49cd70327d9457f1c51bb402f3e2bcfad8fed54a0`; `jarsigner -verify` exits 0. | Signed AAB built | Upload to Play Console still required. |
| Upload key recovery | `docs/upload-key-recovery.md` exists; `npm run test:upload-key` passes; recovered password is configured only in ignored `android/key.properties`. | Resolved locally | Keep signing secrets out of git and mirror into secure release storage if needed. |
| Upload key material | `~/Documents/AndroidReleaseKeys/eranova_upload.jks` and PEPK file exist; `android/key.properties` is ignored. | Present and usable | Final Play upload must confirm Play accepts the upload key. |
| Google Play target API | `android/app/build.gradle.kts` targets SDK 35 and compiles SDK 36. | Implemented | Final AAB upload must confirm Play accepts it. |
| Android release identity | `npm run test:android-release-identity` checks package `com.eranova.babylog`, version `1.0.5+6`, target SDK 35, compile SDK 36, permissions, and listing identity fields. | Implemented | Final AAB upload must confirm Play accepts the artifact. |
| Play policy freshness | `docs/play-policy-freshness.md` records the 2026-05-06 official-doc check for target API 35+, privacy policy, ads, app access, and account deletion requirements; `npm run test:play-policy-freshness` verifies the snapshot and CI wiring. | Reviewed | Re-check immediately before any submission after 2026-08-01 and confirm Play Console accepts the uploaded AAB. |
| Android launcher brand | `android/app/src/main/AndroidManifest.xml` label is `Babylog`; `npm run test:android-manifest` passes. | Implemented | Needs final artifact check. |
| Firebase security rules | `firestore.rules`, `database.rules.json`, `npm run test:rules` passing; `firebase deploy --only firestore:rules --project babylog-flutter` succeeded; disposable AVD smoke created/loaded user and assistant data under deployed rules. Account deletion and existing-event UI deletion are smoke-tested on the release APK. | Deployed and partially smoke-tested | Event creation through the recorder, sharing, and BYOK recording still require app-level smoke evidence. |
| Account deletion implementation | `AccountDeletionService` and focused tests cover event/user/assistant/auth/local-key deletion order; `docs/qa-evidence/2026-05-06-account-deletion-smoke.json` confirms release APK single-user deletion returned to sign-in and removed Firebase Auth access, `users/{uid}`, assistant doc, and a synthetic event. | Implemented and partially device-validated | Shared-assistant deletion and local BYOK cleanup remain test-covered but not manually device-verified. |
| In-app privacy policy access | Settings exposes Privacy Policy; widget test passes. | Implemented | Must align with published policy URL/content before submission. |
| Public privacy policy | `https://babylog-flutter.web.app/privacy-policy` returned HTTP 200 and contains Nacho/privacy/Firebase/OpenAI content; `docs/qa-evidence/2026-05-06-public-policy-pages-smoke.json` records a public browser screenshot; `npm run test:policy` and `npm run test:public-policy-pages-smoke` pass. | Published and browser-smoke-tested | Add URL to Play Console if not already updated. |
| Public account deletion resource | `https://babylog-flutter.web.app/delete-account` returned HTTP 200 and contains deletion request instructions; `docs/qa-evidence/2026-05-06-public-policy-pages-smoke.json` records a public browser screenshot; `npm run test:policy` and `npm run test:public-policy-pages-smoke` pass. | Published and browser-smoke-tested | Add URL to Play Console if not already updated. |
| Static page hosting config | `firebase deploy --only hosting` succeeded for `babylog-flutter`; `npm run test:hosting` passes; browser screenshots are captured in `docs/qa-evidence/2026-05-06-public-policy-pages-smoke.json`. | Deployed and browser-smoke-tested | Play Console fields still need confirmation. |
| Public URLs | `docs/play-store-listing.md` and `docs/firebase-hosting-deploy.md` contain verified Firebase Hosting URLs; `npm run test:public-urls` passes. | Verified | Play Console fields still need confirmation. |
| Play Console action history | `docs/previous_actions.md` confirms the existing Play app `Babylog` / `com.eranova.babylog`, internal testing release `4`, Parenting category, no ads, and old Era Nova contact fields; `docs/play-console-action-history.md` maps that exported history to required Nacho/privacy URL/release updates. | Reviewed | Play Console fields still need confirmation with screenshots or exports after update. |
| Play Console evidence capture | `docs/play-console-evidence.md` defines the redacted evidence checklist for AAB acceptance, internal testing, production availability, public listing URL, policy fields, App access, Data safety, content rating, target audience, ads, store media, SDK disclosure, developer contact, and later 1000 installs; `npm run test:play-console-evidence` verifies required proof items. | Prepared | Must be filled with real redacted Play Console screenshots, exports, or public URLs after Console work. |
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
| Play Console handoff bundle | `scripts/prepare_play_console_handoff.mjs` builds `dist/play-console-handoff/` with the signed AAB, graphics, screenshots, copy sources, README, and manifest; `npm run test:play-handoff` verifies the expected files, AAB hash, and no secret-like manifest/README content. | Prepared | Must be generated locally and used or copied into Play Console; Console acceptance still required. |
| Private App access notes | `scripts/prepare_play_console_private_notes.mjs` reads ignored `.qa-secrets/play-reviewer-account.json` and writes `dist/play-console-handoff/private/play-console-app-access-notes.txt`; `npm run test:play-private-notes` verifies the generator with a fake temp secret. | Prepared locally | Must be generated locally, pasted into Play Console, and captured only with secrets redacted. |
| Manual QA evidence | `docs/manual-qa-checklist.md` exists, is prefilled with known release artifact/reviewer/public URL details, records local AVD `babylog_api35`, release APK install success, launch screenshot, disposable verified sign-in, timeline screenshot, Firestore smoke JSON, account deletion smoke JSON/screenshots, event deletion UI smoke JSON/screenshots, and public policy page browser screenshots; `npm run test:manual-qa` passes. | Partially started | BYOK recording, event creation through the recorder, deletion of a recorder-created event, sharing, restart persistence, and final reviewer credentials still require manual evidence. |
| 1000-user metric plan | `docs/growth-metrics.md` exists; `npm run test:growth` passes. | Paused / metric defined | Actual Play Console/Firebase metric evidence intentionally deferred until after release. |
| Ads/analytics surface | Firebase Analytics and RTDB Flutter dependencies removed; searches recorded clean in `STATUS.md`. | Improved | Final Play SDK/data disclosure must verify uploaded artifact. |
| OpenAI key handling | Firestore dev/shared key fallback removed; BYOK local secure storage implemented and tested; first-release decision is BYOK-only direct client calls with backend proxy deferred. `docs/qa-evidence/2026-05-06-byok-key-save-smoke.json` confirms the release APK saves a non-secret fake key locally, shows it masked after app restart, and Firestore has `byok: true` with no `apikey` field. | Improved and key-save smoke-tested | Real limited OpenAI key recording/transcription and recorder-created event QA still required. |
| Production availability on Play Store | Signed AAB exists locally, but no Play Console upload evidence or public listing URL exists in this workspace. | Not achieved | Upload the AAB, complete review, and finish production release. |
| 1000 downloads/users | `docs/growth-metrics.md` defines Play Console installs as primary evidence, but no metric capture exists. | Paused / not achieved | Resume after release and verify at least 1000 Play Console installs/acquisitions. |

## Current Hard Blockers

- No Play Console internal test, review, production release, or live listing
  evidence exists in this workspace.
- No Play Developer API, Fastlane, Gradle Play Publisher, or service-account
  automation credentials were found in the repo.
- Reviewer Firebase Auth account, password, sample Firestore assistant, REST
  evidence, and release-APK sign-in evidence are prepared locally; Play Console
  notes still must be copied into the Console without committing secrets.
- Single-user account deletion has release-APK smoke evidence against real
  Firebase Auth and Firestore data; shared-assistant deletion and local BYOK
  cleanup still need manual or broader integration evidence.
- Local AVD `babylog_api35` can install/launch the release APK, sign in with
  reviewer/test users, capture sanitized screenshots, and validate single-user
  account deletion; BYOK recording, sharing, restart persistence, and final
  Play Console media acceptance remain open.
- Firebase rules are deployed and partially smoke-tested for disposable
  sign-in/user/assistant data, but account deletion, event writes/deletes,
  sharing, and BYOK recording are not fully validated yet.
- BYOK-only direct OpenAI architecture is the first-release decision. Local
  fake-key save/restart/no-Firestore-key evidence exists, but real
  device/internal-test BYOK recording validation still needs a limited OpenAI
  key.
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
