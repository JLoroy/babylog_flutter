import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('Play Store asset checklist has a 512px app icon artifact', async () => {
  const [listing, icon, featureGraphic] = await Promise.all([
    readFile('docs/play-store-listing.md', 'utf8'),
    readFile('docs/play-assets/icon-512.png'),
    readFile('docs/play-assets/feature-graphic-1024x500.png'),
  ]);

  assert.match(listing, /Play Console app icon:\s*\n\s*`docs\/play-assets\/icon-512\.png`/);
  assert.match(
    listing,
    /Feature graphic:\s*\n\s*`docs\/play-assets\/feature-graphic-1024x500\.png`/,
  );
  assert.deepEqual(pngSize(icon), { width: 512, height: 512 });
  assert.deepEqual(pngSize(featureGraphic), { width: 1024, height: 500 });
  assert.equal(hasAlphaChannel(featureGraphic), false);
});

function pngSize(buffer) {
  assert.equal(buffer.toString('ascii', 1, 4), 'PNG', 'asset must be a PNG');

  return {
    width: buffer.readUInt32BE(16),
    height: buffer.readUInt32BE(20),
  };
}

function hasAlphaChannel(buffer) {
  assert.equal(buffer.toString('ascii', 12, 16), 'IHDR');
  const colorType = buffer.readUInt8(25);

  return colorType === 4 || colorType === 6;
}
