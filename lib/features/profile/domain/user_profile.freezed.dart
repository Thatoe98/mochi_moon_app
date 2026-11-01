// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserProfile {

 String get displayName;/// Date only; the time part is ignored. Null until the user unlocks Cosmic.
 DateTime? get birthDate;/// Minutes since midnight, local to the birthplace. Null means the user
/// does not know the birth time.
 int? get birthMinutes;/// Required in the first-run flow when the birth time is known.
 BirthPlace? get birthPlace; List<FocusArea> get focusAreas;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UserProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.birthDate, _this.birthDate) || other.birthDate == _this.birthDate)&&(identical(other.birthMinutes, _this.birthMinutes) || other.birthMinutes == _this.birthMinutes)&&(identical(other.birthPlace, _this.birthPlace) || other.birthPlace == _this.birthPlace)&&const DeepCollectionEquality().equals(other.focusAreas, _this.focusAreas));
}


@override
int get hashCode {
  final _this = this as UserProfile;
  return Object.hash(runtimeType,_this.displayName,_this.birthDate,_this.birthMinutes,_this.birthPlace,const DeepCollectionEquality().hash(_this.focusAreas));
}

@override
String toString() {
  final _this = this as UserProfile;
  return 'UserProfile(displayName: ${_this.displayName}, birthDate: ${_this.birthDate}, birthMinutes: ${_this.birthMinutes}, birthPlace: ${_this.birthPlace}, focusAreas: ${_this.focusAreas})';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String displayName, DateTime? birthDate, int? birthMinutes, BirthPlace? birthPlace, List<FocusArea> focusAreas
});


$BirthPlaceCopyWith<$Res>? get birthPlace;

}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayName = null,Object? birthDate = freezed,Object? birthMinutes = freezed,Object? birthPlace = freezed,Object? focusAreas = null,}) {
  return _then(UserProfile(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,birthMinutes: freezed == birthMinutes ? _self.birthMinutes : birthMinutes // ignore: cast_nullable_to_non_nullable
as int?,birthPlace: freezed == birthPlace ? _self.birthPlace : birthPlace // ignore: cast_nullable_to_non_nullable
as BirthPlace?,focusAreas: null == focusAreas ? _self.focusAreas : focusAreas // ignore: cast_nullable_to_non_nullable
as List<FocusArea>,
  ));
}
/// Create a copy of UserProfile
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


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String displayName,  DateTime? birthDate,  int? birthMinutes,  BirthPlace? birthPlace,  List<FocusArea> focusAreas)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.displayName,_that.birthDate,_that.birthMinutes,_that.birthPlace,_that.focusAreas);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String displayName,  DateTime? birthDate,  int? birthMinutes,  BirthPlace? birthPlace,  List<FocusArea> focusAreas)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.displayName,_that.birthDate,_that.birthMinutes,_that.birthPlace,_that.focusAreas);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String displayName,  DateTime? birthDate,  int? birthMinutes,  BirthPlace? birthPlace,  List<FocusArea> focusAreas)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.displayName,_that.birthDate,_that.birthMinutes,_that.birthPlace,_that.focusAreas);case _:
  return null;

}
}

}

/// @nodoc


class _UserProfile extends UserProfile {
  const _UserProfile({this.displayName = '', this.birthDate, this.birthMinutes, this.birthPlace,  List<FocusArea> focusAreas = const <FocusArea>[]}): _focusAreas = focusAreas,super._();
  

@override@JsonKey() final  String displayName;
/// Date only; the time part is ignored. Null until the user unlocks Cosmic.
@override final  DateTime? birthDate;
/// Minutes since midnight, local to the birthplace. Null means the user
/// does not know the birth time.
@override final  int? birthMinutes;
/// Required in the first-run flow when the birth time is known.
@override final  BirthPlace? birthPlace;
 final  List<FocusArea> _focusAreas;
@override@JsonKey() List<FocusArea> get focusAreas {
  if (_focusAreas is EqualUnmodifiableListView) return _focusAreas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_focusAreas);
}


/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.birthMinutes, birthMinutes) || other.birthMinutes == birthMinutes)&&(identical(other.birthPlace, birthPlace) || other.birthPlace == birthPlace)&&const DeepCollectionEquality().equals(other.focusAreas, _focusAreas));
}


@override
int get hashCode {
    return Object.hash(runtimeType,displayName,birthDate,birthMinutes,birthPlace,const DeepCollectionEquality().hash(_focusAreas));
}

@override
String toString() {
    return 'UserProfile(displayName: $displayName, birthDate: $birthDate, birthMinutes: $birthMinutes, birthPlace: $birthPlace, focusAreas: $focusAreas)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String displayName, DateTime? birthDate, int? birthMinutes, BirthPlace? birthPlace, List<FocusArea> focusAreas
});


@override $BirthPlaceCopyWith<$Res>? get birthPlace;

}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayName = null,Object? birthDate = freezed,Object? birthMinutes = freezed,Object? birthPlace = freezed,Object? focusAreas = null,}) {
  return _then(_UserProfile(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,birthMinutes: freezed == birthMinutes ? _self.birthMinutes : birthMinutes // ignore: cast_nullable_to_non_nullable
as int?,birthPlace: freezed == birthPlace ? _self.birthPlace : birthPlace // ignore: cast_nullable_to_non_nullable
as BirthPlace?,focusAreas: null == focusAreas ? _self._focusAreas : focusAreas // ignore: cast_nullable_to_non_nullable
as List<FocusArea>,
  ));
}

/// Create a copy of UserProfile
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
