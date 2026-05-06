# Babylog Account Deletion Web Resource Draft

Last updated: 2026-05-06

Status: published on Firebase Hosting as the public account deletion URL
required by Google Play.

Published URL:
https://babylog-flutter.web.app/delete-account

## Page Title

Delete your Babylog account and data

## Page Body

Babylog users can request deletion of their account and associated Babylog data.

To request deletion, email privacy@lenacho.be with the subject "Babylog account
deletion request" and include the email address used for your Babylog account.
We may ask you to verify account ownership before completing deletion.

You can also delete your account inside the Babylog app from Settings.

When your account is deleted, Babylog deletes your Firebase Auth account, your
Babylog user profile, events for your current assistant/timeline, and your
membership in the assistant/timeline. If no users remain in the assistant, the
assistant document is deleted.

Data processed by service providers, including OpenAI API processing logs, may
be retained according to those providers' policies and the relevant API account
settings. Some records may also be retained if required for security, fraud
prevention, legal, or operational reasons.

## Publication Requirements

- The URL must load without authentication.
- The page must mention Babylog or the store listing developer name.
- The deletion request path must be prominent and easy to find.
- The page must not only send users back to the app.
- Add the URL to Play Console's Data safety account deletion section.
