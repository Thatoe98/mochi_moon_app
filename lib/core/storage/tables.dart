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
