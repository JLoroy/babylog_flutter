# Babylog Play Screenshots Plan

Last updated: 2026-05-06

Purpose:
Define the sanitized phone screenshots required before Play Store submission.

Status:
Template. Capture screenshots from the Final Android build after release
signing is fixed and the app is installed through internal testing or an
equivalent release build.

Local workspace device check on 2026-05-06:
`flutter emulators` lists local AVD `babylog_api35`. After launching it,
`flutter devices` found `emulator-5554` as Android 15 / API 35. The release APK
installed and launched to the sign-in screen; the first local screenshot
evidence is `docs/qa-evidence/2026-05-06-release-apk-launch.png`.

After the Firebase Auth/UI upgrade, the release APK also signed in with a
disposable verified QA user and reached the timeline. Sanitized local evidence:
`docs/qa-evidence/2026-05-06-release-apk-qa-timeline-after-firebase-upgrade.png`.

Account deletion release APK smoke screenshots were also captured:
`docs/qa-evidence/2026-05-06-release-apk-account-deletion-before.png`,
`docs/qa-evidence/2026-05-06-release-apk-account-deletion-confirm.png`, and
`docs/qa-evidence/2026-05-06-release-apk-account-deletion-after.png`.

Final full screenshot coverage still requires completing the signed-in flows on
this AVD, a real Android device, or a Play internal testing install.

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
| Sign in | Babylog auth screen or signed-in reviewer entry point. | Install and launch / Sign up | Partial local AVD evidence: `docs/qa-evidence/2026-05-06-release-apk-launch.png` and signed-in timeline screenshot after Firebase Auth/UI upgrade. |
| Settings and Privacy Policy | Settings page with Privacy Policy entry visible, plus policy dialog if useful. | Privacy Policy access | TODO |
| Shared timeline | Timeline with synthetic baby-care events and no real names. | Restart persistence / Shared assistant join | Partial local AVD evidence: timeline shell loads for disposable QA user, but full event/restart/shared-account screenshot set remains TODO. |
| Recording permission | Microphone permission or post-permission recording state. | Recording permission | TODO |
| First event | Synthetic event created from recording/transcription. | First recording / First event creation | TODO |
| Delete Account | Settings delete-account entry or confirmation flow without deleting reviewer account. | Delete account | Partial local AVD evidence: release APK account-deletion before/confirm/after screenshots captured with a disposable account. Final Play media should use non-sensitive reviewer-safe screenshots. |

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
