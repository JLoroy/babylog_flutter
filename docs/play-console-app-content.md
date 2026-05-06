# Babylog Play Console App Content Draft

Last updated: 2026-05-06

Status: draft. These answers must be reviewed in Play Console against the final
signed AAB and the actual production/test account setup.

Official references:

- Prepare your app for review:
  https://support.google.com/googleplay/android-developer/answer/9859455
- Content ratings:
  https://support.google.com/googleplay/android-developer/answer/9898843
- Target audience and Families policy:
  https://support.google.com/googleplay/android-developer/answer/9893335
- Manage target audience and app content settings:
  https://support.google.com/googleplay/android-developer/answer/9867159

## App Access

Recommended Play Console answer:
Some or all functionality is restricted.

Reason:
Babylog requires Firebase email/password authentication before the main app can
be reviewed. A reviewer needs a test account to inspect Settings, timeline,
recording, BYOK behavior, privacy policy access, and account deletion.

Reviewer instructions draft:
Use `docs/play-reviewer-access.md` as the source of truth for the final Play
Console app access notes.

1. Install and open Babylog.
2. Sign in with the reviewer account below.
3. If email verification is requested, use the verified account already prepared
   for review.
4. Open Settings to inspect the Privacy Policy entry, BYOK OpenAI key setting,
   assistant id, and Delete Account flow.
5. Use the sample assistant/timeline only; do not enter real child data.

Reviewer account:

- Email: `test@era-nova.be`
- Password: reset email requested on 2026-05-06; set the final password outside
  git before Play submission.
- Assistant id: `play-reviewer-assistant`
- OpenAI BYOK test key: none. Document that AI recording requires the
  reviewer's own OpenAI API key, and that non-AI authenticated timeline,
  Settings, Privacy Policy, BYOK setting, and Delete Account flows are available
  with the reviewer account.

## Ads Declaration

Recommended Play Console answer:
No, this app does not contain ads.

Evidence:

- No ad SDK dependency is declared in `pubspec.yaml`.
- Firebase Analytics was removed from the Android Gradle dependency list.
- No AdMob or advertising integration was found in app code.

## Target Audience And Content

Recommended Play Console target age:
18 and over.

Rationale:
Babylog is intended for parents, guardians, and caregivers who record baby care
events. It may contain information about children, but the app is not designed
for children to use directly. The app requires account sign-in and can send
audio/transcription content to OpenAI when AI features are used.

Recommended Families answer:
Do not opt into Families / not primarily child-directed.

Risk note:
Because the app name, description, and content mention babies, Play may examine
whether the listing appears child-directed. Store listing copy and screenshots
should consistently describe the user as the parent, guardian, or caregiver.

## Content Rating Questionnaire Draft

Recommended category:
Utility, Productivity, Communication, or Other.

Expected content answers based on current implementation:

- Violence: no.
- Sexual content or nudity: no.
- Profanity or crude humor: no.
- Controlled substances: no.
- Gambling: no.
- Public user-generated content: no public sharing. Users can create private
  timeline content shared only with authenticated assistant members.
- Personal information sharing: yes, users may store account email and baby care
  timeline content, and audio/transcription content may be processed by OpenAI.
- Location sharing: no active location feature found.
- Purchases: no in-app purchases found.
- Ads: no.

Validation before submission:
Complete the Play Console IARC questionnaire honestly against the final build.
If Play asks about user content exchange, explain that timeline data is private
to authenticated assistant members and is not publicly browsable.

## Data Safety Cross-Reference

Use `docs/play-console-compliance.md` for the Data safety form. The important
data disclosures are:

- Email address and Firebase user id.
- Baby care event content.
- Audio recording and transcription content when AI recording is used.
- OpenAI BYOK key stored locally on the device.
- Firebase and OpenAI service-provider processing.

## Permissions Declaration

Current main Android permissions:

- `android.permission.INTERNET`
- `android.permission.RECORD_AUDIO`

No SMS, Call Log, location, contacts, camera, or storage permissions were found
in the main Android manifest.

Recommended reviewer note for microphone:
Babylog uses the microphone only when the user taps record. The recording is
used to create a transcription and baby-care timeline events.

## Remaining Inputs Before Play Submission

- Set the reviewer account's final password outside git.
- Use the documented BYOK-only review path without providing an OpenAI test key
  in repo or Play notes.
- Add/confirm the published privacy-policy and account-deletion pages in Play
  Console.
- Confirm screenshots and listing text consistently target parents/guardians,
  not children.
