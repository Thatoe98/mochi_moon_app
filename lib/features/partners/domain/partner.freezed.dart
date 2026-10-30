// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'partner.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Partner {

 String get id; String get nickname;/// Date only; the time part is ignored.
 DateTime get birthDate; DateTime get createdAt;/// Minutes since midnight, local to [birthPlace]. Null when unknown.
 int? get birthMinutes; BirthPlace? get birthPlace;
/// Create a copy of Partner
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartnerCopyWith<Partner> get copyWith => _$PartnerCopyWithImpl<Partner>(this as Partner, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Partner;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Partner&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.nickname, _this.nickname) || other.nickname == _this.nickname)&&(identical(other.birthDate, _this.birthDate) || other.birthDate == _this.birthDate)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.birthMinutes, _this.birthMinutes) || other.birthMinutes == _this.birthMinutes)&&(identical(other.birthPlace, _this.birthPlace) || other.birthPlace == _this.birthPlace));
}


@override
int get hashCode {
  final _this = this as Partner;
  return Object.hash(runtimeType,_this.id,_this.nickname,_this.birthDate,_this.createdAt,_this.birthMinutes,_this.birthPlace);
}

@override
String toString() {
  final _this = this as Partner;
  return 'Partner(id: ${_this.id}, nickname: ${_this.nickname}, birthDate: ${_this.birthDate}, createdAt: ${_this.createdAt}, birthMinutes: ${_this.birthMinutes}, birthPlace: ${_this.birthPlace})';
}


}

/// @nodoc
abstract mixin class $PartnerCopyWith<$Res>  {
  factory $PartnerCopyWith(Partner value, $Res Function(Partner) _then) = _$PartnerCopyWithImpl;
@useResult
$Res call({
 String id, String nickname, DateTime birthDate, DateTime createdAt, int? birthMinutes, BirthPlace? birthPlace
});


$BirthPlaceCopyWith<$Res>? get birthPlace;

}
/// @nodoc
class _$PartnerCopyWithImpl<$Res>
    implements $PartnerCopyWith<$Res> {
  _$PartnerCopyWithImpl(this._self, this._then);

  final Partner _self;
  final $Res Function(Partner) _then;

/// Create a copy of Partner
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nickname = null,Object? birthDate = null,Object? createdAt = null,Object? birthMinutes = freezed,Object? birthPlace = freezed,}) {
  return _then(Partner(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,birthMinutes: freezed == birthMinutes ? _self.birthMinutes : birthMinutes // ignore: cast_nullable_to_non_nullable
as int?,birthPlace: freezed == birthPlace ? _self.birthPlace : birthPlace // ignore: cast_nullable_to_non_nullable
as BirthPlace?,
  ));
}
/// Create a copy of Partner
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BirthPlaceCopyWith<$Res>? get birthPlace {
    if (_self.birthPlace == null) {
    return null;
  }

  return $BirthPlaceCopyWith<$Res>(_self.birthPlace!, (value) {
    return _then(_self.copyWith(birthPlace: value));
  });
}
}


/// Adds pattern-matching-related methods to [Partner].
extension PartnerPatterns on Partner {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Partner value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Partner() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Partner value)  $default,){
final _that = this;
switch (_that) {
case _Partner():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Partner value)?  $default,){
final _that = this;
switch (_that) {
case _Partner() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nickname,  DateTime birthDate,  DateTime createdAt,  int? birthMinutes,  BirthPlace? birthPlace)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Partner() when $default != null:
return $default(_that.id,_that.nickname,_that.birthDate,_that.createdAt,_that.birthMinutes,_that.birthPlace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nickname,  DateTime birthDate,  DateTime createdAt,  int? birthMinutes,  BirthPlace? birthPlace)  $default,) {final _that = this;
switch (_that) {
case _Partner():
return $default(_that.id,_that.nickname,_that.birthDate,_that.createdAt,_that.birthMinutes,_that.birthPlace);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nickname,  DateTime birthDate,  DateTime createdAt,  int? birthMinutes,  BirthPlace? birthPlace)?  $default,) {final _that = this;
switch (_that) {
case _Partner() when $default != null:
return $default(_that.id,_that.nickname,_that.birthDate,_that.createdAt,_that.birthMinutes,_that.birthPlace);case _:
  return null;

}
}

}

/// @nodoc


class _Partner extends Partner {
  const _Partner({required this.id, required this.nickname, required this.birthDate, required this.createdAt, this.birthMinutes, this.birthPlace}): super._();
  

@override final  String id;
@override final  String nickname;
/// Date only; the time part is ignored.
@override final  DateTime birthDate;
@override final  DateTime createdAt;
/// Minutes since midnight, local to [birthPlace]. Null when unknown.
@override final  int? birthMinutes;
@override final  BirthPlace? birthPlace;

/// Create a copy of Partner
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartnerCopyWith<_Partner> get copyWith => __$PartnerCopyWithImpl<_Partner>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Partner&&(identical(other.id, id) || other.id == id)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.birthMinutes, birthMinutes) || other.birthMinutes == birthMinutes)&&(identical(other.birthPlace, birthPlace) || other.birthPlace == birthPlace));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,nickname,birthDate,createdAt,birthMinutes,birthPlace);
}

@override
String toString() {
    return 'Partner(id: $id, nickname: $nickname, birthDate: $birthDate, createdAt: $createdAt, birthMinutes: $birthMinutes, birthPlace: $birthPlace)';
}


}

/// @nodoc
abstract mixin class _$PartnerCopyWith<$Res> implements $PartnerCopyWith<$Res> {
  factory _$PartnerCopyWith(_Partner value, $Res Function(_Partner) _then) = __$PartnerCopyWithImpl;
@override @useResult
$Res call({
 String id, String nickname, DateTime birthDate, DateTime createdAt, int? birthMinutes, BirthPlace? birthPlace
});


@override $BirthPlaceCopyWith<$Res>? get birthPlace;

}
/// @nodoc
class __$PartnerCopyWithImpl<$Res>
    implements _$PartnerCopyWith<$Res> {
  __$PartnerCopyWithImpl(this._self, this._then);

  final _Partner _self;
  final $Res Function(_Partner) _then;

/// Create a copy of Partner
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nickname = null,Object? birthDate = null,Object? createdAt = null,Object? birthMinutes = freezed,Object? birthPlace = freezed,}) {
  return _then(_Partner(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,birthMinutes: freezed == birthMinutes ? _self.birthMinutes : birthMinutes // ignore: cast_nullable_to_non_nullable
as int?,birthPlace: freezed == birthPlace ? _self.birthPlace : birthPlace // ignore: cast_nullable_to_non_nullable
as BirthPlace?,
  ));
}

/// Create a copy of Partner
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BirthPlaceCopyWith<$Res>? get birthPlace {
    if (_self.birthPlace == null) {
    return null;
  }

  return $BirthPlaceCopyWith<$Res>(_self.birthPlace!, (value) {
    return _then(_self.copyWith(birthPlace: value));
  });
}
}

// dart format on
