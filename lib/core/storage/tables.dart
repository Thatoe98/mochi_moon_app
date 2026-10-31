import 'package:drift/drift.dart';

/// Daily sign readings, keyed by date/sign/lang (PRD §8.6).
class CachedReadings extends Table {
  TextColumn get date => text()();
  TextColumn get sign => text()();
  TextColumn get lang => text()();
  IntColumn get version => integer()();
  TextColumn get json => text()();
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {date, sign, lang};
}

/// Natal / compatibility reports.
class CachedReports extends Table {
  TextColumn get reportId => text()();
  TextColumn get type => text()();
  TextColumn get lang => text()();
  IntColumn get version => integer()();
  TextColumn get json => text()();
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {reportId};
}

/// Every swipe, used for no-repeat windows, streaks and the For You ranking.
class DeckHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get quoteId => text()();
  TextColumn get action => text()();
  DateTimeColumn get at => dateTime()();
}

/// Local copy of saved cards ("This is me"), synced with Firestore later.
class JournalCache extends Table {
  TextColumn get quoteId => text()();
  DateTimeColumn get savedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {quoteId};
}

/// Single-row table (id = 0): the user's profile as JSON, in the same shape as
/// the Firestore document.
class ProfileCache extends Table {
  IntColumn get id => integer()();
  TextColumn get json => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Partners for compatibility (PRD §6.12): [json] is the Firestore shape of
/// the document, [id] its document id.
class PartnerCache extends Table {
  TextColumn get id => text()();
  TextColumn get json => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class RetroCalendar extends Table {
  TextColumn get planet => text()();
  IntColumn get year => integer()();
  TextColumn get json => text()();

  @override
  Set<Column<Object>> get primaryKey => {planet, year};
}

/// Single-row table (id = 0) holding the on-device preference vector.
class PreferenceVector extends Table {
  IntColumn get id => integer()();
  BlobColumn get vector => blob()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// The day's mood (PRD §6.18), one row per local day. [date] is `YYYY-MM-DD`;
/// [mood] is the mood id. [synced] is false until it reached Firestore.
class MoodEntries extends Table {
  TextColumn get date => text()();
  TextColumn get mood => text()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {date};
}

/// Gratitude and wins lines (PRD §6.16). Private: never leaves her own
/// Firestore documents.
class GratitudeEntries extends Table {
  TextColumn get id => text()();
  TextColumn get date => text()();
  TextColumn get body => text()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Her own affirmation cards (PRD §6.17). Private, like gratitude.
class CustomCards extends Table {
  TextColumn get id => text()();
  TextColumn get body => text()();
  TextColumn get illustrationId => text()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Days on which the daily ritual was finished (PRD §6.15), for the streak.
class RitualDays extends Table {
  TextColumn get date => text()();
  DateTimeColumn get completedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {date};
}

/// Where today's ritual stands, so it resumes after the app is closed.
/// [quoteIds] is a JSON list of the three card ids.
class RitualProgress extends Table {
  TextColumn get date => text()();
  IntColumn get step => integer()();
  TextColumn get quoteIds => text()();

  @override
  Set<Column<Object>> get primaryKey => {date};
}
