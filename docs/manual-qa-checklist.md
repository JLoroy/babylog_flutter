# Babylog Manual QA Evidence Checklist

Last updated: 2026-05-06

Status: partially prefilled release evidence template. Complete the remaining
result fields on a real Android device or Play internal testing install before
production release.

## Test Environment

- App version/build: `1.0.2+3`
- Build artifact: `build/app/outputs/bundle/release/app-release.aab`
- Build artifact SHA-256:
  `11ccb6bd27a564f9772725b8ef10fdd1762c55cb1e2a38abffa7d78d1572f283`
- Device model: `sdk_gphone64_arm64` on local AVD `babylog_api35`
- Android version: Android 15 / API 35
- Firebase project: `babylog-flutter`
- Tester: Codex local release install smoke test
- Date/time: 2026-05-06 09:07 Europe/Brussels

Local workspace device check on 2026-05-06:
`flutter emulators` lists local AVD `babylog_api35`. After launching it,
`flutter devices` found `emulator-5554` as Android 15 / API 35. The release APK
`build/app/outputs/flutter-apk/app-release.apk` installed successfully with
`adb install -r`, launched with package `com.eranova.babylog`, and stayed
running as PID `3504`.

Local release APK SHA-256:
`aac71bfa737282db17251f9ea0277ea993fdab5ef164e29339eb3b328101702d`

Launch screenshot evidence:
`docs/qa-evidence/2026-05-06-release-apk-launch.png`

Signed-in release smoke evidence after the Firebase Auth/UI upgrade:
`docs/qa-evidence/2026-05-06-release-apk-qa-timeline-after-firebase-upgrade.png`

Non-secret Firestore smoke evidence:
`docs/qa-evidence/2026-05-06-disposable-qa-firestore-smoke.json`

This smoke confirms REST Auth sign-in, user document load, current assistant reference creation, assistant document creation, and assistant membership for the disposable QA account under the deployed Firestore rules.

Account deletion smoke evidence for disposable QA user
`deleteqa20260506075317ad1d03@example.com`
(`codexdeleteqa20260506075317ad1d03`):
`docs/qa-evidence/2026-05-06-account-deletion-smoke.json`

The deletion smoke includes `restAuthSignInRejectedAfterDeletion`, user doc
deletion, assistant doc deletion, and synthetic event deletion checks.

Account deletion screenshots:
`docs/qa-evidence/2026-05-06-release-apk-account-deletion-before.png`,
`docs/qa-evidence/2026-05-06-release-apk-account-deletion-confirm.png`, and
`docs/qa-evidence/2026-05-06-release-apk-account-deletion-after.png`.

Play reviewer access smoke evidence:
`docs/qa-evidence/2026-05-06-play-reviewer-access-smoke.json`

Play reviewer release APK screenshot:
`docs/qa-evidence/2026-05-06-release-apk-play-reviewer-timeline.png`

BYOK key-save/restart smoke evidence:
`docs/qa-evidence/2026-05-06-byok-key-save-smoke.json`

BYOK key-save/restart screenshot:
`docs/qa-evidence/2026-05-06-release-apk-byok-key-hidden-after-restart.png`

Local Play screenshot set captured from the same release APK on AVD:
`docs/play-assets/screenshots/phone-00-sign-in.png`,
`docs/play-assets/screenshots/phone-01-shared-timeline.png`,
`docs/play-assets/screenshots/phone-02-settings.png`,
`docs/play-assets/screenshots/phone-03-privacy-policy.png`, and
`docs/play-assets/screenshots/phone-04-recording-permission.png`.
The non-secret screenshot manifest is
`docs/play-assets/screenshots/2026-05-06-local-release-screenshot-set.json`.

Disposable verified QA account passwords are stored only in ignored
`.qa-secrets/current-qa-account.json` and
`.qa-secrets/deletion-qa-account.json`. The Play reviewer password is stored
only in ignored `.qa-secrets/play-reviewer-account.json`.

Remaining manual Android QA still must run on this AVD, a real Android device,
or a Play internal testing install.

## Test Data Rules

- Use synthetic baby names only.
- Use test email addresses only.
- Do not put real OpenAI API keys in screenshots.
- Do not capture real child data, real parent names, or private event history.

## Required Flow Evidence

| Flow | Steps | Evidence to capture | Result |
| --- | --- | --- | --- |
| Install and launch | Install the APK/AAB test build and open Babylog. | Screenshot of launch/auth screen and installed app version. | PASS locally on AVD `babylog_api35`; release APK installed, `com.eranova.babylog` launched, screenshot saved at `docs/qa-evidence/2026-05-06-release-apk-launch.png`. |
| Sign up | Create a new Firebase email/password test account. | Firebase Auth user id and screenshot without password. | Not covered by UI smoke yet; disposable verified Firebase Auth user `qa202605060729068d@example.com` was imported for release sign-in validation. |
| Email verification | Complete or bypass only with documented reviewer-ready test account. | Screenshot/note showing verified state. | PASS for disposable imported QA user; email-verified state is recorded in `docs/qa-evidence/2026-05-06-disposable-qa-firestore-smoke.json`. |
| Assistant creation | Let the app create the initial assistant/timeline. | Firestore `users/{uid}` and `assistants/{assistantId}` evidence. | PASS locally on AVD with disposable QA user; evidence saved in `docs/qa-evidence/2026-05-06-disposable-qa-firestore-smoke.json` and signed-in screenshot saved at `docs/qa-evidence/2026-05-06-release-apk-qa-timeline-after-firebase-upgrade.png`. |
| Privacy Policy access | Open Settings and tap Privacy Policy. | Screenshot of Settings and policy dialog. | PASS locally on AVD `babylog_api35`; Settings and Privacy Policy screenshots saved at `docs/play-assets/screenshots/phone-02-settings.png` and `docs/play-assets/screenshots/phone-03-privacy-policy.png`. |
| BYOK key save | Enable BYOK and save a limited test OpenAI key. | Screenshot with key hidden plus note confirming no Firestore `apikey`. | PARTIAL PASS locally on AVD `babylog_api35`; a non-secret fake key validates local key save/restart masking and confirms Firestore has `byok: true` with no `apikey` field. Evidence: `docs/qa-evidence/2026-05-06-byok-key-save-smoke.json`. A real limited OpenAI key is still required for recording/transcription QA. |
| Recording permission | Tap record and approve microphone permission. | Screenshot of Android permission dialog or post-permission recording state. | PASS locally on AVD `babylog_api35`; microphone permission dialog screenshot saved at `docs/play-assets/screenshots/phone-04-recording-permission.png`. |
| First recording | Record a synthetic baby-care event and send it. | Screenshot of recording/send flow. | TODO |
| First event creation | Confirm transcription creates a timeline event. | Screenshot of event and matching Firestore `events` doc. | TODO |
| Restart persistence | Restart the app and confirm the event remains visible. | Screenshot after restart. | TODO |
| Shared assistant join | Sign in with a second test account and join the assistant. | Screenshot and Firestore `assistants.users` evidence. | TODO |
| Delete event | Delete a test event from the timeline. | Screenshot and Firestore evidence that event doc is gone. | TODO |
| Delete account | Delete the primary test account from Settings. | Firebase Auth, `users`, `assistants`, `events`, and local BYOK cleanup evidence. | PASS for single-user release APK smoke on AVD `babylog_api35`; evidence in `docs/qa-evidence/2026-05-06-account-deletion-smoke.json` confirms the app returned to sign-in, Auth sign-in was rejected afterward, and the Firebase user, assistant, and synthetic event documents were deleted. Shared-assistant deletion and local BYOK cleanup remain covered by tests, not manual device evidence. |
| Reauthentication edge | Trigger or document `requires-recent-login` behavior. | Screenshot or note explaining reviewer-observed behavior. | TODO |
| Public deletion page | Open the account deletion page without the app installed. | Browser screenshot with public URL. | TODO |
| Public privacy page | Open the privacy policy page without authentication. | Browser screenshot with public URL. | TODO |

## Firebase Console Evidence

- Disposable smoke auth user before deletion: `codexqa20260506072958350d`
- Auth user after deletion: TODO
- Disposable smoke user document before deletion: PASS in `docs/qa-evidence/2026-05-06-disposable-qa-firestore-smoke.json`
- User document after deletion: TODO
- Disposable smoke assistant users before deletion: PASS in `docs/qa-evidence/2026-05-06-disposable-qa-firestore-smoke.json`
- Assistant users after deletion: TODO
- Event documents before deletion: TODO
- Disposable account deletion event before deletion: `delete-smoke-codexdeleteqa20260506075317ad1d03`
- Disposable account deletion event after deletion: PASS in `docs/qa-evidence/2026-05-06-account-deletion-smoke.json`

## Play Review Inputs

- Reviewer email: `test@era-nova.be`
- Reviewer password storage location:
  `.qa-secrets/play-reviewer-account.json` (ignored; do not commit)
- Reviewer assistant id: `play-reviewer-assistant`
- BYOK review path: documented BYOK-only review; no OpenAI test key in repo docs.
- Public privacy policy URL: `https://babylog-flutter.web.app/privacy-policy`
- Public account deletion URL: `https://babylog-flutter.web.app/delete-account`

## Sign-Off

- Manual QA owner: TODO
- Release owner: TODO
- Known issues accepted for internal testing: TODO
- Known issues accepted for production: TODO
