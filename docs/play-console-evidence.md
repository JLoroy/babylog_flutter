# Babylog Play Console Evidence

Last updated: 2026-05-07

Status: partial Console capture.

Purpose:
Capture the redacted evidence that proves Play Console accepted the release,
policy fields, listing media, and distribution settings. This file is not
evidence by itself; it is the checklist for what to capture after Console work
is done.

## Redaction Rules

- Do not commit unredacted reviewer passwords.
- Do not commit OpenAI API keys, Firebase tokens, Google account tokens, or
  signing secrets.
- Redact reviewer password fields before saving screenshots or exports.
- Redact any real child names, personal emails other than the reviewer account,
  billing data, or account recovery details.
- Keep raw private screenshots outside git if redaction is not possible.

## Console Acceptance Checklist

| Console item | Evidence to capture | Evidence path or URL | Status |
| --- | --- | --- | --- |
| AAB uploaded and accepted | Release artifact screen showing package `com.eranova.babylog`, version `1.0.6+7`, and accepted AAB state. | User reported in chat on 2026-05-06 that the uploaded AAB appears as version code 7. User reported on 2026-05-07 that the release was accepted and deployed to his phone. Redacted screenshot/export still needed for committed evidence. | User-reported Accepted for internal testing and deployed to device; redacted evidence pending |
| Internal testing release rolled out | Internal testing track screen showing rollout active or available to testers. | User-provided chat screenshot on 2026-05-06: release `6 (1.0.5)` shows `Available to internal testers`, released on 6 May 15:06, review status `Not reviewed`. | Active / not reviewed |
| Production release available | Production track screen or public listing proving Babylog is available to users. | Pending | Pending |
| Public Play listing URL | Public Google Play URL for Babylog. | Pending | Pending |
| Privacy policy URL configured | App content or Store settings screen showing `https://babylog-flutter.web.app/privacy-policy`. | Pending | Pending |
| Account deletion URL configured | Data safety account deletion screen showing `https://babylog-flutter.web.app/delete-account`. | Pending | Pending |
| App access notes saved | App access screen showing restricted access and redacted reviewer instructions. | User reported in chat on 2026-05-06 that App access notes were added. Redacted screenshot/export still needed for committed evidence. | User-reported added; redacted evidence pending |
| Data safety accepted | Data safety summary screen showing accepted or ready-to-submit answers for the uploaded build. | Pending | Pending |
| Content rating accepted | Content rating screen showing questionnaire result accepted for Babylog. | Pending | Pending |
| Target audience accepted | Target audience and content screen showing 18+ parent/guardian target. | Pending | Pending |
| Ads declaration accepted | Ads declaration screen showing no ads. | Pending | Pending |
| Store listing media accepted | Main store listing screen showing app icon, feature graphic, and phone screenshots accepted. | Pending | Pending |
| SDK/data disclosure reviewed | SDK/data disclosure or Policy status screen for the uploaded AAB. | Pending | Pending |
| Developer identity/contact reviewed | Developer account or Store settings screen showing Nacho / `privacy@lenacho.be` where Play allows it. | Pending | Pending |
| 1000 installs/acquisitions evidence | Play Console statistics or acquisition report showing at least 1000 installs/acquisitions after release. | Paused by current user direction | Paused |

## Capture Procedure

1. Generate the handoff bundle:

   ```bash
   npm run prepare:play-handoff
   ```

2. Generate private App access notes only when ready to paste into Console:

   ```bash
   npm run prepare:play-private-notes
   ```

3. Upload/copy from `dist/play-console-handoff/`.
4. Save Play Console screenshots or exports into `docs/qa-evidence/` only after
   redacting secrets.
5. Update this table with the evidence paths or public URLs.
6. Update `docs/release-completion-audit.md` with the same evidence.
7. Update `STATUS.md` with the capture date, Console state, and remaining
   blockers.

## Completion Boundary

This checklist closes only when the Play Console evidence paths or URLs are
filled in with real, redacted evidence. Local tests, generated handoff files,
and signed AAB hashes remain preparation evidence until Play Console accepts
the upload and settings.
