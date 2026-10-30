// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'partner_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PartnerDraft {

 String get nickname; DateTime? get birthDate;/// Minutes since midnight; null is "I don't know".
 int? get birthMinutes; BirthPlace? get birthPlace;
/// Create a copy of PartnerDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartnerDraftCopyWith<PartnerDraft> get copyWith => _$PartnerDraftCopyWithImpl<PartnerDraft>(this as PartnerDraft, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PartnerDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartnerDraft&&(identical(other.nickname, _this.nickname) || other.nickname == _this.nickname)&&(identical(other.birthDate, _this.birthDate) || other.birthDate == _this.birthDate)&&(identical(other.birthMinutes, _this.birthMinutes) || other.birthMinutes == _this.birthMinutes)&&(identical(other.birthPlace, _this.birthPlace) || other.birthPlace == _this.birthPlace));
}


@override
int get hashCode {
  final _this = this as PartnerDraft;
  return Object.hash(runtimeType,_this.nickname,_this.birthDate,_this.birthMinutes,_this.birthPlace);
}

@override
String toString() {
  final _this = this as PartnerDraft;
  return 'PartnerDraft(nickname: ${_this.nickname}, birthDate: ${_this.birthDate}, birthMinutes: ${_this.birthMinutes}, birthPlace: ${_this.birthPlace})';
}


}

/// @nodoc
abstract mixin class $PartnerDraftCopyWith<$Res>  {
  factory $PartnerDraftCopyWith(PartnerDraft value, $Res Function(PartnerDraft) _then) = _$PartnerDraftCopyWithImpl;
@useResult
$Res call({
 String nickname, DateTime? birthDate, int? birthMinutes, BirthPlace? birthPlace
});


$BirthPlaceCopyWith<$Res>? get birthPlace;

}
/// @nodoc
class _$PartnerDraftCopyWithImpl<$Res>
    implements $PartnerDraftCopyWith<$Res> {
  _$PartnerDraftCopyWithImpl(this._self, this._then);

  final PartnerDraft _self;
  final $Res Function(PartnerDraft) _then;

/// Create a copy of PartnerDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nickname = null,Object? birthDate = freezed,Object? birthMinutes = freezed,Object? birthPlace = freezed,}) {
  return _then(PartnerDraft(
nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,birthMinutes: freezed == birthMinutes ? _self.birthMinutes : birthMinutes // ignore: cast_nullable_to_non_nullable
as int?,birthPlace: freezed == birthPlace ? _self.birthPlace : birthPlace // ignore: cast_nullable_to_non_nullable
as BirthPlace?,
  ));
}
/// Create a copy of PartnerDraft
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


/// Adds pattern-matching-related methods to [PartnerDraft].
extension PartnerDraftPatterns on PartnerDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartnerDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartnerDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartnerDraft value)  $default,){
final _that = this;
switch (_that) {
case _PartnerDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartnerDraft value)?  $default,){
final _that = this;
switch (_that) {
case _PartnerDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nickname,  DateTime? birthDate,  int? birthMinutes,  BirthPlace? birthPlace)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartnerDraft() when $default != null:
return $default(_that.nickname,_that.birthDate,_that.birthMinutes,_that.birthPlace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nickname,  DateTime? birthDate,  int? birthMinutes,  BirthPlace? birthPlace)  $default,) {final _that = this;
switch (_that) {
case _PartnerDraft():
return $default(_that.nickname,_that.birthDate,_that.birthMinutes,_that.birthPlace);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nickname,  DateTime? birthDate,  int? birthMinutes,  BirthPlace? birthPlace)?  $default,) {final _that = this;
switch (_that) {
case _PartnerDraft() when $default != null:
return $default(_that.nickname,_that.birthDate,_that.birthMinutes,_that.birthPlace);case _:
  return null;

}
}

}

/// @nodoc


class _PartnerDraft extends PartnerDraft {
  const _PartnerDraft({this.nickname = '', this.birthDate, this.birthMinutes, this.birthPlace}): super._();
  

@override@JsonKey() final  String nickname;
@override final  DateTime? birthDate;
/// Minutes since midnight; null is "I don't know".
@override final  int? birthMinutes;
@override final  BirthPlace? birthPlace;

/// Create a copy of PartnerDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartnerDraftCopyWith<_PartnerDraft> get copyWith => __$PartnerDraftCopyWithImpl<_PartnerDraft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartnerDraft&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.birthMinutes, birthMinutes) || other.birthMinutes == birthMinutes)&&(identical(other.birthPlace, birthPlace) || other.birthPlace == birthPlace));
}


@override
int get hashCode {
    return Object.hash(runtimeType,nickname,birthDate,birthMinutes,birthPlace);
}

@override
String toString() {
    return 'PartnerDraft(nickname: $nickname, birthDate: $birthDate, birthMinutes: $birthMinutes, birthPlace: $birthPlace)';
}


}

/// @nodoc
abstract mixin class _$PartnerDraftCopyWith<$Res> implements $PartnerDraftCopyWith<$Res> {
  factory _$PartnerDraftCopyWith(_PartnerDraft value, $Res Function(_PartnerDraft) _then) = __$PartnerDraftCopyWithImpl;
@override @useResult
$Res call({
 String nickname, DateTime? birthDate, int? birthMinutes, BirthPlace? birthPlace
});


@override $BirthPlaceCopyWith<$Res>? get birthPlace;

}
/// @nodoc
class __$PartnerDraftCopyWithImpl<$Res>
    implements _$PartnerDraftCopyWith<$Res> {
  __$PartnerDraftCopyWithImpl(this._self, this._then);

  final _PartnerDraft _self;
  final $Res Function(_PartnerDraft) _then;

/// Create a copy of PartnerDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nickname = null,Object? birthDate = freezed,Object? birthMinutes = freezed,Object? birthPlace = freezed,}) {
  return _then(_PartnerDraft(
nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,birthMinutes: freezed == birthMinutes ? _self.birthMinutes : birthMinutes // ignore: cast_nullable_to_non_nullable
as int?,birthPlace: freezed == birthPlace ? _self.birthPlace : birthPlace // ignore: cast_nullable_to_non_nullable
as BirthPlace?,
  ));
}

/// Create a copy of PartnerDraft
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
