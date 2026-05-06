# Babylog Play Distribution Draft

Last updated: 2026-05-05

Status:
Draft. Confirm these settings in Play Console before production rollout.

Official references:

- Create and set up your app:
  https://support.google.com/googleplay/android-developer/answer/9859152
- Choose a category and tags for your app or game:
  https://support.google.com/googleplay/android-developer/answer/9859673

## App Setup

App or game: App

Pricing: Free

In-app purchases: No in-app purchases

Ads: No ads

Families: Not enrolled in Families

Target audience:
Parents, guardians, and caregivers age 18 and over.

## Category And Tags

Category: Parenting

Rationale:
Google's category guidance describes Parenting as "Pregnancy, infant care and
monitoring, childcare." Babylog's core use case is a shared baby-care timeline
for parents and caregivers.

Tags: baby care, parenting, caregiver

Tag guidance:
Use only tags that are clearly reflected in the store listing and first-run app
experience. Do not add child-directed education, entertainment, medical, or
tracking tags unless the product scope changes.

## Countries And Regions

Countries/regions: Start with Belgium and the United States

Rationale:

- The project timezone, team context, and public contact appear Belgium-oriented.
- The Play Store objective and current store copy are in English and suitable for
  United States review/testing.
- Expand country availability after the first production release has stable
  crashes/ANRs, deletion verification, and support capacity.

## Production Rollout Notes

- Do not start production rollout until `docs/play-release-runbook.md`
  preconditions are complete.
- Record selected countries/regions in `STATUS.md` and
  `docs/release-completion-audit.md`.
- If adding paid plans, subscriptions, or in-app purchases later, update Play
  pricing, Data safety, policy docs, and the privacy policy before release.
