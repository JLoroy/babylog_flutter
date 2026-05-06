# Babylog Growth Metrics And 1000-User Evidence Plan

Last updated: 2026-05-05

Objective:
Prove Babylog has been downloaded or used by at least 1000 people after the Play
Store release.

Status:
No evidence yet. Babylog is not currently released on Google Play from this
workspace, and no Play Console or Firebase metric proving 1000 downloads/users
has been inspected.

## Primary Metric

Primary completion metric:
Google Play Console user acquisitions / installs for the production Android
release.

Why:
The objective explicitly says the app must be available on the Play Store and
downloaded by at least 1000 users. Play Console install/acquisition data is the
closest source of truth for Play Store downloads.

Completion threshold:
At least 1000 Play Store user acquisitions or installs for Babylog production
release.

Evidence required:

- Screenshot or export from Play Console showing Babylog package
  `com.eranova.babylog`.
- Date range visible in the evidence.
- Metric name visible in the evidence.
- Value greater than or equal to 1000.
- Track/channel visible if the data is scoped to production, open testing, or
  internal testing.

## Secondary Metric

Secondary health metric:
Firebase Auth unique user count.

Why:
Installs do not prove signups or useful app usage. Firebase Auth user count helps
confirm that downloads turn into actual accounts.

Evidence required:

- Firebase Console Auth user count or an exported count from the production
  Firebase project.
- Date/time of capture.
- Firebase project id visible.
- Notes excluding test/reviewer accounts when possible.

## Metric Decision

For objective completion:

- Use Play Console installs/acquisitions as the required proof for the 1000
  download requirement.
- Use Firebase Auth users as supporting evidence, not a replacement for Play
  installs.
- Do not use repository stars, website visits, debug APK installs, internal test
  installs, or anecdotal feedback as completion evidence.

## Current Baseline

Play Console production installs:
UNKNOWN, no evidence captured.

Firebase Auth production users:
UNKNOWN, no evidence captured.

Current completion status:
Not achieved.

## Collection Workflow

1. Release Babylog to Google Play production.
2. Wait for Play Console acquisition/install data to populate.
3. Capture the Play Console install/acquisition report with package id,
   date range, metric name, and value.
4. Capture Firebase Auth user count from the production Firebase project.
5. Store sanitized screenshots/exports outside the repo if they contain private
   account data.
6. Update `STATUS.md` and `docs/release-completion-audit.md` with:
   - capture date,
   - metric source,
   - metric value,
   - evidence location,
   - whether the value meets or exceeds 1000.

## Privacy Guardrails

- Do not add analytics SDKs solely for this goal unless the privacy policy and
  Play Data safety declarations are updated first.
- Prefer Play Console aggregate install metrics over per-user tracking.
- If adding product analytics later, document the SDK, events, retention, user
  consent model, and Data safety impact before implementation.
- Do not store personally identifying screenshots in the repository.

## Growth Readiness Notes

- Store listing copy exists in `docs/play-store-listing.md`.
- Manual QA evidence template exists in `docs/manual-qa-checklist.md`.
- No acquisition campaign, onboarding experiment, referral mechanism, or
  retention dashboard exists yet.
