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
- `manifest.json` with release identity, source paths, byte sizes, and SHA-256
  hashes
- `README.md` with release identity and Console upload notes

## Private App Access Notes

After generating the non-secret handoff, create the private Play Console App
access notes from the ignored reviewer secret:

```bash
npm run prepare:play-private-notes
```

Default output:

```text
dist/play-console-handoff/private/play-console-app-access-notes.txt
```

This private file contains the reviewer password from
`.qa-secrets/play-reviewer-account.json`. Use it only to copy/paste App access
credentials into Play Console. Do not commit, screenshot, or share the private
file outside the release process.

Run `npm run prepare:play-handoff` first, then `npm run
prepare:play-private-notes`. Regenerating the non-secret handoff clears the
`dist/play-console-handoff/` folder, including private generated files.

## Secret Handling

The handoff intentionally excludes:

- Android signing secrets
- Firebase tokens
- Reviewer password
- OpenAI keys

Copy the reviewer password separately from ignored
`.qa-secrets/play-reviewer-account.json` into Play Console App access notes.

Alternatively, generate the private notes file above and paste from that ignored
output.

## Verification

```bash
npm run test:play-handoff
npm run test:play-private-notes
```

These tests regenerate the bundle and private notes in temporary directories,
verify the expected files and copy, and check that secret-like values are absent
from the generated non-secret manifest and README.

## Remaining Console Evidence

This bundle prepares files for upload. It does not prove Play Console accepted
the AAB, media, policy fields, or reviewer access notes. Capture Console
screenshots or exports after upload and link them from
`docs/release-completion-audit.md`.
