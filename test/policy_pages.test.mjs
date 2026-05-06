import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

const pages = [
  {
    path: 'docs/public/privacy-policy.html',
    required: [
      '<title>Babylog Privacy Policy</title>',
      'Privacy Policy',
      'Firebase',
      'OpenAI',
      'account deletion',
      'Developer: Nacho',
      'privacy@lenacho.be',
    ],
  },
  {
    path: 'docs/public/delete-account.html',
    required: [
      '<title>Delete your Babylog account and data</title>',
      'Delete your Babylog account and data',
      'Babylog account deletion request',
      'privacy@lenacho.be',
      'without reinstalling the app',
    ],
  },
];

for (const page of pages) {
  test(`${page.path} contains Play-required policy content`, async () => {
    const html = await readFile(page.path, 'utf8');

    for (const text of page.required) {
      assert.match(html, new RegExp(escapeRegExp(text)));
    }

    assert.doesNotMatch(html, /privacy@eranova\.be/);
    assert.doesNotMatch(html, /Developer: Eranova/);
    assert.doesNotMatch(html, /TODO:/);
  });
}

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
