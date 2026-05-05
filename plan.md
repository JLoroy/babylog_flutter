# Plan

## Decisions

- 2026-05-05: Preserve the dirty pre-merge workspace, including untracked files, in stash `pre-main-merge dirty workspace backup` before switching branches.
- 2026-05-05: Merge `feature/unbug` into local `main` with a merge commit instead of rebasing, preserving branch history.
- 2026-05-05: Keep `main` clean after the merge by committing this bookkeeping update separately.

## Next

- Install or expose Flutter on `PATH` before running `flutter test`.
- Push `main` when ready; local `main` is ahead of `origin/main`.
