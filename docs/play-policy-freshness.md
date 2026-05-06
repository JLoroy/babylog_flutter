# Babylog Play Policy Freshness Check

Last checked: 2026-05-06

Purpose:
Record the current official Play requirements that are most likely to change
between local release preparation and Play Console submission.

## Official Sources Checked

- Target API level requirement:
  https://developer.android.com/google/play/requirements/target-sdk?hl=en
- Prepare your app for review:
  https://support.google.com/googleplay/android-developer/answer/9859455
- App account deletion requirements:
  https://support.google.com/googleplay/android-developer/answer/13327111

## Current Policy Snapshot

- Target API: Android Developers says that starting 2025-08-31, new apps and
  app updates must target Android 15 / API level 35 or higher to be submitted
  to Google Play, with separate exceptions for Wear OS, Android Automotive OS,
  and Android TV.
- Privacy policy: Play requires an active privacy policy URL on the store
  listing and inside the app for apps that request sensitive permissions or
  data. Babylog has both a public hosted URL and an in-app Settings entry.
- Ads declaration: Play requires developers to declare whether the app contains
  ads. Babylog is prepared as no ads.
- App access: If app access is restricted by sign-in or authentication, Play
  requires the details needed to access the app. Babylog has reviewer access
  notes and a local-only reviewer password file.
- Account deletion: Play requires apps with account creation to disclose
  deletion practices in Data safety and provide a functional web link where
  users can request deletion without reinstalling the app. Babylog's public
  deletion URL is live, but the URL still needs Console confirmation.

## Babylog Release Interpretation

- Current Android config is aligned for a 2026-05-06 Play submission:
  `targetSdk = 35` and `compileSdk = 36`.
- Re-check this file and the official target API page immediately before any
  submission after 2026-08-01, because Google often advances the target API
  requirement on an annual schedule.
- Play Console acceptance still has to be verified from the uploaded AAB and
  Console screens. This policy freshness check is not release evidence by
  itself.

## Required Before Production

- Confirm the uploaded AAB is accepted by Play Console with target API 35.
- Confirm Play Console privacy policy, account deletion, app access, ads,
  target audience, content rating, and Data safety screens are complete.
- Capture Console screenshots or exports and link them from
  `docs/release-completion-audit.md`.
