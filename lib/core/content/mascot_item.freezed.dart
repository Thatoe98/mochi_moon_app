// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mascot_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MascotUnlock {

 String get type; Object get value;
/// Create a copy of MascotUnlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MascotUnlockCopyWith<MascotUnlock> get copyWith => _$MascotUnlockCopyWithImpl<MascotUnlock>(this as MascotUnlock, _$identity);

  /// Serializes this MascotUnlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MascotUnlock;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MascotUnlock&&(identical(other.type, _this.type) || other.type == _this.type)&&const DeepCollectionEquality().equals(other.value, _this.value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MascotUnlock;
  return Object.hash(runtimeType,_this.type,const DeepCollectionEquality().hash(_this.value));
}

@override
String toString() {
  final _this = this as MascotUnlock;
  return 'MascotUnlock(type: ${_this.type}, value: ${_this.value})';
}


}

/// @nodoc
abstract mixin class $MascotUnlockCopyWith<$Res>  {
  factory $MascotUnlockCopyWith(MascotUnlock value, $Res Function(MascotUnlock) _then) = _$MascotUnlockCopyWithImpl;
@useResult
$Res call({
 String type, Object value
});




}
/// @nodoc
class _$MascotUnlockCopyWithImpl<$Res>
    implements $MascotUnlockCopyWith<$Res> {
  _$MascotUnlockCopyWithImpl(this._self, this._then);

  final MascotUnlock _self;
  final $Res Function(MascotUnlock) _then;

/// Create a copy of MascotUnlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? value = null,}) {
  return _then(MascotUnlock(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value ,
  ));
}

}


/// Adds pattern-matching-related methods to [MascotUnlock].
extension MascotUnlockPatterns on MascotUnlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MascotUnlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MascotUnlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MascotUnlock value)  $default,){
final _that = this;
switch (_that) {
case _MascotUnlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MascotUnlock value)?  $default,){
final _that = this;
switch (_that) {
case _MascotUnlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  Object value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MascotUnlock() when $default != null:
return $default(_that.type,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  Object value)  $default,) {final _that = this;
switch (_that) {
case _MascotUnlock():
return $default(_that.type,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  Object value)?  $default,) {final _that = this;
switch (_that) {
case _MascotUnlock() when $default != null:
return $default(_that.type,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MascotUnlock implements MascotUnlock {
  const _MascotUnlock({required this.type, required this.value});
  factory _MascotUnlock.fromJson(Map<String, dynamic> json) => _$MascotUnlockFromJson(json);

@override final  String type;
@override final  Object value;

/// Create a copy of MascotUnlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MascotUnlockCopyWith<_MascotUnlock> get copyWith => __$MascotUnlockCopyWithImpl<_MascotUnlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MascotUnlockToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MascotUnlock&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.value, value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,const DeepCollectionEquality().hash(value));
}

@override
String toString() {
    return 'MascotUnlock(type: $type, value: $value)';
}


}

/// @nodoc
abstract mixin class _$MascotUnlockCopyWith<$Res> implements $MascotUnlockCopyWith<$Res> {
  factory _$MascotUnlockCopyWith(_MascotUnlock value, $Res Function(_MascotUnlock) _then) = __$MascotUnlockCopyWithImpl;
@override @useResult
$Res call({
 String type, Object value
});




}
/// @nodoc
class __$MascotUnlockCopyWithImpl<$Res>
    implements _$MascotUnlockCopyWith<$Res> {
  __$MascotUnlockCopyWithImpl(this._self, this._then);

  final _MascotUnlock _self;
  final $Res Function(_MascotUnlock) _then;

/// Create a copy of MascotUnlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? value = null,}) {
  return _then(_MascotUnlock(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value ,
  ));
}


}


/// @nodoc
mixin _$MascotItem {

 String get id;/// `outfit`, or a room slot such as `shelf` or `floor`.
 String get slot; Map<String, String> get name; MascotUnlock get unlock; String get illustrationId; bool get premium;
/// Create a copy of MascotItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MascotItemCopyWith<MascotItem> get copyWith => _$MascotItemCopyWithImpl<MascotItem>(this as MascotItem, _$identity);

  /// Serializes this MascotItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MascotItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MascotItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slot, _this.slot) || other.slot == _this.slot)&&const DeepCollectionEquality().equals(other.name, _this.name)&&(identical(other.unlock, _this.unlock) || other.unlock == _this.unlock)&&(identical(other.illustrationId, _this.illustrationId) || other.illustrationId == _this.illustrationId)&&(identical(other.premium, _this.premium) || other.premium == _this.premium));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MascotItem;
  return Object.hash(runtimeType,_this.id,_this.slot,const DeepCollectionEquality().hash(_this.name),_this.unlock,_this.illustrationId,_this.premium);
}

@override
String toString() {
  final _this = this as MascotItem;
  return 'MascotItem(id: ${_this.id}, slot: ${_this.slot}, name: ${_this.name}, unlock: ${_this.unlock}, illustrationId: ${_this.illustrationId}, premium: ${_this.premium})';
}


}

/// @nodoc
abstract mixin class $MascotItemCopyWith<$Res>  {
  factory $MascotItemCopyWith(MascotItem value, $Res Function(MascotItem) _then) = _$MascotItemCopyWithImpl;
@useResult
$Res call({
 String id, String slot, Map<String, String> name, MascotUnlock unlock, String illustrationId, bool premium
});


$MascotUnlockCopyWith<$Res> get unlock;

}
/// @nodoc
class _$MascotItemCopyWithImpl<$Res>
    implements $MascotItemCopyWith<$Res> {
  _$MascotItemCopyWithImpl(this._self, this._then);

  final MascotItem _self;
  final $Res Function(MascotItem) _then;

/// Create a copy of MascotItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slot = null,Object? name = null,Object? unlock = null,Object? illustrationId = null,Object? premium = null,}) {
  return _then(MascotItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as Map<String, String>,unlock: null == unlock ? _self.unlock : unlock // ignore: cast_nullable_to_non_nullable
as MascotUnlock,illustrationId: null == illustrationId ? _self.illustrationId : illustrationId // ignore: cast_nullable_to_non_nullable
as String,premium: null == premium ? _self.premium : premium // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of MascotItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MascotUnlockCopyWith<$Res> get unlock {
  
  return $MascotUnlockCopyWith<$Res>(_self.unlock, (value) {
    return _then(_self.copyWith(unlock: value));
  });
}
}


/// Adds pattern-matching-related methods to [MascotItem].
extension MascotItemPatterns on MascotItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MascotItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MascotItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MascotItem value)  $default,){
final _that = this;
switch (_that) {
case _MascotItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MascotItem value)?  $default,){
final _that = this;
switch (_that) {
case _MascotItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slot,  Map<String, String> name,  MascotUnlock unlock,  String illustrationId,  bool premium)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MascotItem() when $default != null:
return $default(_that.id,_that.slot,_that.name,_that.unlock,_that.illustrationId,_that.premium);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slot,  Map<String, String> name,  MascotUnlock unlock,  String illustrationId,  bool premium)  $default,) {final _that = this;
switch (_that) {
case _MascotItem():
return $default(_that.id,_that.slot,_that.name,_that.unlock,_that.illustrationId,_that.premium);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slot,  Map<String, String> name,  MascotUnlock unlock,  String illustrationId,  bool premium)?  $default,) {final _that = this;
switch (_that) {
case _MascotItem() when $default != null:
return $default(_that.id,_that.slot,_that.name,_that.unlock,_that.illustrationId,_that.premium);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MascotItem extends MascotItem {
  const _MascotItem({required this.id, required this.slot, required  Map<String, String> name, required this.unlock, required this.illustrationId, this.premium = false}): _name = name,super._();
  factory _MascotItem.fromJson(Map<String, dynamic> json) => _$MascotItemFromJson(json);

@override final  String id;
/// `outfit`, or a room slot such as `shelf` or `floor`.
@override final  String slot;
 final  Map<String, String> _name;
@override Map<String, String> get name {
  if (_name is EqualUnmodifiableMapView) return _name;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_name);
}

@override final  MascotUnlock unlock;
@override final  String illustrationId;
@override@JsonKey() final  bool premium;

/// Create a copy of MascotItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MascotItemCopyWith<_MascotItem> get copyWith => __$MascotItemCopyWithImpl<_MascotItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MascotItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MascotItem&&(identical(other.id, id) || other.id == id)&&(identical(other.slot, slot) || other.slot == slot)&&const DeepCollectionEquality().equals(other.name, _name)&&(identical(other.unlock, unlock) || other.unlock == unlock)&&(identical(other.illustrationId, illustrationId) || other.illustrationId == illustrationId)&&(identical(other.premium, premium) || other.premium == premium));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,slot,const DeepCollectionEquality().hash(_name),unlock,illustrationId,premium);
}

@override
String toString() {
    return 'MascotItem(id: $id, slot: $slot, name: $name, unlock: $unlock, illustrationId: $illustrationId, premium: $premium)';
}


}

/// @nodoc
abstract mixin class _$MascotItemCopyWith<$Res> implements $MascotItemCopyWith<$Res> {
  factory _$MascotItemCopyWith(_MascotItem value, $Res Function(_MascotItem) _then) = __$MascotItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String slot, Map<String, String> name, MascotUnlock unlock, String illustrationId, bool premium
});


@override $MascotUnlockCopyWith<$Res> get unlock;

}
/// @nodoc
class __$MascotItemCopyWithImpl<$Res>
    implements _$MascotItemCopyWith<$Res> {
  __$MascotItemCopyWithImpl(this._self, this._then);

  final _MascotItem _self;
  final $Res Function(_MascotItem) _then;

/// Create a copy of MascotItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slot = null,Object? name = null,Object? unlock = null,Object? illustrationId = null,Object? premium = null,}) {
  return _then(_MascotItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self._name : name // ignore: cast_nullable_to_non_nullable
as Map<String, String>,unlock: null == unlock ? _self.unlock : unlock // ignore: cast_nullable_to_non_nullable
as MascotUnlock,illustrationId: null == illustrationId ? _self.illustrationId : illustrationId // ignore: cast_nullable_to_non_nullable
as String,premium: null == premium ? _self.premium : premium // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of MascotItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MascotUnlockCopyWith<$Res> get unlock {
  
  return $MascotUnlockCopyWith<$Res>(_self.unlock, (value) {
    return _then(_self.copyWith(unlock: value));
  });
}
}

// dart format on
