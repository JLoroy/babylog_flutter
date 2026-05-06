import { readFile } from 'node:fs/promises';
import test from 'node:test';
import assert from 'node:assert/strict';

test('Firestore indexes preserve production event query indexes', async () => {
  const indexes = JSON.parse(await readFile('firestore.indexes.json', 'utf8'));
  const eventIndexes = indexes.indexes.filter(
    (index) => index.collectionGroup === 'events',
  );

  assert.ok(
    hasIndex(eventIndexes, ['assistant', 'when', '__name__']),
    'events index for assistant timeline queries must be preserved',
  );
  assert.ok(
    hasIndex(eventIndexes, ['type', 'when', '__name__']),
    'events index for type/time queries must be preserved',
  );
});

function hasIndex(indexes, fields) {
  return indexes.some((index) => {
    const actual = index.fields.map((field) => field.fieldPath);
    return fields.length === actual.length && fields.every((field, i) => field === actual[i]);
  });
}
