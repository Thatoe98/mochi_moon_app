// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_colors.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ThaiDayColor {

 int get weekday; String get name; String get hex;
/// Create a copy of ThaiDayColor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThaiDayColorCopyWith<ThaiDayColor> get copyWith => _$ThaiDayColorCopyWithImpl<ThaiDayColor>(this as ThaiDayColor, _$identity);

  /// Serializes this ThaiDayColor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ThaiDayColor;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThaiDayColor&&(identical(other.weekday, _this.weekday) || other.weekday == _this.weekday)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.hex, _this.hex) || other.hex == _this.hex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ThaiDayColor;
  return Object.hash(runtimeType,_this.weekday,_this.name,_this.hex);
}

@override
String toString() {
  final _this = this as ThaiDayColor;
  return 'ThaiDayColor(weekday: ${_this.weekday}, name: ${_this.name}, hex: ${_this.hex})';
}


}

/// @nodoc
abstract mixin class $ThaiDayColorCopyWith<$Res>  {
  factory $ThaiDayColorCopyWith(ThaiDayColor value, $Res Function(ThaiDayColor) _then) = _$ThaiDayColorCopyWithImpl;
@useResult
$Res call({
 int weekday, String name, String hex
});




}
/// @nodoc
class _$ThaiDayColorCopyWithImpl<$Res>
    implements $ThaiDayColorCopyWith<$Res> {
  _$ThaiDayColorCopyWithImpl(this._self, this._then);

  final ThaiDayColor _self;
  final $Res Function(ThaiDayColor) _then;

/// Create a copy of ThaiDayColor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekday = null,Object? name = null,Object? hex = null,}) {
  return _then(ThaiDayColor(
weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hex: null == hex ? _self.hex : hex // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ThaiDayColor].
extension ThaiDayColorPatterns on ThaiDayColor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ThaiDayColor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ThaiDayColor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ThaiDayColor value)  $default,){
final _that = this;
switch (_that) {
case _ThaiDayColor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ThaiDayColor value)?  $default,){
final _that = this;
switch (_that) {
case _ThaiDayColor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int weekday,  String name,  String hex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ThaiDayColor() when $default != null:
return $default(_that.weekday,_that.name,_that.hex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int weekday,  String name,  String hex)  $default,) {final _that = this;
switch (_that) {
case _ThaiDayColor():
return $default(_that.weekday,_that.name,_that.hex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int weekday,  String name,  String hex)?  $default,) {final _that = this;
switch (_that) {
case _ThaiDayColor() when $default != null:
return $default(_that.weekday,_that.name,_that.hex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ThaiDayColor implements ThaiDayColor {
  const _ThaiDayColor({required this.weekday, required this.name, required this.hex});
  factory _ThaiDayColor.fromJson(Map<String, dynamic> json) => _$ThaiDayColorFromJson(json);

@override final  int weekday;
@override final  String name;
@override final  String hex;

/// Create a copy of ThaiDayColor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ThaiDayColorCopyWith<_ThaiDayColor> get copyWith => __$ThaiDayColorCopyWithImpl<_ThaiDayColor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ThaiDayColorToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ThaiDayColor&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.name, name) || other.name == name)&&(identical(other.hex, hex) || other.hex == hex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,weekday,name,hex);
}

@override
String toString() {
    return 'ThaiDayColor(weekday: $weekday, name: $name, hex: $hex)';
}


}

/// @nodoc
abstract mixin class _$ThaiDayColorCopyWith<$Res> implements $ThaiDayColorCopyWith<$Res> {
  factory _$ThaiDayColorCopyWith(_ThaiDayColor value, $Res Function(_ThaiDayColor) _then) = __$ThaiDayColorCopyWithImpl;
@override @useResult
$Res call({
 int weekday, String name, String hex
});




}
/// @nodoc
class __$ThaiDayColorCopyWithImpl<$Res>
    implements _$ThaiDayColorCopyWith<$Res> {
  __$ThaiDayColorCopyWithImpl(this._self, this._then);

  final _ThaiDayColor _self;
  final $Res Function(_ThaiDayColor) _then;

/// Create a copy of ThaiDayColor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekday = null,Object? name = null,Object? hex = null,}) {
  return _then(_ThaiDayColor(
weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hex: null == hex ? _self.hex : hex // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DayColors {

 Map<Element, List<NamedColor>> get elements; List<ThaiDayColor> get thaiDays;
/// Create a copy of DayColors
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayColorsCopyWith<DayColors> get copyWith => _$DayColorsCopyWithImpl<DayColors>(this as DayColors, _$identity);

  /// Serializes this DayColors to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DayColors;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayColors&&const DeepCollectionEquality().equals(other.elements, _this.elements)&&const DeepCollectionEquality().equals(other.thaiDays, _this.thaiDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DayColors;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.elements),const DeepCollectionEquality().hash(_this.thaiDays));
}

@override
String toString() {
  final _this = this as DayColors;
  return 'DayColors(elements: ${_this.elements}, thaiDays: ${_this.thaiDays})';
}


}

/// @nodoc
abstract mixin class $DayColorsCopyWith<$Res>  {
  factory $DayColorsCopyWith(DayColors value, $Res Function(DayColors) _then) = _$DayColorsCopyWithImpl;
@useResult
$Res call({
 Map<Element, List<NamedColor>> elements, List<ThaiDayColor> thaiDays
});




}
/// @nodoc
class _$DayColorsCopyWithImpl<$Res>
    implements $DayColorsCopyWith<$Res> {
  _$DayColorsCopyWithImpl(this._self, this._then);

  final DayColors _self;
  final $Res Function(DayColors) _then;

/// Create a copy of DayColors
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? elements = null,Object? thaiDays = null,}) {
  return _then(DayColors(
elements: null == elements ? _self.elements : elements // ignore: cast_nullable_to_non_nullable
as Map<Element, List<NamedColor>>,thaiDays: null == thaiDays ? _self.thaiDays : thaiDays // ignore: cast_nullable_to_non_nullable
as List<ThaiDayColor>,
  ));
}

}


/// Adds pattern-matching-related methods to [DayColors].
extension DayColorsPatterns on DayColors {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayColors value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayColors() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayColors value)  $default,){
final _that = this;
switch (_that) {
case _DayColors():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayColors value)?  $default,){
final _that = this;
switch (_that) {
case _DayColors() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<Element, List<NamedColor>> elements,  List<ThaiDayColor> thaiDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DayColors() when $default != null:
return $default(_that.elements,_that.thaiDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<Element, List<NamedColor>> elements,  List<ThaiDayColor> thaiDays)  $default,) {final _that = this;
switch (_that) {
case _DayColors():
return $default(_that.elements,_that.thaiDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<Element, List<NamedColor>> elements,  List<ThaiDayColor> thaiDays)?  $default,) {final _that = this;
switch (_that) {
case _DayColors() when $default != null:
return $default(_that.elements,_that.thaiDays);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DayColors implements DayColors {
  const _DayColors({required  Map<Element, List<NamedColor>> elements, required  List<ThaiDayColor> thaiDays}): _elements = elements,_thaiDays = thaiDays;
  factory _DayColors.fromJson(Map<String, dynamic> json) => _$DayColorsFromJson(json);

 final  Map<Element, List<NamedColor>> _elements;
@override Map<Element, List<NamedColor>> get elements {
  if (_elements is EqualUnmodifiableMapView) return _elements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_elements);
}

 final  List<ThaiDayColor> _thaiDays;
@override List<ThaiDayColor> get thaiDays {
  if (_thaiDays is EqualUnmodifiableListView) return _thaiDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_thaiDays);
}


/// Create a copy of DayColors
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayColorsCopyWith<_DayColors> get copyWith => __$DayColorsCopyWithImpl<_DayColors>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DayColorsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayColors&&const DeepCollectionEquality().equals(other.elements, _elements)&&const DeepCollectionEquality().equals(other.thaiDays, _thaiDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_elements),const DeepCollectionEquality().hash(_thaiDays));
}

@override
String toString() {
    return 'DayColors(elements: $elements, thaiDays: $thaiDays)';
}


}

/// @nodoc
abstract mixin class _$DayColorsCopyWith<$Res> implements $DayColorsCopyWith<$Res> {
  factory _$DayColorsCopyWith(_DayColors value, $Res Function(_DayColors) _then) = __$DayColorsCopyWithImpl;
@override @useResult
$Res call({
 Map<Element, List<NamedColor>> elements, List<ThaiDayColor> thaiDays
});




}
/// @nodoc
class __$DayColorsCopyWithImpl<$Res>
    implements _$DayColorsCopyWith<$Res> {
  __$DayColorsCopyWithImpl(this._self, this._then);

  final _DayColors _self;
  final $Res Function(_DayColors) _then;

/// Create a copy of DayColors
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? elements = null,Object? thaiDays = null,}) {
  return _then(_DayColors(
elements: null == elements ? _self._elements : elements // ignore: cast_nullable_to_non_nullable
as Map<Element, List<NamedColor>>,thaiDays: null == thaiDays ? _self._thaiDays : thaiDays // ignore: cast_nullable_to_non_nullable
as List<ThaiDayColor>,
  ));
}


}

// dart format on
