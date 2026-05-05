# STATUS — Babylog

**Last updated:** 2026-05-05

## Update (2026-05-05)

### Current milestone
- Merge completed locally: `feature/unbug` is now merged into `main`.

### What changed
- Created merge commit `4f3cd94` on `main`.
- Preserved the pre-merge dirty workspace in stash `pre-main-merge dirty workspace backup`.
- Added `plan.md` so merge and cleanup decisions have a durable place to live.

### Verification
- `git status` was clean immediately after the merge.
- `flutter test` could not run because `flutter` is not installed or not on `PATH` in this shell.

### Next steps
1. Restore or inspect the pre-merge stash only if those local-only files are still needed.
2. Run Flutter tests once the Flutter SDK is available.
3. Push local `main` when ready.

## What this is
A quick, living snapshot of where the Babylog app is at, what’s risky, and what we’re doing next.

## Product summary
Babylog is a Flutter mobile app for parents to log baby events to a shared timeline.
Core interaction: record audio → transcribe (OpenAI Whisper) → interpret into structured “events” → store in Firebase.

## Repo snapshot (today)
- **Framework:** Flutter / Dart
- **Backend services:** Firebase Auth + Firestore (+ Realtime Database present per audit)
- **AI:** OpenAI API calls currently done directly from the client (chat + audio transcription)
- **Android:** targetSdk 34, minSdk 23, AGP 8.8.0, Gradle 8.10.2, Kotlin 1.9.22

## Current state
The app runs in dev, but a **production-quality Android release is not safe yet**.
The Codex audit (audit/2026-02-03.md) flags multiple release blockers and compliance risks.

## Critical blockers (must fix before release)
1) **Android INTERNET permission missing**
   - `android/app/src/main/AndroidManifest.xml` currently only declares `RECORD_AUDIO`.
   - Risk: release build cannot call OpenAI/Firebase/network.

2) **Audio recording path is invalid**
   - `lib/components/recorder.dart` uses hardcoded placeholder path `your/app/directory/...`.
   - Risk: recording fails on real devices.

3) **OpenAI key handling is unsafe**
   - Client uses keys directly; dev key fetched from Firestore; BYOK keys stored in Firestore.
   - Risk: key exfiltration, data liability, Play compliance / user trust.

4) **Release signing config is hardcoded**
   - `android/app/build.gradle.kts` references `H:/My Drive/...eranova_upload.jks`.
   - Risk: cannot build in CI / other machines; release pipeline fragile.

5) **Data deletion incomplete**
   - Delete account deletes only events; leaves user/assistant docs.
   - Risk: Play Console account deletion requirements.

## High-risk / compliance
- **Firebase security rules** are not in repo → unknown access control.
- **Data Safety disclosures** needed (audio, OpenAI processing, Firebase).

## Architecture pain points (to revamp)
- **Transcription pipeline** is currently client-driven.
- **Cost monitoring** is currently not robust/centralized.

## Milestones (Justin’s)
- ✅ (This week) Onboard + plan tasks
- **Milestone 1:** Fix all critical findings from Codex audit
- **Milestone 2:** Revamp architecture (transcription service + cost monitoring)
- **Milestone 3:** Professional-grade quality
- **Milestone 4:** Publish a new version by **2026-03-10**

## Next actions (immediate)
- Produce an actionable task list in `todo.md` (format: Title / Description / Guidance / How to validate).
- Confirm decisions:
  - Keep OpenAI features in the March 10 release or not?
  - Backend proxy vs BYOK-local-only strategy.
  - Source of truth for events storage (Firestore vs RTDB).
