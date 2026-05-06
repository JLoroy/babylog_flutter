# Privacy Policy Draft for Babylog

Last updated: 2026-05-06

Status: published on Firebase Hosting. Google Play requires the final privacy
policy to be clearly labeled, publicly accessible, non-PDF, non-editable,
non-geofenced, and linked in Play Console and inside the app.

Published URL:
https://babylog-flutter.web.app/privacy-policy

## Babylog Privacy Policy

Babylog helps parents record baby-related events on a shared timeline. This
policy explains what information Babylog collects, why it is used, how it is
shared, and how users can request deletion.

Developer: Nacho

Privacy contact: privacy@lenacho.be

## Information We Collect

Babylog collects account information, including email address and Firebase user
identifier, to create and manage user accounts.

Babylog stores timeline content that users create, including baby event
descriptions, event types, timestamps, author information, and the shared
assistant/timeline identifier.

If a user records audio, Babylog temporarily records audio on the device so it
can be sent for transcription. The transcription and interpreted event content
may include personal or sensitive information that the user speaks into the app.

If a user enables bring-your-own-key OpenAI access, Babylog stores the OpenAI
API key locally on the device using secure storage. Babylog does not store this
key in Firestore, and account deletion clears the locally stored key for the
current assistant.

## How We Use Information

Babylog uses account information to sign users in, keep shared timelines
available across devices, and manage shared assistant membership.

Babylog uses timeline content to display baby events to the authenticated users
who belong to the same shared assistant/timeline.

Babylog uses audio and transcription content to convert speech into structured
timeline events.

## Service Providers

Babylog uses Google Firebase for authentication and Cloud Firestore database
storage.

Babylog uses the OpenAI API to transcribe audio and interpret text into
structured events when AI features are used. OpenAI's current API data controls
state that API inputs and outputs are not used to train models by default unless
the API account opts in. OpenAI may retain data for abuse monitoring depending
on the API account and product settings.

## Data Sharing

Babylog does not sell user data. Babylog shares data with service providers only
as needed to provide core app functionality, including Firebase account/database
services and OpenAI transcription/interpretation services.

Users who join the same Babylog assistant/timeline can see shared timeline
events associated with that assistant.

## Data Security

Babylog uses Firebase and OpenAI over encrypted network connections. Firestore
security rules are designed to restrict assistant and event access to
authenticated members of the relevant assistant. OpenAI API keys are stored on
the user's device using local secure storage and are not written to Firestore.

## Retention and Deletion

Users can request account deletion in the app from Settings. The current
implementation deletes the Firebase Auth user, the user's Firestore profile,
assistant events for the current assistant, and assistant membership or the
assistant document when no users remain.

Users can also request account and associated data deletion from the public
account deletion page:

https://babylog-flutter.web.app/delete-account

This page is available without reinstalling the app.

Some data may be retained when required for security, fraud prevention, legal,
or operational reasons. OpenAI processing retention is controlled by the OpenAI
API account and OpenAI's data controls.

## Children's Privacy

Babylog is intended for parents or guardians to record baby care events. The app
may contain information about children if users choose to enter or speak it.
Users should avoid entering unnecessary sensitive information.

Babylog is intended for adults, specifically parents, guardians, and
caregivers. The Play Console target audience draft is 18 and over, and Babylog
is not intended to be enrolled in Families.

## Contact

For privacy questions or deletion requests, contact: privacy@lenacho.be.
