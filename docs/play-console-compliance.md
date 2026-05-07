# Babylog Play Console Compliance Inventory

Last updated: 2026-05-06

This file is the implementation-backed source of truth for Play Console policy
answers. It is a draft until the final Play Console Data safety/App content
screens are accepted for the uploaded AAB.

## Official policy references

- Google Play User Data policy and privacy policy requirements:
  https://support.google.com/googleplay/android-developer/answer/9888076
- Google Play Data safety form guidance:
  https://support.google.com/googleplay/android-developer/answer/10787469
- Google Play app account deletion requirements:
  https://support.google.com/googleplay/android-developer/answer/13327111
- OpenAI platform data controls:
  https://platform.openai.com/docs/guides/your-data/
- Play policy freshness snapshot:
  `docs/play-policy-freshness.md`

## Current implementation evidence

- Android package: `com.eranova.babylog`
- Current Play target API submission floor checked on 2026-05-06:
  Android 15 / API level 35 or higher for new apps and app updates. Babylog is
  configured with `targetSdk = 35` and `compileSdk = 36`.
- Public developer identity: Nacho.
- Privacy contact: privacy@lenacho.be.
- Public privacy policy URL:
  `https://babylog-flutter.web.app/privacy-policy`.
- Public account deletion URL:
  `https://babylog-flutter.web.app/delete-account`.
- Permissions in `android/app/src/main/AndroidManifest.xml`:
  - `android.permission.INTERNET`
  - `android.permission.RECORD_AUDIO`
- Authentication: Firebase Auth email/password and Google sign-in through
  `firebase_auth`, `firebase_ui_auth`, and `firebase_ui_oauth_google`.
- Cloud storage/database: Cloud Firestore through `cloud_firestore`.
- Realtime Database packages were removed from `pubspec.yaml` after no active
  RTDB data path was found; committed RTDB rules remain default-deny.
- OpenAI calls are direct from the Flutter client for audio transcription and
  event interpretation. Shared/dev key storage has been removed; API calls now
  require a locally stored BYOK key using `flutter_secure_storage`.
- First-release architecture decision: keep BYOK-only direct OpenAI calls for
  this Play submission and defer a backend proxy. This avoids shipping or
  storing a shared OpenAI key, but requires manual BYOK device QA before
  production rollout.
- Firebase Analytics has been removed from the Android Gradle dependency list,
  and no `firebase_analytics` Flutter dependency or analytics event calls were
  found.

## Data categories to disclose

| Data category | Collected by Babylog | Purpose | Stored by Babylog | Shared/processed by third parties | User deletion path |
| --- | --- | --- | --- | --- | --- |
| Email address | Yes, through Firebase Auth email/password or Google sign-in | Account creation, sign-in, shared assistant membership | Firebase Auth and Firestore `users` / `assistants.users` | Google Firebase | In-app account deletion; web deletion request at `https://babylog-flutter.web.app/delete-account` |
| User identifier | Yes, Firebase Auth UID | Link account to current assistant | Firestore `users/{uid}` | Google Firebase | In-app account deletion; web deletion request at `https://babylog-flutter.web.app/delete-account` |
| Name/profile information | Optional, through Google sign-in if the Google account provides it | Authentication account profile | Firebase Auth provider profile | Google Firebase | In-app account deletion; web deletion request at `https://babylog-flutter.web.app/delete-account` |
| Baby event content | Yes, event type, description/log, timestamp, author, assistant id | Shared timeline | Firestore `events` | Google Firebase | In-app account deletion removes events for the user's assistant; manual Firebase validation pending |
| Audio recording | Yes, microphone recording for transcription | Convert speech into text/events | Temporary local file during recording flow | OpenAI API during transcription | Local temporary file lifecycle needs manual device QA; OpenAI processing is outside Firebase deletion |
| Transcribed text and AI prompt content | Yes, generated from audio and submitted for event interpretation | Create structured timeline events | Event result stored in Firestore | OpenAI API | Stored event data deleted through account deletion; OpenAI retention depends on API account settings |
| OpenAI API key | Yes, only if user opts into BYOK | Authenticate OpenAI requests | Local secure storage only, keyed by assistant id | OpenAI receives requests authorized by the key | Removed when BYOK is disabled or account deletion runs for that assistant; manual device validation pending |
| Diagnostics/crash data | Not intentionally integrated in app code | None currently | None currently | Platform/provider defaults may apply | Confirm Play SDK list before submission |
| Analytics/advertising data | No app-level analytics or ads found | None currently | None currently | None intentionally | Not applicable |

## Play Console answer draft

Use this as a checklist when completing the Play Console Data safety and App
content forms. The final answers must be verified against the uploaded AAB's SDK
list in Play Console.

- Data collection: yes.
- Data sharing: yes, because data is processed by Firebase and OpenAI service
  providers to provide app functionality.
- Data encrypted in transit: yes, Firebase/OpenAI calls use HTTPS/TLS through
  their SDKs/APIs.
- Users can request deletion: yes in-app and through the public web deletion
  request URL.
- Account creation: yes, email/password sign-up and Google sign-in are
  available in the app.
- Account deletion: in-app path exists in settings and public web request page
  is published; manual Firebase validation remains a blocker.
- Ads: no.
- Analytics: no intentional analytics integration after removing the unused
  Firebase Analytics Android dependency.

## Required before submission

- Add/confirm the published privacy policy URL in Play Console:
  `https://babylog-flutter.web.app/privacy-policy`.
- Keep the in-app privacy policy access in Settings aligned with the published
  policy.
- Add/confirm the published account deletion URL in Play Console:
  `https://babylog-flutter.web.app/delete-account`.
- Create or confirm the `privacy@lenacho.be` alias before Play submission.
- Use Nacho as the public developer/business identity where Play Console allows
  it. Keep package `com.eranova.babylog` because it is the existing Play app.
- Firebase Hosting is configured and deployed for these pages from
  `docs/public`.
- Confirm the Play Console SDK/data disclosure screen for the final signed AAB.
- Manually validate account deletion against Firebase Auth and Firestore.
- Manually test BYOK key save/restart/recording on a real device or internal
  test install before production rollout.
