// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedReadingsTable extends CachedReadings
    with TableInfo<$CachedReadingsTable, CachedReading> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedReadingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _signMeta = const VerificationMeta('sign');
  @override
  late final GeneratedColumn<String> sign = GeneratedColumn<String>(
    'sign',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _langMeta = const VerificationMeta('lang');
  @override
  late final GeneratedColumn<String> lang = GeneratedColumn<String>(
    'lang',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    sign,
    lang,
    version,
    json,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_readings';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedReading> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('sign')) {
      context.handle(
        _signMeta,
        sign.isAcceptableOrUnknown(data['sign']!, _signMeta),
      );
    } else if (isInserting) {
      context.missing(_signMeta);
    }
    if (data.containsKey('lang')) {
      context.handle(
        _langMeta,
        lang.isAcceptableOrUnknown(data['lang']!, _langMeta),
      );
    } else if (isInserting) {
      context.missing(_langMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date, sign, lang};
  @override
  CachedReading map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedReading(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      sign: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sign'],
      )!,
      lang: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lang'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $CachedReadingsTable createAlias(String alias) {
    return $CachedReadingsTable(attachedDatabase, alias);
  }
}

class CachedReading extends DataClass implements Insertable<CachedReading> {
  final String date;
  final String sign;
  final String lang;
  final int version;
  final String json;
  final DateTime fetchedAt;
  const CachedReading({
    required this.date,
    required this.sign,
    required this.lang,
    required this.version,
    required this.json,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['sign'] = Variable<String>(sign);
    map['lang'] = Variable<String>(lang);
    map['version'] = Variable<int>(version);
    map['json'] = Variable<String>(json);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  CachedReadingsCompanion toCompanion(bool nullToAbsent) {
    return CachedReadingsCompanion(
      date: Value(date),
      sign: Value(sign),
      lang: Value(lang),
      version: Value(version),
      json: Value(json),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory CachedReading.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedReading(
      date: serializer.fromJson<String>(json['date']),
      sign: serializer.fromJson<String>(json['sign']),
      lang: serializer.fromJson<String>(json['lang']),
      version: serializer.fromJson<int>(json['version']),
      json: serializer.fromJson<String>(json['json']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'sign': serializer.toJson<String>(sign),
      'lang': serializer.toJson<String>(lang),
      'version': serializer.toJson<int>(version),
      'json': serializer.toJson<String>(json),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  CachedReading copyWith({
    String? date,
    String? sign,
    String? lang,
    int? version,
    String? json,
    DateTime? fetchedAt,
  }) => CachedReading(
    date: date ?? this.date,
    sign: sign ?? this.sign,
    lang: lang ?? this.lang,
    version: version ?? this.version,
    json: json ?? this.json,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  CachedReading copyWithCompanion(CachedReadingsCompanion data) {
    return CachedReading(
      date: data.date.present ? data.date.value : this.date,
      sign: data.sign.present ? data.sign.value : this.sign,
      lang: data.lang.present ? data.lang.value : this.lang,
      version: data.version.present ? data.version.value : this.version,
      json: data.json.present ? data.json.value : this.json,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedReading(')
          ..write('date: $date, ')
          ..write('sign: $sign, ')
          ..write('lang: $lang, ')
          ..write('version: $version, ')
          ..write('json: $json, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, sign, lang, version, json, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedReading &&
          other.date == this.date &&
          other.sign == this.sign &&
          other.lang == this.lang &&
          other.version == this.version &&
          other.json == this.json &&
          other.fetchedAt == this.fetchedAt);
}

class CachedReadingsCompanion extends UpdateCompanion<CachedReading> {
  final Value<String> date;
  final Value<String> sign;
  final Value<String> lang;
  final Value<int> version;
  final Value<String> json;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const CachedReadingsCompanion({
    this.date = const Value.absent(),
    this.sign = const Value.absent(),
    this.lang = const Value.absent(),
    this.version = const Value.absent(),
    this.json = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedReadingsCompanion.insert({
    required String date,
    required String sign,
    required String lang,
    required int version,
    required String json,
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       sign = Value(sign),
       lang = Value(lang),
       version = Value(version),
       json = Value(json),
       fetchedAt = Value(fetchedAt);
  static Insertable<CachedReading> custom({
    Expression<String>? date,
    Expression<String>? sign,
    Expression<String>? lang,
    Expression<int>? version,
    Expression<String>? json,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (sign != null) 'sign': sign,
      if (lang != null) 'lang': lang,
      if (version != null) 'version': version,
      if (json != null) 'json': json,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedReadingsCompanion copyWith({
    Value<String>? date,
    Value<String>? sign,
    Value<String>? lang,
    Value<int>? version,
    Value<String>? json,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return CachedReadingsCompanion(
      date: date ?? this.date,
      sign: sign ?? this.sign,
      lang: lang ?? this.lang,
      version: version ?? this.version,
      json: json ?? this.json,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (sign.present) {
      map['sign'] = Variable<String>(sign.value);
    }
    if (lang.present) {
      map['lang'] = Variable<String>(lang.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedReadingsCompanion(')
          ..write('date: $date, ')
          ..write('sign: $sign, ')
          ..write('lang: $lang, ')
          ..write('version: $version, ')
          ..write('json: $json, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedReportsTable extends CachedReports
    with TableInfo<$CachedReportsTable, CachedReport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _reportIdMeta = const VerificationMeta(
    'reportId',
  );
  @override
  late final GeneratedColumn<String> reportId = GeneratedColumn<String>(
    'report_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _langMeta = const VerificationMeta('lang');
  @override
  late final GeneratedColumn<String> lang = GeneratedColumn<String>(
    'lang',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    reportId,
    type,
    lang,
    version,
    json,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_reports';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedReport> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('report_id')) {
      context.handle(
        _reportIdMeta,
        reportId.isAcceptableOrUnknown(data['report_id']!, _reportIdMeta),
      );
    } else if (isInserting) {
      context.missing(_reportIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('lang')) {
      context.handle(
        _langMeta,
        lang.isAcceptableOrUnknown(data['lang']!, _langMeta),
      );
    } else if (isInserting) {
      context.missing(_langMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {reportId};
  @override
  CachedReport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedReport(
      reportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      lang: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lang'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $CachedReportsTable createAlias(String alias) {
    return $CachedReportsTable(attachedDatabase, alias);
  }
}

class CachedReport extends DataClass implements Insertable<CachedReport> {
  final String reportId;
  final String type;
  final String lang;
  final int version;
  final String json;
  final DateTime fetchedAt;
  const CachedReport({
    required this.reportId,
    required this.type,
    required this.lang,
    required this.version,
    required this.json,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['report_id'] = Variable<String>(reportId);
    map['type'] = Variable<String>(type);
    map['lang'] = Variable<String>(lang);
    map['version'] = Variable<int>(version);
    map['json'] = Variable<String>(json);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  CachedReportsCompanion toCompanion(bool nullToAbsent) {
    return CachedReportsCompanion(
      reportId: Value(reportId),
      type: Value(type),
      lang: Value(lang),
      version: Value(version),
      json: Value(json),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory CachedReport.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedReport(
      reportId: serializer.fromJson<String>(json['reportId']),
      type: serializer.fromJson<String>(json['type']),
      lang: serializer.fromJson<String>(json['lang']),
      version: serializer.fromJson<int>(json['version']),
      json: serializer.fromJson<String>(json['json']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'reportId': serializer.toJson<String>(reportId),
      'type': serializer.toJson<String>(type),
      'lang': serializer.toJson<String>(lang),
      'version': serializer.toJson<int>(version),
      'json': serializer.toJson<String>(json),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  CachedReport copyWith({
    String? reportId,
    String? type,
    String? lang,
    int? version,
    String? json,
    DateTime? fetchedAt,
  }) => CachedReport(
    reportId: reportId ?? this.reportId,
    type: type ?? this.type,
    lang: lang ?? this.lang,
    version: version ?? this.version,
    json: json ?? this.json,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  CachedReport copyWithCompanion(CachedReportsCompanion data) {
    return CachedReport(
      reportId: data.reportId.present ? data.reportId.value : this.reportId,
      type: data.type.present ? data.type.value : this.type,
      lang: data.lang.present ? data.lang.value : this.lang,
      version: data.version.present ? data.version.value : this.version,
      json: data.json.present ? data.json.value : this.json,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedReport(')
          ..write('reportId: $reportId, ')
          ..write('type: $type, ')
          ..write('lang: $lang, ')
          ..write('version: $version, ')
          ..write('json: $json, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(reportId, type, lang, version, json, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedReport &&
          other.reportId == this.reportId &&
          other.type == this.type &&
          other.lang == this.lang &&
          other.version == this.version &&
          other.json == this.json &&
          other.fetchedAt == this.fetchedAt);
}

class CachedReportsCompanion extends UpdateCompanion<CachedReport> {
  final Value<String> reportId;
  final Value<String> type;
  final Value<String> lang;
  final Value<int> version;
  final Value<String> json;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const CachedReportsCompanion({
    this.reportId = const Value.absent(),
    this.type = const Value.absent(),
    this.lang = const Value.absent(),
    this.version = const Value.absent(),
    this.json = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedReportsCompanion.insert({
    required String reportId,
    required String type,
    required String lang,
    required int version,
    required String json,
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  }) : reportId = Value(reportId),
       type = Value(type),
       lang = Value(lang),
       version = Value(version),
       json = Value(json),
       fetchedAt = Value(fetchedAt);
  static Insertable<CachedReport> custom({
    Expression<String>? reportId,
    Expression<String>? type,
    Expression<String>? lang,
    Expression<int>? version,
    Expression<String>? json,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (reportId != null) 'report_id': reportId,
      if (type != null) 'type': type,
      if (lang != null) 'lang': lang,
      if (version != null) 'version': version,
      if (json != null) 'json': json,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedReportsCompanion copyWith({
    Value<String>? reportId,
    Value<String>? type,
    Value<String>? lang,
    Value<int>? version,
    Value<String>? json,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return CachedReportsCompanion(
      reportId: reportId ?? this.reportId,
      type: type ?? this.type,
      lang: lang ?? this.lang,
      version: version ?? this.version,
      json: json ?? this.json,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (reportId.present) {
      map['report_id'] = Variable<String>(reportId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (lang.present) {
      map['lang'] = Variable<String>(lang.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedReportsCompanion(')
          ..write('reportId: $reportId, ')
          ..write('type: $type, ')
          ..write('lang: $lang, ')
          ..write('version: $version, ')
          ..write('json: $json, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeckHistoryTable extends DeckHistory
    with TableInfo<$DeckHistoryTable, DeckHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeckHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _quoteIdMeta = const VerificationMeta(
    'quoteId',
  );
  @override
  late final GeneratedColumn<String> quoteId = GeneratedColumn<String>(
    'quote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, quoteId, action, at];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deck_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeckHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('quote_id')) {
      context.handle(
        _quoteIdMeta,
        quoteId.isAcceptableOrUnknown(data['quote_id']!, _quoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_quoteIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeckHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeckHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      quoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_id'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
    );
  }

  @override
  $DeckHistoryTable createAlias(String alias) {
    return $DeckHistoryTable(attachedDatabase, alias);
  }
}

class DeckHistoryData extends DataClass implements Insertable<DeckHistoryData> {
  final int id;
  final String quoteId;
  final String action;
  final DateTime at;
  const DeckHistoryData({
    required this.id,
    required this.quoteId,
    required this.action,
    required this.at,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['quote_id'] = Variable<String>(quoteId);
    map['action'] = Variable<String>(action);
    map['at'] = Variable<DateTime>(at);
    return map;
  }

  DeckHistoryCompanion toCompanion(bool nullToAbsent) {
    return DeckHistoryCompanion(
      id: Value(id),
      quoteId: Value(quoteId),
      action: Value(action),
      at: Value(at),
    );
  }

  factory DeckHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeckHistoryData(
      id: serializer.fromJson<int>(json['id']),
      quoteId: serializer.fromJson<String>(json['quoteId']),
      action: serializer.fromJson<String>(json['action']),
      at: serializer.fromJson<DateTime>(json['at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'quoteId': serializer.toJson<String>(quoteId),
      'action': serializer.toJson<String>(action),
      'at': serializer.toJson<DateTime>(at),
    };
  }

  DeckHistoryData copyWith({
    int? id,
    String? quoteId,
    String? action,
    DateTime? at,
  }) => DeckHistoryData(
    id: id ?? this.id,
    quoteId: quoteId ?? this.quoteId,
    action: action ?? this.action,
    at: at ?? this.at,
  );
  DeckHistoryData copyWithCompanion(DeckHistoryCompanion data) {
    return DeckHistoryData(
      id: data.id.present ? data.id.value : this.id,
      quoteId: data.quoteId.present ? data.quoteId.value : this.quoteId,
      action: data.action.present ? data.action.value : this.action,
      at: data.at.present ? data.at.value : this.at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeckHistoryData(')
          ..write('id: $id, ')
          ..write('quoteId: $quoteId, ')
          ..write('action: $action, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, quoteId, action, at);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeckHistoryData &&
          other.id == this.id &&
          other.quoteId == this.quoteId &&
          other.action == this.action &&
          other.at == this.at);
}

class DeckHistoryCompanion extends UpdateCompanion<DeckHistoryData> {
  final Value<int> id;
  final Value<String> quoteId;
  final Value<String> action;
  final Value<DateTime> at;
  const DeckHistoryCompanion({
    this.id = const Value.absent(),
    this.quoteId = const Value.absent(),
    this.action = const Value.absent(),
    this.at = const Value.absent(),
  });
  DeckHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String quoteId,
    required String action,
    required DateTime at,
  }) : quoteId = Value(quoteId),
       action = Value(action),
       at = Value(at);
  static Insertable<DeckHistoryData> custom({
    Expression<int>? id,
    Expression<String>? quoteId,
    Expression<String>? action,
    Expression<DateTime>? at,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (quoteId != null) 'quote_id': quoteId,
      if (action != null) 'action': action,
      if (at != null) 'at': at,
    });
  }

  DeckHistoryCompanion copyWith({
    Value<int>? id,
    Value<String>? quoteId,
    Value<String>? action,
    Value<DateTime>? at,
  }) {
    return DeckHistoryCompanion(
      id: id ?? this.id,
      quoteId: quoteId ?? this.quoteId,
      action: action ?? this.action,
      at: at ?? this.at,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (quoteId.present) {
      map['quote_id'] = Variable<String>(quoteId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeckHistoryCompanion(')
          ..write('id: $id, ')
          ..write('quoteId: $quoteId, ')
          ..write('action: $action, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }
}

class $JournalCacheTable extends JournalCache
    with TableInfo<$JournalCacheTable, JournalCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _quoteIdMeta = const VerificationMeta(
    'quoteId',
  );
  @override
  late final GeneratedColumn<String> quoteId = GeneratedColumn<String>(
    'quote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savedAtMeta = const VerificationMeta(
    'savedAt',
  );
  @override
  late final GeneratedColumn<DateTime> savedAt = GeneratedColumn<DateTime>(
    'saved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [quoteId, savedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('quote_id')) {
      context.handle(
        _quoteIdMeta,
        quoteId.isAcceptableOrUnknown(data['quote_id']!, _quoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_quoteIdMeta);
    }
    if (data.containsKey('saved_at')) {
      context.handle(
        _savedAtMeta,
        savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_savedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {quoteId};
  @override
  JournalCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalCacheData(
      quoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_id'],
      )!,
      savedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}saved_at'],
      )!,
    );
  }

  @override
  $JournalCacheTable createAlias(String alias) {
    return $JournalCacheTable(attachedDatabase, alias);
  }
}

class JournalCacheData extends DataClass
    implements Insertable<JournalCacheData> {
  final String quoteId;
  final DateTime savedAt;
  const JournalCacheData({required this.quoteId, required this.savedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['quote_id'] = Variable<String>(quoteId);
    map['saved_at'] = Variable<DateTime>(savedAt);
    return map;
  }

  JournalCacheCompanion toCompanion(bool nullToAbsent) {
    return JournalCacheCompanion(
      quoteId: Value(quoteId),
      savedAt: Value(savedAt),
    );
  }

  factory JournalCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalCacheData(
      quoteId: serializer.fromJson<String>(json['quoteId']),
      savedAt: serializer.fromJson<DateTime>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'quoteId': serializer.toJson<String>(quoteId),
      'savedAt': serializer.toJson<DateTime>(savedAt),
    };
  }

  JournalCacheData copyWith({String? quoteId, DateTime? savedAt}) =>
      JournalCacheData(
        quoteId: quoteId ?? this.quoteId,
        savedAt: savedAt ?? this.savedAt,
      );
  JournalCacheData copyWithCompanion(JournalCacheCompanion data) {
    return JournalCacheData(
      quoteId: data.quoteId.present ? data.quoteId.value : this.quoteId,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalCacheData(')
          ..write('quoteId: $quoteId, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(quoteId, savedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalCacheData &&
          other.quoteId == this.quoteId &&
          other.savedAt == this.savedAt);
}

class JournalCacheCompanion extends UpdateCompanion<JournalCacheData> {
  final Value<String> quoteId;
  final Value<DateTime> savedAt;
  final Value<int> rowid;
  const JournalCacheCompanion({
    this.quoteId = const Value.absent(),
    this.savedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JournalCacheCompanion.insert({
    required String quoteId,
    required DateTime savedAt,
    this.rowid = const Value.absent(),
  }) : quoteId = Value(quoteId),
       savedAt = Value(savedAt);
  static Insertable<JournalCacheData> custom({
    Expression<String>? quoteId,
    Expression<DateTime>? savedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (quoteId != null) 'quote_id': quoteId,
      if (savedAt != null) 'saved_at': savedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JournalCacheCompanion copyWith({
    Value<String>? quoteId,
    Value<DateTime>? savedAt,
    Value<int>? rowid,
  }) {
    return JournalCacheCompanion(
      quoteId: quoteId ?? this.quoteId,
      savedAt: savedAt ?? this.savedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (quoteId.present) {
      map['quote_id'] = Variable<String>(quoteId.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<DateTime>(savedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalCacheCompanion(')
          ..write('quoteId: $quoteId, ')
          ..write('savedAt: $savedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RetroCalendarTable extends RetroCalendar
    with TableInfo<$RetroCalendarTable, RetroCalendarData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RetroCalendarTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _planetMeta = const VerificationMeta('planet');
  @override
  late final GeneratedColumn<String> planet = GeneratedColumn<String>(
    'planet',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [planet, year, json];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'retro_calendar';
  @override
  VerificationContext validateIntegrity(
    Insertable<RetroCalendarData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('planet')) {
      context.handle(
        _planetMeta,
        planet.isAcceptableOrUnknown(data['planet']!, _planetMeta),
      );
    } else if (isInserting) {
      context.missing(_planetMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {planet, year};
  @override
  RetroCalendarData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RetroCalendarData(
      planet: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}planet'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
    );
  }

  @override
  $RetroCalendarTable createAlias(String alias) {
    return $RetroCalendarTable(attachedDatabase, alias);
  }
}

class RetroCalendarData extends DataClass
    implements Insertable<RetroCalendarData> {
  final String planet;
  final int year;
  final String json;
  const RetroCalendarData({
    required this.planet,
    required this.year,
    required this.json,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['planet'] = Variable<String>(planet);
    map['year'] = Variable<int>(year);
    map['json'] = Variable<String>(json);
    return map;
  }

  RetroCalendarCompanion toCompanion(bool nullToAbsent) {
    return RetroCalendarCompanion(
      planet: Value(planet),
      year: Value(year),
      json: Value(json),
    );
  }

  factory RetroCalendarData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RetroCalendarData(
      planet: serializer.fromJson<String>(json['planet']),
      year: serializer.fromJson<int>(json['year']),
      json: serializer.fromJson<String>(json['json']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'planet': serializer.toJson<String>(planet),
      'year': serializer.toJson<int>(year),
      'json': serializer.toJson<String>(json),
    };
  }

  RetroCalendarData copyWith({String? planet, int? year, String? json}) =>
      RetroCalendarData(
        planet: planet ?? this.planet,
        year: year ?? this.year,
        json: json ?? this.json,
      );
  RetroCalendarData copyWithCompanion(RetroCalendarCompanion data) {
    return RetroCalendarData(
      planet: data.planet.present ? data.planet.value : this.planet,
      year: data.year.present ? data.year.value : this.year,
      json: data.json.present ? data.json.value : this.json,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RetroCalendarData(')
          ..write('planet: $planet, ')
          ..write('year: $year, ')
          ..write('json: $json')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(planet, year, json);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RetroCalendarData &&
          other.planet == this.planet &&
          other.year == this.year &&
          other.json == this.json);
}

class RetroCalendarCompanion extends UpdateCompanion<RetroCalendarData> {
  final Value<String> planet;
  final Value<int> year;
  final Value<String> json;
  final Value<int> rowid;
  const RetroCalendarCompanion({
    this.planet = const Value.absent(),
    this.year = const Value.absent(),
    this.json = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RetroCalendarCompanion.insert({
    required String planet,
    required int year,
    required String json,
    this.rowid = const Value.absent(),
  }) : planet = Value(planet),
       year = Value(year),
       json = Value(json);
  static Insertable<RetroCalendarData> custom({
    Expression<String>? planet,
    Expression<int>? year,
    Expression<String>? json,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (planet != null) 'planet': planet,
      if (year != null) 'year': year,
      if (json != null) 'json': json,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RetroCalendarCompanion copyWith({
    Value<String>? planet,
    Value<int>? year,
    Value<String>? json,
    Value<int>? rowid,
  }) {
    return RetroCalendarCompanion(
      planet: planet ?? this.planet,
      year: year ?? this.year,
      json: json ?? this.json,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (planet.present) {
      map['planet'] = Variable<String>(planet.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RetroCalendarCompanion(')
          ..write('planet: $planet, ')
          ..write('year: $year, ')
          ..write('json: $json, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PreferenceVectorTable extends PreferenceVector
    with TableInfo<$PreferenceVectorTable, PreferenceVectorData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferenceVectorTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vectorMeta = const VerificationMeta('vector');
  @override
  late final GeneratedColumn<Uint8List> vector = GeneratedColumn<Uint8List>(
    'vector',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, vector, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preference_vector';
  @override
  VerificationContext validateIntegrity(
    Insertable<PreferenceVectorData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vector')) {
      context.handle(
        _vectorMeta,
        vector.isAcceptableOrUnknown(data['vector']!, _vectorMeta),
      );
    } else if (isInserting) {
      context.missing(_vectorMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PreferenceVectorData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferenceVectorData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vector: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}vector'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PreferenceVectorTable createAlias(String alias) {
    return $PreferenceVectorTable(attachedDatabase, alias);
  }
}

class PreferenceVectorData extends DataClass
    implements Insertable<PreferenceVectorData> {
  final int id;
  final Uint8List vector;
  final DateTime updatedAt;
  const PreferenceVectorData({
    required this.id,
    required this.vector,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vector'] = Variable<Uint8List>(vector);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PreferenceVectorCompanion toCompanion(bool nullToAbsent) {
    return PreferenceVectorCompanion(
      id: Value(id),
      vector: Value(vector),
      updatedAt: Value(updatedAt),
    );
  }

  factory PreferenceVectorData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferenceVectorData(
      id: serializer.fromJson<int>(json['id']),
      vector: serializer.fromJson<Uint8List>(json['vector']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vector': serializer.toJson<Uint8List>(vector),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PreferenceVectorData copyWith({
    int? id,
    Uint8List? vector,
    DateTime? updatedAt,
  }) => PreferenceVectorData(
    id: id ?? this.id,
    vector: vector ?? this.vector,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PreferenceVectorData copyWithCompanion(PreferenceVectorCompanion data) {
    return PreferenceVectorData(
      id: data.id.present ? data.id.value : this.id,
      vector: data.vector.present ? data.vector.value : this.vector,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceVectorData(')
          ..write('id: $id, ')
          ..write('vector: $vector, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, $driftBlobEquality.hash(vector), updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferenceVectorData &&
          other.id == this.id &&
          $driftBlobEquality.equals(other.vector, this.vector) &&
          other.updatedAt == this.updatedAt);
}

class PreferenceVectorCompanion extends UpdateCompanion<PreferenceVectorData> {
  final Value<int> id;
  final Value<Uint8List> vector;
  final Value<DateTime> updatedAt;
  const PreferenceVectorCompanion({
    this.id = const Value.absent(),
    this.vector = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PreferenceVectorCompanion.insert({
    this.id = const Value.absent(),
    required Uint8List vector,
    required DateTime updatedAt,
  }) : vector = Value(vector),
       updatedAt = Value(updatedAt);
  static Insertable<PreferenceVectorData> custom({
    Expression<int>? id,
    Expression<Uint8List>? vector,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vector != null) 'vector': vector,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PreferenceVectorCompanion copyWith({
    Value<int>? id,
    Value<Uint8List>? vector,
    Value<DateTime>? updatedAt,
  }) {
    return PreferenceVectorCompanion(
      id: id ?? this.id,
      vector: vector ?? this.vector,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vector.present) {
      map['vector'] = Variable<Uint8List>(vector.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceVectorCompanion(')
          ..write('id: $id, ')
          ..write('vector: $vector, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ProfileCacheTable extends ProfileCache
    with TableInfo<$ProfileCacheTable, ProfileCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfileCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, json, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profile_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfileCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileCacheData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProfileCacheTable createAlias(String alias) {
    return $ProfileCacheTable(attachedDatabase, alias);
  }
}

class ProfileCacheData extends DataClass
    implements Insertable<ProfileCacheData> {
  final int id;
  final String json;
  final DateTime updatedAt;
  const ProfileCacheData({
    required this.id,
    required this.json,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['json'] = Variable<String>(json);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProfileCacheCompanion toCompanion(bool nullToAbsent) {
    return ProfileCacheCompanion(
      id: Value(id),
      json: Value(json),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProfileCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileCacheData(
      id: serializer.fromJson<int>(json['id']),
      json: serializer.fromJson<String>(json['json']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'json': serializer.toJson<String>(json),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProfileCacheData copyWith({int? id, String? json, DateTime? updatedAt}) =>
      ProfileCacheData(
        id: id ?? this.id,
        json: json ?? this.json,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ProfileCacheData copyWithCompanion(ProfileCacheCompanion data) {
    return ProfileCacheData(
      id: data.id.present ? data.id.value : this.id,
      json: data.json.present ? data.json.value : this.json,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileCacheData(')
          ..write('id: $id, ')
          ..write('json: $json, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, json, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileCacheData &&
          other.id == this.id &&
          other.json == this.json &&
          other.updatedAt == this.updatedAt);
}

class ProfileCacheCompanion extends UpdateCompanion<ProfileCacheData> {
  final Value<int> id;
  final Value<String> json;
  final Value<DateTime> updatedAt;
  const ProfileCacheCompanion({
    this.id = const Value.absent(),
    this.json = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProfileCacheCompanion.insert({
    this.id = const Value.absent(),
    required String json,
    required DateTime updatedAt,
  }) : json = Value(json),
       updatedAt = Value(updatedAt);
  static Insertable<ProfileCacheData> custom({
    Expression<int>? id,
    Expression<String>? json,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (json != null) 'json': json,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProfileCacheCompanion copyWith({
    Value<int>? id,
    Value<String>? json,
    Value<DateTime>? updatedAt,
  }) {
    return ProfileCacheCompanion(
      id: id ?? this.id,
      json: json ?? this.json,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfileCacheCompanion(')
          ..write('id: $id, ')
          ..write('json: $json, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PartnerCacheTable extends PartnerCache
    with TableInfo<$PartnerCacheTable, PartnerCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartnerCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, json, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'partner_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<PartnerCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PartnerCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartnerCacheData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PartnerCacheTable createAlias(String alias) {
    return $PartnerCacheTable(attachedDatabase, alias);
  }
}

class PartnerCacheData extends DataClass
    implements Insertable<PartnerCacheData> {
  final String id;
  final String json;
  final DateTime createdAt;
  const PartnerCacheData({
    required this.id,
    required this.json,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['json'] = Variable<String>(json);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PartnerCacheCompanion toCompanion(bool nullToAbsent) {
    return PartnerCacheCompanion(
      id: Value(id),
      json: Value(json),
      createdAt: Value(createdAt),
    );
  }

  factory PartnerCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartnerCacheData(
      id: serializer.fromJson<String>(json['id']),
      json: serializer.fromJson<String>(json['json']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'json': serializer.toJson<String>(json),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PartnerCacheData copyWith({String? id, String? json, DateTime? createdAt}) =>
      PartnerCacheData(
        id: id ?? this.id,
        json: json ?? this.json,
        createdAt: createdAt ?? this.createdAt,
      );
  PartnerCacheData copyWithCompanion(PartnerCacheCompanion data) {
    return PartnerCacheData(
      id: data.id.present ? data.id.value : this.id,
      json: data.json.present ? data.json.value : this.json,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartnerCacheData(')
          ..write('id: $id, ')
          ..write('json: $json, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, json, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartnerCacheData &&
          other.id == this.id &&
          other.json == this.json &&
          other.createdAt == this.createdAt);
}

class PartnerCacheCompanion extends UpdateCompanion<PartnerCacheData> {
  final Value<String> id;
  final Value<String> json;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PartnerCacheCompanion({
    this.id = const Value.absent(),
    this.json = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PartnerCacheCompanion.insert({
    required String id,
    required String json,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       json = Value(json),
       createdAt = Value(createdAt);
  static Insertable<PartnerCacheData> custom({
    Expression<String>? id,
    Expression<String>? json,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (json != null) 'json': json,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PartnerCacheCompanion copyWith({
    Value<String>? id,
    Value<String>? json,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PartnerCacheCompanion(
      id: id ?? this.id,
      json: json ?? this.json,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartnerCacheCompanion(')
          ..write('id: $id, ')
          ..write('json: $json, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MoodEntriesTable extends MoodEntries
    with TableInfo<$MoodEntriesTable, MoodEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<String> mood = GeneratedColumn<String>(
    'mood',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [date, mood, synced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mood_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoodEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    } else if (isInserting) {
      context.missing(_moodMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  MoodEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoodEntry(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mood'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $MoodEntriesTable createAlias(String alias) {
    return $MoodEntriesTable(attachedDatabase, alias);
  }
}

class MoodEntry extends DataClass implements Insertable<MoodEntry> {
  final String date;
  final String mood;
  final bool synced;
  const MoodEntry({
    required this.date,
    required this.mood,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['mood'] = Variable<String>(mood);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  MoodEntriesCompanion toCompanion(bool nullToAbsent) {
    return MoodEntriesCompanion(
      date: Value(date),
      mood: Value(mood),
      synced: Value(synced),
    );
  }

  factory MoodEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoodEntry(
      date: serializer.fromJson<String>(json['date']),
      mood: serializer.fromJson<String>(json['mood']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'mood': serializer.toJson<String>(mood),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  MoodEntry copyWith({String? date, String? mood, bool? synced}) => MoodEntry(
    date: date ?? this.date,
    mood: mood ?? this.mood,
    synced: synced ?? this.synced,
  );
  MoodEntry copyWithCompanion(MoodEntriesCompanion data) {
    return MoodEntry(
      date: data.date.present ? data.date.value : this.date,
      mood: data.mood.present ? data.mood.value : this.mood,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoodEntry(')
          ..write('date: $date, ')
          ..write('mood: $mood, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, mood, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoodEntry &&
          other.date == this.date &&
          other.mood == this.mood &&
          other.synced == this.synced);
}

class MoodEntriesCompanion extends UpdateCompanion<MoodEntry> {
  final Value<String> date;
  final Value<String> mood;
  final Value<bool> synced;
  final Value<int> rowid;
  const MoodEntriesCompanion({
    this.date = const Value.absent(),
    this.mood = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MoodEntriesCompanion.insert({
    required String date,
    required String mood,
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       mood = Value(mood);
  static Insertable<MoodEntry> custom({
    Expression<String>? date,
    Expression<String>? mood,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (mood != null) 'mood': mood,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MoodEntriesCompanion copyWith({
    Value<String>? date,
    Value<String>? mood,
    Value<bool>? synced,
    Value<int>? rowid,
  }) {
    return MoodEntriesCompanion(
      date: date ?? this.date,
      mood: mood ?? this.mood,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (mood.present) {
      map['mood'] = Variable<String>(mood.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodEntriesCompanion(')
          ..write('date: $date, ')
          ..write('mood: $mood, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GratitudeEntriesTable extends GratitudeEntries
    with TableInfo<$GratitudeEntriesTable, GratitudeEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GratitudeEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, body, createdAt, synced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gratitude_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<GratitudeEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GratitudeEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GratitudeEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $GratitudeEntriesTable createAlias(String alias) {
    return $GratitudeEntriesTable(attachedDatabase, alias);
  }
}

class GratitudeEntry extends DataClass implements Insertable<GratitudeEntry> {
  final String id;
  final String date;
  final String body;
  final DateTime createdAt;
  final bool synced;
  const GratitudeEntry({
    required this.id,
    required this.date,
    required this.body,
    required this.createdAt,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<String>(date);
    map['body'] = Variable<String>(body);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  GratitudeEntriesCompanion toCompanion(bool nullToAbsent) {
    return GratitudeEntriesCompanion(
      id: Value(id),
      date: Value(date),
      body: Value(body),
      createdAt: Value(createdAt),
      synced: Value(synced),
    );
  }

  factory GratitudeEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GratitudeEntry(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      body: serializer.fromJson<String>(json['body']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<String>(date),
      'body': serializer.toJson<String>(body),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  GratitudeEntry copyWith({
    String? id,
    String? date,
    String? body,
    DateTime? createdAt,
    bool? synced,
  }) => GratitudeEntry(
    id: id ?? this.id,
    date: date ?? this.date,
    body: body ?? this.body,
    createdAt: createdAt ?? this.createdAt,
    synced: synced ?? this.synced,
  );
  GratitudeEntry copyWithCompanion(GratitudeEntriesCompanion data) {
    return GratitudeEntry(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      body: data.body.present ? data.body.value : this.body,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GratitudeEntry(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, body, createdAt, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GratitudeEntry &&
          other.id == this.id &&
          other.date == this.date &&
          other.body == this.body &&
          other.createdAt == this.createdAt &&
          other.synced == this.synced);
}

class GratitudeEntriesCompanion extends UpdateCompanion<GratitudeEntry> {
  final Value<String> id;
  final Value<String> date;
  final Value<String> body;
  final Value<DateTime> createdAt;
  final Value<bool> synced;
  final Value<int> rowid;
  const GratitudeEntriesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GratitudeEntriesCompanion.insert({
    required String id,
    required String date,
    required String body,
    required DateTime createdAt,
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       body = Value(body),
       createdAt = Value(createdAt);
  static Insertable<GratitudeEntry> custom({
    Expression<String>? id,
    Expression<String>? date,
    Expression<String>? body,
    Expression<DateTime>? createdAt,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (body != null) 'body': body,
      if (createdAt != null) 'created_at': createdAt,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GratitudeEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? date,
    Value<String>? body,
    Value<DateTime>? createdAt,
    Value<bool>? synced,
    Value<int>? rowid,
  }) {
    return GratitudeEntriesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GratitudeEntriesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FutureLetterEntriesTable extends FutureLetterEntries
    with TableInfo<$FutureLetterEntriesTable, FutureLetterEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FutureLetterEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _writtenAtMeta = const VerificationMeta(
    'writtenAt',
  );
  @override
  late final GeneratedColumn<DateTime> writtenAt = GeneratedColumn<DateTime>(
    'written_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unlockAtMeta = const VerificationMeta(
    'unlockAt',
  );
  @override
  late final GeneratedColumn<DateTime> unlockAt = GeneratedColumn<DateTime>(
    'unlock_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unlockDaysMeta = const VerificationMeta(
    'unlockDays',
  );
  @override
  late final GeneratedColumn<int> unlockDays = GeneratedColumn<int>(
    'unlock_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    body,
    writtenAt,
    unlockAt,
    unlockDays,
    synced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'future_letter_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<FutureLetterEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('written_at')) {
      context.handle(
        _writtenAtMeta,
        writtenAt.isAcceptableOrUnknown(data['written_at']!, _writtenAtMeta),
      );
    } else if (isInserting) {
      context.missing(_writtenAtMeta);
    }
    if (data.containsKey('unlock_at')) {
      context.handle(
        _unlockAtMeta,
        unlockAt.isAcceptableOrUnknown(data['unlock_at']!, _unlockAtMeta),
      );
    } else if (isInserting) {
      context.missing(_unlockAtMeta);
    }
    if (data.containsKey('unlock_days')) {
      context.handle(
        _unlockDaysMeta,
        unlockDays.isAcceptableOrUnknown(data['unlock_days']!, _unlockDaysMeta),
      );
    } else if (isInserting) {
      context.missing(_unlockDaysMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FutureLetterEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FutureLetterEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      writtenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}written_at'],
      )!,
      unlockAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}unlock_at'],
      )!,
      unlockDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unlock_days'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $FutureLetterEntriesTable createAlias(String alias) {
    return $FutureLetterEntriesTable(attachedDatabase, alias);
  }
}

class FutureLetterEntry extends DataClass
    implements Insertable<FutureLetterEntry> {
  final String id;
  final String body;
  final DateTime writtenAt;
  final DateTime unlockAt;
  final int unlockDays;
  final bool synced;
  const FutureLetterEntry({
    required this.id,
    required this.body,
    required this.writtenAt,
    required this.unlockAt,
    required this.unlockDays,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['body'] = Variable<String>(body);
    map['written_at'] = Variable<DateTime>(writtenAt);
    map['unlock_at'] = Variable<DateTime>(unlockAt);
    map['unlock_days'] = Variable<int>(unlockDays);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  FutureLetterEntriesCompanion toCompanion(bool nullToAbsent) {
    return FutureLetterEntriesCompanion(
      id: Value(id),
      body: Value(body),
      writtenAt: Value(writtenAt),
      unlockAt: Value(unlockAt),
      unlockDays: Value(unlockDays),
      synced: Value(synced),
    );
  }

  factory FutureLetterEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FutureLetterEntry(
      id: serializer.fromJson<String>(json['id']),
      body: serializer.fromJson<String>(json['body']),
      writtenAt: serializer.fromJson<DateTime>(json['writtenAt']),
      unlockAt: serializer.fromJson<DateTime>(json['unlockAt']),
      unlockDays: serializer.fromJson<int>(json['unlockDays']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'body': serializer.toJson<String>(body),
      'writtenAt': serializer.toJson<DateTime>(writtenAt),
      'unlockAt': serializer.toJson<DateTime>(unlockAt),
      'unlockDays': serializer.toJson<int>(unlockDays),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  FutureLetterEntry copyWith({
    String? id,
    String? body,
    DateTime? writtenAt,
    DateTime? unlockAt,
    int? unlockDays,
    bool? synced,
  }) => FutureLetterEntry(
    id: id ?? this.id,
    body: body ?? this.body,
    writtenAt: writtenAt ?? this.writtenAt,
    unlockAt: unlockAt ?? this.unlockAt,
    unlockDays: unlockDays ?? this.unlockDays,
    synced: synced ?? this.synced,
  );
  FutureLetterEntry copyWithCompanion(FutureLetterEntriesCompanion data) {
    return FutureLetterEntry(
      id: data.id.present ? data.id.value : this.id,
      body: data.body.present ? data.body.value : this.body,
      writtenAt: data.writtenAt.present ? data.writtenAt.value : this.writtenAt,
      unlockAt: data.unlockAt.present ? data.unlockAt.value : this.unlockAt,
      unlockDays: data.unlockDays.present
          ? data.unlockDays.value
          : this.unlockDays,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FutureLetterEntry(')
          ..write('id: $id, ')
          ..write('body: $body, ')
          ..write('writtenAt: $writtenAt, ')
          ..write('unlockAt: $unlockAt, ')
          ..write('unlockDays: $unlockDays, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, body, writtenAt, unlockAt, unlockDays, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FutureLetterEntry &&
          other.id == this.id &&
          other.body == this.body &&
          other.writtenAt == this.writtenAt &&
          other.unlockAt == this.unlockAt &&
          other.unlockDays == this.unlockDays &&
          other.synced == this.synced);
}

class FutureLetterEntriesCompanion extends UpdateCompanion<FutureLetterEntry> {
  final Value<String> id;
  final Value<String> body;
  final Value<DateTime> writtenAt;
  final Value<DateTime> unlockAt;
  final Value<int> unlockDays;
  final Value<bool> synced;
  final Value<int> rowid;
  const FutureLetterEntriesCompanion({
    this.id = const Value.absent(),
    this.body = const Value.absent(),
    this.writtenAt = const Value.absent(),
    this.unlockAt = const Value.absent(),
    this.unlockDays = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FutureLetterEntriesCompanion.insert({
    required String id,
    required String body,
    required DateTime writtenAt,
    required DateTime unlockAt,
    required int unlockDays,
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       body = Value(body),
       writtenAt = Value(writtenAt),
       unlockAt = Value(unlockAt),
       unlockDays = Value(unlockDays);
  static Insertable<FutureLetterEntry> custom({
    Expression<String>? id,
    Expression<String>? body,
    Expression<DateTime>? writtenAt,
    Expression<DateTime>? unlockAt,
    Expression<int>? unlockDays,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (body != null) 'body': body,
      if (writtenAt != null) 'written_at': writtenAt,
      if (unlockAt != null) 'unlock_at': unlockAt,
      if (unlockDays != null) 'unlock_days': unlockDays,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FutureLetterEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? body,
    Value<DateTime>? writtenAt,
    Value<DateTime>? unlockAt,
    Value<int>? unlockDays,
    Value<bool>? synced,
    Value<int>? rowid,
  }) {
    return FutureLetterEntriesCompanion(
      id: id ?? this.id,
      body: body ?? this.body,
      writtenAt: writtenAt ?? this.writtenAt,
      unlockAt: unlockAt ?? this.unlockAt,
      unlockDays: unlockDays ?? this.unlockDays,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (writtenAt.present) {
      map['written_at'] = Variable<DateTime>(writtenAt.value);
    }
    if (unlockAt.present) {
      map['unlock_at'] = Variable<DateTime>(unlockAt.value);
    }
    if (unlockDays.present) {
      map['unlock_days'] = Variable<int>(unlockDays.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FutureLetterEntriesCompanion(')
          ..write('id: $id, ')
          ..write('body: $body, ')
          ..write('writtenAt: $writtenAt, ')
          ..write('unlockAt: $unlockAt, ')
          ..write('unlockDays: $unlockDays, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomCardsTable extends CustomCards
    with TableInfo<$CustomCardsTable, CustomCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _illustrationIdMeta = const VerificationMeta(
    'illustrationId',
  );
  @override
  late final GeneratedColumn<String> illustrationId = GeneratedColumn<String>(
    'illustration_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    body,
    illustrationId,
    createdAt,
    synced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomCard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('illustration_id')) {
      context.handle(
        _illustrationIdMeta,
        illustrationId.isAcceptableOrUnknown(
          data['illustration_id']!,
          _illustrationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_illustrationIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomCard(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      illustrationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}illustration_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $CustomCardsTable createAlias(String alias) {
    return $CustomCardsTable(attachedDatabase, alias);
  }
}

class CustomCard extends DataClass implements Insertable<CustomCard> {
  final String id;
  final String body;
  final String illustrationId;
  final DateTime createdAt;
  final bool synced;
  const CustomCard({
    required this.id,
    required this.body,
    required this.illustrationId,
    required this.createdAt,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['body'] = Variable<String>(body);
    map['illustration_id'] = Variable<String>(illustrationId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  CustomCardsCompanion toCompanion(bool nullToAbsent) {
    return CustomCardsCompanion(
      id: Value(id),
      body: Value(body),
      illustrationId: Value(illustrationId),
      createdAt: Value(createdAt),
      synced: Value(synced),
    );
  }

  factory CustomCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomCard(
      id: serializer.fromJson<String>(json['id']),
      body: serializer.fromJson<String>(json['body']),
      illustrationId: serializer.fromJson<String>(json['illustrationId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'body': serializer.toJson<String>(body),
      'illustrationId': serializer.toJson<String>(illustrationId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  CustomCard copyWith({
    String? id,
    String? body,
    String? illustrationId,
    DateTime? createdAt,
    bool? synced,
  }) => CustomCard(
    id: id ?? this.id,
    body: body ?? this.body,
    illustrationId: illustrationId ?? this.illustrationId,
    createdAt: createdAt ?? this.createdAt,
    synced: synced ?? this.synced,
  );
  CustomCard copyWithCompanion(CustomCardsCompanion data) {
    return CustomCard(
      id: data.id.present ? data.id.value : this.id,
      body: data.body.present ? data.body.value : this.body,
      illustrationId: data.illustrationId.present
          ? data.illustrationId.value
          : this.illustrationId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomCard(')
          ..write('id: $id, ')
          ..write('body: $body, ')
          ..write('illustrationId: $illustrationId, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, body, illustrationId, createdAt, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomCard &&
          other.id == this.id &&
          other.body == this.body &&
          other.illustrationId == this.illustrationId &&
          other.createdAt == this.createdAt &&
          other.synced == this.synced);
}

class CustomCardsCompanion extends UpdateCompanion<CustomCard> {
  final Value<String> id;
  final Value<String> body;
  final Value<String> illustrationId;
  final Value<DateTime> createdAt;
  final Value<bool> synced;
  final Value<int> rowid;
  const CustomCardsCompanion({
    this.id = const Value.absent(),
    this.body = const Value.absent(),
    this.illustrationId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomCardsCompanion.insert({
    required String id,
    required String body,
    required String illustrationId,
    required DateTime createdAt,
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       body = Value(body),
       illustrationId = Value(illustrationId),
       createdAt = Value(createdAt);
  static Insertable<CustomCard> custom({
    Expression<String>? id,
    Expression<String>? body,
    Expression<String>? illustrationId,
    Expression<DateTime>? createdAt,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (body != null) 'body': body,
      if (illustrationId != null) 'illustration_id': illustrationId,
      if (createdAt != null) 'created_at': createdAt,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomCardsCompanion copyWith({
    Value<String>? id,
    Value<String>? body,
    Value<String>? illustrationId,
    Value<DateTime>? createdAt,
    Value<bool>? synced,
    Value<int>? rowid,
  }) {
    return CustomCardsCompanion(
      id: id ?? this.id,
      body: body ?? this.body,
      illustrationId: illustrationId ?? this.illustrationId,
      createdAt: createdAt ?? this.createdAt,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (illustrationId.present) {
      map['illustration_id'] = Variable<String>(illustrationId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomCardsCompanion(')
          ..write('id: $id, ')
          ..write('body: $body, ')
          ..write('illustrationId: $illustrationId, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RitualDaysTable extends RitualDays
    with TableInfo<$RitualDaysTable, RitualDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RitualDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [date, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ritual_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<RitualDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  RitualDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RitualDay(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
    );
  }

  @override
  $RitualDaysTable createAlias(String alias) {
    return $RitualDaysTable(attachedDatabase, alias);
  }
}

class RitualDay extends DataClass implements Insertable<RitualDay> {
  final String date;
  final DateTime completedAt;
  const RitualDay({required this.date, required this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  RitualDaysCompanion toCompanion(bool nullToAbsent) {
    return RitualDaysCompanion(
      date: Value(date),
      completedAt: Value(completedAt),
    );
  }

  factory RitualDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RitualDay(
      date: serializer.fromJson<String>(json['date']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  RitualDay copyWith({String? date, DateTime? completedAt}) => RitualDay(
    date: date ?? this.date,
    completedAt: completedAt ?? this.completedAt,
  );
  RitualDay copyWithCompanion(RitualDaysCompanion data) {
    return RitualDay(
      date: data.date.present ? data.date.value : this.date,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RitualDay(')
          ..write('date: $date, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RitualDay &&
          other.date == this.date &&
          other.completedAt == this.completedAt);
}

class RitualDaysCompanion extends UpdateCompanion<RitualDay> {
  final Value<String> date;
  final Value<DateTime> completedAt;
  final Value<int> rowid;
  const RitualDaysCompanion({
    this.date = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RitualDaysCompanion.insert({
    required String date,
    required DateTime completedAt,
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       completedAt = Value(completedAt);
  static Insertable<RitualDay> custom({
    Expression<String>? date,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RitualDaysCompanion copyWith({
    Value<String>? date,
    Value<DateTime>? completedAt,
    Value<int>? rowid,
  }) {
    return RitualDaysCompanion(
      date: date ?? this.date,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RitualDaysCompanion(')
          ..write('date: $date, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RitualProgressTable extends RitualProgress
    with TableInfo<$RitualProgressTable, RitualProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RitualProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepMeta = const VerificationMeta('step');
  @override
  late final GeneratedColumn<int> step = GeneratedColumn<int>(
    'step',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quoteIdsMeta = const VerificationMeta(
    'quoteIds',
  );
  @override
  late final GeneratedColumn<String> quoteIds = GeneratedColumn<String>(
    'quote_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [date, step, quoteIds];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ritual_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<RitualProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('step')) {
      context.handle(
        _stepMeta,
        step.isAcceptableOrUnknown(data['step']!, _stepMeta),
      );
    } else if (isInserting) {
      context.missing(_stepMeta);
    }
    if (data.containsKey('quote_ids')) {
      context.handle(
        _quoteIdsMeta,
        quoteIds.isAcceptableOrUnknown(data['quote_ids']!, _quoteIdsMeta),
      );
    } else if (isInserting) {
      context.missing(_quoteIdsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  RitualProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RitualProgressData(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      step: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}step'],
      )!,
      quoteIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_ids'],
      )!,
    );
  }

  @override
  $RitualProgressTable createAlias(String alias) {
    return $RitualProgressTable(attachedDatabase, alias);
  }
}

class RitualProgressData extends DataClass
    implements Insertable<RitualProgressData> {
  final String date;
  final int step;
  final String quoteIds;
  const RitualProgressData({
    required this.date,
    required this.step,
    required this.quoteIds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['step'] = Variable<int>(step);
    map['quote_ids'] = Variable<String>(quoteIds);
    return map;
  }

  RitualProgressCompanion toCompanion(bool nullToAbsent) {
    return RitualProgressCompanion(
      date: Value(date),
      step: Value(step),
      quoteIds: Value(quoteIds),
    );
  }

  factory RitualProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RitualProgressData(
      date: serializer.fromJson<String>(json['date']),
      step: serializer.fromJson<int>(json['step']),
      quoteIds: serializer.fromJson<String>(json['quoteIds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'step': serializer.toJson<int>(step),
      'quoteIds': serializer.toJson<String>(quoteIds),
    };
  }

  RitualProgressData copyWith({String? date, int? step, String? quoteIds}) =>
      RitualProgressData(
        date: date ?? this.date,
        step: step ?? this.step,
        quoteIds: quoteIds ?? this.quoteIds,
      );
  RitualProgressData copyWithCompanion(RitualProgressCompanion data) {
    return RitualProgressData(
      date: data.date.present ? data.date.value : this.date,
      step: data.step.present ? data.step.value : this.step,
      quoteIds: data.quoteIds.present ? data.quoteIds.value : this.quoteIds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RitualProgressData(')
          ..write('date: $date, ')
          ..write('step: $step, ')
          ..write('quoteIds: $quoteIds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, step, quoteIds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RitualProgressData &&
          other.date == this.date &&
          other.step == this.step &&
          other.quoteIds == this.quoteIds);
}

class RitualProgressCompanion extends UpdateCompanion<RitualProgressData> {
  final Value<String> date;
  final Value<int> step;
  final Value<String> quoteIds;
  final Value<int> rowid;
  const RitualProgressCompanion({
    this.date = const Value.absent(),
    this.step = const Value.absent(),
    this.quoteIds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RitualProgressCompanion.insert({
    required String date,
    required int step,
    required String quoteIds,
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       step = Value(step),
       quoteIds = Value(quoteIds);
  static Insertable<RitualProgressData> custom({
    Expression<String>? date,
    Expression<int>? step,
    Expression<String>? quoteIds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (step != null) 'step': step,
      if (quoteIds != null) 'quote_ids': quoteIds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RitualProgressCompanion copyWith({
    Value<String>? date,
    Value<int>? step,
    Value<String>? quoteIds,
    Value<int>? rowid,
  }) {
    return RitualProgressCompanion(
      date: date ?? this.date,
      step: step ?? this.step,
      quoteIds: quoteIds ?? this.quoteIds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (step.present) {
      map['step'] = Variable<int>(step.value);
    }
    if (quoteIds.present) {
      map['quote_ids'] = Variable<String>(quoteIds.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RitualProgressCompanion(')
          ..write('date: $date, ')
          ..write('step: $step, ')
          ..write('quoteIds: $quoteIds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestStatesTable extends QuestStates
    with TableInfo<$QuestStatesTable, QuestState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questIdMeta = const VerificationMeta(
    'questId',
  );
  @override
  late final GeneratedColumn<String> questId = GeneratedColumn<String>(
    'quest_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _swappedMeta = const VerificationMeta(
    'swapped',
  );
  @override
  late final GeneratedColumn<bool> swapped = GeneratedColumn<bool>(
    'swapped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("swapped" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [date, questId, done, swapped, synced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quest_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuestState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('quest_id')) {
      context.handle(
        _questIdMeta,
        questId.isAcceptableOrUnknown(data['quest_id']!, _questIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questIdMeta);
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    if (data.containsKey('swapped')) {
      context.handle(
        _swappedMeta,
        swapped.isAcceptableOrUnknown(data['swapped']!, _swappedMeta),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  QuestState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestState(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      questId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quest_id'],
      )!,
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
      swapped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}swapped'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $QuestStatesTable createAlias(String alias) {
    return $QuestStatesTable(attachedDatabase, alias);
  }
}

class QuestState extends DataClass implements Insertable<QuestState> {
  final String date;
  final String questId;
  final bool done;
  final bool swapped;
  final bool synced;
  const QuestState({
    required this.date,
    required this.questId,
    required this.done,
    required this.swapped,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['quest_id'] = Variable<String>(questId);
    map['done'] = Variable<bool>(done);
    map['swapped'] = Variable<bool>(swapped);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  QuestStatesCompanion toCompanion(bool nullToAbsent) {
    return QuestStatesCompanion(
      date: Value(date),
      questId: Value(questId),
      done: Value(done),
      swapped: Value(swapped),
      synced: Value(synced),
    );
  }

  factory QuestState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestState(
      date: serializer.fromJson<String>(json['date']),
      questId: serializer.fromJson<String>(json['questId']),
      done: serializer.fromJson<bool>(json['done']),
      swapped: serializer.fromJson<bool>(json['swapped']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'questId': serializer.toJson<String>(questId),
      'done': serializer.toJson<bool>(done),
      'swapped': serializer.toJson<bool>(swapped),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  QuestState copyWith({
    String? date,
    String? questId,
    bool? done,
    bool? swapped,
    bool? synced,
  }) => QuestState(
    date: date ?? this.date,
    questId: questId ?? this.questId,
    done: done ?? this.done,
    swapped: swapped ?? this.swapped,
    synced: synced ?? this.synced,
  );
  QuestState copyWithCompanion(QuestStatesCompanion data) {
    return QuestState(
      date: data.date.present ? data.date.value : this.date,
      questId: data.questId.present ? data.questId.value : this.questId,
      done: data.done.present ? data.done.value : this.done,
      swapped: data.swapped.present ? data.swapped.value : this.swapped,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestState(')
          ..write('date: $date, ')
          ..write('questId: $questId, ')
          ..write('done: $done, ')
          ..write('swapped: $swapped, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, questId, done, swapped, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestState &&
          other.date == this.date &&
          other.questId == this.questId &&
          other.done == this.done &&
          other.swapped == this.swapped &&
          other.synced == this.synced);
}

class QuestStatesCompanion extends UpdateCompanion<QuestState> {
  final Value<String> date;
  final Value<String> questId;
  final Value<bool> done;
  final Value<bool> swapped;
  final Value<bool> synced;
  final Value<int> rowid;
  const QuestStatesCompanion({
    this.date = const Value.absent(),
    this.questId = const Value.absent(),
    this.done = const Value.absent(),
    this.swapped = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestStatesCompanion.insert({
    required String date,
    required String questId,
    this.done = const Value.absent(),
    this.swapped = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       questId = Value(questId);
  static Insertable<QuestState> custom({
    Expression<String>? date,
    Expression<String>? questId,
    Expression<bool>? done,
    Expression<bool>? swapped,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (questId != null) 'quest_id': questId,
      if (done != null) 'done': done,
      if (swapped != null) 'swapped': swapped,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestStatesCompanion copyWith({
    Value<String>? date,
    Value<String>? questId,
    Value<bool>? done,
    Value<bool>? swapped,
    Value<bool>? synced,
    Value<int>? rowid,
  }) {
    return QuestStatesCompanion(
      date: date ?? this.date,
      questId: questId ?? this.questId,
      done: done ?? this.done,
      swapped: swapped ?? this.swapped,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (questId.present) {
      map['quest_id'] = Variable<String>(questId.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (swapped.present) {
      map['swapped'] = Variable<bool>(swapped.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestStatesCompanion(')
          ..write('date: $date, ')
          ..write('questId: $questId, ')
          ..write('done: $done, ')
          ..write('swapped: $swapped, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JourneyProgressEntriesTable extends JourneyProgressEntries
    with TableInfo<$JourneyProgressEntriesTable, JourneyProgressEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JourneyProgressEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _journeyIdMeta = const VerificationMeta(
    'journeyId',
  );
  @override
  late final GeneratedColumn<String> journeyId = GeneratedColumn<String>(
    'journey_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentDayMeta = const VerificationMeta(
    'currentDay',
  );
  @override
  late final GeneratedColumn<int> currentDay = GeneratedColumn<int>(
    'current_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _completedDaysMeta = const VerificationMeta(
    'completedDays',
  );
  @override
  late final GeneratedColumn<String> completedDays = GeneratedColumn<String>(
    'completed_days',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _reflectionsMeta = const VerificationMeta(
    'reflections',
  );
  @override
  late final GeneratedColumn<String> reflections = GeneratedColumn<String>(
    'reflections',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastDoneOnMeta = const VerificationMeta(
    'lastDoneOn',
  );
  @override
  late final GeneratedColumn<String> lastDoneOn = GeneratedColumn<String>(
    'last_done_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    journeyId,
    startedAt,
    currentDay,
    completedDays,
    reflections,
    completedAt,
    lastDoneOn,
    synced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journey_progress_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<JourneyProgressEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('journey_id')) {
      context.handle(
        _journeyIdMeta,
        journeyId.isAcceptableOrUnknown(data['journey_id']!, _journeyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_journeyIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('current_day')) {
      context.handle(
        _currentDayMeta,
        currentDay.isAcceptableOrUnknown(data['current_day']!, _currentDayMeta),
      );
    }
    if (data.containsKey('completed_days')) {
      context.handle(
        _completedDaysMeta,
        completedDays.isAcceptableOrUnknown(
          data['completed_days']!,
          _completedDaysMeta,
        ),
      );
    }
    if (data.containsKey('reflections')) {
      context.handle(
        _reflectionsMeta,
        reflections.isAcceptableOrUnknown(
          data['reflections']!,
          _reflectionsMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('last_done_on')) {
      context.handle(
        _lastDoneOnMeta,
        lastDoneOn.isAcceptableOrUnknown(
          data['last_done_on']!,
          _lastDoneOnMeta,
        ),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {journeyId};
  @override
  JourneyProgressEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JourneyProgressEntry(
      journeyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}journey_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      currentDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_day'],
      )!,
      completedDays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_days'],
      )!,
      reflections: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reflections'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      lastDoneOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_done_on'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $JourneyProgressEntriesTable createAlias(String alias) {
    return $JourneyProgressEntriesTable(attachedDatabase, alias);
  }
}

class JourneyProgressEntry extends DataClass
    implements Insertable<JourneyProgressEntry> {
  final String journeyId;
  final DateTime startedAt;
  final int currentDay;
  final String completedDays;
  final String reflections;
  final DateTime? completedAt;
  final String? lastDoneOn;
  final bool synced;
  const JourneyProgressEntry({
    required this.journeyId,
    required this.startedAt,
    required this.currentDay,
    required this.completedDays,
    required this.reflections,
    this.completedAt,
    this.lastDoneOn,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['journey_id'] = Variable<String>(journeyId);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['current_day'] = Variable<int>(currentDay);
    map['completed_days'] = Variable<String>(completedDays);
    map['reflections'] = Variable<String>(reflections);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || lastDoneOn != null) {
      map['last_done_on'] = Variable<String>(lastDoneOn);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  JourneyProgressEntriesCompanion toCompanion(bool nullToAbsent) {
    return JourneyProgressEntriesCompanion(
      journeyId: Value(journeyId),
      startedAt: Value(startedAt),
      currentDay: Value(currentDay),
      completedDays: Value(completedDays),
      reflections: Value(reflections),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      lastDoneOn: lastDoneOn == null && nullToAbsent
          ? const Value.absent()
          : Value(lastDoneOn),
      synced: Value(synced),
    );
  }

  factory JourneyProgressEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JourneyProgressEntry(
      journeyId: serializer.fromJson<String>(json['journeyId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      currentDay: serializer.fromJson<int>(json['currentDay']),
      completedDays: serializer.fromJson<String>(json['completedDays']),
      reflections: serializer.fromJson<String>(json['reflections']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      lastDoneOn: serializer.fromJson<String?>(json['lastDoneOn']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'journeyId': serializer.toJson<String>(journeyId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'currentDay': serializer.toJson<int>(currentDay),
      'completedDays': serializer.toJson<String>(completedDays),
      'reflections': serializer.toJson<String>(reflections),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'lastDoneOn': serializer.toJson<String?>(lastDoneOn),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  JourneyProgressEntry copyWith({
    String? journeyId,
    DateTime? startedAt,
    int? currentDay,
    String? completedDays,
    String? reflections,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<String?> lastDoneOn = const Value.absent(),
    bool? synced,
  }) => JourneyProgressEntry(
    journeyId: journeyId ?? this.journeyId,
    startedAt: startedAt ?? this.startedAt,
    currentDay: currentDay ?? this.currentDay,
    completedDays: completedDays ?? this.completedDays,
    reflections: reflections ?? this.reflections,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    lastDoneOn: lastDoneOn.present ? lastDoneOn.value : this.lastDoneOn,
    synced: synced ?? this.synced,
  );
  JourneyProgressEntry copyWithCompanion(JourneyProgressEntriesCompanion data) {
    return JourneyProgressEntry(
      journeyId: data.journeyId.present ? data.journeyId.value : this.journeyId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      currentDay: data.currentDay.present
          ? data.currentDay.value
          : this.currentDay,
      completedDays: data.completedDays.present
          ? data.completedDays.value
          : this.completedDays,
      reflections: data.reflections.present
          ? data.reflections.value
          : this.reflections,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      lastDoneOn: data.lastDoneOn.present
          ? data.lastDoneOn.value
          : this.lastDoneOn,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JourneyProgressEntry(')
          ..write('journeyId: $journeyId, ')
          ..write('startedAt: $startedAt, ')
          ..write('currentDay: $currentDay, ')
          ..write('completedDays: $completedDays, ')
          ..write('reflections: $reflections, ')
          ..write('completedAt: $completedAt, ')
          ..write('lastDoneOn: $lastDoneOn, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    journeyId,
    startedAt,
    currentDay,
    completedDays,
    reflections,
    completedAt,
    lastDoneOn,
    synced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JourneyProgressEntry &&
          other.journeyId == this.journeyId &&
          other.startedAt == this.startedAt &&
          other.currentDay == this.currentDay &&
          other.completedDays == this.completedDays &&
          other.reflections == this.reflections &&
          other.completedAt == this.completedAt &&
          other.lastDoneOn == this.lastDoneOn &&
          other.synced == this.synced);
}

class JourneyProgressEntriesCompanion
    extends UpdateCompanion<JourneyProgressEntry> {
  final Value<String> journeyId;
  final Value<DateTime> startedAt;
  final Value<int> currentDay;
  final Value<String> completedDays;
  final Value<String> reflections;
  final Value<DateTime?> completedAt;
  final Value<String?> lastDoneOn;
  final Value<bool> synced;
  final Value<int> rowid;
  const JourneyProgressEntriesCompanion({
    this.journeyId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.currentDay = const Value.absent(),
    this.completedDays = const Value.absent(),
    this.reflections = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.lastDoneOn = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JourneyProgressEntriesCompanion.insert({
    required String journeyId,
    required DateTime startedAt,
    this.currentDay = const Value.absent(),
    this.completedDays = const Value.absent(),
    this.reflections = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.lastDoneOn = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : journeyId = Value(journeyId),
       startedAt = Value(startedAt);
  static Insertable<JourneyProgressEntry> custom({
    Expression<String>? journeyId,
    Expression<DateTime>? startedAt,
    Expression<int>? currentDay,
    Expression<String>? completedDays,
    Expression<String>? reflections,
    Expression<DateTime>? completedAt,
    Expression<String>? lastDoneOn,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (journeyId != null) 'journey_id': journeyId,
      if (startedAt != null) 'started_at': startedAt,
      if (currentDay != null) 'current_day': currentDay,
      if (completedDays != null) 'completed_days': completedDays,
      if (reflections != null) 'reflections': reflections,
      if (completedAt != null) 'completed_at': completedAt,
      if (lastDoneOn != null) 'last_done_on': lastDoneOn,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JourneyProgressEntriesCompanion copyWith({
    Value<String>? journeyId,
    Value<DateTime>? startedAt,
    Value<int>? currentDay,
    Value<String>? completedDays,
    Value<String>? reflections,
    Value<DateTime?>? completedAt,
    Value<String?>? lastDoneOn,
    Value<bool>? synced,
    Value<int>? rowid,
  }) {
    return JourneyProgressEntriesCompanion(
      journeyId: journeyId ?? this.journeyId,
      startedAt: startedAt ?? this.startedAt,
      currentDay: currentDay ?? this.currentDay,
      completedDays: completedDays ?? this.completedDays,
      reflections: reflections ?? this.reflections,
      completedAt: completedAt ?? this.completedAt,
      lastDoneOn: lastDoneOn ?? this.lastDoneOn,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (journeyId.present) {
      map['journey_id'] = Variable<String>(journeyId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (currentDay.present) {
      map['current_day'] = Variable<int>(currentDay.value);
    }
    if (completedDays.present) {
      map['completed_days'] = Variable<String>(completedDays.value);
    }
    if (reflections.present) {
      map['reflections'] = Variable<String>(reflections.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (lastDoneOn.present) {
      map['last_done_on'] = Variable<String>(lastDoneOn.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JourneyProgressEntriesCompanion(')
          ..write('journeyId: $journeyId, ')
          ..write('startedAt: $startedAt, ')
          ..write('currentDay: $currentDay, ')
          ..write('completedDays: $completedDays, ')
          ..write('reflections: $reflections, ')
          ..write('completedAt: $completedAt, ')
          ..write('lastDoneOn: $lastDoneOn, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MascotInventoryTable extends MascotInventory
    with TableInfo<$MascotInventoryTable, MascotInventoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MascotInventoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _earnedAtMeta = const VerificationMeta(
    'earnedAt',
  );
  @override
  late final GeneratedColumn<DateTime> earnedAt = GeneratedColumn<DateTime>(
    'earned_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _equippedSlotMeta = const VerificationMeta(
    'equippedSlot',
  );
  @override
  late final GeneratedColumn<String> equippedSlot = GeneratedColumn<String>(
    'equipped_slot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [itemId, earnedAt, equippedSlot];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mascot_inventory';
  @override
  VerificationContext validateIntegrity(
    Insertable<MascotInventoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('earned_at')) {
      context.handle(
        _earnedAtMeta,
        earnedAt.isAcceptableOrUnknown(data['earned_at']!, _earnedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_earnedAtMeta);
    }
    if (data.containsKey('equipped_slot')) {
      context.handle(
        _equippedSlotMeta,
        equippedSlot.isAcceptableOrUnknown(
          data['equipped_slot']!,
          _equippedSlotMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId};
  @override
  MascotInventoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MascotInventoryData(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      earnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}earned_at'],
      )!,
      equippedSlot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipped_slot'],
      ),
    );
  }

  @override
  $MascotInventoryTable createAlias(String alias) {
    return $MascotInventoryTable(attachedDatabase, alias);
  }
}

class MascotInventoryData extends DataClass
    implements Insertable<MascotInventoryData> {
  final String itemId;
  final DateTime earnedAt;
  final String? equippedSlot;
  const MascotInventoryData({
    required this.itemId,
    required this.earnedAt,
    this.equippedSlot,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['earned_at'] = Variable<DateTime>(earnedAt);
    if (!nullToAbsent || equippedSlot != null) {
      map['equipped_slot'] = Variable<String>(equippedSlot);
    }
    return map;
  }

  MascotInventoryCompanion toCompanion(bool nullToAbsent) {
    return MascotInventoryCompanion(
      itemId: Value(itemId),
      earnedAt: Value(earnedAt),
      equippedSlot: equippedSlot == null && nullToAbsent
          ? const Value.absent()
          : Value(equippedSlot),
    );
  }

  factory MascotInventoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MascotInventoryData(
      itemId: serializer.fromJson<String>(json['itemId']),
      earnedAt: serializer.fromJson<DateTime>(json['earnedAt']),
      equippedSlot: serializer.fromJson<String?>(json['equippedSlot']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'earnedAt': serializer.toJson<DateTime>(earnedAt),
      'equippedSlot': serializer.toJson<String?>(equippedSlot),
    };
  }

  MascotInventoryData copyWith({
    String? itemId,
    DateTime? earnedAt,
    Value<String?> equippedSlot = const Value.absent(),
  }) => MascotInventoryData(
    itemId: itemId ?? this.itemId,
    earnedAt: earnedAt ?? this.earnedAt,
    equippedSlot: equippedSlot.present ? equippedSlot.value : this.equippedSlot,
  );
  MascotInventoryData copyWithCompanion(MascotInventoryCompanion data) {
    return MascotInventoryData(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      earnedAt: data.earnedAt.present ? data.earnedAt.value : this.earnedAt,
      equippedSlot: data.equippedSlot.present
          ? data.equippedSlot.value
          : this.equippedSlot,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MascotInventoryData(')
          ..write('itemId: $itemId, ')
          ..write('earnedAt: $earnedAt, ')
          ..write('equippedSlot: $equippedSlot')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemId, earnedAt, equippedSlot);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MascotInventoryData &&
          other.itemId == this.itemId &&
          other.earnedAt == this.earnedAt &&
          other.equippedSlot == this.equippedSlot);
}

class MascotInventoryCompanion extends UpdateCompanion<MascotInventoryData> {
  final Value<String> itemId;
  final Value<DateTime> earnedAt;
  final Value<String?> equippedSlot;
  final Value<int> rowid;
  const MascotInventoryCompanion({
    this.itemId = const Value.absent(),
    this.earnedAt = const Value.absent(),
    this.equippedSlot = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MascotInventoryCompanion.insert({
    required String itemId,
    required DateTime earnedAt,
    this.equippedSlot = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       earnedAt = Value(earnedAt);
  static Insertable<MascotInventoryData> custom({
    Expression<String>? itemId,
    Expression<DateTime>? earnedAt,
    Expression<String>? equippedSlot,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (earnedAt != null) 'earned_at': earnedAt,
      if (equippedSlot != null) 'equipped_slot': equippedSlot,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MascotInventoryCompanion copyWith({
    Value<String>? itemId,
    Value<DateTime>? earnedAt,
    Value<String?>? equippedSlot,
    Value<int>? rowid,
  }) {
    return MascotInventoryCompanion(
      itemId: itemId ?? this.itemId,
      earnedAt: earnedAt ?? this.earnedAt,
      equippedSlot: equippedSlot ?? this.equippedSlot,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (earnedAt.present) {
      map['earned_at'] = Variable<DateTime>(earnedAt.value);
    }
    if (equippedSlot.present) {
      map['equipped_slot'] = Variable<String>(equippedSlot.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MascotInventoryCompanion(')
          ..write('itemId: $itemId, ')
          ..write('earnedAt: $earnedAt, ')
          ..write('equippedSlot: $equippedSlot, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedReadingsTable cachedReadings = $CachedReadingsTable(this);
  late final $CachedReportsTable cachedReports = $CachedReportsTable(this);
  late final $DeckHistoryTable deckHistory = $DeckHistoryTable(this);
  late final $JournalCacheTable journalCache = $JournalCacheTable(this);
  late final $RetroCalendarTable retroCalendar = $RetroCalendarTable(this);
  late final $PreferenceVectorTable preferenceVector = $PreferenceVectorTable(
    this,
  );
  late final $ProfileCacheTable profileCache = $ProfileCacheTable(this);
  late final $PartnerCacheTable partnerCache = $PartnerCacheTable(this);
  late final $MoodEntriesTable moodEntries = $MoodEntriesTable(this);
  late final $GratitudeEntriesTable gratitudeEntries = $GratitudeEntriesTable(
    this,
  );
  late final $FutureLetterEntriesTable futureLetterEntries =
      $FutureLetterEntriesTable(this);
  late final $CustomCardsTable customCards = $CustomCardsTable(this);
  late final $RitualDaysTable ritualDays = $RitualDaysTable(this);
  late final $RitualProgressTable ritualProgress = $RitualProgressTable(this);
  late final $QuestStatesTable questStates = $QuestStatesTable(this);
  late final $JourneyProgressEntriesTable journeyProgressEntries =
      $JourneyProgressEntriesTable(this);
  late final $MascotInventoryTable mascotInventory = $MascotInventoryTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cachedReadings,
    cachedReports,
    deckHistory,
    journalCache,
    retroCalendar,
    preferenceVector,
    profileCache,
    partnerCache,
    moodEntries,
    gratitudeEntries,
    futureLetterEntries,
    customCards,
    ritualDays,
    ritualProgress,
    questStates,
    journeyProgressEntries,
    mascotInventory,
  ];
}

typedef $$CachedReadingsTableCreateCompanionBuilder =
    CachedReadingsCompanion Function({
      required String date,
      required String sign,
      required String lang,
      required int version,
      required String json,
      required DateTime fetchedAt,
      Value<int> rowid,
    });
typedef $$CachedReadingsTableUpdateCompanionBuilder =
    CachedReadingsCompanion Function({
      Value<String> date,
      Value<String> sign,
      Value<String> lang,
      Value<int> version,
      Value<String> json,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$CachedReadingsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedReadingsTable> {
  $$CachedReadingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sign => $composableBuilder(
    column: $table.sign,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lang => $composableBuilder(
    column: $table.lang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedReadingsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedReadingsTable> {
  $$CachedReadingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sign => $composableBuilder(
    column: $table.sign,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lang => $composableBuilder(
    column: $table.lang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedReadingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedReadingsTable> {
  $$CachedReadingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get sign =>
      $composableBuilder(column: $table.sign, builder: (column) => column);

  GeneratedColumn<String> get lang =>
      $composableBuilder(column: $table.lang, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$CachedReadingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedReadingsTable,
          CachedReading,
          $$CachedReadingsTableFilterComposer,
          $$CachedReadingsTableOrderingComposer,
          $$CachedReadingsTableAnnotationComposer,
          $$CachedReadingsTableCreateCompanionBuilder,
          $$CachedReadingsTableUpdateCompanionBuilder,
          (
            CachedReading,
            BaseReferences<_$AppDatabase, $CachedReadingsTable, CachedReading>,
          ),
          CachedReading,
          PrefetchHooks Function()
        > {
  $$CachedReadingsTableTableManager(
    _$AppDatabase db,
    $CachedReadingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedReadingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedReadingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedReadingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<String> sign = const Value.absent(),
                Value<String> lang = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedReadingsCompanion(
                date: date,
                sign: sign,
                lang: lang,
                version: version,
                json: json,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required String sign,
                required String lang,
                required int version,
                required String json,
                required DateTime fetchedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedReadingsCompanion.insert(
                date: date,
                sign: sign,
                lang: lang,
                version: version,
                json: json,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedReadingsTable, CachedReading>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedReadingsTable,
                    CachedReading
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedReadingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedReadingsTable,
      CachedReading,
      $$CachedReadingsTableFilterComposer,
      $$CachedReadingsTableOrderingComposer,
      $$CachedReadingsTableAnnotationComposer,
      $$CachedReadingsTableCreateCompanionBuilder,
      $$CachedReadingsTableUpdateCompanionBuilder,
      (
        CachedReading,
        BaseReferences<_$AppDatabase, $CachedReadingsTable, CachedReading>,
      ),
      CachedReading,
      PrefetchHooks Function()
    >;
typedef $$CachedReportsTableCreateCompanionBuilder =
    CachedReportsCompanion Function({
      required String reportId,
      required String type,
      required String lang,
      required int version,
      required String json,
      required DateTime fetchedAt,
      Value<int> rowid,
    });
typedef $$CachedReportsTableUpdateCompanionBuilder =
    CachedReportsCompanion Function({
      Value<String> reportId,
      Value<String> type,
      Value<String> lang,
      Value<int> version,
      Value<String> json,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$CachedReportsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedReportsTable> {
  $$CachedReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get reportId => $composableBuilder(
    column: $table.reportId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lang => $composableBuilder(
    column: $table.lang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedReportsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedReportsTable> {
  $$CachedReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get reportId => $composableBuilder(
    column: $table.reportId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lang => $composableBuilder(
    column: $table.lang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedReportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedReportsTable> {
  $$CachedReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get reportId =>
      $composableBuilder(column: $table.reportId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get lang =>
      $composableBuilder(column: $table.lang, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$CachedReportsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedReportsTable,
          CachedReport,
          $$CachedReportsTableFilterComposer,
          $$CachedReportsTableOrderingComposer,
          $$CachedReportsTableAnnotationComposer,
          $$CachedReportsTableCreateCompanionBuilder,
          $$CachedReportsTableUpdateCompanionBuilder,
          (
            CachedReport,
            BaseReferences<_$AppDatabase, $CachedReportsTable, CachedReport>,
          ),
          CachedReport,
          PrefetchHooks Function()
        > {
  $$CachedReportsTableTableManager(_$AppDatabase db, $CachedReportsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> reportId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> lang = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedReportsCompanion(
                reportId: reportId,
                type: type,
                lang: lang,
                version: version,
                json: json,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String reportId,
                required String type,
                required String lang,
                required int version,
                required String json,
                required DateTime fetchedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedReportsCompanion.insert(
                reportId: reportId,
                type: type,
                lang: lang,
                version: version,
                json: json,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedReportsTable, CachedReport>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedReportsTable,
                    CachedReport
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedReportsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedReportsTable,
      CachedReport,
      $$CachedReportsTableFilterComposer,
      $$CachedReportsTableOrderingComposer,
      $$CachedReportsTableAnnotationComposer,
      $$CachedReportsTableCreateCompanionBuilder,
      $$CachedReportsTableUpdateCompanionBuilder,
      (
        CachedReport,
        BaseReferences<_$AppDatabase, $CachedReportsTable, CachedReport>,
      ),
      CachedReport,
      PrefetchHooks Function()
    >;
typedef $$DeckHistoryTableCreateCompanionBuilder =
    DeckHistoryCompanion Function({
      Value<int> id,
      required String quoteId,
      required String action,
      required DateTime at,
    });
typedef $$DeckHistoryTableUpdateCompanionBuilder =
    DeckHistoryCompanion Function({
      Value<int> id,
      Value<String> quoteId,
      Value<String> action,
      Value<DateTime> at,
    });

class $$DeckHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $DeckHistoryTable> {
  $$DeckHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quoteId => $composableBuilder(
    column: $table.quoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeckHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $DeckHistoryTable> {
  $$DeckHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quoteId => $composableBuilder(
    column: $table.quoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeckHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeckHistoryTable> {
  $$DeckHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get quoteId =>
      $composableBuilder(column: $table.quoteId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);
}

class $$DeckHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeckHistoryTable,
          DeckHistoryData,
          $$DeckHistoryTableFilterComposer,
          $$DeckHistoryTableOrderingComposer,
          $$DeckHistoryTableAnnotationComposer,
          $$DeckHistoryTableCreateCompanionBuilder,
          $$DeckHistoryTableUpdateCompanionBuilder,
          (
            DeckHistoryData,
            BaseReferences<_$AppDatabase, $DeckHistoryTable, DeckHistoryData>,
          ),
          DeckHistoryData,
          PrefetchHooks Function()
        > {
  $$DeckHistoryTableTableManager(_$AppDatabase db, $DeckHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeckHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeckHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeckHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> quoteId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
              }) => DeckHistoryCompanion(
                id: id,
                quoteId: quoteId,
                action: action,
                at: at,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String quoteId,
                required String action,
                required DateTime at,
              }) => DeckHistoryCompanion.insert(
                id: id,
                quoteId: quoteId,
                action: action,
                at: at,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DeckHistoryTable, DeckHistoryData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DeckHistoryTable,
                    DeckHistoryData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeckHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeckHistoryTable,
      DeckHistoryData,
      $$DeckHistoryTableFilterComposer,
      $$DeckHistoryTableOrderingComposer,
      $$DeckHistoryTableAnnotationComposer,
      $$DeckHistoryTableCreateCompanionBuilder,
      $$DeckHistoryTableUpdateCompanionBuilder,
      (
        DeckHistoryData,
        BaseReferences<_$AppDatabase, $DeckHistoryTable, DeckHistoryData>,
      ),
      DeckHistoryData,
      PrefetchHooks Function()
    >;
typedef $$JournalCacheTableCreateCompanionBuilder =
    JournalCacheCompanion Function({
      required String quoteId,
      required DateTime savedAt,
      Value<int> rowid,
    });
typedef $$JournalCacheTableUpdateCompanionBuilder =
    JournalCacheCompanion Function({
      Value<String> quoteId,
      Value<DateTime> savedAt,
      Value<int> rowid,
    });

class $$JournalCacheTableFilterComposer
    extends Composer<_$AppDatabase, $JournalCacheTable> {
  $$JournalCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get quoteId => $composableBuilder(
    column: $table.quoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$JournalCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalCacheTable> {
  $$JournalCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get quoteId => $composableBuilder(
    column: $table.quoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JournalCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalCacheTable> {
  $$JournalCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get quoteId =>
      $composableBuilder(column: $table.quoteId, builder: (column) => column);

  GeneratedColumn<DateTime> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);
}

class $$JournalCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JournalCacheTable,
          JournalCacheData,
          $$JournalCacheTableFilterComposer,
          $$JournalCacheTableOrderingComposer,
          $$JournalCacheTableAnnotationComposer,
          $$JournalCacheTableCreateCompanionBuilder,
          $$JournalCacheTableUpdateCompanionBuilder,
          (
            JournalCacheData,
            BaseReferences<_$AppDatabase, $JournalCacheTable, JournalCacheData>,
          ),
          JournalCacheData,
          PrefetchHooks Function()
        > {
  $$JournalCacheTableTableManager(_$AppDatabase db, $JournalCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> quoteId = const Value.absent(),
                Value<DateTime> savedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JournalCacheCompanion(
                quoteId: quoteId,
                savedAt: savedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String quoteId,
                required DateTime savedAt,
                Value<int> rowid = const Value.absent(),
              }) => JournalCacheCompanion.insert(
                quoteId: quoteId,
                savedAt: savedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$JournalCacheTable, JournalCacheData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $JournalCacheTable,
                    JournalCacheData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$JournalCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JournalCacheTable,
      JournalCacheData,
      $$JournalCacheTableFilterComposer,
      $$JournalCacheTableOrderingComposer,
      $$JournalCacheTableAnnotationComposer,
      $$JournalCacheTableCreateCompanionBuilder,
      $$JournalCacheTableUpdateCompanionBuilder,
      (
        JournalCacheData,
        BaseReferences<_$AppDatabase, $JournalCacheTable, JournalCacheData>,
      ),
      JournalCacheData,
      PrefetchHooks Function()
    >;
typedef $$RetroCalendarTableCreateCompanionBuilder =
    RetroCalendarCompanion Function({
      required String planet,
      required int year,
      required String json,
      Value<int> rowid,
    });
typedef $$RetroCalendarTableUpdateCompanionBuilder =
    RetroCalendarCompanion Function({
      Value<String> planet,
      Value<int> year,
      Value<String> json,
      Value<int> rowid,
    });

class $$RetroCalendarTableFilterComposer
    extends Composer<_$AppDatabase, $RetroCalendarTable> {
  $$RetroCalendarTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get planet => $composableBuilder(
    column: $table.planet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RetroCalendarTableOrderingComposer
    extends Composer<_$AppDatabase, $RetroCalendarTable> {
  $$RetroCalendarTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get planet => $composableBuilder(
    column: $table.planet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RetroCalendarTableAnnotationComposer
    extends Composer<_$AppDatabase, $RetroCalendarTable> {
  $$RetroCalendarTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get planet =>
      $composableBuilder(column: $table.planet, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);
}

class $$RetroCalendarTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RetroCalendarTable,
          RetroCalendarData,
          $$RetroCalendarTableFilterComposer,
          $$RetroCalendarTableOrderingComposer,
          $$RetroCalendarTableAnnotationComposer,
          $$RetroCalendarTableCreateCompanionBuilder,
          $$RetroCalendarTableUpdateCompanionBuilder,
          (
            RetroCalendarData,
            BaseReferences<
              _$AppDatabase,
              $RetroCalendarTable,
              RetroCalendarData
            >,
          ),
          RetroCalendarData,
          PrefetchHooks Function()
        > {
  $$RetroCalendarTableTableManager(_$AppDatabase db, $RetroCalendarTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RetroCalendarTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RetroCalendarTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RetroCalendarTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> planet = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RetroCalendarCompanion(
                planet: planet,
                year: year,
                json: json,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String planet,
                required int year,
                required String json,
                Value<int> rowid = const Value.absent(),
              }) => RetroCalendarCompanion.insert(
                planet: planet,
                year: year,
                json: json,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RetroCalendarTable, RetroCalendarData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $RetroCalendarTable,
                    RetroCalendarData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RetroCalendarTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RetroCalendarTable,
      RetroCalendarData,
      $$RetroCalendarTableFilterComposer,
      $$RetroCalendarTableOrderingComposer,
      $$RetroCalendarTableAnnotationComposer,
      $$RetroCalendarTableCreateCompanionBuilder,
      $$RetroCalendarTableUpdateCompanionBuilder,
      (
        RetroCalendarData,
        BaseReferences<_$AppDatabase, $RetroCalendarTable, RetroCalendarData>,
      ),
      RetroCalendarData,
      PrefetchHooks Function()
    >;
typedef $$PreferenceVectorTableCreateCompanionBuilder =
    PreferenceVectorCompanion Function({
      Value<int> id,
      required Uint8List vector,
      required DateTime updatedAt,
    });
typedef $$PreferenceVectorTableUpdateCompanionBuilder =
    PreferenceVectorCompanion Function({
      Value<int> id,
      Value<Uint8List> vector,
      Value<DateTime> updatedAt,
    });

class $$PreferenceVectorTableFilterComposer
    extends Composer<_$AppDatabase, $PreferenceVectorTable> {
  $$PreferenceVectorTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get vector => $composableBuilder(
    column: $table.vector,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PreferenceVectorTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferenceVectorTable> {
  $$PreferenceVectorTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get vector => $composableBuilder(
    column: $table.vector,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PreferenceVectorTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferenceVectorTable> {
  $$PreferenceVectorTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<Uint8List> get vector =>
      $composableBuilder(column: $table.vector, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PreferenceVectorTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreferenceVectorTable,
          PreferenceVectorData,
          $$PreferenceVectorTableFilterComposer,
          $$PreferenceVectorTableOrderingComposer,
          $$PreferenceVectorTableAnnotationComposer,
          $$PreferenceVectorTableCreateCompanionBuilder,
          $$PreferenceVectorTableUpdateCompanionBuilder,
          (
            PreferenceVectorData,
            BaseReferences<
              _$AppDatabase,
              $PreferenceVectorTable,
              PreferenceVectorData
            >,
          ),
          PreferenceVectorData,
          PrefetchHooks Function()
        > {
  $$PreferenceVectorTableTableManager(
    _$AppDatabase db,
    $PreferenceVectorTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferenceVectorTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferenceVectorTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferenceVectorTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<Uint8List> vector = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PreferenceVectorCompanion(
                id: id,
                vector: vector,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required Uint8List vector,
                required DateTime updatedAt,
              }) => PreferenceVectorCompanion.insert(
                id: id,
                vector: vector,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PreferenceVectorTable, PreferenceVectorData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $PreferenceVectorTable,
                    PreferenceVectorData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PreferenceVectorTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreferenceVectorTable,
      PreferenceVectorData,
      $$PreferenceVectorTableFilterComposer,
      $$PreferenceVectorTableOrderingComposer,
      $$PreferenceVectorTableAnnotationComposer,
      $$PreferenceVectorTableCreateCompanionBuilder,
      $$PreferenceVectorTableUpdateCompanionBuilder,
      (
        PreferenceVectorData,
        BaseReferences<
          _$AppDatabase,
          $PreferenceVectorTable,
          PreferenceVectorData
        >,
      ),
      PreferenceVectorData,
      PrefetchHooks Function()
    >;
typedef $$ProfileCacheTableCreateCompanionBuilder =
    ProfileCacheCompanion Function({
      Value<int> id,
      required String json,
      required DateTime updatedAt,
    });
typedef $$ProfileCacheTableUpdateCompanionBuilder =
    ProfileCacheCompanion Function({
      Value<int> id,
      Value<String> json,
      Value<DateTime> updatedAt,
    });

class $$ProfileCacheTableFilterComposer
    extends Composer<_$AppDatabase, $ProfileCacheTable> {
  $$ProfileCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfileCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfileCacheTable> {
  $$ProfileCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfileCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfileCacheTable> {
  $$ProfileCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProfileCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfileCacheTable,
          ProfileCacheData,
          $$ProfileCacheTableFilterComposer,
          $$ProfileCacheTableOrderingComposer,
          $$ProfileCacheTableAnnotationComposer,
          $$ProfileCacheTableCreateCompanionBuilder,
          $$ProfileCacheTableUpdateCompanionBuilder,
          (
            ProfileCacheData,
            BaseReferences<_$AppDatabase, $ProfileCacheTable, ProfileCacheData>,
          ),
          ProfileCacheData,
          PrefetchHooks Function()
        > {
  $$ProfileCacheTableTableManager(_$AppDatabase db, $ProfileCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfileCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfileCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfileCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> json = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) => ProfileCacheCompanion(id: id, json: json, updatedAt: updatedAt),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String json,
                required DateTime updatedAt,
              }) => ProfileCacheCompanion.insert(
                id: id,
                json: json,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfileCacheTable, ProfileCacheData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ProfileCacheTable,
                    ProfileCacheData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfileCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfileCacheTable,
      ProfileCacheData,
      $$ProfileCacheTableFilterComposer,
      $$ProfileCacheTableOrderingComposer,
      $$ProfileCacheTableAnnotationComposer,
      $$ProfileCacheTableCreateCompanionBuilder,
      $$ProfileCacheTableUpdateCompanionBuilder,
      (
        ProfileCacheData,
        BaseReferences<_$AppDatabase, $ProfileCacheTable, ProfileCacheData>,
      ),
      ProfileCacheData,
      PrefetchHooks Function()
    >;
typedef $$PartnerCacheTableCreateCompanionBuilder =
    PartnerCacheCompanion Function({
      required String id,
      required String json,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$PartnerCacheTableUpdateCompanionBuilder =
    PartnerCacheCompanion Function({
      Value<String> id,
      Value<String> json,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$PartnerCacheTableFilterComposer
    extends Composer<_$AppDatabase, $PartnerCacheTable> {
  $$PartnerCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PartnerCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $PartnerCacheTable> {
  $$PartnerCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PartnerCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartnerCacheTable> {
  $$PartnerCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PartnerCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartnerCacheTable,
          PartnerCacheData,
          $$PartnerCacheTableFilterComposer,
          $$PartnerCacheTableOrderingComposer,
          $$PartnerCacheTableAnnotationComposer,
          $$PartnerCacheTableCreateCompanionBuilder,
          $$PartnerCacheTableUpdateCompanionBuilder,
          (
            PartnerCacheData,
            BaseReferences<_$AppDatabase, $PartnerCacheTable, PartnerCacheData>,
          ),
          PartnerCacheData,
          PrefetchHooks Function()
        > {
  $$PartnerCacheTableTableManager(_$AppDatabase db, $PartnerCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartnerCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartnerCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartnerCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PartnerCacheCompanion(
                id: id,
                json: json,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String json,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PartnerCacheCompanion.insert(
                id: id,
                json: json,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PartnerCacheTable, PartnerCacheData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PartnerCacheTable,
                    PartnerCacheData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PartnerCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartnerCacheTable,
      PartnerCacheData,
      $$PartnerCacheTableFilterComposer,
      $$PartnerCacheTableOrderingComposer,
      $$PartnerCacheTableAnnotationComposer,
      $$PartnerCacheTableCreateCompanionBuilder,
      $$PartnerCacheTableUpdateCompanionBuilder,
      (
        PartnerCacheData,
        BaseReferences<_$AppDatabase, $PartnerCacheTable, PartnerCacheData>,
      ),
      PartnerCacheData,
      PrefetchHooks Function()
    >;
typedef $$MoodEntriesTableCreateCompanionBuilder =
    MoodEntriesCompanion Function({
      required String date,
      required String mood,
      Value<bool> synced,
      Value<int> rowid,
    });
typedef $$MoodEntriesTableUpdateCompanionBuilder =
    MoodEntriesCompanion Function({
      Value<String> date,
      Value<String> mood,
      Value<bool> synced,
      Value<int> rowid,
    });

class $$MoodEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $MoodEntriesTable> {
  $$MoodEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MoodEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodEntriesTable> {
  $$MoodEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MoodEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodEntriesTable> {
  $$MoodEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$MoodEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoodEntriesTable,
          MoodEntry,
          $$MoodEntriesTableFilterComposer,
          $$MoodEntriesTableOrderingComposer,
          $$MoodEntriesTableAnnotationComposer,
          $$MoodEntriesTableCreateCompanionBuilder,
          $$MoodEntriesTableUpdateCompanionBuilder,
          (
            MoodEntry,
            BaseReferences<_$AppDatabase, $MoodEntriesTable, MoodEntry>,
          ),
          MoodEntry,
          PrefetchHooks Function()
        > {
  $$MoodEntriesTableTableManager(_$AppDatabase db, $MoodEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoodEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoodEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoodEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<String> mood = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MoodEntriesCompanion(
                date: date,
                mood: mood,
                synced: synced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required String mood,
                Value<bool> synced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MoodEntriesCompanion.insert(
                date: date,
                mood: mood,
                synced: synced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MoodEntriesTable, MoodEntry>(table),
                  BaseReferences<_$AppDatabase, $MoodEntriesTable, MoodEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MoodEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoodEntriesTable,
      MoodEntry,
      $$MoodEntriesTableFilterComposer,
      $$MoodEntriesTableOrderingComposer,
      $$MoodEntriesTableAnnotationComposer,
      $$MoodEntriesTableCreateCompanionBuilder,
      $$MoodEntriesTableUpdateCompanionBuilder,
      (MoodEntry, BaseReferences<_$AppDatabase, $MoodEntriesTable, MoodEntry>),
      MoodEntry,
      PrefetchHooks Function()
    >;
typedef $$GratitudeEntriesTableCreateCompanionBuilder =
    GratitudeEntriesCompanion Function({
      required String id,
      required String date,
      required String body,
      required DateTime createdAt,
      Value<bool> synced,
      Value<int> rowid,
    });
typedef $$GratitudeEntriesTableUpdateCompanionBuilder =
    GratitudeEntriesCompanion Function({
      Value<String> id,
      Value<String> date,
      Value<String> body,
      Value<DateTime> createdAt,
      Value<bool> synced,
      Value<int> rowid,
    });

class $$GratitudeEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $GratitudeEntriesTable> {
  $$GratitudeEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GratitudeEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $GratitudeEntriesTable> {
  $$GratitudeEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GratitudeEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GratitudeEntriesTable> {
  $$GratitudeEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$GratitudeEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GratitudeEntriesTable,
          GratitudeEntry,
          $$GratitudeEntriesTableFilterComposer,
          $$GratitudeEntriesTableOrderingComposer,
          $$GratitudeEntriesTableAnnotationComposer,
          $$GratitudeEntriesTableCreateCompanionBuilder,
          $$GratitudeEntriesTableUpdateCompanionBuilder,
          (
            GratitudeEntry,
            BaseReferences<
              _$AppDatabase,
              $GratitudeEntriesTable,
              GratitudeEntry
            >,
          ),
          GratitudeEntry,
          PrefetchHooks Function()
        > {
  $$GratitudeEntriesTableTableManager(
    _$AppDatabase db,
    $GratitudeEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GratitudeEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GratitudeEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GratitudeEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GratitudeEntriesCompanion(
                id: id,
                date: date,
                body: body,
                createdAt: createdAt,
                synced: synced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String date,
                required String body,
                required DateTime createdAt,
                Value<bool> synced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GratitudeEntriesCompanion.insert(
                id: id,
                date: date,
                body: body,
                createdAt: createdAt,
                synced: synced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GratitudeEntriesTable, GratitudeEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $GratitudeEntriesTable,
                    GratitudeEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GratitudeEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GratitudeEntriesTable,
      GratitudeEntry,
      $$GratitudeEntriesTableFilterComposer,
      $$GratitudeEntriesTableOrderingComposer,
      $$GratitudeEntriesTableAnnotationComposer,
      $$GratitudeEntriesTableCreateCompanionBuilder,
      $$GratitudeEntriesTableUpdateCompanionBuilder,
      (
        GratitudeEntry,
        BaseReferences<_$AppDatabase, $GratitudeEntriesTable, GratitudeEntry>,
      ),
      GratitudeEntry,
      PrefetchHooks Function()
    >;
typedef $$FutureLetterEntriesTableCreateCompanionBuilder =
    FutureLetterEntriesCompanion Function({
      required String id,
      required String body,
      required DateTime writtenAt,
      required DateTime unlockAt,
      required int unlockDays,
      Value<bool> synced,
      Value<int> rowid,
    });
typedef $$FutureLetterEntriesTableUpdateCompanionBuilder =
    FutureLetterEntriesCompanion Function({
      Value<String> id,
      Value<String> body,
      Value<DateTime> writtenAt,
      Value<DateTime> unlockAt,
      Value<int> unlockDays,
      Value<bool> synced,
      Value<int> rowid,
    });

class $$FutureLetterEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $FutureLetterEntriesTable> {
  $$FutureLetterEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get writtenAt => $composableBuilder(
    column: $table.writtenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get unlockAt => $composableBuilder(
    column: $table.unlockAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unlockDays => $composableBuilder(
    column: $table.unlockDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FutureLetterEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $FutureLetterEntriesTable> {
  $$FutureLetterEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get writtenAt => $composableBuilder(
    column: $table.writtenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get unlockAt => $composableBuilder(
    column: $table.unlockAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unlockDays => $composableBuilder(
    column: $table.unlockDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FutureLetterEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FutureLetterEntriesTable> {
  $$FutureLetterEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get writtenAt =>
      $composableBuilder(column: $table.writtenAt, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockAt =>
      $composableBuilder(column: $table.unlockAt, builder: (column) => column);

  GeneratedColumn<int> get unlockDays => $composableBuilder(
    column: $table.unlockDays,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$FutureLetterEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FutureLetterEntriesTable,
          FutureLetterEntry,
          $$FutureLetterEntriesTableFilterComposer,
          $$FutureLetterEntriesTableOrderingComposer,
          $$FutureLetterEntriesTableAnnotationComposer,
          $$FutureLetterEntriesTableCreateCompanionBuilder,
          $$FutureLetterEntriesTableUpdateCompanionBuilder,
          (
            FutureLetterEntry,
            BaseReferences<
              _$AppDatabase,
              $FutureLetterEntriesTable,
              FutureLetterEntry
            >,
          ),
          FutureLetterEntry,
          PrefetchHooks Function()
        > {
  $$FutureLetterEntriesTableTableManager(
    _$AppDatabase db,
    $FutureLetterEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FutureLetterEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FutureLetterEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FutureLetterEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> writtenAt = const Value.absent(),
                Value<DateTime> unlockAt = const Value.absent(),
                Value<int> unlockDays = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FutureLetterEntriesCompanion(
                id: id,
                body: body,
                writtenAt: writtenAt,
                unlockAt: unlockAt,
                unlockDays: unlockDays,
                synced: synced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String body,
                required DateTime writtenAt,
                required DateTime unlockAt,
                required int unlockDays,
                Value<bool> synced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FutureLetterEntriesCompanion.insert(
                id: id,
                body: body,
                writtenAt: writtenAt,
                unlockAt: unlockAt,
                unlockDays: unlockDays,
                synced: synced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FutureLetterEntriesTable, FutureLetterEntry>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $FutureLetterEntriesTable,
                    FutureLetterEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FutureLetterEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FutureLetterEntriesTable,
      FutureLetterEntry,
      $$FutureLetterEntriesTableFilterComposer,
      $$FutureLetterEntriesTableOrderingComposer,
      $$FutureLetterEntriesTableAnnotationComposer,
      $$FutureLetterEntriesTableCreateCompanionBuilder,
      $$FutureLetterEntriesTableUpdateCompanionBuilder,
      (
        FutureLetterEntry,
        BaseReferences<
          _$AppDatabase,
          $FutureLetterEntriesTable,
          FutureLetterEntry
        >,
      ),
      FutureLetterEntry,
      PrefetchHooks Function()
    >;
typedef $$CustomCardsTableCreateCompanionBuilder =
    CustomCardsCompanion Function({
      required String id,
      required String body,
      required String illustrationId,
      required DateTime createdAt,
      Value<bool> synced,
      Value<int> rowid,
    });
typedef $$CustomCardsTableUpdateCompanionBuilder =
    CustomCardsCompanion Function({
      Value<String> id,
      Value<String> body,
      Value<String> illustrationId,
      Value<DateTime> createdAt,
      Value<bool> synced,
      Value<int> rowid,
    });

class $$CustomCardsTableFilterComposer
    extends Composer<_$AppDatabase, $CustomCardsTable> {
  $$CustomCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get illustrationId => $composableBuilder(
    column: $table.illustrationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomCardsTable> {
  $$CustomCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get illustrationId => $composableBuilder(
    column: $table.illustrationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomCardsTable> {
  $$CustomCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get illustrationId => $composableBuilder(
    column: $table.illustrationId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$CustomCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomCardsTable,
          CustomCard,
          $$CustomCardsTableFilterComposer,
          $$CustomCardsTableOrderingComposer,
          $$CustomCardsTableAnnotationComposer,
          $$CustomCardsTableCreateCompanionBuilder,
          $$CustomCardsTableUpdateCompanionBuilder,
          (
            CustomCard,
            BaseReferences<_$AppDatabase, $CustomCardsTable, CustomCard>,
          ),
          CustomCard,
          PrefetchHooks Function()
        > {
  $$CustomCardsTableTableManager(_$AppDatabase db, $CustomCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> illustrationId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomCardsCompanion(
                id: id,
                body: body,
                illustrationId: illustrationId,
                createdAt: createdAt,
                synced: synced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String body,
                required String illustrationId,
                required DateTime createdAt,
                Value<bool> synced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomCardsCompanion.insert(
                id: id,
                body: body,
                illustrationId: illustrationId,
                createdAt: createdAt,
                synced: synced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CustomCardsTable, CustomCard>(table),
                  BaseReferences<_$AppDatabase, $CustomCardsTable, CustomCard>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomCardsTable,
      CustomCard,
      $$CustomCardsTableFilterComposer,
      $$CustomCardsTableOrderingComposer,
      $$CustomCardsTableAnnotationComposer,
      $$CustomCardsTableCreateCompanionBuilder,
      $$CustomCardsTableUpdateCompanionBuilder,
      (
        CustomCard,
        BaseReferences<_$AppDatabase, $CustomCardsTable, CustomCard>,
      ),
      CustomCard,
      PrefetchHooks Function()
    >;
typedef $$RitualDaysTableCreateCompanionBuilder = RitualDaysCompanion Function({
  required String date,
  required DateTime completedAt,
  Value<int> rowid,
});
typedef $$RitualDaysTableUpdateCompanionBuilder = RitualDaysCompanion Function({
  Value<String> date,
  Value<DateTime> completedAt,
  Value<int> rowid,
});

class $$RitualDaysTableFilterComposer
    extends Composer<_$AppDatabase, $RitualDaysTable> {
  $$RitualDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RitualDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $RitualDaysTable> {
  $$RitualDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RitualDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $RitualDaysTable> {
  $$RitualDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$RitualDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RitualDaysTable,
          RitualDay,
          $$RitualDaysTableFilterComposer,
          $$RitualDaysTableOrderingComposer,
          $$RitualDaysTableAnnotationComposer,
          $$RitualDaysTableCreateCompanionBuilder,
          $$RitualDaysTableUpdateCompanionBuilder,
          (
            RitualDay,
            BaseReferences<_$AppDatabase, $RitualDaysTable, RitualDay>,
          ),
          RitualDay,
          PrefetchHooks Function()
        > {
  $$RitualDaysTableTableManager(_$AppDatabase db, $RitualDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RitualDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RitualDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RitualDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RitualDaysCompanion(
                date: date,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required DateTime completedAt,
                Value<int> rowid = const Value.absent(),
              }) => RitualDaysCompanion.insert(
                date: date,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RitualDaysTable, RitualDay>(table),
                  BaseReferences<_$AppDatabase, $RitualDaysTable, RitualDay>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RitualDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RitualDaysTable,
      RitualDay,
      $$RitualDaysTableFilterComposer,
      $$RitualDaysTableOrderingComposer,
      $$RitualDaysTableAnnotationComposer,
      $$RitualDaysTableCreateCompanionBuilder,
      $$RitualDaysTableUpdateCompanionBuilder,
      (RitualDay, BaseReferences<_$AppDatabase, $RitualDaysTable, RitualDay>),
      RitualDay,
      PrefetchHooks Function()
    >;
typedef $$RitualProgressTableCreateCompanionBuilder =
    RitualProgressCompanion Function({
      required String date,
      required int step,
      required String quoteIds,
      Value<int> rowid,
    });
typedef $$RitualProgressTableUpdateCompanionBuilder =
    RitualProgressCompanion Function({
      Value<String> date,
      Value<int> step,
      Value<String> quoteIds,
      Value<int> rowid,
    });

class $$RitualProgressTableFilterComposer
    extends Composer<_$AppDatabase, $RitualProgressTable> {
  $$RitualProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quoteIds => $composableBuilder(
    column: $table.quoteIds,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RitualProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $RitualProgressTable> {
  $$RitualProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quoteIds => $composableBuilder(
    column: $table.quoteIds,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RitualProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $RitualProgressTable> {
  $$RitualProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get step =>
      $composableBuilder(column: $table.step, builder: (column) => column);

  GeneratedColumn<String> get quoteIds =>
      $composableBuilder(column: $table.quoteIds, builder: (column) => column);
}

class $$RitualProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RitualProgressTable,
          RitualProgressData,
          $$RitualProgressTableFilterComposer,
          $$RitualProgressTableOrderingComposer,
          $$RitualProgressTableAnnotationComposer,
          $$RitualProgressTableCreateCompanionBuilder,
          $$RitualProgressTableUpdateCompanionBuilder,
          (
            RitualProgressData,
            BaseReferences<
              _$AppDatabase,
              $RitualProgressTable,
              RitualProgressData
            >,
          ),
          RitualProgressData,
          PrefetchHooks Function()
        > {
  $$RitualProgressTableTableManager(
    _$AppDatabase db,
    $RitualProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RitualProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RitualProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RitualProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<int> step = const Value.absent(),
                Value<String> quoteIds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RitualProgressCompanion(
                date: date,
                step: step,
                quoteIds: quoteIds,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required int step,
                required String quoteIds,
                Value<int> rowid = const Value.absent(),
              }) => RitualProgressCompanion.insert(
                date: date,
                step: step,
                quoteIds: quoteIds,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RitualProgressTable, RitualProgressData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $RitualProgressTable,
                    RitualProgressData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RitualProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RitualProgressTable,
      RitualProgressData,
      $$RitualProgressTableFilterComposer,
      $$RitualProgressTableOrderingComposer,
      $$RitualProgressTableAnnotationComposer,
      $$RitualProgressTableCreateCompanionBuilder,
      $$RitualProgressTableUpdateCompanionBuilder,
      (
        RitualProgressData,
        BaseReferences<_$AppDatabase, $RitualProgressTable, RitualProgressData>,
      ),
      RitualProgressData,
      PrefetchHooks Function()
    >;
typedef $$QuestStatesTableCreateCompanionBuilder =
    QuestStatesCompanion Function({
      required String date,
      required String questId,
      Value<bool> done,
      Value<bool> swapped,
      Value<bool> synced,
      Value<int> rowid,
    });
typedef $$QuestStatesTableUpdateCompanionBuilder =
    QuestStatesCompanion Function({
      Value<String> date,
      Value<String> questId,
      Value<bool> done,
      Value<bool> swapped,
      Value<bool> synced,
      Value<int> rowid,
    });

class $$QuestStatesTableFilterComposer
    extends Composer<_$AppDatabase, $QuestStatesTable> {
  $$QuestStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questId => $composableBuilder(
    column: $table.questId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get swapped => $composableBuilder(
    column: $table.swapped,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestStatesTable> {
  $$QuestStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questId => $composableBuilder(
    column: $table.questId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get swapped => $composableBuilder(
    column: $table.swapped,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestStatesTable> {
  $$QuestStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get questId =>
      $composableBuilder(column: $table.questId, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<bool> get swapped =>
      $composableBuilder(column: $table.swapped, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$QuestStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestStatesTable,
          QuestState,
          $$QuestStatesTableFilterComposer,
          $$QuestStatesTableOrderingComposer,
          $$QuestStatesTableAnnotationComposer,
          $$QuestStatesTableCreateCompanionBuilder,
          $$QuestStatesTableUpdateCompanionBuilder,
          (
            QuestState,
            BaseReferences<_$AppDatabase, $QuestStatesTable, QuestState>,
          ),
          QuestState,
          PrefetchHooks Function()
        > {
  $$QuestStatesTableTableManager(_$AppDatabase db, $QuestStatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<String> questId = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<bool> swapped = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestStatesCompanion(
                date: date,
                questId: questId,
                done: done,
                swapped: swapped,
                synced: synced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required String questId,
                Value<bool> done = const Value.absent(),
                Value<bool> swapped = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestStatesCompanion.insert(
                date: date,
                questId: questId,
                done: done,
                swapped: swapped,
                synced: synced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$QuestStatesTable, QuestState>(table),
                  BaseReferences<_$AppDatabase, $QuestStatesTable, QuestState>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestStatesTable,
      QuestState,
      $$QuestStatesTableFilterComposer,
      $$QuestStatesTableOrderingComposer,
      $$QuestStatesTableAnnotationComposer,
      $$QuestStatesTableCreateCompanionBuilder,
      $$QuestStatesTableUpdateCompanionBuilder,
      (
        QuestState,
        BaseReferences<_$AppDatabase, $QuestStatesTable, QuestState>,
      ),
      QuestState,
      PrefetchHooks Function()
    >;
typedef $$JourneyProgressEntriesTableCreateCompanionBuilder =
    JourneyProgressEntriesCompanion Function({
      required String journeyId,
      required DateTime startedAt,
      Value<int> currentDay,
      Value<String> completedDays,
      Value<String> reflections,
      Value<DateTime?> completedAt,
      Value<String?> lastDoneOn,
      Value<bool> synced,
      Value<int> rowid,
    });
typedef $$JourneyProgressEntriesTableUpdateCompanionBuilder =
    JourneyProgressEntriesCompanion Function({
      Value<String> journeyId,
      Value<DateTime> startedAt,
      Value<int> currentDay,
      Value<String> completedDays,
      Value<String> reflections,
      Value<DateTime?> completedAt,
      Value<String?> lastDoneOn,
      Value<bool> synced,
      Value<int> rowid,
    });

class $$JourneyProgressEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $JourneyProgressEntriesTable> {
  $$JourneyProgressEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get journeyId => $composableBuilder(
    column: $table.journeyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentDay => $composableBuilder(
    column: $table.currentDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedDays => $composableBuilder(
    column: $table.completedDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reflections => $composableBuilder(
    column: $table.reflections,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastDoneOn => $composableBuilder(
    column: $table.lastDoneOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$JourneyProgressEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $JourneyProgressEntriesTable> {
  $$JourneyProgressEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get journeyId => $composableBuilder(
    column: $table.journeyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentDay => $composableBuilder(
    column: $table.currentDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedDays => $composableBuilder(
    column: $table.completedDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reflections => $composableBuilder(
    column: $table.reflections,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastDoneOn => $composableBuilder(
    column: $table.lastDoneOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JourneyProgressEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $JourneyProgressEntriesTable> {
  $$JourneyProgressEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get journeyId =>
      $composableBuilder(column: $table.journeyId, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get currentDay => $composableBuilder(
    column: $table.currentDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get completedDays => $composableBuilder(
    column: $table.completedDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reflections => $composableBuilder(
    column: $table.reflections,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastDoneOn => $composableBuilder(
    column: $table.lastDoneOn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$JourneyProgressEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JourneyProgressEntriesTable,
          JourneyProgressEntry,
          $$JourneyProgressEntriesTableFilterComposer,
          $$JourneyProgressEntriesTableOrderingComposer,
          $$JourneyProgressEntriesTableAnnotationComposer,
          $$JourneyProgressEntriesTableCreateCompanionBuilder,
          $$JourneyProgressEntriesTableUpdateCompanionBuilder,
          (
            JourneyProgressEntry,
            BaseReferences<
              _$AppDatabase,
              $JourneyProgressEntriesTable,
              JourneyProgressEntry
            >,
          ),
          JourneyProgressEntry,
          PrefetchHooks Function()
        > {
  $$JourneyProgressEntriesTableTableManager(
    _$AppDatabase db,
    $JourneyProgressEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JourneyProgressEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$JourneyProgressEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$JourneyProgressEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> journeyId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<int> currentDay = const Value.absent(),
                Value<String> completedDays = const Value.absent(),
                Value<String> reflections = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> lastDoneOn = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JourneyProgressEntriesCompanion(
                journeyId: journeyId,
                startedAt: startedAt,
                currentDay: currentDay,
                completedDays: completedDays,
                reflections: reflections,
                completedAt: completedAt,
                lastDoneOn: lastDoneOn,
                synced: synced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String journeyId,
                required DateTime startedAt,
                Value<int> currentDay = const Value.absent(),
                Value<String> completedDays = const Value.absent(),
                Value<String> reflections = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> lastDoneOn = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JourneyProgressEntriesCompanion.insert(
                journeyId: journeyId,
                startedAt: startedAt,
                currentDay: currentDay,
                completedDays: completedDays,
                reflections: reflections,
                completedAt: completedAt,
                lastDoneOn: lastDoneOn,
                synced: synced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $JourneyProgressEntriesTable,
                    JourneyProgressEntry
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $JourneyProgressEntriesTable,
                    JourneyProgressEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$JourneyProgressEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JourneyProgressEntriesTable,
      JourneyProgressEntry,
      $$JourneyProgressEntriesTableFilterComposer,
      $$JourneyProgressEntriesTableOrderingComposer,
      $$JourneyProgressEntriesTableAnnotationComposer,
      $$JourneyProgressEntriesTableCreateCompanionBuilder,
      $$JourneyProgressEntriesTableUpdateCompanionBuilder,
      (
        JourneyProgressEntry,
        BaseReferences<
          _$AppDatabase,
          $JourneyProgressEntriesTable,
          JourneyProgressEntry
        >,
      ),
      JourneyProgressEntry,
      PrefetchHooks Function()
    >;
typedef $$MascotInventoryTableCreateCompanionBuilder =
    MascotInventoryCompanion Function({
      required String itemId,
      required DateTime earnedAt,
      Value<String?> equippedSlot,
      Value<int> rowid,
    });
typedef $$MascotInventoryTableUpdateCompanionBuilder =
    MascotInventoryCompanion Function({
      Value<String> itemId,
      Value<DateTime> earnedAt,
      Value<String?> equippedSlot,
      Value<int> rowid,
    });

class $$MascotInventoryTableFilterComposer
    extends Composer<_$AppDatabase, $MascotInventoryTable> {
  $$MascotInventoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get earnedAt => $composableBuilder(
    column: $table.earnedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equippedSlot => $composableBuilder(
    column: $table.equippedSlot,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MascotInventoryTableOrderingComposer
    extends Composer<_$AppDatabase, $MascotInventoryTable> {
  $$MascotInventoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get earnedAt => $composableBuilder(
    column: $table.earnedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equippedSlot => $composableBuilder(
    column: $table.equippedSlot,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MascotInventoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $MascotInventoryTable> {
  $$MascotInventoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<DateTime> get earnedAt =>
      $composableBuilder(column: $table.earnedAt, builder: (column) => column);

  GeneratedColumn<String> get equippedSlot => $composableBuilder(
    column: $table.equippedSlot,
    builder: (column) => column,
  );
}

class $$MascotInventoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MascotInventoryTable,
          MascotInventoryData,
          $$MascotInventoryTableFilterComposer,
          $$MascotInventoryTableOrderingComposer,
          $$MascotInventoryTableAnnotationComposer,
          $$MascotInventoryTableCreateCompanionBuilder,
          $$MascotInventoryTableUpdateCompanionBuilder,
          (
            MascotInventoryData,
            BaseReferences<
              _$AppDatabase,
              $MascotInventoryTable,
              MascotInventoryData
            >,
          ),
          MascotInventoryData,
          PrefetchHooks Function()
        > {
  $$MascotInventoryTableTableManager(
    _$AppDatabase db,
    $MascotInventoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MascotInventoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MascotInventoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MascotInventoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<DateTime> earnedAt = const Value.absent(),
                Value<String?> equippedSlot = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MascotInventoryCompanion(
                itemId: itemId,
                earnedAt: earnedAt,
                equippedSlot: equippedSlot,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                required DateTime earnedAt,
                Value<String?> equippedSlot = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MascotInventoryCompanion.insert(
                itemId: itemId,
                earnedAt: earnedAt,
                equippedSlot: equippedSlot,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MascotInventoryTable, MascotInventoryData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $MascotInventoryTable,
                    MascotInventoryData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MascotInventoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MascotInventoryTable,
      MascotInventoryData,
      $$MascotInventoryTableFilterComposer,
      $$MascotInventoryTableOrderingComposer,
      $$MascotInventoryTableAnnotationComposer,
      $$MascotInventoryTableCreateCompanionBuilder,
      $$MascotInventoryTableUpdateCompanionBuilder,
      (
        MascotInventoryData,
        BaseReferences<
          _$AppDatabase,
          $MascotInventoryTable,
          MascotInventoryData
        >,
      ),
      MascotInventoryData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedReadingsTableTableManager get cachedReadings =>
      $$CachedReadingsTableTableManager(_db, _db.cachedReadings);
  $$CachedReportsTableTableManager get cachedReports =>
      $$CachedReportsTableTableManager(_db, _db.cachedReports);
  $$DeckHistoryTableTableManager get deckHistory =>
      $$DeckHistoryTableTableManager(_db, _db.deckHistory);
  $$JournalCacheTableTableManager get journalCache =>
      $$JournalCacheTableTableManager(_db, _db.journalCache);
  $$RetroCalendarTableTableManager get retroCalendar =>
      $$RetroCalendarTableTableManager(_db, _db.retroCalendar);
  $$PreferenceVectorTableTableManager get preferenceVector =>
      $$PreferenceVectorTableTableManager(_db, _db.preferenceVector);
  $$ProfileCacheTableTableManager get profileCache =>
      $$ProfileCacheTableTableManager(_db, _db.profileCache);
  $$PartnerCacheTableTableManager get partnerCache =>
      $$PartnerCacheTableTableManager(_db, _db.partnerCache);
  $$MoodEntriesTableTableManager get moodEntries =>
      $$MoodEntriesTableTableManager(_db, _db.moodEntries);
  $$GratitudeEntriesTableTableManager get gratitudeEntries =>
      $$GratitudeEntriesTableTableManager(_db, _db.gratitudeEntries);
  $$FutureLetterEntriesTableTableManager get futureLetterEntries =>
      $$FutureLetterEntriesTableTableManager(_db, _db.futureLetterEntries);
  $$CustomCardsTableTableManager get customCards =>
      $$CustomCardsTableTableManager(_db, _db.customCards);
  $$RitualDaysTableTableManager get ritualDays =>
      $$RitualDaysTableTableManager(_db, _db.ritualDays);
  $$RitualProgressTableTableManager get ritualProgress =>
      $$RitualProgressTableTableManager(_db, _db.ritualProgress);
  $$QuestStatesTableTableManager get questStates =>
      $$QuestStatesTableTableManager(_db, _db.questStates);
  $$JourneyProgressEntriesTableTableManager get journeyProgressEntries =>
      $$JourneyProgressEntriesTableTableManager(
        _db,
        _db.journeyProgressEntries,
      );
  $$MascotInventoryTableTableManager get mascotInventory =>
      $$MascotInventoryTableTableManager(_db, _db.mascotInventory);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'59cce38d45eeaba199eddd097d8e149d66f9f3e1';
