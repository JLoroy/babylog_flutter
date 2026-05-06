# Babylog Manual QA Evidence Checklist

Last updated: 2026-05-06

Status: partially prefilled release evidence template. Complete the remaining
result fields on a real Android device or Play internal testing install before
production release.

## Test Environment

- App version/build: `1.0.2+3`
- Build artifact: `build/app/outputs/bundle/release/app-release.aab`
- Build artifact SHA-256:
  `ac9b27ec22bb4d6c963a2c38eb3b274f9c539ea508b566fccab8d3f4ba8b226b`
- Device model: TODO
- Android version: TODO
- Firebase project: `babylog-flutter`
- Tester: TODO
- Date/time: TODO

Local workspace device check on 2026-05-06:
`flutter devices` found only macOS and Chrome; `flutter emulators` found no Android emulator sources.
Manual Android QA must run on a real Android device, new local AVD, or Play
internal testing install.

## Test Data Rules

- Use synthetic baby names only.
- Use test email addresses only.
- Do not put real OpenAI API keys in screenshots.
- Do not capture real child data, real parent names, or private event history.

## Required Flow Evidence

| Flow | Steps | Evidence to capture | Result |
| --- | --- | --- | --- |
| Install and launch | Install the APK/AAB test build and open Babylog. | Screenshot of launch/auth screen and installed app version. | TODO |
| Sign up | Create a new Firebase email/password test account. | Firebase Auth user id and screenshot without password. | TODO |
| Email verification | Complete or bypass only with documented reviewer-ready test account. | Screenshot/note showing verified state. | TODO |
| Assistant creation | Let the app create the initial assistant/timeline. | Firestore `users/{uid}` and `assistants/{assistantId}` evidence. | TODO |
| Privacy Policy access | Open Settings and tap Privacy Policy. | Screenshot of Settings and policy dialog. | TODO |
| BYOK key save | Enable BYOK and save a limited test OpenAI key. | Screenshot with key hidden plus note confirming no Firestore `apikey`. | TODO |
| Recording permission | Tap record and approve microphone permission. | Screenshot of Android permission dialog or post-permission recording state. | TODO |
| First recording | Record a synthetic baby-care event and send it. | Screenshot of recording/send flow. | TODO |
| First event creation | Confirm transcription creates a timeline event. | Screenshot of event and matching Firestore `events` doc. | TODO |
| Restart persistence | Restart the app and confirm the event remains visible. | Screenshot after restart. | TODO |
| Shared assistant join | Sign in with a second test account and join the assistant. | Screenshot and Firestore `assistants.users` evidence. | TODO |
| Delete event | Delete a test event from the timeline. | Screenshot and Firestore evidence that event doc is gone. | TODO |
| Delete account | Delete the primary test account from Settings. | Firebase Auth, `users`, `assistants`, `events`, and local BYOK cleanup evidence. | TODO |
| Reauthentication edge | Trigger or document `requires-recent-login` behavior. | Screenshot or note explaining reviewer-observed behavior. | TODO |
| Public deletion page | Open the account deletion page without the app installed. | Browser screenshot with public URL. | TODO |
| Public privacy page | Open the privacy policy page without authentication. | Browser screenshot with public URL. | TODO |

## Firebase Console Evidence

- Auth user before deletion: TODO
- Auth user after deletion: TODO
- User document before deletion: TODO
- User document after deletion: TODO
- Assistant users before deletion: TODO
- Assistant users after deletion: TODO
- Event documents before deletion: TODO
- Event documents after deletion: TODO

## Play Review Inputs

- Reviewer email: `test@era-nova.be`
- Reviewer password storage location: TODO
- Reviewer assistant id: `play-reviewer-assistant`
- BYOK review path: documented BYOK-only review; no OpenAI test key in repo docs.
- Public privacy policy URL: `https://babylog-flutter.web.app/privacy-policy`
- Public account deletion URL: `https://babylog-flutter.web.app/delete-account`

## Sign-Off

- Manual QA owner: TODO
- Release owner: TODO
- Known issues accepted for internal testing: TODO
- Known issues accepted for production: TODO
