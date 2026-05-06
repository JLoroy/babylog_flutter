# Babylog Play Console Action History Review

Last updated: 2026-05-06

Purpose:
Summarize the exported Play Console action history in `docs/previous_actions.md`
and turn it into concrete Console updates that still need confirmation.

## Source Evidence

The exported action history confirms an existing Play Console app:

- App name: `Babylog`
- Package name: `com.eranova.babylog`
- Internal testing release `4` was rolled out to `100.0%` on 2026-03-10.
- Store category was set to `Parenting`.
- Tags included `Baby care`, `Audio recorder`, `Parenting`,
  `Personal assistant`, and `Activity tracker`.
- Contains ads was set to `No`.
- Store contact email was `justin@era-nova.be`.
- Store contact website was `https://www.era-nova.be`.
- Existing French listing copy referenced an old free-tier/OpenAI-key framing.

## Current Interpretation

This repo can prepare the next release package and evidence, but the exported
history does not prove the current Play Console state has been updated with the
new Nacho identity, Firebase Hosting policy URLs, reviewer password, screenshots,
or signed AAB.

Treat the action history as evidence that Babylog already exists in Play
Console, not as evidence that the 2026-05-06 release package has been uploaded
or accepted.

## Required Play Console Updates

Before production rollout, verify or update these Console fields:

- Upload `build/app/outputs/bundle/release/app-release.aab` for version
  `1.0.2+3`.
- Replace the old contact email with `privacy@lenacho.be`.
- Replace the old website with
  `https://babylog-flutter.web.app/privacy-policy` or the final `lenacho.be`
  page if migrated before submission.
- Add the privacy policy URL:
  `https://babylog-flutter.web.app/privacy-policy`.
- Add the account deletion URL:
  `https://babylog-flutter.web.app/delete-account`.
- Copy reviewer access notes and the local-only reviewer password from
  `.qa-secrets/play-reviewer-account.json`.
- Replace older listing copy with the current draft in
  `docs/play-store-listing.md`.
- Upload the current icon, feature graphic, and screenshot set from
  `docs/play-assets/`.
- Complete and submit App content, Data safety, target audience, content
  rating, ads, and distribution answers from the current repo docs.

## Evidence To Capture After Console Changes

- Screenshot or export showing the uploaded AAB version/build.
- Screenshot or export showing Store settings contact email and website.
- Screenshot or export showing privacy policy and account deletion URLs.
- Screenshot or export showing App access notes are present.
- Screenshot or export showing Store listing/media accepted.
- Screenshot or export showing the internal testing or production release
  status.

Record those artifacts in `docs/release-completion-audit.md`, `STATUS.md`, and
`docs/manual-qa-checklist.md`.
