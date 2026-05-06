# Firebase Hosting Deploy Runbook

Last updated: 2026-05-05

Purpose:
Publish Babylog's public privacy policy and account deletion pages for Google
Play Console.

## Current Hosting Configuration

- Firebase project: `babylog-flutter`
- Expected Firebase Hosting origin: `https://babylog-flutter.web.app`
- Hosting public directory: `docs/public`
- Privacy policy source: `docs/public/privacy-policy.html`
- Account deletion source: `docs/public/delete-account.html`
- Firebase CLI project binding: `.firebaserc`

## Pre-Deploy Checklist

- Confirm `privacy@lenacho.be` is the correct public contact.
- Confirm the Firebase project `babylog-flutter` is the production project:
  https://console.firebase.google.com/project/babylog-flutter/overview
- Confirm you are authenticated with the Firebase CLI account that can deploy
  Hosting for `babylog-flutter`. If authentication expires, run
  `firebase login --reauth`.
- Run `npm run test:hosting`.
- Run `npm run test:policy`.

## Deploy

```bash
firebase deploy --only hosting
```

## Post-Deploy Verification

Deployment verified: 2026-05-06.

- Firebase Hosting URL: `https://babylog-flutter.web.app`
- Privacy policy URL: `https://babylog-flutter.web.app/privacy-policy`
- Account deletion URL: `https://babylog-flutter.web.app/delete-account`
- Privacy policy URL returned HTTP 200 and contained `Developer: Nacho`,
  `privacy@lenacho.be`, Firebase, and OpenAI content.
- Account deletion URL returned HTTP 200 and contained
  `privacy@lenacho.be`, `Babylog account deletion request`, and
  `without reinstalling the app`.
- Browser screenshots in `docs/qa-evidence/2026-05-06-public-policy-pages-smoke.json`
  confirm both URLs load without authentication.
- Play Console fields still need confirmation with Console evidence after the
  URLs are copied into the relevant privacy policy and account deletion fields.

Expected pages:

- `/privacy-policy`
- `/delete-account`

## After Deploy

- Update `STATUS.md` with the deployed URLs and verification date.
- Update `docs/release-completion-audit.md` with the public URL evidence.
- Update `docs/play-store-listing.md` contact fields.
- Align the Settings privacy-policy dialog with the published page if the final
  policy text changed.
