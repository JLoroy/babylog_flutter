# Babylog Release Todo

Format: Title / Description / Guidance / How to validate.

## Critical

### Complete account deletion

**Description:** The delete-account flow is implemented through `AccountDeletionService`, including Firebase data/auth deletion and assistant-scoped local OpenAI key cleanup. Single-user release APK deletion has real Firebase/Auth/Firestore smoke evidence; shared-assistant deletion and local BYOK cleanup still need broader manual evidence before the checklist is fully closed.

**Guidance:** Use a disposable test account and assistant. Confirm deletion removes assistant events, deletes `users/{uid}`, removes the deleting user from shared assistant membership or deletes the assistant doc when no users remain, clears the local BYOK key for that assistant, and deletes the Firebase Auth user. Confirm the app handles `requires-recent-login` by asking the user to sign in again.

**How to validate:** `flutter test` covers the deletion coordinator. Single-user device evidence is recorded in `docs/qa-evidence/2026-05-06-account-deletion-smoke.json`. Manual validation is still required for the shared-assistant branch and local BYOK cleanup, with Firebase Console evidence for Auth, user doc, event docs, and assistant membership.

### Move OpenAI calls off the client

**Description:** The app still sends audio and chat requests directly from Flutter, but shared/dev key handling has been removed. OpenAI calls now require a local BYOK key stored with `flutter_secure_storage`, and assistant Firestore payloads no longer include `apikey`.

**Guidance:** First Play submission uses BYOK-only direct client calls. A backend proxy remains preferred later for request limits, structured logging, and centralized cost controls, but is deferred unless manual QA or Play review blocks release.

**How to validate:** `flutter test` covers no-Firestore-key serialization and BYOK key selection. Search the Flutter client for `devapikey` and Firestore key fetches; none should remain. If BYOK-only is accepted, manually test saving a key, restarting the app, and recording. If backend proxy is chosen, exercise the backend from an authenticated test account and confirm unauthenticated requests fail.

### Add Firebase security rules to the repo

**Description:** Firestore and Realtime Database rules are now in the repo. Firestore rules are covered by emulator tests and deployed to `babylog-flutter`; Realtime Database is default-deny because no active RTDB code path or RTDB instance was found, and unused RTDB Flutter dependencies have been removed.

**Guidance:** Smoke-test the deployed rules with the app/internal test account. The rules intentionally restrict assistant and event access to authenticated users whose email is in the assistant `users` list.

**How to validate:** Run `npm run test:rules` and `npm run test:firestore-indexes`. In Firebase Console, verify the deployed Firestore rules match `firestore.rules`, then test sign-in, assistant read/update, event creation, and account deletion against real Firebase.

### Establish release signing on this machine or CI

**Description:** Android release signing is now portable through `android/key.properties` or environment variables, the release keystore is present in `~/Documents`, and the recovered password now builds a signed release AAB.

**Guidance:** Keep `android/key.properties` ignored. Do not commit signing secrets. Mirror the signing values only into secure CI or Play release automation secrets if automation is added later.

**How to validate:** Run `npm run test:upload-key`. `keytool -list` opens `/Users/home/Documents/AndroidReleaseKeys/eranova_upload.jks` with alias `upload`; `flutter build appbundle --release` produces `build/app/outputs/bundle/release/app-release.aab`; `jarsigner -verify` exits 0.

## High

### Build a complete release verification gate

**Description:** Release readiness needs repeatable checks rather than manual memory. GitHub Actions now runs Flutter formatting/analyze/tests/debug APK, Firestore rules tests, Android release identity checks, Play Store asset checks, the Play metadata/policy validators, the Play release runbook validator, and the upload-key recovery validator.

**Guidance:** Keep `.github/workflows/flutter-ci.yml` green for formatting, analysis, tests, Android debug builds, Firestore rules, Android manifest metadata, Android release identity, Play Store listing limits, Play Store assets, App content draft, policy page checks, `docs/play-release-runbook.md`, and `docs/upload-key-recovery.md`. Keep `docs/release-verification.md` aligned with CI and include the exact Flutter version used for release.

**How to validate:** Push `main` or open a PR and confirm GitHub Actions passes. Run the full local release gate from a clean checkout and record the passing command output in `STATUS.md`.

### Prepare Play Console compliance content

**Description:** Play Store publication requires accurate store listing, privacy policy, data safety, account deletion, app access, and content declarations. Firebase Hosting URLs are now deployed and verified.

**Guidance:** Drafts now live in `docs/play-console-compliance.md`, `docs/privacy-policy-draft.md`, and `docs/account-deletion-web-copy.md`. Published pages live at `https://babylog-flutter.web.app/privacy-policy` and `https://babylog-flutter.web.app/delete-account`. Settings exposes in-app privacy-policy text. Create or confirm the `privacy@lenacho.be` alias and add/confirm both URLs in Play Console before submission.

**How to validate:** Run `npm run test:policy`, `npm run test:hosting`, and `npm run test:public-urls`. Verify both public URLs load without authentication. Review the final Play Console declarations against the committed implementation, Play Console SDK/data disclosure output for the signed AAB, and backend logs.

### Prepare Play Store listing assets

**Description:** Store listing text now has a draft in `docs/play-store-listing.md`, the Android launcher label is set to `Babylog`, Play graphics are prepared under `docs/play-assets/`, and screenshot requirements are defined in `docs/play-screenshots.md`. A local release screenshot set is captured under `docs/play-assets/screenshots/`; final Play Console media upload/acceptance is still missing.

**Guidance:** Use the listing draft for app name, package/version identity, short description, full description, release notes, contact fields, app icon, and feature graphic. Produce screenshots from a sanitized Android build according to `docs/play-screenshots.md` without exposing real baby names, email addresses, or API keys.

**How to validate:** Run `npm run test:listing`, `npm run test:play-assets`, `npm run test:play-screenshots`, `npm run test:android-manifest`, and `npm run test:android-release-identity`. Confirm Play Console accepts all text fields/assets, the uploaded APK/AAB displays the launcher label as `Babylog`, and screenshots match the final app behavior.

### Prepare Play distribution settings

**Description:** Play Console distribution settings now have a draft in `docs/play-distribution.md`, covering free pricing, Parenting category, tags, no ads, no in-app purchases, not enrolling in Families, and an initial Belgium/United States rollout.

**Guidance:** Confirm the category and initial country availability in Play Console before production. Keep the store listing clearly parent/guardian-directed so the Parenting category does not look child-directed.

**How to validate:** Run `npm run test:play-distribution`. Confirm Play Console accepts the chosen category, pricing, country availability, and declarations.

### Prepare Play Console app content answers

**Description:** Draft Play Console App content answers now live in `docs/play-console-app-content.md`, with dedicated reviewer access notes in `docs/play-reviewer-access.md`, covering restricted app access, no ads, adult parent/guardian target audience, content rating notes, data safety cross-reference, and microphone permission rationale.

**Guidance:** The reviewer Firebase Auth account is `test@era-nova.be`; it is verified, has a locally stored password in ignored `.qa-secrets/play-reviewer-account.json`, and is linked to the synthetic `play-reviewer-assistant` timeline. Use BYOK-only reviewer instructions with no OpenAI test key, then copy final Play Console app-access notes without committing real credentials. Keep listing/screenshots clearly aimed at parents and guardians rather than children.

**How to validate:** Run `npm run test:app-content` and `npm run test:play-reviewer-access`. Current local evidence is in `docs/qa-evidence/2026-05-06-play-reviewer-access-smoke.json` and `docs/qa-evidence/2026-05-06-release-apk-play-reviewer-timeline.png`. Confirm Play Console accepts the App content answers and the reviewer account can access the relevant app flows from the uploaded test build.

### Decide the March release feature scope

**Description:** OpenAI features, BYOK, shared assistants, and deletion behavior affect the release architecture and compliance story.

**Guidance:** Current first-release scope keeps AI as BYOK-only, defers the backend proxy, and uses Firestore as the source of truth. Revisit this after Play release or if manual QA/Play review blocks BYOK-only review.

**How to validate:** Record decisions in `plan.md`, update this todo list accordingly, and remove tasks that no longer apply.

## Growth

### Instrument the 1000-user goal

**Description:** The original objective includes at least 1000 downloads/users, but Justin paused that target while release, security, deployment, and Play submission are prioritized. `docs/growth-metrics.md` still defines Play Console installs/acquisitions as the primary completion metric for later.

**Guidance:** Use Play Console installs/acquisitions for the objective proof. Use Firebase Auth user count as a secondary health signal. Avoid adding analytics SDKs unless the privacy policy and Data safety disclosures are updated first.

**How to validate:** Run `npm run test:growth`. After production release, capture Play Console evidence showing at least 1000 installs/acquisitions and document the capture date, metric source, value, and evidence location in `STATUS.md` and `docs/release-completion-audit.md`.

### Improve onboarding and retention

**Description:** A professional launch needs the first session to be reliable and understandable for new parents. A manual QA evidence template now lives in `docs/manual-qa-checklist.md`.

**Guidance:** Test first-run auth, email verification, assistant creation, first recording, first event creation, settings, invite/join assistant, account deletion, public privacy/deletion pages, and Firebase Console evidence on real Android devices.

**How to validate:** Run `npm run test:manual-qa`, then complete `docs/manual-qa-checklist.md` with screenshots or notes for each flow before production rollout.
