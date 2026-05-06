import { mkdir, readFile, writeFile } from 'node:fs/promises';
import { dirname, join, relative } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = fileURLToPath(new URL('..', import.meta.url));

const args = process.argv.slice(2);
const outputArgIndex = args.indexOf('--out');
const secretArgIndex = args.indexOf('--secret');

const outputPath =
  outputArgIndex === -1
    ? join(root, 'dist/play-console-handoff/private/play-console-app-access-notes.txt')
    : resolveFromRoot(args[outputArgIndex + 1], '--out');
const secretPath =
  secretArgIndex === -1
    ? join(root, '.qa-secrets/play-reviewer-account.json')
    : resolveFromRoot(args[secretArgIndex + 1], '--secret');

const reviewer = JSON.parse(await readFile(secretPath, 'utf8'));

for (const field of ['email', 'password', 'assistantId']) {
  if (typeof reviewer[field] !== 'string' || reviewer[field].trim() === '') {
    throw new Error(`Reviewer secret is missing required string field: ${field}`);
  }
}

const openAiApiKey = optionalString(reviewer.openaiApiKey);
const openAiKeySection = openAiApiKey
  ? `Temporary OpenAI API key for AI recording review:
OpenAI API key: ${openAiApiKey}

AI recording setup:
1. Sign in with the reviewer account above.
2. Open Settings.
3. Enable "Bring your own API key".
4. Paste the OpenAI API key above into the OpenAI API Key field.
5. Save the settings.
6. Return to the timeline, tap record, allow microphone access if prompted,
   and record a short synthetic baby-care event only.
`
  : `AI recording setup:
No OpenAI API key is present in the local reviewer secret. If Play review needs
to test AI recording, add a temporary limited key to the ignored reviewer secret
as "openaiApiKey", regenerate this file, and paste it into Play Console App
access notes.
`;

const notes = `Babylog Play Console App Access Notes

WARNING: This file contains private reviewer credentials${openAiApiKey ? ' and an OpenAI API key' : ''}. It is
generated under ignored dist/ output for copy/paste into Play Console only. Do
not commit or share it outside the release process.

Access type:
Some or all functionality is restricted.

Reviewer account:
Email: ${reviewer.email}
Password: ${reviewer.password}
Assistant id: ${reviewer.assistantId}

Reviewer instructions:
Install and open Babylog.
Sign in with the reviewer account above.
Use only the ${reviewer.assistantId} sample timeline. Do not enter real child data.
Open Settings to inspect the Privacy Policy entry, BYOK OpenAI key setting,
assistant id, and Delete Account flow.

Babylog is BYOK-only for OpenAI. It does not ship or fetch a shared OpenAI API
key. The OpenAI key must be entered in Settings on the review device because
Babylog stores BYOK keys locally on-device, not in Firebase.

${openAiKeySection}
The authenticated timeline, Settings, Privacy Policy, BYOK setting, AI recording
after local key entry, and Delete Account flows are available with the reviewer
account.

Please do not delete the reviewer account unless the review specifically needs
to validate deletion.
`;

await mkdir(dirname(outputPath), { recursive: true });
await writeFile(outputPath, notes);

console.log(`Private Play Console app access notes written to ${relative(root, outputPath)}`);

function resolveFromRoot(value, flag) {
  if (!value) {
    throw new Error(`Missing value after ${flag}`);
  }

  return value.startsWith('/') ? value : join(root, value);
}

function optionalString(value) {
  return typeof value === 'string' && value.trim() !== '' ? value.trim() : null;
}
