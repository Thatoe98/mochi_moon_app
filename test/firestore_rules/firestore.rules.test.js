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

const ts = () => serverTimestamp();

/** One row per self-love collection: a valid document and what must fail. */
const selfLove = [
  {
    name: 'gratitude',
    path: 'users/alice/gratitude/g1',
    valid: () => ({ text: 'Warm tea', date: '2026-10-31', createdAt: ts() }),
    bad: {
      'a 201-character line': (d) => ({ ...d, text: 'a'.repeat(201) }),
      'an empty line': (d) => ({ ...d, text: '' }),
      'a bad date': (d) => ({ ...d, date: 'yesterday' }),
      'an unknown key': (d) => ({ ...d, extra: 1 }),
      'a missing date': ({ date, ...d }) => d,
    },
    edge: { 'a 200-character line': (d) => ({ ...d, text: 'a'.repeat(200) }) },
  },
  {
    name: 'customCards',
    path: 'users/alice/customCards/c1',
    valid: () => ({
      text: 'I am enough',
      illustrationId: 'ill_0001',
      createdAt: ts(),
      updatedAt: ts(),
    }),
    bad: {
      'a 141-character card': (d) => ({ ...d, text: 'a'.repeat(141) }),
      'an empty card': (d) => ({ ...d, text: '' }),
      'no illustration': ({ illustrationId, ...d }) => d,
      'an unknown key': (d) => ({ ...d, category: 'x' }),
    },
    edge: { 'a 140-character card': (d) => ({ ...d, text: 'a'.repeat(140) }) },
  },
  {
    name: 'moods',
    path: 'users/alice/moods/2026-10-31',
    valid: () => ({ mood: 'calm', updatedAt: ts() }),
    bad: {
      'an unknown mood': (d) => ({ ...d, mood: 'furious' }),
      'an unknown key': (d) => ({ ...d, note: 'hi' }),
      'a missing timestamp': ({ updatedAt, ...d }) => d,
    },
    edge: { in_love: (d) => ({ ...d, mood: 'in_love' }) },
  },
  {
    name: 'letters',
    path: 'users/alice/letters/l1',
    valid: () => ({
      text: 'Dear me',
      writtenAt: ts(),
      unlockAt: ts(),
      unlockDays: 30,
    }),
    bad: {
      'a 1001-character letter': (d) => ({ ...d, text: 'a'.repeat(1001) }),
      'an odd unlock length': (d) => ({ ...d, unlockDays: 7 }),
      'an unknown key': (d) => ({ ...d, mood: 'x' }),
    },
    edge: {
      'a 1000-character letter': (d) => ({ ...d, text: 'a'.repeat(1000) }),
      'a 365-day unlock': (d) => ({ ...d, unlockDays: 365 }),
    },
  },
  {
    name: 'journeyProgress',
    path: 'users/alice/journeyProgress/confidence',
    valid: () => ({
      startedAt: ts(),
      currentDay: 2,
      completedDays: [1],
      reflections: { 1: 'I felt proud' },
      completedAt: null,
    }),
    bad: {
      'day zero': (d) => ({ ...d, currentDay: 0 }),
      'a text day': (d) => ({ ...d, currentDay: '2' }),
      'too many completed days': (d) => ({
        ...d,
        completedDays: Array.from({ length: 15 }, (_, i) => i + 1),
      }),
      'an unknown key': (d) => ({ ...d, score: 3 }),
    },
    edge: {
      'a finished journey': (d) => ({ ...d, completedAt: ts() }),
      'no reflections': ({ reflections, ...d }) => d,
    },
  },
  {
    name: 'state/quest',
    path: 'users/alice/state/quest',
    valid: () => ({
      date: '2026-10-31',
      questId: 'quest_001',
      done: false,
      swapped: false,
    }),
    bad: {
      'a text flag': (d) => ({ ...d, done: 'yes' }),
      'a bad date': (d) => ({ ...d, date: '31/10/2026' }),
      'an unknown key': (d) => ({ ...d, extra: 1 }),
    },
    edge: {},
  },
  {
    name: 'state/mascot',
    path: 'users/alice/state/mascot',
    valid: () => ({
      owned: ['hat_star'],
      equipped: { outfit: null, room: {} },
      updatedAt: ts(),
    }),
    bad: {
      'owned that is not a list': (d) => ({ ...d, owned: 'hat_star' }),
      'a hundred and one items': (d) => ({
        ...d,
        owned: Array.from({ length: 101 }, (_, i) => `i${i}`),
      }),
      'an unknown key': (d) => ({ ...d, coins: 5 }),
    },
    edge: {},
  },
  {
    name: 'state/ritual',
    path: 'users/alice/state/ritual',
    valid: () => ({ completedDates: ['2026-10-30', '2026-10-31'] }),
    bad: {
      'more than 400 dates': (d) => ({
        ...d,
        completedDates: Array.from({ length: 401 }, () => '2026-10-31'),
      }),
      'dates that are not a list': (d) => ({ ...d, completedDates: 'x' }),
      'an unknown key': (d) => ({ ...d, streak: 3 }),
    },
    edge: {},
  },
];

for (const c of selfLove) {
  describe(`users/{uid}/${c.name}`, () => {
    test('the owner can write, read, update and delete', async () => {
      const ref = doc(alice(), c.path);
      await assertSucceeds(setDoc(ref, c.valid()));
      await assertSucceeds(getDoc(ref));
      await assertSucceeds(setDoc(ref, c.valid()));
      await assertSucceeds(deleteDoc(ref));
    });

    for (const [label, make] of Object.entries(c.edge)) {
      test(`accepts ${label}`, async () => {
        await assertSucceeds(setDoc(doc(alice(), c.path), make(c.valid())));
      });
    }

    for (const [label, make] of Object.entries(c.bad)) {
      test(`rejects ${label}`, async () => {
        await assertFails(setDoc(doc(alice(), c.path), make(c.valid())));
      });
    }

    test('someone else cannot read, write or delete it', async () => {
      await seed(c.path, c.valid());
      const ref = doc(bob(), c.path);
      await assertFails(getDoc(ref));
      await assertFails(setDoc(ref, c.valid()));
      await assertFails(deleteDoc(ref));
    });

    test('signed-out visitors cannot read or write it', async () => {
      await seed(c.path, c.valid());
      const ref = doc(anonymous(), c.path);
      await assertFails(getDoc(ref));
      await assertFails(setDoc(ref, c.valid()));
    });
  });
}

describe('users/{uid}/moods/{date}', () => {
  test('the document id must be a date', async () => {
    await assertFails(
      setDoc(doc(alice(), 'users/alice/moods/today'), {
        mood: 'calm',
        updatedAt: ts(),
      }),
    );
  });
});

describe('users/{uid}/state/{other}', () => {
  test('unknown state documents are closed', async () => {
    await assertFails(
      setDoc(doc(alice(), 'users/alice/state/other'), { a: 1 }),
    );
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
