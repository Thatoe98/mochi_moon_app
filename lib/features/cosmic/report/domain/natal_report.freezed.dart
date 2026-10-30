// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'natal_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReportSection {

 String get key; String get title; String get body;
/// Create a copy of ReportSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportSectionCopyWith<ReportSection> get copyWith => _$ReportSectionCopyWithImpl<ReportSection>(this as ReportSection, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ReportSection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportSection&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.body, _this.body) || other.body == _this.body));
}


@override
int get hashCode {
  final _this = this as ReportSection;
  return Object.hash(runtimeType,_this.key,_this.title,_this.body);
}

@override
String toString() {
  final _this = this as ReportSection;
  return 'ReportSection(key: ${_this.key}, title: ${_this.title}, body: ${_this.body})';
}


}

/// @nodoc
abstract mixin class $ReportSectionCopyWith<$Res>  {
  factory $ReportSectionCopyWith(ReportSection value, $Res Function(ReportSection) _then) = _$ReportSectionCopyWithImpl;
@useResult
$Res call({
 String key, String title, String body
});




}
/// @nodoc
class _$ReportSectionCopyWithImpl<$Res>
    implements $ReportSectionCopyWith<$Res> {
  _$ReportSectionCopyWithImpl(this._self, this._then);

  final ReportSection _self;
  final $Res Function(ReportSection) _then;

/// Create a copy of ReportSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? title = null,Object? body = null,}) {
  return _then(ReportSection(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportSection].
extension ReportSectionPatterns on ReportSection {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportSection() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportSection value)  $default,){
final _that = this;
switch (_that) {
case _ReportSection():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportSection value)?  $default,){
final _that = this;
switch (_that) {
case _ReportSection() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String title,  String body)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportSection() when $default != null:
return $default(_that.key,_that.title,_that.body);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String title,  String body)  $default,) {final _that = this;
switch (_that) {
case _ReportSection():
return $default(_that.key,_that.title,_that.body);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String title,  String body)?  $default,) {final _that = this;
switch (_that) {
case _ReportSection() when $default != null:
return $default(_that.key,_that.title,_that.body);case _:
  return null;

}
}

}

/// @nodoc


class _ReportSection implements ReportSection {
  const _ReportSection({required this.key, required this.title, required this.body});
  

@override final  String key;
@override final  String title;
@override final  String body;

/// Create a copy of ReportSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportSectionCopyWith<_ReportSection> get copyWith => __$ReportSectionCopyWithImpl<_ReportSection>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportSection&&(identical(other.key, key) || other.key == key)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body));
}


@override
int get hashCode {
    return Object.hash(runtimeType,key,title,body);
}

@override
String toString() {
    return 'ReportSection(key: $key, title: $title, body: $body)';
}


}

/// @nodoc
abstract mixin class _$ReportSectionCopyWith<$Res> implements $ReportSectionCopyWith<$Res> {
  factory _$ReportSectionCopyWith(_ReportSection value, $Res Function(_ReportSection) _then) = __$ReportSectionCopyWithImpl;
@override @useResult
$Res call({
 String key, String title, String body
});




}
/// @nodoc
class __$ReportSectionCopyWithImpl<$Res>
    implements _$ReportSectionCopyWith<$Res> {
  __$ReportSectionCopyWithImpl(this._self, this._then);

  final _ReportSection _self;
  final $Res Function(_ReportSection) _then;

/// Create a copy of ReportSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? title = null,Object? body = null,}) {
  return _then(_ReportSection(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$NatalReport {

 String get reportId; String get lang; int get version; ReportStatus get status; int get total; List<ReportSection> get sections;
/// Create a copy of NatalReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NatalReportCopyWith<NatalReport> get copyWith => _$NatalReportCopyWithImpl<NatalReport>(this as NatalReport, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as NatalReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NatalReport&&(identical(other.reportId, _this.reportId) || other.reportId == _this.reportId)&&(identical(other.lang, _this.lang) || other.lang == _this.lang)&&(identical(other.version, _this.version) || other.version == _this.version)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.total, _this.total) || other.total == _this.total)&&const DeepCollectionEquality().equals(other.sections, _this.sections));
}


@override
int get hashCode {
  final _this = this as NatalReport;
  return Object.hash(runtimeType,_this.reportId,_this.lang,_this.version,_this.status,_this.total,const DeepCollectionEquality().hash(_this.sections));
}

@override
String toString() {
  final _this = this as NatalReport;
  return 'NatalReport(reportId: ${_this.reportId}, lang: ${_this.lang}, version: ${_this.version}, status: ${_this.status}, total: ${_this.total}, sections: ${_this.sections})';
}


}

/// @nodoc
abstract mixin class $NatalReportCopyWith<$Res>  {
  factory $NatalReportCopyWith(NatalReport value, $Res Function(NatalReport) _then) = _$NatalReportCopyWithImpl;
@useResult
$Res call({
 String reportId, String lang, int version, ReportStatus status, int total, List<ReportSection> sections
});




}
/// @nodoc
class _$NatalReportCopyWithImpl<$Res>
    implements $NatalReportCopyWith<$Res> {
  _$NatalReportCopyWithImpl(this._self, this._then);

  final NatalReport _self;
  final $Res Function(NatalReport) _then;

/// Create a copy of NatalReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reportId = null,Object? lang = null,Object? version = null,Object? status = null,Object? total = null,Object? sections = null,}) {
  return _then(NatalReport(
reportId: null == reportId ? _self.reportId : reportId // ignore: cast_nullable_to_non_nullable
as String,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReportStatus,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<ReportSection>,
  ));
}

}


/// Adds pattern-matching-related methods to [NatalReport].
extension NatalReportPatterns on NatalReport {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NatalReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NatalReport() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NatalReport value)  $default,){
final _that = this;
switch (_that) {
case _NatalReport():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NatalReport value)?  $default,){
final _that = this;
switch (_that) {
case _NatalReport() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String reportId,  String lang,  int version,  ReportStatus status,  int total,  List<ReportSection> sections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NatalReport() when $default != null:
return $default(_that.reportId,_that.lang,_that.version,_that.status,_that.total,_that.sections);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String reportId,  String lang,  int version,  ReportStatus status,  int total,  List<ReportSection> sections)  $default,) {final _that = this;
switch (_that) {
case _NatalReport():
return $default(_that.reportId,_that.lang,_that.version,_that.status,_that.total,_that.sections);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String reportId,  String lang,  int version,  ReportStatus status,  int total,  List<ReportSection> sections)?  $default,) {final _that = this;
switch (_that) {
case _NatalReport() when $default != null:
return $default(_that.reportId,_that.lang,_that.version,_that.status,_that.total,_that.sections);case _:
  return null;

}
}

}

/// @nodoc


class _NatalReport extends NatalReport {
  const _NatalReport({required this.reportId, required this.lang, required this.version, required this.status, required this.total, required  List<ReportSection> sections}): _sections = sections,super._();
  

@override final  String reportId;
@override final  String lang;
@override final  int version;
@override final  ReportStatus status;
@override final  int total;
 final  List<ReportSection> _sections;
@override List<ReportSection> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}


/// Create a copy of NatalReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NatalReportCopyWith<_NatalReport> get copyWith => __$NatalReportCopyWithImpl<_NatalReport>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NatalReport&&(identical(other.reportId, reportId) || other.reportId == reportId)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.version, version) || other.version == version)&&(identical(other.status, status) || other.status == status)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.sections, _sections));
}


@override
int get hashCode {
    return Object.hash(runtimeType,reportId,lang,version,status,total,const DeepCollectionEquality().hash(_sections));
}

@override
String toString() {
    return 'NatalReport(reportId: $reportId, lang: $lang, version: $version, status: $status, total: $total, sections: $sections)';
}


}

/// @nodoc
abstract mixin class _$NatalReportCopyWith<$Res> implements $NatalReportCopyWith<$Res> {
  factory _$NatalReportCopyWith(_NatalReport value, $Res Function(_NatalReport) _then) = __$NatalReportCopyWithImpl;
@override @useResult
$Res call({
 String reportId, String lang, int version, ReportStatus status, int total, List<ReportSection> sections
});




}
/// @nodoc
class __$NatalReportCopyWithImpl<$Res>
    implements _$NatalReportCopyWith<$Res> {
  __$NatalReportCopyWithImpl(this._self, this._then);

  final _NatalReport _self;
  final $Res Function(_NatalReport) _then;

/// Create a copy of NatalReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reportId = null,Object? lang = null,Object? version = null,Object? status = null,Object? total = null,Object? sections = null,}) {
  return _then(_NatalReport(
reportId: null == reportId ? _self.reportId : reportId // ignore: cast_nullable_to_non_nullable
as String,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReportStatus,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<ReportSection>,
  ));
}


}

// dart format on
