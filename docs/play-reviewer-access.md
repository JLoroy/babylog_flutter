# Babylog Play Reviewer Access

Last updated: 2026-05-06

Purpose:
Provide Play Console app access notes for reviewers without committing real
credentials, child data, or OpenAI secrets.

## Play Console App Access Answer

Recommended answer:
Some or all functionality is restricted.

Reason:
Babylog requires Firebase email/password authentication before reviewers can
inspect the app. The main app flows are not available anonymously.

## Reviewer Account

Reviewer account details must be finalized in Firebase Auth before Play
submission. Keep the actual password in the team password manager, not in git.

- Email: `test@era-nova.be`
- Password: reset email requested on 2026-05-06; set the final password outside
  git before Play submission.
- Assistant id: `play-reviewer-assistant`
- Account state: existing Firebase Auth account, email verified, enabled.

## Reviewer Instructions

Use these notes in Play Console after replacing the placeholder credentials:

1. Install and open Babylog.
2. Sign in with the reviewer account.
3. Open the shared assistant/timeline linked to the reviewer account.
4. Use only the `play-reviewer-assistant` sample timeline.
5. Do not enter real child data.
6. Open Settings.
7. Confirm the Privacy Policy entry is visible.
8. Inspect the OpenAI key setting.
9. Inspect the Delete Account flow, but do not delete the reviewer account
   unless the release test specifically asks for deletion validation.

## BYOK Review Path

Current app behavior is BYOK-only for OpenAI. Babylog does not ship or fetch a
shared production OpenAI API key from Firestore.

First-release reviewer path:

- Do not provide an OpenAI test key in Play Console notes.
- Document that AI recording requires the reviewer's own OpenAI API key.
- The authenticated non-AI timeline, Settings, Privacy Policy, BYOK setting,
  and Delete Account flows are available with the reviewer account.

Do not provide a production or personal OpenAI key in Play Console notes.

## Evidence To Capture

- Firebase Auth screenshot showing `test@era-nova.be` exists and is verified.
- Firestore screenshot or export showing the reviewer account has access to the
  `play-reviewer-assistant` sample assistant id.
- The exact Play Console app access notes submitted, with secrets redacted in
  repo docs.
- Internal-test confirmation that the reviewer account can sign in, view the
  timeline, open Privacy Policy, inspect BYOK settings, and reach Delete Account.
