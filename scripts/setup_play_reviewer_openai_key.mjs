import { readFile, writeFile } from 'node:fs/promises';
import { join, relative } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = fileURLToPath(new URL('..', import.meta.url));
const args = process.argv.slice(2);
const secretArgIndex = args.indexOf('--secret');
const secretPath =
  secretArgIndex === -1
    ? join(root, '.qa-secrets/play-reviewer-account.json')
    : resolveFromRoot(args[secretArgIndex + 1], '--secret');

const openAiApiKey = process.env.OPENAI_API_KEY?.trim();
if (!openAiApiKey) {
  throw new Error(
    'OPENAI_API_KEY is required. Set it in the environment; do not pass it as a command-line argument.',
  );
}

if (!openAiApiKey.startsWith('sk-')) {
  throw new Error('OPENAI_API_KEY does not look like an OpenAI API key.');
}

const reviewer = JSON.parse(await readFile(secretPath, 'utf8'));

for (const field of ['email', 'password', 'assistantId']) {
  if (typeof reviewer[field] !== 'string' || reviewer[field].trim() === '') {
    throw new Error(`Reviewer secret is missing required string field: ${field}`);
  }
}

reviewer.openaiApiKey = openAiApiKey;

await writeFile(secretPath, `${JSON.stringify(reviewer, null, 2)}\n`);

console.log(
  `Reviewer OpenAI API key saved to ignored secret ${relative(root, secretPath)}.`,
);
console.log(
  'Run `npm run prepare:play-private-notes` to regenerate the private Play Console notes.',
);

function resolveFromRoot(value, flag) {
  if (!value) {
    throw new Error(`Missing value after ${flag}`);
  }

  return value.startsWith('/') ? value : join(root, value);
}
