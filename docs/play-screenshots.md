# Babylog Play Screenshots Plan

Last updated: 2026-05-06

Purpose:
Define the sanitized phone screenshots required before Play Store submission.

Status:
Template. Capture screenshots from the Final Android build after release
signing is fixed and the app is installed through internal testing or an
equivalent release build.

Local workspace device check on 2026-05-06:
`flutter devices` found only macOS and Chrome; `flutter emulators` found no Android emulator sources.
Final screenshots require a real Android device, a new local AVD, or a Play
internal testing install.

## Capture Rules

- Use synthetic baby names only.
- Use test parent/caregiver email addresses only.
- Do not show OpenAI API keys, passwords, real child data, real parent names,
  private event history, Firebase ids, or secret assistant ids.
- Use the same synthetic dataset captured in `docs/manual-qa-checklist.md`.
- Prefer portrait phone screenshots unless Play Console asks for additional
  form factors.

## Required Phone Screenshots

| Screenshot | Required content | Manual QA link | Status |
| --- | --- | --- | --- |
| Sign in | Babylog auth screen or signed-in reviewer entry point. | Install and launch / Sign up | TODO |
| Settings and Privacy Policy | Settings page with Privacy Policy entry visible, plus policy dialog if useful. | Privacy Policy access | TODO |
| Shared timeline | Timeline with synthetic baby-care events and no real names. | Restart persistence / Shared assistant join | TODO |
| Recording permission | Microphone permission or post-permission recording state. | Recording permission | TODO |
| First event | Synthetic event created from recording/transcription. | First recording / First event creation | TODO |
| Delete Account | Settings delete-account entry or confirmation flow without deleting reviewer account. | Delete account | TODO |

## Optional Screenshots

- BYOK settings with key hidden.
- Shared assistant handoff between two test accounts.
- Public privacy/deletion pages in a browser, if Play Console media needs them.

## Evidence To Capture

- Device model and Android version.
- App version/build.
- Whether screenshots came from internal testing or local release build.
- Screenshot file names and storage location.
- Confirmation that screenshots were reviewed for private data before upload.

Record the completed evidence in `docs/manual-qa-checklist.md` and `STATUS.md`.
