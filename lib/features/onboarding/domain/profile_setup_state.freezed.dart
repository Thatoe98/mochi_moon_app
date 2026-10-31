// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_setup_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileSetupState {

 ProfileStep get step; String get name; DateTime? get birthDate;/// Birth data is not asked in this flow; it is carried over from a saved
/// profile so finishing never erases it. Minutes since midnight; null is
/// "I don't know".
 int? get birthMinutes; BirthPlace? get birthPlace; bool get reminderEnabled; ReminderTime get reminderTime; List<FocusArea> get focusAreas; bool get saving;
/// Create a copy of ProfileSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileSetupStateCopyWith<ProfileSetupState> get copyWith => _$ProfileSetupStateCopyWithImpl<ProfileSetupState>(this as ProfileSetupState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProfileSetupState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileSetupState&&(identical(other.step, _this.step) || other.step == _this.step)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.birthDate, _this.birthDate) || other.birthDate == _this.birthDate)&&(identical(other.birthMinutes, _this.birthMinutes) || other.birthMinutes == _this.birthMinutes)&&(identical(other.birthPlace, _this.birthPlace) || other.birthPlace == _this.birthPlace)&&(identical(other.reminderEnabled, _this.reminderEnabled) || other.reminderEnabled == _this.reminderEnabled)&&(identical(other.reminderTime, _this.reminderTime) || other.reminderTime == _this.reminderTime)&&const DeepCollectionEquality().equals(other.focusAreas, _this.focusAreas)&&(identical(other.saving, _this.saving) || other.saving == _this.saving));
}


@override
int get hashCode {
  final _this = this as ProfileSetupState;
  return Object.hash(runtimeType,_this.step,_this.name,_this.birthDate,_this.birthMinutes,_this.birthPlace,_this.reminderEnabled,_this.reminderTime,const DeepCollectionEquality().hash(_this.focusAreas),_this.saving);
}

@override
String toString() {
  final _this = this as ProfileSetupState;
  return 'ProfileSetupState(step: ${_this.step}, name: ${_this.name}, birthDate: ${_this.birthDate}, birthMinutes: ${_this.birthMinutes}, birthPlace: ${_this.birthPlace}, reminderEnabled: ${_this.reminderEnabled}, reminderTime: ${_this.reminderTime}, focusAreas: ${_this.focusAreas}, saving: ${_this.saving})';
}


}

/// @nodoc
abstract mixin class $ProfileSetupStateCopyWith<$Res>  {
  factory $ProfileSetupStateCopyWith(ProfileSetupState value, $Res Function(ProfileSetupState) _then) = _$ProfileSetupStateCopyWithImpl;
@useResult
$Res call({
 ProfileStep step, String name, DateTime? birthDate, int? birthMinutes, BirthPlace? birthPlace, bool reminderEnabled, ReminderTime reminderTime, List<FocusArea> focusAreas, bool saving
});


$BirthPlaceCopyWith<$Res>? get birthPlace;$ReminderTimeCopyWith<$Res> get reminderTime;

}
/// @nodoc
class _$ProfileSetupStateCopyWithImpl<$Res>
    implements $ProfileSetupStateCopyWith<$Res> {
  _$ProfileSetupStateCopyWithImpl(this._self, this._then);

  final ProfileSetupState _self;
  final $Res Function(ProfileSetupState) _then;

/// Create a copy of ProfileSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? step = null,Object? name = null,Object? birthDate = freezed,Object? birthMinutes = freezed,Object? birthPlace = freezed,Object? reminderEnabled = null,Object? reminderTime = null,Object? focusAreas = null,Object? saving = null,}) {
  return _then(ProfileSetupState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as ProfileStep,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,birthMinutes: freezed == birthMinutes ? _self.birthMinutes : birthMinutes // ignore: cast_nullable_to_non_nullable
as int?,birthPlace: freezed == birthPlace ? _self.birthPlace : birthPlace // ignore: cast_nullable_to_non_nullable
as BirthPlace?,reminderEnabled: null == reminderEnabled ? _self.reminderEnabled : reminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,reminderTime: null == reminderTime ? _self.reminderTime : reminderTime // ignore: cast_nullable_to_non_nullable
as ReminderTime,focusAreas: null == focusAreas ? _self.focusAreas : focusAreas // ignore: cast_nullable_to_non_nullable
as List<FocusArea>,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ProfileSetupState
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
}/// Create a copy of ProfileSetupState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReminderTimeCopyWith<$Res> get reminderTime {
  
  return $ReminderTimeCopyWith<$Res>(_self.reminderTime, (value) {
    return _then(_self.copyWith(reminderTime: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProfileSetupState].
extension ProfileSetupStatePatterns on ProfileSetupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileSetupState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileSetupState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileSetupState value)  $default,){
final _that = this;
switch (_that) {
case _ProfileSetupState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileSetupState value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileSetupState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProfileStep step,  String name,  DateTime? birthDate,  int? birthMinutes,  BirthPlace? birthPlace,  bool reminderEnabled,  ReminderTime reminderTime,  List<FocusArea> focusAreas,  bool saving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileSetupState() when $default != null:
return $default(_that.step,_that.name,_that.birthDate,_that.birthMinutes,_that.birthPlace,_that.reminderEnabled,_that.reminderTime,_that.focusAreas,_that.saving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProfileStep step,  String name,  DateTime? birthDate,  int? birthMinutes,  BirthPlace? birthPlace,  bool reminderEnabled,  ReminderTime reminderTime,  List<FocusArea> focusAreas,  bool saving)  $default,) {final _that = this;
switch (_that) {
case _ProfileSetupState():
return $default(_that.step,_that.name,_that.birthDate,_that.birthMinutes,_that.birthPlace,_that.reminderEnabled,_that.reminderTime,_that.focusAreas,_that.saving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProfileStep step,  String name,  DateTime? birthDate,  int? birthMinutes,  BirthPlace? birthPlace,  bool reminderEnabled,  ReminderTime reminderTime,  List<FocusArea> focusAreas,  bool saving)?  $default,) {final _that = this;
switch (_that) {
case _ProfileSetupState() when $default != null:
return $default(_that.step,_that.name,_that.birthDate,_that.birthMinutes,_that.birthPlace,_that.reminderEnabled,_that.reminderTime,_that.focusAreas,_that.saving);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileSetupState extends ProfileSetupState {
  const _ProfileSetupState({this.step = ProfileStep.name, this.name = '', this.birthDate, this.birthMinutes, this.birthPlace, this.reminderEnabled = true, this.reminderTime = ReminderTime.defaultTime,  List<FocusArea> focusAreas = const <FocusArea>[], this.saving = false}): _focusAreas = focusAreas,super._();
  

@override@JsonKey() final  ProfileStep step;
@override@JsonKey() final  String name;
@override final  DateTime? birthDate;
/// Birth data is not asked in this flow; it is carried over from a saved
/// profile so finishing never erases it. Minutes since midnight; null is
/// "I don't know".
@override final  int? birthMinutes;
@override final  BirthPlace? birthPlace;
@override@JsonKey() final  bool reminderEnabled;
@override@JsonKey() final  ReminderTime reminderTime;
 final  List<FocusArea> _focusAreas;
@override@JsonKey() List<FocusArea> get focusAreas {
  if (_focusAreas is EqualUnmodifiableListView) return _focusAreas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_focusAreas);
}

@override@JsonKey() final  bool saving;

/// Create a copy of ProfileSetupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileSetupStateCopyWith<_ProfileSetupState> get copyWith => __$ProfileSetupStateCopyWithImpl<_ProfileSetupState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileSetupState&&(identical(other.step, step) || other.step == step)&&(identical(other.name, name) || other.name == name)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.birthMinutes, birthMinutes) || other.birthMinutes == birthMinutes)&&(identical(other.birthPlace, birthPlace) || other.birthPlace == birthPlace)&&(identical(other.reminderEnabled, reminderEnabled) || other.reminderEnabled == reminderEnabled)&&(identical(other.reminderTime, reminderTime) || other.reminderTime == reminderTime)&&const DeepCollectionEquality().equals(other.focusAreas, _focusAreas)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode {
    return Object.hash(runtimeType,step,name,birthDate,birthMinutes,birthPlace,reminderEnabled,reminderTime,const DeepCollectionEquality().hash(_focusAreas),saving);
}

@override
String toString() {
    return 'ProfileSetupState(step: $step, name: $name, birthDate: $birthDate, birthMinutes: $birthMinutes, birthPlace: $birthPlace, reminderEnabled: $reminderEnabled, reminderTime: $reminderTime, focusAreas: $focusAreas, saving: $saving)';
}


}

/// @nodoc
abstract mixin class _$ProfileSetupStateCopyWith<$Res> implements $ProfileSetupStateCopyWith<$Res> {
  factory _$ProfileSetupStateCopyWith(_ProfileSetupState value, $Res Function(_ProfileSetupState) _then) = __$ProfileSetupStateCopyWithImpl;
@override @useResult
$Res call({
 ProfileStep step, String name, DateTime? birthDate, int? birthMinutes, BirthPlace? birthPlace, bool reminderEnabled, ReminderTime reminderTime, List<FocusArea> focusAreas, bool saving
});


@override $BirthPlaceCopyWith<$Res>? get birthPlace;@override $ReminderTimeCopyWith<$Res> get reminderTime;

}
/// @nodoc
class __$ProfileSetupStateCopyWithImpl<$Res>
    implements _$ProfileSetupStateCopyWith<$Res> {
  __$ProfileSetupStateCopyWithImpl(this._self, this._then);

  final _ProfileSetupState _self;
  final $Res Function(_ProfileSetupState) _then;

/// Create a copy of ProfileSetupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? step = null,Object? name = null,Object? birthDate = freezed,Object? birthMinutes = freezed,Object? birthPlace = freezed,Object? reminderEnabled = null,Object? reminderTime = null,Object? focusAreas = null,Object? saving = null,}) {
  return _then(_ProfileSetupState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as ProfileStep,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,birthMinutes: freezed == birthMinutes ? _self.birthMinutes : birthMinutes // ignore: cast_nullable_to_non_nullable
as int?,birthPlace: freezed == birthPlace ? _self.birthPlace : birthPlace // ignore: cast_nullable_to_non_nullable
as BirthPlace?,reminderEnabled: null == reminderEnabled ? _self.reminderEnabled : reminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,reminderTime: null == reminderTime ? _self.reminderTime : reminderTime // ignore: cast_nullable_to_non_nullable
as ReminderTime,focusAreas: null == focusAreas ? _self._focusAreas : focusAreas // ignore: cast_nullable_to_non_nullable
as List<FocusArea>,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ProfileSetupState
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
}/// Create a copy of ProfileSetupState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReminderTimeCopyWith<$Res> get reminderTime {
  
  return $ReminderTimeCopyWith<$Res>(_self.reminderTime, (value) {
    return _then(_self.copyWith(reminderTime: value));
  });
}
}

// dart format on
