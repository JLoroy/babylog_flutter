# Babylog Manual QA Evidence Checklist

Last updated: 2026-05-07

Status: partially prefilled release evidence template. Complete the remaining
result fields on a real Android device or Play internal testing install before
production release.

## Test Environment

- App version/build: `1.0.7+8`
- Build artifact: `build/app/outputs/bundle/release/app-release.aab`
- Build artifact SHA-256:
  `5947ba69b5a05b16c1627fdc3db7882c27b418838623b63c3e46607690b8d376`
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
`62adf39ff32aee776a4b4d1af4fd05f548b6368d1fc9e09fa19f392c5c77fa1d`

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

Restart persistence smoke evidence:
`docs/qa-evidence/2026-05-06-restart-persistence-smoke.json`

Restart persistence screenshots:
`docs/qa-evidence/2026-05-06-release-apk-restart-persistence-before.png` and
`docs/qa-evidence/2026-05-06-release-apk-restart-persistence-after.png`.

BYOK key-save/restart smoke evidence:
`docs/qa-evidence/2026-05-06-byok-key-save-smoke.json`

BYOK key-save/restart screenshot:
`docs/qa-evidence/2026-05-06-release-apk-byok-key-hidden-after-restart.png`

Recorder and note icon fallback smoke evidence:
`docs/qa-evidence/2026-05-07-recorder-and-note-icon-smoke.json`

Note icon fallback launch screenshot:
`docs/qa-evidence/2026-05-07-note-icon-fallback-launch.png`

Event deletion UI smoke evidence:
`docs/qa-evidence/2026-05-06-event-delete-ui-smoke.json`

Event deletion UI screenshots:
`docs/qa-evidence/2026-05-06-release-apk-event-delete-before.png` and
`docs/qa-evidence/2026-05-06-release-apk-event-delete-after.png`.

Shared-assistant account deletion smoke evidence:
`docs/qa-evidence/2026-05-06-shared-assistant-deletion-smoke.json`

Shared-assistant account deletion screenshots:
`docs/qa-evidence/2026-05-06-release-apk-shared-assistant-before-delete.png`,
`docs/qa-evidence/2026-05-06-release-apk-shared-assistant-delete-confirm.png`,
and
`docs/qa-evidence/2026-05-06-release-apk-shared-assistant-after-delete.png`.

Shared-assistant join UI smoke evidence for disposable users
`joinowner20260506151008@example.com` and
`joiner20260506151008@example.com`:
`docs/qa-evidence/2026-05-06-join-assistant-ui-smoke.json`

Shared-assistant join UI screenshots:
`docs/qa-evidence/2026-05-06-release-apk-join-assistant-before.png`,
`docs/qa-evidence/2026-05-06-release-apk-join-assistant-dialog.png`,
`docs/qa-evidence/2026-05-06-release-apk-join-assistant-after.png`, and
`docs/qa-evidence/2026-05-06-release-apk-join-assistant-settings-after-refresh.png`.

Public policy page browser smoke evidence:
`docs/qa-evidence/2026-05-06-public-policy-pages-smoke.json`

Public policy page browser screenshots:
`docs/qa-evidence/2026-05-06-public-privacy-policy-page.png` and
`docs/qa-evidence/2026-05-06-public-delete-account-page.png`.

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
`.qa-secrets/deletion-qa-account.json`. Shared-assistant deletion smoke
passwords are stored only in ignored
`.qa-secrets/shared-deletion-qa-account.json`. The Play reviewer password is
stored only in ignored `.qa-secrets/play-reviewer-account.json`. Shared join
UI smoke passwords are stored only in ignored
`.qa-secrets/join-assistant-qa-account.json`.

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
| BYOK key save | Enable BYOK and save a limited test OpenAI key. | Screenshot with key hidden plus note confirming no Firestore `apikey`. | PARTIAL PASS locally on AVD `babylog_api35`; a non-secret fake key validates local key save/restart masking and confirms Firestore has `byok: true` with no `apikey` field. Evidence: `docs/qa-evidence/2026-05-06-byok-key-save-smoke.json`. A temporary reviewer OpenAI key also passed direct redacted endpoint smoke for Whisper transcription and `gpt-4o-mini` event interpretation in `docs/qa-evidence/2026-05-07-openai-byok-endpoint-smoke.json`. Full in-app recorder-created event QA is still pending. |
| Recording permission | Tap record and approve microphone permission. | Screenshot of Android permission dialog or post-permission recording state. | PASS locally on AVD `babylog_api35`; microphone permission dialog screenshot saved at `docs/play-assets/screenshots/phone-04-recording-permission.png`. |
| First recording | Record a synthetic baby-care event and send it. | Screenshot of recording/send flow. | PARTIAL PASS on AVD `babylog_api35`: after entering the temporary reviewer key locally, the signed release app reached the real Whisper endpoint through the recorder, but the emulator microphone source captured only `BELL`, not the spoken synthetic event. Evidence: `docs/qa-evidence/2026-05-07-recorder-and-note-icon-smoke.json`. Full real-device/internal-test recording remains TODO. |
| First event creation | Confirm transcription creates a timeline event. | Screenshot of event and matching Firestore `events` doc. | TODO. Firestore still contained only `play-reviewer-welcome` after the emulator recorder attempt because the emulator microphone captured only a bell tone; evidence: `docs/qa-evidence/2026-05-07-recorder-and-note-icon-smoke.json`. |
| Restart persistence | Restart the app and confirm the event remains visible. | Screenshot after restart. | PASS locally on AVD `babylog_api35` with release APK `1.0.6+7`: reviewer account `test@era-nova.be` displayed `play-reviewer-welcome`, the app was force-stopped and relaunched, and the same event remained visible. Evidence: `docs/qa-evidence/2026-05-06-restart-persistence-smoke.json`. |
| Shared assistant join | Sign in with a second test account and join the assistant. | Screenshot and Firestore `assistants.users` evidence. | PASS locally on AVD `babylog_api35` with release APK `1.0.6+7`: joiner `joiner20260506151008@example.com` used Settings > Join another assistant to join assistant `join-ui-smoke-20260506151008`, the timeline switched to owner event `join-ui-owner-event-20260506151008`, refreshed Settings showed both synthetic users, and Firestore confirmed the joiner can write event `join-ui-joiner-event-20260506151008`. Evidence: `docs/qa-evidence/2026-05-06-join-assistant-ui-smoke.json`. |
| Delete event | Delete a test event from the timeline. | Screenshot and Firestore evidence that event doc is gone. | PASS locally on AVD `babylog_api35` for an existing synthetic event in the reviewer assistant; evidence in `docs/qa-evidence/2026-05-06-event-delete-ui-smoke.json` confirms event `ui-delete-smoke-20260506090414` was visible before deletion, hidden afterward, absent from the Firestore query, and the reviewer sample event remained. Recorder-created event deletion remains pending until recording/event creation QA is complete. |
| Delete account | Delete the primary test account from Settings. | Firebase Auth, `users`, `assistants`, `events`, and local BYOK cleanup evidence. | PASS for single-user release APK smoke on AVD `babylog_api35`; evidence in `docs/qa-evidence/2026-05-06-account-deletion-smoke.json` confirms the app returned to sign-in, Auth sign-in was rejected afterward, and the Firebase user, assistant, and synthetic event documents were deleted. PASS for shared-assistant release APK smoke in `docs/qa-evidence/2026-05-06-shared-assistant-deletion-smoke.json`: primary Auth sign-in is rejected after deletion, partner Auth sign-in still works, the assistant doc still exists for the partner, assistant `users` contains only the partner, old shared events are deleted, and the partner can create a new event afterward. Local BYOK cleanup is still covered by tests and exercised with a fake key before deletion, but not directly introspected from device secure storage. |
| Reauthentication edge | Trigger or document `requires-recent-login` behavior. | Screenshot or note explaining reviewer-observed behavior. | TODO |
| Public deletion page | Open the account deletion page without the app installed. | Browser screenshot with public URL. | PASS from public Firebase Hosting URL in Google Chrome headless; screenshot saved at `docs/qa-evidence/2026-05-06-public-delete-account-page.png` and evidence manifest saved at `docs/qa-evidence/2026-05-06-public-policy-pages-smoke.json`. |
| Public privacy page | Open the privacy policy page without authentication. | Browser screenshot with public URL. | PASS from public Firebase Hosting URL in Google Chrome headless; screenshot saved at `docs/qa-evidence/2026-05-06-public-privacy-policy-page.png` and evidence manifest saved at `docs/qa-evidence/2026-05-06-public-policy-pages-smoke.json`. |

## Firebase Console Evidence

- Disposable smoke auth user before deletion: `codexqa20260506072958350d`
- Auth user after deletion: TODO
- Disposable smoke user document before deletion: PASS in `docs/qa-evidence/2026-05-06-disposable-qa-firestore-smoke.json`
- User document after deletion: TODO
- Disposable smoke assistant users before deletion: PASS in `docs/qa-evidence/2026-05-06-disposable-qa-firestore-smoke.json`
- Assistant users after deletion: TODO
- Event documents before deletion: PASS for account deletion event `delete-smoke-codexdeleteqa20260506075317ad1d03` and UI deletion event `ui-delete-smoke-20260506090414`.
- Event documents after deletion: PASS in `docs/qa-evidence/2026-05-06-account-deletion-smoke.json` and `docs/qa-evidence/2026-05-06-event-delete-ui-smoke.json`; the reviewer sample event `play-reviewer-welcome` remains for Play review.
- Restart persistence event after relaunch: PASS in `docs/qa-evidence/2026-05-06-restart-persistence-smoke.json`; reviewer assistant `play-reviewer-assistant` still has event `play-reviewer-welcome` after release APK force-stop/relaunch.
- Shared assistant before deletion: `shared-delete-smoke-20260506145235` contained users `sharedprimary20260506145235@example.com` and `sharedpartner20260506145235@example.com`, plus event `shared-delete-event-20260506145235`.
- Shared assistant after primary deletion: PASS in `docs/qa-evidence/2026-05-06-shared-assistant-deletion-smoke.json`; primary Auth sign-in is rejected, partner Auth sign-in succeeds, assistant users are `sharedpartner20260506145235@example.com`, old shared events are gone, and partner-created event `shared-delete-partner-event-20260506145235` proves the remaining member can still write.
- Shared assistant join via UI: PASS in `docs/qa-evidence/2026-05-06-join-assistant-ui-smoke.json`; assistant `join-ui-smoke-20260506151008` contains users `joinowner20260506151008@example.com` and `joiner20260506151008@example.com`, and events `join-ui-owner-event-20260506151008` and `join-ui-joiner-event-20260506151008`.
- Disposable account deletion event before deletion: `delete-smoke-codexdeleteqa20260506075317ad1d03`
- Disposable account deletion event after deletion: PASS in `docs/qa-evidence/2026-05-06-account-deletion-smoke.json`

## Play Review Inputs

- Reviewer email: `test@era-nova.be`
- Reviewer password storage location:
  `.qa-secrets/play-reviewer-account.json` (ignored; do not commit)
- Reviewer assistant id: `play-reviewer-assistant`
- BYOK review path: documented BYOK-only review; no OpenAI key in repo docs,
  Firebase, or the app bundle. Optional temporary reviewer keys belong only in
  ignored private Play Console notes and must be pasted into local Settings.
- Public privacy policy URL: `https://babylog-flutter.web.app/privacy-policy`
- Public account deletion URL: `https://babylog-flutter.web.app/delete-account`

## Sign-Off

- Manual QA owner: TODO
- Release owner: TODO
- Known issues accepted for internal testing: TODO
- Known issues accepted for production: TODO
