// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'birth_place.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BirthPlace {

 String get name; String get region; String get countryCode; double get lat; double get lng; String get tzId;
/// Create a copy of BirthPlace
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BirthPlaceCopyWith<BirthPlace> get copyWith => _$BirthPlaceCopyWithImpl<BirthPlace>(this as BirthPlace, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BirthPlace;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BirthPlace&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.region, _this.region) || other.region == _this.region)&&(identical(other.countryCode, _this.countryCode) || other.countryCode == _this.countryCode)&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lng, _this.lng) || other.lng == _this.lng)&&(identical(other.tzId, _this.tzId) || other.tzId == _this.tzId));
}


@override
int get hashCode {
  final _this = this as BirthPlace;
  return Object.hash(runtimeType,_this.name,_this.region,_this.countryCode,_this.lat,_this.lng,_this.tzId);
}

@override
String toString() {
  final _this = this as BirthPlace;
  return 'BirthPlace(name: ${_this.name}, region: ${_this.region}, countryCode: ${_this.countryCode}, lat: ${_this.lat}, lng: ${_this.lng}, tzId: ${_this.tzId})';
}


}

/// @nodoc
abstract mixin class $BirthPlaceCopyWith<$Res>  {
  factory $BirthPlaceCopyWith(BirthPlace value, $Res Function(BirthPlace) _then) = _$BirthPlaceCopyWithImpl;
@useResult
$Res call({
 String name, String region, String countryCode, double lat, double lng, String tzId
});




}
/// @nodoc
class _$BirthPlaceCopyWithImpl<$Res>
    implements $BirthPlaceCopyWith<$Res> {
  _$BirthPlaceCopyWithImpl(this._self, this._then);

  final BirthPlace _self;
  final $Res Function(BirthPlace) _then;

/// Create a copy of BirthPlace
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? region = null,Object? countryCode = null,Object? lat = null,Object? lng = null,Object? tzId = null,}) {
  return _then(BirthPlace(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,tzId: null == tzId ? _self.tzId : tzId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BirthPlace].
extension BirthPlacePatterns on BirthPlace {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BirthPlace value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BirthPlace() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BirthPlace value)  $default,){
final _that = this;
switch (_that) {
case _BirthPlace():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BirthPlace value)?  $default,){
final _that = this;
switch (_that) {
case _BirthPlace() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String region,  String countryCode,  double lat,  double lng,  String tzId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BirthPlace() when $default != null:
return $default(_that.name,_that.region,_that.countryCode,_that.lat,_that.lng,_that.tzId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String region,  String countryCode,  double lat,  double lng,  String tzId)  $default,) {final _that = this;
switch (_that) {
case _BirthPlace():
return $default(_that.name,_that.region,_that.countryCode,_that.lat,_that.lng,_that.tzId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String region,  String countryCode,  double lat,  double lng,  String tzId)?  $default,) {final _that = this;
switch (_that) {
case _BirthPlace() when $default != null:
return $default(_that.name,_that.region,_that.countryCode,_that.lat,_that.lng,_that.tzId);case _:
  return null;

}
}

}

/// @nodoc


class _BirthPlace implements BirthPlace {
  const _BirthPlace({required this.name, required this.region, required this.countryCode, required this.lat, required this.lng, required this.tzId});
  

@override final  String name;
@override final  String region;
@override final  String countryCode;
@override final  double lat;
@override final  double lng;
@override final  String tzId;

/// Create a copy of BirthPlace
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BirthPlaceCopyWith<_BirthPlace> get copyWith => __$BirthPlaceCopyWithImpl<_BirthPlace>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BirthPlace&&(identical(other.name, name) || other.name == name)&&(identical(other.region, region) || other.region == region)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.tzId, tzId) || other.tzId == tzId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,region,countryCode,lat,lng,tzId);
}

@override
String toString() {
    return 'BirthPlace(name: $name, region: $region, countryCode: $countryCode, lat: $lat, lng: $lng, tzId: $tzId)';
}


}

/// @nodoc
abstract mixin class _$BirthPlaceCopyWith<$Res> implements $BirthPlaceCopyWith<$Res> {
  factory _$BirthPlaceCopyWith(_BirthPlace value, $Res Function(_BirthPlace) _then) = __$BirthPlaceCopyWithImpl;
@override @useResult
$Res call({
 String name, String region, String countryCode, double lat, double lng, String tzId
});




}
/// @nodoc
class __$BirthPlaceCopyWithImpl<$Res>
    implements _$BirthPlaceCopyWith<$Res> {
  __$BirthPlaceCopyWithImpl(this._self, this._then);

  final _BirthPlace _self;
  final $Res Function(_BirthPlace) _then;

/// Create a copy of BirthPlace
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? region = null,Object? countryCode = null,Object? lat = null,Object? lng = null,Object? tzId = null,}) {
  return _then(_BirthPlace(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,tzId: null == tzId ? _self.tzId : tzId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
