// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journey.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Journey {

 String get id; int get days; Map<String, String> get title; Map<String, String> get summary; String get illustrationId; List<JourneyDayPlan> get daysPlan; bool get premium;
/// Create a copy of Journey
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JourneyCopyWith<Journey> get copyWith => _$JourneyCopyWithImpl<Journey>(this as Journey, _$identity);

  /// Serializes this Journey to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Journey;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Journey&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.days, _this.days) || other.days == _this.days)&&const DeepCollectionEquality().equals(other.title, _this.title)&&const DeepCollectionEquality().equals(other.summary, _this.summary)&&(identical(other.illustrationId, _this.illustrationId) || other.illustrationId == _this.illustrationId)&&const DeepCollectionEquality().equals(other.daysPlan, _this.daysPlan)&&(identical(other.premium, _this.premium) || other.premium == _this.premium));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Journey;
  return Object.hash(runtimeType,_this.id,_this.days,const DeepCollectionEquality().hash(_this.title),const DeepCollectionEquality().hash(_this.summary),_this.illustrationId,const DeepCollectionEquality().hash(_this.daysPlan),_this.premium);
}

@override
String toString() {
  final _this = this as Journey;
  return 'Journey(id: ${_this.id}, days: ${_this.days}, title: ${_this.title}, summary: ${_this.summary}, illustrationId: ${_this.illustrationId}, daysPlan: ${_this.daysPlan}, premium: ${_this.premium})';
}


}

/// @nodoc
abstract mixin class $JourneyCopyWith<$Res>  {
  factory $JourneyCopyWith(Journey value, $Res Function(Journey) _then) = _$JourneyCopyWithImpl;
@useResult
$Res call({
 String id, int days, Map<String, String> title, Map<String, String> summary, String illustrationId, List<JourneyDayPlan> daysPlan, bool premium
});




}
/// @nodoc
class _$JourneyCopyWithImpl<$Res>
    implements $JourneyCopyWith<$Res> {
  _$JourneyCopyWithImpl(this._self, this._then);

  final Journey _self;
  final $Res Function(Journey) _then;

/// Create a copy of Journey
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? days = null,Object? title = null,Object? summary = null,Object? illustrationId = null,Object? daysPlan = null,Object? premium = null,}) {
  return _then(Journey(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as Map<String, String>,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as Map<String, String>,illustrationId: null == illustrationId ? _self.illustrationId : illustrationId // ignore: cast_nullable_to_non_nullable
as String,daysPlan: null == daysPlan ? _self.daysPlan : daysPlan // ignore: cast_nullable_to_non_nullable
as List<JourneyDayPlan>,premium: null == premium ? _self.premium : premium // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Journey].
extension JourneyPatterns on Journey {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Journey value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Journey() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Journey value)  $default,){
final _that = this;
switch (_that) {
case _Journey():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Journey value)?  $default,){
final _that = this;
switch (_that) {
case _Journey() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int days,  Map<String, String> title,  Map<String, String> summary,  String illustrationId,  List<JourneyDayPlan> daysPlan,  bool premium)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Journey() when $default != null:
return $default(_that.id,_that.days,_that.title,_that.summary,_that.illustrationId,_that.daysPlan,_that.premium);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int days,  Map<String, String> title,  Map<String, String> summary,  String illustrationId,  List<JourneyDayPlan> daysPlan,  bool premium)  $default,) {final _that = this;
switch (_that) {
case _Journey():
return $default(_that.id,_that.days,_that.title,_that.summary,_that.illustrationId,_that.daysPlan,_that.premium);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int days,  Map<String, String> title,  Map<String, String> summary,  String illustrationId,  List<JourneyDayPlan> daysPlan,  bool premium)?  $default,) {final _that = this;
switch (_that) {
case _Journey() when $default != null:
return $default(_that.id,_that.days,_that.title,_that.summary,_that.illustrationId,_that.daysPlan,_that.premium);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Journey extends Journey {
  const _Journey({required this.id, required this.days, required  Map<String, String> title, required  Map<String, String> summary, required this.illustrationId,  List<JourneyDayPlan> daysPlan = const <JourneyDayPlan>[], this.premium = false}): _title = title,_summary = summary,_daysPlan = daysPlan,super._();
  factory _Journey.fromJson(Map<String, dynamic> json) => _$JourneyFromJson(json);

@override final  String id;
@override final  int days;
 final  Map<String, String> _title;
@override Map<String, String> get title {
  if (_title is EqualUnmodifiableMapView) return _title;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_title);
}

 final  Map<String, String> _summary;
@override Map<String, String> get summary {
  if (_summary is EqualUnmodifiableMapView) return _summary;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_summary);
}

@override final  String illustrationId;
 final  List<JourneyDayPlan> _daysPlan;
@override@JsonKey() List<JourneyDayPlan> get daysPlan {
  if (_daysPlan is EqualUnmodifiableListView) return _daysPlan;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_daysPlan);
}

@override@JsonKey() final  bool premium;

/// Create a copy of Journey
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JourneyCopyWith<_Journey> get copyWith => __$JourneyCopyWithImpl<_Journey>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JourneyToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Journey&&(identical(other.id, id) || other.id == id)&&(identical(other.days, days) || other.days == days)&&const DeepCollectionEquality().equals(other.title, _title)&&const DeepCollectionEquality().equals(other.summary, _summary)&&(identical(other.illustrationId, illustrationId) || other.illustrationId == illustrationId)&&const DeepCollectionEquality().equals(other.daysPlan, _daysPlan)&&(identical(other.premium, premium) || other.premium == premium));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,days,const DeepCollectionEquality().hash(_title),const DeepCollectionEquality().hash(_summary),illustrationId,const DeepCollectionEquality().hash(_daysPlan),premium);
}

@override
String toString() {
    return 'Journey(id: $id, days: $days, title: $title, summary: $summary, illustrationId: $illustrationId, daysPlan: $daysPlan, premium: $premium)';
}


}

/// @nodoc
abstract mixin class _$JourneyCopyWith<$Res> implements $JourneyCopyWith<$Res> {
  factory _$JourneyCopyWith(_Journey value, $Res Function(_Journey) _then) = __$JourneyCopyWithImpl;
@override @useResult
$Res call({
 String id, int days, Map<String, String> title, Map<String, String> summary, String illustrationId, List<JourneyDayPlan> daysPlan, bool premium
});




}
/// @nodoc
class __$JourneyCopyWithImpl<$Res>
    implements _$JourneyCopyWith<$Res> {
  __$JourneyCopyWithImpl(this._self, this._then);

  final _Journey _self;
  final $Res Function(_Journey) _then;

/// Create a copy of Journey
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? days = null,Object? title = null,Object? summary = null,Object? illustrationId = null,Object? daysPlan = null,Object? premium = null,}) {
  return _then(_Journey(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self._title : title // ignore: cast_nullable_to_non_nullable
as Map<String, String>,summary: null == summary ? _self._summary : summary // ignore: cast_nullable_to_non_nullable
as Map<String, String>,illustrationId: null == illustrationId ? _self.illustrationId : illustrationId // ignore: cast_nullable_to_non_nullable
as String,daysPlan: null == daysPlan ? _self._daysPlan : daysPlan // ignore: cast_nullable_to_non_nullable
as List<JourneyDayPlan>,premium: null == premium ? _self.premium : premium // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$JourneyDayPlan {

 int get day; List<String> get quoteIds; String get questId; Map<String, String> get reflection;
/// Create a copy of JourneyDayPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JourneyDayPlanCopyWith<JourneyDayPlan> get copyWith => _$JourneyDayPlanCopyWithImpl<JourneyDayPlan>(this as JourneyDayPlan, _$identity);

  /// Serializes this JourneyDayPlan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as JourneyDayPlan;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JourneyDayPlan&&(identical(other.day, _this.day) || other.day == _this.day)&&const DeepCollectionEquality().equals(other.quoteIds, _this.quoteIds)&&(identical(other.questId, _this.questId) || other.questId == _this.questId)&&const DeepCollectionEquality().equals(other.reflection, _this.reflection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as JourneyDayPlan;
  return Object.hash(runtimeType,_this.day,const DeepCollectionEquality().hash(_this.quoteIds),_this.questId,const DeepCollectionEquality().hash(_this.reflection));
}

@override
String toString() {
  final _this = this as JourneyDayPlan;
  return 'JourneyDayPlan(day: ${_this.day}, quoteIds: ${_this.quoteIds}, questId: ${_this.questId}, reflection: ${_this.reflection})';
}


}

/// @nodoc
abstract mixin class $JourneyDayPlanCopyWith<$Res>  {
  factory $JourneyDayPlanCopyWith(JourneyDayPlan value, $Res Function(JourneyDayPlan) _then) = _$JourneyDayPlanCopyWithImpl;
@useResult
$Res call({
 int day, List<String> quoteIds, String questId, Map<String, String> reflection
});




}
/// @nodoc
class _$JourneyDayPlanCopyWithImpl<$Res>
    implements $JourneyDayPlanCopyWith<$Res> {
  _$JourneyDayPlanCopyWithImpl(this._self, this._then);

  final JourneyDayPlan _self;
  final $Res Function(JourneyDayPlan) _then;

/// Create a copy of JourneyDayPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? quoteIds = null,Object? questId = null,Object? reflection = null,}) {
  return _then(JourneyDayPlan(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,quoteIds: null == quoteIds ? _self.quoteIds : quoteIds // ignore: cast_nullable_to_non_nullable
as List<String>,questId: null == questId ? _self.questId : questId // ignore: cast_nullable_to_non_nullable
as String,reflection: null == reflection ? _self.reflection : reflection // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [JourneyDayPlan].
extension JourneyDayPlanPatterns on JourneyDayPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JourneyDayPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JourneyDayPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JourneyDayPlan value)  $default,){
final _that = this;
switch (_that) {
case _JourneyDayPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JourneyDayPlan value)?  $default,){
final _that = this;
switch (_that) {
case _JourneyDayPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int day,  List<String> quoteIds,  String questId,  Map<String, String> reflection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JourneyDayPlan() when $default != null:
return $default(_that.day,_that.quoteIds,_that.questId,_that.reflection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int day,  List<String> quoteIds,  String questId,  Map<String, String> reflection)  $default,) {final _that = this;
switch (_that) {
case _JourneyDayPlan():
return $default(_that.day,_that.quoteIds,_that.questId,_that.reflection);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int day,  List<String> quoteIds,  String questId,  Map<String, String> reflection)?  $default,) {final _that = this;
switch (_that) {
case _JourneyDayPlan() when $default != null:
return $default(_that.day,_that.quoteIds,_that.questId,_that.reflection);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JourneyDayPlan extends JourneyDayPlan {
  const _JourneyDayPlan({required this.day, required  List<String> quoteIds, required this.questId, required  Map<String, String> reflection}): _quoteIds = quoteIds,_reflection = reflection,super._();
  factory _JourneyDayPlan.fromJson(Map<String, dynamic> json) => _$JourneyDayPlanFromJson(json);

@override final  int day;
 final  List<String> _quoteIds;
@override List<String> get quoteIds {
  if (_quoteIds is EqualUnmodifiableListView) return _quoteIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_quoteIds);
}

@override final  String questId;
 final  Map<String, String> _reflection;
@override Map<String, String> get reflection {
  if (_reflection is EqualUnmodifiableMapView) return _reflection;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_reflection);
}


/// Create a copy of JourneyDayPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JourneyDayPlanCopyWith<_JourneyDayPlan> get copyWith => __$JourneyDayPlanCopyWithImpl<_JourneyDayPlan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JourneyDayPlanToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JourneyDayPlan&&(identical(other.day, day) || other.day == day)&&const DeepCollectionEquality().equals(other.quoteIds, _quoteIds)&&(identical(other.questId, questId) || other.questId == questId)&&const DeepCollectionEquality().equals(other.reflection, _reflection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,day,const DeepCollectionEquality().hash(_quoteIds),questId,const DeepCollectionEquality().hash(_reflection));
}

@override
String toString() {
    return 'JourneyDayPlan(day: $day, quoteIds: $quoteIds, questId: $questId, reflection: $reflection)';
}


}

/// @nodoc
abstract mixin class _$JourneyDayPlanCopyWith<$Res> implements $JourneyDayPlanCopyWith<$Res> {
  factory _$JourneyDayPlanCopyWith(_JourneyDayPlan value, $Res Function(_JourneyDayPlan) _then) = __$JourneyDayPlanCopyWithImpl;
@override @useResult
$Res call({
 int day, List<String> quoteIds, String questId, Map<String, String> reflection
});




}
/// @nodoc
class __$JourneyDayPlanCopyWithImpl<$Res>
    implements _$JourneyDayPlanCopyWith<$Res> {
  __$JourneyDayPlanCopyWithImpl(this._self, this._then);

  final _JourneyDayPlan _self;
  final $Res Function(_JourneyDayPlan) _then;

/// Create a copy of JourneyDayPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? quoteIds = null,Object? questId = null,Object? reflection = null,}) {
  return _then(_JourneyDayPlan(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,quoteIds: null == quoteIds ? _self._quoteIds : quoteIds // ignore: cast_nullable_to_non_nullable
as List<String>,questId: null == questId ? _self.questId : questId // ignore: cast_nullable_to_non_nullable
as String,reflection: null == reflection ? _self._reflection : reflection // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
