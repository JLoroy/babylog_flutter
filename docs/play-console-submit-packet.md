# Babylog Play Console Submit Packet

Last updated: 2026-05-06

Status:
Ready for Play Console copy/paste after the reviewer password is set outside
git and the AAB is uploaded.

## Release Artifact

- Existing Play package: `com.eranova.babylog`
- Release version: `1.0.2+3`
- AAB path: `build/app/outputs/bundle/release/app-release.aab`
- AAB SHA-256:
  `ac9b27ec22bb4d6c963a2c38eb3b274f9c539ea508b566fccab8d3f4ba8b226b`
- Signing verification: `jarsigner -verify` exits 0.

## Store Listing

- App name: `Babylog`
- Short description:
  `Record baby care moments by voice and keep a shared timeline.`
- Category: `Parenting`
- Pricing: `Free`
- Ads: `No`
- In-app purchases: `No`
- Families: do not enroll.
- Target audience: parents, guardians, and caregivers age 18 and over.
- Initial countries/regions: Belgium and United States.

Use the full description and release notes from `docs/play-store-listing.md`.

## Public URLs

- Website: `https://babylog-flutter.web.app/privacy-policy`
- Privacy policy: `https://babylog-flutter.web.app/privacy-policy`
- Account deletion: `https://babylog-flutter.web.app/delete-account`
- Contact email: `privacy@lenacho.be`

Reminder: create or confirm the `privacy@lenacho.be` alias before submission.

## Developer Identity

- Public developer/business identity where Play allows it: `Nacho`
- Website/domain for future migration: `lenacho.be`
- Keep package name `com.eranova.babylog` because it is the existing Play app.

## App Access

Recommended Play Console answer:
`Some or all functionality is restricted.`

Reviewer account:

- Email: `test@era-nova.be`
- Password: set from the reset email and store outside git.
- Assistant id: `play-reviewer-assistant`

Reviewer notes:

```text
Install and open Babylog.
Sign in with the reviewer account provided in Play Console.
Use only the play-reviewer-assistant sample timeline. Do not enter real child data.
Open Settings to inspect the Privacy Policy entry, BYOK OpenAI key setting, assistant id, and Delete Account flow.

Babylog is BYOK-only for OpenAI. It does not ship or fetch a shared OpenAI API key.
AI recording requires the reviewer's own OpenAI API key. The authenticated non-AI timeline, Settings, Privacy Policy, BYOK setting, and Delete Account flows are available with the reviewer account.
Please do not delete the reviewer account unless the review specifically needs to validate deletion.
```

## App Content Answers

- Ads declaration: no ads.
- Content target: adults, 18 and over.
- Families: not primarily child-directed; do not opt into Families.
- Microphone permission rationale: Babylog uses the microphone only when the
  user taps record, to create transcription and baby-care timeline events.
- Data safety source of truth: `docs/play-console-compliance.md`.

## Assets

- App icon: `docs/play-assets/icon-512.png`
- Feature graphic: `docs/play-assets/feature-graphic-1024x500.png`
- Screenshots: still capture from the internal-test or final release build using
  `docs/play-screenshots.md`.

## Before Rollout

- Upload the signed AAB to internal testing.
- Set the final reviewer password outside git.
- Copy the app-access notes into Play Console.
- Add/confirm the public privacy-policy and account-deletion URLs.
- Complete `docs/manual-qa-checklist.md` on a real Android/internal-test build.
- Verify BYOK save/restart/recording with a tester-provided OpenAI key.
- Verify account deletion against Firebase Auth and Firestore.
