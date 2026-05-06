import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('Play distribution draft covers category, pricing, and country rollout', async () => {
  const draft = await readFile('docs/play-distribution.md', 'utf8');

  const compactDraft = draft.replace(/\s+/g, ' ');

  for (const required of [
    'App or game: App',
    'Pricing: Free',
    'Category: Parenting',
    'Pregnancy, infant care and monitoring, childcare',
    'Tags: baby care, parenting, caregiver',
    'Countries/regions: Start with Belgium and the United States',
    'No in-app purchases',
    'No ads',
    'Not enrolled in Families',
  ]) {
    assert.match(compactDraft, new RegExp(escapeRegExp(required)));
  }
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
