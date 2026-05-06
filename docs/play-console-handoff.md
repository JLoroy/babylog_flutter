# Babylog Play Console Handoff Bundle

Last updated: 2026-05-06

Purpose:
Create a deterministic non-secret folder of files needed for Play Console
submission.

## Generate

```bash
npm run prepare:play-handoff
```

Default output:

```text
dist/play-console-handoff/
```

The script uses `build/app/outputs/bundle/release/app-release.aab` by default.
For tests or one-off verification, pass `--aab /absolute/or/relative/path.aab`
to package a specific bundle path.

The generated folder includes:

- Signed AAB: `release/app-release.aab`
- App icon: `assets/icon-512.png`
- Feature graphic: `assets/feature-graphic-1024x500.png`
- Phone screenshots: `screenshots/*.png`
- Store listing, App content, Data safety, reviewer access, and release notes
  copy under `copy/`
- `manifest.json` with source paths, byte sizes, and SHA-256 hashes
- `README.md` with Console upload notes

## Secret Handling

The handoff intentionally excludes:

- Android signing secrets
- Firebase tokens
- Reviewer password
- OpenAI keys

Copy the reviewer password separately from ignored
`.qa-secrets/play-reviewer-account.json` into Play Console App access notes.

## Verification

```bash
npm run test:play-handoff
```

This test regenerates the bundle in a temporary directory, verifies the expected
files and hashes, and checks that secret-like values are absent from the
generated manifest and README.

## Remaining Console Evidence

This bundle prepares files for upload. It does not prove Play Console accepted
the AAB, media, policy fields, or reviewer access notes. Capture Console
screenshots or exports after upload and link them from
`docs/release-completion-audit.md`.
