import { readFileSync } from 'node:fs';
import assert from 'node:assert/strict';
import { after, before, beforeEach, describe, it } from 'node:test';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  deleteDoc,
  doc,
  getDoc,
  setDoc,
  updateDoc,
} from 'firebase/firestore';

const projectId = 'babylog-rules-test';

let testEnv;

before(async () => {
  testEnv = await initializeTestEnvironment({
    projectId,
    firestore: {
      rules: readFileSync('firestore.rules', 'utf8'),
      host: '127.0.0.1',
      port: 8085,
    },
  });
});

beforeEach(async () => {
  await testEnv.clearFirestore();
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, 'assistants', 'assistant-1'), {
      name: 'Baby',
      users: ['parent@example.com'],
      apikey: 'server-secret',
      byok: false,
      language: 'fr',
      usage: 100,
    });
    await setDoc(doc(db, 'events', 'event-1'), {
      assistant: 'assistant-1',
      description: 'Bottle',
      by: 'parent@example.com',
    });
    await setDoc(doc(db, 'users', 'uid-1'), {
      email: 'parent@example.com',
      current_assistant: doc(db, 'assistants', 'assistant-1'),
    });
  });
});

after(async () => {
  if (testEnv) {
    await testEnv.cleanup();
  }
});

function authedDb(uid, email) {
  return testEnv
    .authenticatedContext(uid, { email })
    .firestore();
}

describe('users', () => {
  it('allows users to read and update only their own document', async () => {
    const db = authedDb('uid-1', 'parent@example.com');

    await assertSucceeds(getDoc(doc(db, 'users', 'uid-1')));
    await assertSucceeds(updateDoc(doc(db, 'users', 'uid-1'), {
      current_assistant: doc(db, 'assistants', 'assistant-1'),
    }));
    await assertFails(getDoc(doc(db, 'users', 'uid-2')));
  });

  it('denies unauthenticated user document reads', async () => {
    const db = testEnv.unauthenticatedContext().firestore();

    await assertFails(getDoc(doc(db, 'users', 'uid-1')));
  });
});

describe('assistants', () => {
  it('allows assistant members to read and update their assistant', async () => {
    const db = authedDb('uid-1', 'parent@example.com');

    await assertSucceeds(getDoc(doc(db, 'assistants', 'assistant-1')));
    await assertSucceeds(updateDoc(doc(db, 'assistants', 'assistant-1'), {
      name: 'New Baby Name',
    }));
  });

  it('denies non-members assistant access', async () => {
    const db = authedDb('uid-2', 'stranger@example.com');

    await assertFails(getDoc(doc(db, 'assistants', 'assistant-1')));
    await assertFails(updateDoc(doc(db, 'assistants', 'assistant-1'), {
      name: 'Nope',
    }));
  });
});

describe('events', () => {
  it('allows assistant members to read, create, and delete events', async () => {
    const db = authedDb('uid-1', 'parent@example.com');

    await assertSucceeds(getDoc(doc(db, 'events', 'event-1')));
    await assertSucceeds(setDoc(doc(db, 'events', 'event-2'), {
      assistant: 'assistant-1',
      description: 'Nap',
      by: 'parent@example.com',
    }));
    await assertSucceeds(deleteDoc(doc(db, 'events', 'event-1')));
  });

  it('denies event access when the user is not an assistant member', async () => {
    const db = authedDb('uid-2', 'stranger@example.com');

    await assertFails(getDoc(doc(db, 'events', 'event-1')));
    await assertFails(setDoc(doc(db, 'events', 'event-2'), {
      assistant: 'assistant-1',
      description: 'Nope',
      by: 'stranger@example.com',
    }));
    await assertFails(deleteDoc(doc(db, 'events', 'event-1')));
  });
});
