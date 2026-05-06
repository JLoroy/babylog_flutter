# Babylog Play Store Listing Draft

Last updated: 2026-05-07

Status: draft. This copy follows current Google Play listing limits: app name up
to 30 characters, short description up to 80 characters, and full description up
to 4000 characters.

Official references:

- Create and set up your app:
  https://support.google.com/googleplay/android-developer/answer/9859152
- Target API level requirements:
  https://support.google.com/googleplay/android-developer/answer/11926878
- Store listing best practices:
  https://support.google.com/googleplay/android-developer/answer/13393723
- Metadata policy:
  https://support.google.com/googleplay/android-developer/answer/9898842
- Preview asset requirements:
  https://support.google.com/googleplay/android-developer/answer/9866151

## App Details

Package name:
com.eranova.babylog

Release version:
1.0.7+8

Target API:
Android 15 / API level 35

App name:
Babylog

Short description:
Record baby care moments by voice and keep a shared timeline.

Full description:
Babylog helps parents and caregivers keep a shared timeline of everyday baby
care events.

Record a short voice note, send it for transcription, and review the events
Babylog adds to your timeline. You can also use the timeline to stay aligned
with another parent or caregiver when you are not in the same room.

What Babylog helps you track:

- Bottles, medicine, hygiene, and other daily care moments
- Who recorded each event
- When events happened
- A shared assistant/timeline for trusted caregivers

Privacy and control:

- Babylog uses Firebase Authentication for accounts and Firestore for timeline
  storage.
- Audio and transcription content are sent to OpenAI only when you use the AI
  recording flow.
- OpenAI API keys are stored locally on your device when bring-your-own-key mode
  is enabled.
- Account deletion is available from Settings and through the published web
  deletion request page.

Babylog is designed for parents and guardians who want a calmer way to remember
the small but important details of baby care.

## Release Notes

en-US:
Version 1.0.7 refreshes Babylog with a modern Android design, smoother timeline cards, clearer recording feedback, and polished settings, while keeping tested Firebase security rules, safer account deletion, local-only OpenAI key handling, Play policy pages, and Android release signing.

fr-FR:
La version 1.0.7 modernise Babylog avec un design Android plus actuel, une timeline plus fluide, un retour d'enregistrement plus clair et des paramètres mieux finis, tout en gardant les règles Firebase testées, une suppression de compte plus sûre, une gestion locale des clés OpenAI, des pages de politique Play et une signature Android configurée.

## Store Contact Fields

Contact email:
privacy@lenacho.be

Website:
https://babylog-flutter.web.app/privacy-policy

Privacy policy:
https://babylog-flutter.web.app/privacy-policy

Account deletion:
https://babylog-flutter.web.app/delete-account

## Graphic Assets

Current repo evidence:

- App launcher icons exist under `android/app/src/main/res/mipmap-*`.
- Source icon exists at `assets/icon/icon.png`.
- Play Console app icon:
  `docs/play-assets/icon-512.png`
- Feature graphic:
  `docs/play-assets/feature-graphic-1024x500.png`

Still required before Play submission:

- Produce phone screenshots from the final Android build using
  `docs/play-screenshots.md`.
- Confirm screenshots do not expose real baby names, email addresses, or API
  keys.
