import { createHash } from 'node:crypto';
import { copyFile, mkdir, readFile, rm, writeFile } from 'node:fs/promises';
import { basename, dirname, join, relative } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = fileURLToPath(new URL('..', import.meta.url));
const defaultOutput = join(root, 'dist/play-console-handoff');

const args = process.argv.slice(2);
const outputArgIndex = args.indexOf('--out');
const aabArgIndex = args.indexOf('--aab');
const outputDir =
  outputArgIndex === -1 ? defaultOutput : resolveFromRoot(args[outputArgIndex + 1]);
const aabSource =
  aabArgIndex === -1
    ? 'build/app/outputs/bundle/release/app-release.aab'
    : resolveFromRoot(args[aabArgIndex + 1]);

const files = [
  ['signed-aab', aabSource, 'release/app-release.aab'],
  ['app-icon', 'docs/play-assets/icon-512.png', 'assets/icon-512.png'],
  [
    'feature-graphic',
    'docs/play-assets/feature-graphic-1024x500.png',
    'assets/feature-graphic-1024x500.png',
  ],
  ['screenshot', 'docs/play-assets/screenshots/phone-00-sign-in.png', 'screenshots/phone-00-sign-in.png'],
  [
    'screenshot',
    'docs/play-assets/screenshots/phone-01-shared-timeline.png',
    'screenshots/phone-01-shared-timeline.png',
  ],
  ['screenshot', 'docs/play-assets/screenshots/phone-02-settings.png', 'screenshots/phone-02-settings.png'],
  [
    'screenshot',
    'docs/play-assets/screenshots/phone-03-privacy-policy.png',
    'screenshots/phone-03-privacy-policy.png',
  ],
  [
    'screenshot',
    'docs/play-assets/screenshots/phone-04-recording-permission.png',
    'screenshots/phone-04-recording-permission.png',
  ],
  [
    'screenshot-manifest',
    'docs/play-assets/screenshots/2026-05-06-local-release-screenshot-set.json',
    'screenshots/2026-05-06-local-release-screenshot-set.json',
  ],
  ['submit-packet', 'docs/play-console-submit-packet.md', 'copy/play-console-submit-packet.md'],
  ['store-listing', 'docs/play-store-listing.md', 'copy/play-store-listing.md'],
  ['app-content', 'docs/play-console-app-content.md', 'copy/play-console-app-content.md'],
  ['data-safety', 'docs/play-console-compliance.md', 'copy/play-console-compliance.md'],
  ['reviewer-access', 'docs/play-reviewer-access.md', 'copy/play-reviewer-access.md'],
  ['release-notes', 'android/app/releasenotes.md', 'copy/releasenotes.md'],
];

await rm(outputDir, { recursive: true, force: true });
await mkdir(outputDir, { recursive: true });

const manifest = {
  generatedAt: new Date().toISOString(),
  note:
    'Non-secret Play Console handoff generated from repository release evidence. Copy reviewer password separately from ignored .qa-secrets/play-reviewer-account.json.',
  files: [],
};

for (const [role, source, target] of files) {
  const sourcePath = source.startsWith('/') ? source : join(root, source);
  const targetPath = join(outputDir, target);
  const buffer = await readFile(sourcePath);

  await mkdir(dirname(targetPath), { recursive: true });
  await copyFile(sourcePath, targetPath);

  manifest.files.push({
    role,
    source,
    target,
    filename: basename(target),
    bytes: buffer.byteLength,
    sha256: createHash('sha256').update(buffer).digest('hex'),
  });
}

await writeFile(join(outputDir, 'manifest.json'), `${JSON.stringify(manifest, null, 2)}\n`);
await writeFile(join(outputDir, 'README.md'), readmeFor(manifest.generatedAt));

console.log(`Play Console handoff written to ${relative(root, outputDir)}`);

function resolveFromRoot(value) {
  if (!value) {
    throw new Error('Missing value after --out');
  }

  return value.startsWith('/') ? value : join(root, value);
}

function readmeFor(generatedAt) {
  return `# Babylog Play Console Handoff

Generated: ${generatedAt}

This folder contains non-secret files for the Play Console release handoff.

Use:

- \`release/app-release.aab\` for the internal testing or production release upload.
- \`assets/icon-512.png\` and \`assets/feature-graphic-1024x500.png\` for store graphics.
- \`screenshots/*.png\` for phone screenshots.
- \`copy/*.md\` for store listing, app content, Data safety, reviewer access, and release notes copy.
- \`manifest.json\` for file hashes and source paths.

Secrets are intentionally excluded. Copy the reviewer password separately from
\`.qa-secrets/play-reviewer-account.json\` into Play Console App access notes.

The handoff is not Play Console acceptance evidence. Capture Console screenshots
or exports after upload and update \`docs/release-completion-audit.md\`.
`;
}
