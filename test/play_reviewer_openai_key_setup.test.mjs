import { execFile } from 'node:child_process';
import { mkdtemp, readFile, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { promisify } from 'node:util';
import test from 'node:test';
import assert from 'node:assert/strict';

const execFileAsync = promisify(execFile);

test('reviewer OpenAI key setup writes only to the ignored local reviewer secret', async () => {
  const tempRoot = await mkdtemp(join(tmpdir(), 'babylog-play-reviewer-key-'));
  const secretPath = join(tempRoot, 'reviewer.json');
  const fakeKey = 'sk-test-openai-key-for-local-reviewer-secret-only';

  try {
    await writeFile(
      secretPath,
      JSON.stringify(
        {
          email: 'test@era-nova.be',
          password: 'fake-reviewer-password-for-test-only',
          assistantId: 'play-reviewer-assistant',
        },
        null,
        2,
      ),
    );

    const { stdout } = await execFileAsync(
      'node',
      ['scripts/setup_play_reviewer_openai_key.mjs', '--secret', secretPath],
      {
        env: {
          ...process.env,
          OPENAI_API_KEY: fakeKey,
        },
      },
    );

    const reviewer = JSON.parse(await readFile(secretPath, 'utf8'));
    assert.equal(reviewer.openaiApiKey, fakeKey);
    assert.match(stdout, /Reviewer OpenAI API key saved to ignored secret/);
    assert.doesNotMatch(stdout, new RegExp(escapeRegExp(fakeKey)));

    const script = await readFile(
      'scripts/setup_play_reviewer_openai_key.mjs',
      'utf8',
    );
    assert.match(script, /\.qa-secrets\/play-reviewer-account\.json/);
    assert.match(script, /process\.env\.OPENAI_API_KEY/);
    assert.doesNotMatch(script, /args\.indexOf\('--openai/);
    assert.doesNotMatch(script, /args\.indexOf\('--key/);
  } finally {
    await rm(tempRoot, { recursive: true, force: true });
  }
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
