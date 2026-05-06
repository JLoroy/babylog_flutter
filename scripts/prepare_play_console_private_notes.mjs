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

const notes = `Babylog Play Console App Access Notes

WARNING: This file contains the reviewer account password. It is generated
under ignored dist/ output for copy/paste into Play Console only. Do not commit
or share it outside the release process.

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
key. AI recording requires the reviewer's own OpenAI API key. The authenticated
non-AI timeline, Settings, Privacy Policy, BYOK setting, and Delete Account
flows are available with the reviewer account.

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
