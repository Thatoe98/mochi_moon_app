// Tests for /firestore.rules (PRD §8.1). The Firestore emulator must be
// running: use scripts/test_rules.ps1 (or .sh).
const { after, before, beforeEach, describe, test } = require('node:test');
const fs = require('node:fs');
const path = require('node:path');
const {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} = require('@firebase/rules-unit-testing');
const {
  doc,
  setDoc,
  getDoc,
  updateDoc,
  deleteDoc,
  serverTimestamp,
  setLogLevel,
} = require('firebase/firestore');

// Denied writes are expected here; keep the SDK from logging each one.
setLogLevel('silent');

let env;

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-mochi-moon',
    firestore: {
      rules: fs.readFileSync(
        path.join(__dirname, '..', '..', 'firestore.rules'),
        'utf8',
      ),
    },
  });
});

after(async () => {
  await env.cleanup();
});

beforeEach(async () => {
  await env.clearFirestore();
});

const alice = () => env.authenticatedContext('alice').firestore();
const bob = () => env.authenticatedContext('bob').firestore();
const anonymous = () => env.unauthenticatedContext().firestore();

/** Writes [data] at [docPath] with the rules switched off. */
async function seed(docPath, data) {
  await env.withSecurityRulesDisabled(async (context) => {
    await setDoc(doc(context.firestore(), docPath), data);
  });
}

describe('users/{uid}', () => {
  test('the owner can create and read their document', async () => {
    const db = alice();
    await assertSucceeds(
      setDoc(doc(db, 'users/alice'), { displayName: 'Alice' }),
    );
    await assertSucceeds(getDoc(doc(db, 'users/alice')));
  });

  test('the owner can write the deck counters', async () => {
    await seed('users/alice', { displayName: 'Alice' });
    await assertSucceeds(
      setDoc(
        doc(alice(), 'users/alice'),
        {
          deck: {
            streak: 3,
            lastCompletedDate: '2026-10-28',
            todayCount: 2,
            todayDate: '2026-10-28',
          },
          updatedAt: serverTimestamp(),
        },
        { merge: true },
      ),
    );
  });

  test('someone else cannot read or write it', async () => {
    await seed('users/alice', { displayName: 'Alice' });
    await assertFails(getDoc(doc(bob(), 'users/alice')));
    await assertFails(
      setDoc(doc(bob(), 'users/alice'), { displayName: 'Bob' }),
    );
    await assertFails(updateDoc(doc(bob(), 'users/alice'), { displayName: 'B' }));
  });

  test('signed-out visitors cannot read or write it', async () => {
    await seed('users/alice', { displayName: 'Alice' });
    await assertFails(getDoc(doc(anonymous(), 'users/alice')));
    await assertFails(
      setDoc(doc(anonymous(), 'users/alice'), { displayName: 'X' }),
    );
  });

  test('nobody can create a document for another uid', async () => {
    await assertFails(setDoc(doc(bob(), 'users/alice'), { displayName: 'B' }));
  });

  test('the owner cannot create a document with an entitlement', async () => {
    await assertFails(
      setDoc(doc(alice(), 'users/alice'), {
        displayName: 'Alice',
        entitlement: { premium: true },
      }),
    );
  });

  test('the owner cannot grant or change their entitlement', async () => {
    await seed('users/alice', {
      displayName: 'Alice',
      entitlement: { premium: false },
    });
    await assertFails(
      updateDoc(doc(alice(), 'users/alice'), { entitlement: { premium: true } }),
    );
    await assertFails(
      setDoc(
        doc(alice(), 'users/alice'),
        { entitlement: { premium: true } },
        { merge: true },
      ),
    );
  });

  test('the owner can still update other fields next to an entitlement', async () => {
    await seed('users/alice', {
      displayName: 'Alice',
      entitlement: { premium: true },
    });
    await assertSucceeds(
      updateDoc(doc(alice(), 'users/alice'), { displayName: 'Alice B' }),
    );
  });

  test('the owner can delete their own document, nobody else can', async () => {
    await seed('users/alice', { displayName: 'Alice' });
    await assertFails(deleteDoc(doc(bob(), 'users/alice')));
    await assertSucceeds(deleteDoc(doc(alice(), 'users/alice')));
  });
});

describe('users/{uid}/journal/{quoteId}', () => {
  test('the owner can save, read and remove a card', async () => {
    const entry = doc(alice(), 'users/alice/journal/q1');
    await assertSucceeds(setDoc(entry, { savedAt: new Date() }));
    await assertSucceeds(getDoc(entry));
    await assertSucceeds(deleteDoc(entry));
  });

  test('rejects an entry with extra fields or a non-timestamp date', async () => {
    const entry = doc(alice(), 'users/alice/journal/q1');
    await assertFails(setDoc(entry, { savedAt: new Date(), note: 'hi' }));
    await assertFails(setDoc(entry, { savedAt: '2026-10-28' }));
    await assertFails(setDoc(entry, {}));
  });

  test('someone else cannot read, write or remove it', async () => {
    await seed('users/alice/journal/q1', { savedAt: new Date() });
    const entry = doc(bob(), 'users/alice/journal/q1');
    await assertFails(getDoc(entry));
    await assertFails(setDoc(entry, { savedAt: new Date() }));
    await assertFails(deleteDoc(entry));
  });

  test('signed-out visitors cannot read it', async () => {
    await seed('users/alice/journal/q1', { savedAt: new Date() });
    await assertFails(getDoc(doc(anonymous(), 'users/alice/journal/q1')));
  });
});

describe('users/{uid}/partners/{id}', () => {
  const partner = (extra = {}) => ({
    nickname: 'Moon',
    birthDate: '1998-05-14',
    birthTime: null,
    timeKnown: false,
    place: null,
    createdAt: new Date(),
    ...extra,
  });
  const place = {
    name: 'Bangkok',
    region: 'Bangkok',
    countryCode: 'TH',
    lat: 13.75,
    lng: 100.52,
    tzId: 'Asia/Bangkok',
  };

  test('the owner can add, read, edit and delete a partner', async () => {
    const ref = doc(alice(), 'users/alice/partners/p1');
    await assertSucceeds(setDoc(ref, partner()));
    await assertSucceeds(getDoc(ref));
    await assertSucceeds(
      setDoc(
        ref,
        partner({ nickname: 'Sol', birthTime: '14:30', timeKnown: true, place }),
      ),
    );
    await assertSucceeds(deleteDoc(ref));
  });

  test('a partner needs a nickname, a birth date and a creation time', async () => {
    const ref = doc(alice(), 'users/alice/partners/p1');
    await assertSucceeds(
      setDoc(ref, {
        nickname: 'Moon',
        birthDate: '1998-05-14',
        createdAt: new Date(),
      }),
    );
    await assertFails(setDoc(ref, { nickname: 'Moon' }));
    await assertFails(
      setDoc(ref, { nickname: 'Moon', birthDate: '1998-05-14' }),
    );
    await assertFails(
      setDoc(ref, { birthDate: '1998-05-14', createdAt: new Date() }),
    );
  });

  test('rejects a nickname that is empty, too long or not text', async () => {
    const ref = doc(alice(), 'users/alice/partners/p1');
    await assertFails(setDoc(ref, partner({ nickname: '' })));
    await assertFails(setDoc(ref, partner({ nickname: 'x'.repeat(31) })));
    await assertSucceeds(setDoc(ref, partner({ nickname: 'x'.repeat(30) })));
    await assertFails(setDoc(ref, partner({ nickname: 7 })));
  });

  test('rejects fields that are not part of a partner or have the wrong type', async () => {
    const ref = doc(alice(), 'users/alice/partners/p1');
    await assertFails(setDoc(ref, partner({ note: 'secret' })));
    await assertFails(setDoc(ref, partner({ birthDate: new Date() })));
    await assertFails(setDoc(ref, partner({ createdAt: '2026-10-30' })));
    await assertFails(setDoc(ref, partner({ birthTime: 1430 })));
    await assertFails(setDoc(ref, partner({ timeKnown: 'yes' })));
    await assertFails(setDoc(ref, partner({ place: 'Bangkok' })));
  });

  test('the owner can delete one partner and the others stay', async () => {
    await seed('users/alice/partners/p1', partner());
    await seed('users/alice/partners/p2', partner({ nickname: 'Sol' }));
    await assertSucceeds(deleteDoc(doc(alice(), 'users/alice/partners/p1')));
    await assertSucceeds(getDoc(doc(alice(), 'users/alice/partners/p2')));
  });

  test('someone else cannot read, write or delete a partner', async () => {
    await seed('users/alice/partners/p1', partner());
    const ref = doc(bob(), 'users/alice/partners/p1');
    await assertFails(getDoc(ref));
    await assertFails(setDoc(ref, partner({ nickname: 'X' })));
    await assertFails(deleteDoc(ref));
  });

  test('signed-out visitors cannot read or write a partner', async () => {
    await seed('users/alice/partners/p1', partner());
    const ref = doc(anonymous(), 'users/alice/partners/p1');
    await assertFails(getDoc(ref));
    await assertFails(setDoc(ref, partner()));
  });
});

describe('users/{uid}/reports/{id}', () => {
  test('the owner can read but never write; others cannot read', async () => {
    await seed('users/alice/reports/r1', { type: 'natal' });
    await assertSucceeds(getDoc(doc(alice(), 'users/alice/reports/r1')));
    await assertFails(
      setDoc(doc(alice(), 'users/alice/reports/r2'), { type: 'natal' }),
    );
    await assertFails(
      updateDoc(doc(alice(), 'users/alice/reports/r1'), { type: 'x' }),
    );
    await assertFails(deleteDoc(doc(alice(), 'users/alice/reports/r1')));
    await assertFails(getDoc(doc(bob(), 'users/alice/reports/r1')));
  });
});

describe('everything else', () => {
  test('other collections are closed', async () => {
    await assertFails(setDoc(doc(alice(), 'other/x'), { a: 1 }));
    await assertFails(getDoc(doc(alice(), 'other/x')));
  });
});
