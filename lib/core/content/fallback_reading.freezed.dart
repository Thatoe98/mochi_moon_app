// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fallback_reading.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FallbackReading {

 String get headline; String get body; String get energy; String get love; List<String> get avoid;
/// Create a copy of FallbackReading
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FallbackReadingCopyWith<FallbackReading> get copyWith => _$FallbackReadingCopyWithImpl<FallbackReading>(this as FallbackReading, _$identity);

  /// Serializes this FallbackReading to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FallbackReading;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FallbackReading&&(identical(other.headline, _this.headline) || other.headline == _this.headline)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.energy, _this.energy) || other.energy == _this.energy)&&(identical(other.love, _this.love) || other.love == _this.love)&&const DeepCollectionEquality().equals(other.avoid, _this.avoid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FallbackReading;
  return Object.hash(runtimeType,_this.headline,_this.body,_this.energy,_this.love,const DeepCollectionEquality().hash(_this.avoid));
}

@override
String toString() {
  final _this = this as FallbackReading;
  return 'FallbackReading(headline: ${_this.headline}, body: ${_this.body}, energy: ${_this.energy}, love: ${_this.love}, avoid: ${_this.avoid})';
}


}

/// @nodoc
abstract mixin class $FallbackReadingCopyWith<$Res>  {
  factory $FallbackReadingCopyWith(FallbackReading value, $Res Function(FallbackReading) _then) = _$FallbackReadingCopyWithImpl;
@useResult
$Res call({
 String headline, String body, String energy, String love, List<String> avoid
});




}
/// @nodoc
class _$FallbackReadingCopyWithImpl<$Res>
    implements $FallbackReadingCopyWith<$Res> {
  _$FallbackReadingCopyWithImpl(this._self, this._then);

  final FallbackReading _self;
  final $Res Function(FallbackReading) _then;

/// Create a copy of FallbackReading
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? headline = null,Object? body = null,Object? energy = null,Object? love = null,Object? avoid = null,}) {
  return _then(FallbackReading(
headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,energy: null == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as String,love: null == love ? _self.love : love // ignore: cast_nullable_to_non_nullable
as String,avoid: null == avoid ? _self.avoid : avoid // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [FallbackReading].
extension FallbackReadingPatterns on FallbackReading {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FallbackReading value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FallbackReading() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FallbackReading value)  $default,){
final _that = this;
switch (_that) {
case _FallbackReading():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FallbackReading value)?  $default,){
final _that = this;
switch (_that) {
case _FallbackReading() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String headline,  String body,  String energy,  String love,  List<String> avoid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FallbackReading() when $default != null:
return $default(_that.headline,_that.body,_that.energy,_that.love,_that.avoid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String headline,  String body,  String energy,  String love,  List<String> avoid)  $default,) {final _that = this;
switch (_that) {
case _FallbackReading():
return $default(_that.headline,_that.body,_that.energy,_that.love,_that.avoid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String headline,  String body,  String energy,  String love,  List<String> avoid)?  $default,) {final _that = this;
switch (_that) {
case _FallbackReading() when $default != null:
return $default(_that.headline,_that.body,_that.energy,_that.love,_that.avoid);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FallbackReading implements FallbackReading {
  const _FallbackReading({required this.headline, required this.body, required this.energy, required this.love, required  List<String> avoid}): _avoid = avoid;
  factory _FallbackReading.fromJson(Map<String, dynamic> json) => _$FallbackReadingFromJson(json);

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


/// Create a copy of FallbackReading
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FallbackReadingCopyWith<_FallbackReading> get copyWith => __$FallbackReadingCopyWithImpl<_FallbackReading>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FallbackReadingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FallbackReading&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.body, body) || other.body == body)&&(identical(other.energy, energy) || other.energy == energy)&&(identical(other.love, love) || other.love == love)&&const DeepCollectionEquality().equals(other.avoid, _avoid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,headline,body,energy,love,const DeepCollectionEquality().hash(_avoid));
}

@override
String toString() {
    return 'FallbackReading(headline: $headline, body: $body, energy: $energy, love: $love, avoid: $avoid)';
}


}

/// @nodoc
abstract mixin class _$FallbackReadingCopyWith<$Res> implements $FallbackReadingCopyWith<$Res> {
  factory _$FallbackReadingCopyWith(_FallbackReading value, $Res Function(_FallbackReading) _then) = __$FallbackReadingCopyWithImpl;
@override @useResult
$Res call({
 String headline, String body, String energy, String love, List<String> avoid
});




}
/// @nodoc
class __$FallbackReadingCopyWithImpl<$Res>
    implements _$FallbackReadingCopyWith<$Res> {
  __$FallbackReadingCopyWithImpl(this._self, this._then);

  final _FallbackReading _self;
  final $Res Function(_FallbackReading) _then;

/// Create a copy of FallbackReading
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? headline = null,Object? body = null,Object? energy = null,Object? love = null,Object? avoid = null,}) {
  return _then(_FallbackReading(
headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,energy: null == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as String,love: null == love ? _self.love : love // ignore: cast_nullable_to_non_nullable
as String,avoid: null == avoid ? _self._avoid : avoid // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
