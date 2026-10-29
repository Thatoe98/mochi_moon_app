// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_reading.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DailyReading {

 String get headline; String get body; String get energy; String get love; List<String> get avoid;/// The language the text is actually in, which is English when the asked
/// language has no text.
 String get lang;/// True for the texts bundled with the app, false for server readings.
 bool get isFallback;
/// Create a copy of DailyReading
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyReadingCopyWith<DailyReading> get copyWith => _$DailyReadingCopyWithImpl<DailyReading>(this as DailyReading, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DailyReading;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyReading&&(identical(other.headline, _this.headline) || other.headline == _this.headline)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.energy, _this.energy) || other.energy == _this.energy)&&(identical(other.love, _this.love) || other.love == _this.love)&&const DeepCollectionEquality().equals(other.avoid, _this.avoid)&&(identical(other.lang, _this.lang) || other.lang == _this.lang)&&(identical(other.isFallback, _this.isFallback) || other.isFallback == _this.isFallback));
}


@override
int get hashCode {
  final _this = this as DailyReading;
  return Object.hash(runtimeType,_this.headline,_this.body,_this.energy,_this.love,const DeepCollectionEquality().hash(_this.avoid),_this.lang,_this.isFallback);
}

@override
String toString() {
  final _this = this as DailyReading;
  return 'DailyReading(headline: ${_this.headline}, body: ${_this.body}, energy: ${_this.energy}, love: ${_this.love}, avoid: ${_this.avoid}, lang: ${_this.lang}, isFallback: ${_this.isFallback})';
}


}

/// @nodoc
abstract mixin class $DailyReadingCopyWith<$Res>  {
  factory $DailyReadingCopyWith(DailyReading value, $Res Function(DailyReading) _then) = _$DailyReadingCopyWithImpl;
@useResult
$Res call({
 String headline, String body, String energy, String love, List<String> avoid, String lang, bool isFallback
});




}
/// @nodoc
class _$DailyReadingCopyWithImpl<$Res>
    implements $DailyReadingCopyWith<$Res> {
  _$DailyReadingCopyWithImpl(this._self, this._then);

  final DailyReading _self;
  final $Res Function(DailyReading) _then;

/// Create a copy of DailyReading
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? headline = null,Object? body = null,Object? energy = null,Object? love = null,Object? avoid = null,Object? lang = null,Object? isFallback = null,}) {
  return _then(DailyReading(
headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,energy: null == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as String,love: null == love ? _self.love : love // ignore: cast_nullable_to_non_nullable
as String,avoid: null == avoid ? _self.avoid : avoid // ignore: cast_nullable_to_non_nullable
as List<String>,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String,isFallback: null == isFallback ? _self.isFallback : isFallback // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyReading].
extension DailyReadingPatterns on DailyReading {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyReading value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyReading() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyReading value)  $default,){
final _that = this;
switch (_that) {
case _DailyReading():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyReading value)?  $default,){
final _that = this;
switch (_that) {
case _DailyReading() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String headline,  String body,  String energy,  String love,  List<String> avoid,  String lang,  bool isFallback)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyReading() when $default != null:
return $default(_that.headline,_that.body,_that.energy,_that.love,_that.avoid,_that.lang,_that.isFallback);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String headline,  String body,  String energy,  String love,  List<String> avoid,  String lang,  bool isFallback)  $default,) {final _that = this;
switch (_that) {
case _DailyReading():
return $default(_that.headline,_that.body,_that.energy,_that.love,_that.avoid,_that.lang,_that.isFallback);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String headline,  String body,  String energy,  String love,  List<String> avoid,  String lang,  bool isFallback)?  $default,) {final _that = this;
switch (_that) {
case _DailyReading() when $default != null:
return $default(_that.headline,_that.body,_that.energy,_that.love,_that.avoid,_that.lang,_that.isFallback);case _:
  return null;

}
}

}

/// @nodoc


class _DailyReading implements DailyReading {
  const _DailyReading({required this.headline, required this.body, required this.energy, required this.love, required  List<String> avoid, required this.lang, required this.isFallback}): _avoid = avoid;
  

@override final  String headline;
@override final  String body;
@override final  String energy;
@override final  String love;
 final  List<String> _avoid;
@override List<String> get avoid {
  if (_avoid is EqualUnmodifiableListView) return _avoid;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_avoid);
}

/// The language the text is actually in, which is English when the asked
/// language has no text.
@override final  String lang;
/// True for the texts bundled with the app, false for server readings.
@override final  bool isFallback;

/// Create a copy of DailyReading
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyReadingCopyWith<_DailyReading> get copyWith => __$DailyReadingCopyWithImpl<_DailyReading>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyReading&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.body, body) || other.body == body)&&(identical(other.energy, energy) || other.energy == energy)&&(identical(other.love, love) || other.love == love)&&const DeepCollectionEquality().equals(other.avoid, _avoid)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.isFallback, isFallback) || other.isFallback == isFallback));
}


@override
int get hashCode {
    return Object.hash(runtimeType,headline,body,energy,love,const DeepCollectionEquality().hash(_avoid),lang,isFallback);
}

@override
String toString() {
    return 'DailyReading(headline: $headline, body: $body, energy: $energy, love: $love, avoid: $avoid, lang: $lang, isFallback: $isFallback)';
}


}

/// @nodoc
abstract mixin class _$DailyReadingCopyWith<$Res> implements $DailyReadingCopyWith<$Res> {
  factory _$DailyReadingCopyWith(_DailyReading value, $Res Function(_DailyReading) _then) = __$DailyReadingCopyWithImpl;
@override @useResult
$Res call({
 String headline, String body, String energy, String love, List<String> avoid, String lang, bool isFallback
});




}
/// @nodoc
class __$DailyReadingCopyWithImpl<$Res>
    implements _$DailyReadingCopyWith<$Res> {
  __$DailyReadingCopyWithImpl(this._self, this._then);

  final _DailyReading _self;
  final $Res Function(_DailyReading) _then;

/// Create a copy of DailyReading
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? headline = null,Object? body = null,Object? energy = null,Object? love = null,Object? avoid = null,Object? lang = null,Object? isFallback = null,}) {
  return _then(_DailyReading(
headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,energy: null == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as String,love: null == love ? _self.love : love // ignore: cast_nullable_to_non_nullable
as String,avoid: null == avoid ? _self._avoid : avoid // ignore: cast_nullable_to_non_nullable
as List<String>,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String,isFallback: null == isFallback ? _self.isFallback : isFallback // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
