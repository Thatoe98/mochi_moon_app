// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Quest {

 String get id; Map<String, String> get text;/// Focus area ids (`FocusArea.id`) this quest suits.
 List<String> get focusAreas; bool get premium;
/// Create a copy of Quest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestCopyWith<Quest> get copyWith => _$QuestCopyWithImpl<Quest>(this as Quest, _$identity);

  /// Serializes this Quest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Quest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Quest&&(identical(other.id, _this.id) || other.id == _this.id)&&const DeepCollectionEquality().equals(other.text, _this.text)&&const DeepCollectionEquality().equals(other.focusAreas, _this.focusAreas)&&(identical(other.premium, _this.premium) || other.premium == _this.premium));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Quest;
  return Object.hash(runtimeType,_this.id,const DeepCollectionEquality().hash(_this.text),const DeepCollectionEquality().hash(_this.focusAreas),_this.premium);
}

@override
String toString() {
  final _this = this as Quest;
  return 'Quest(id: ${_this.id}, text: ${_this.text}, focusAreas: ${_this.focusAreas}, premium: ${_this.premium})';
}


}

/// @nodoc
abstract mixin class $QuestCopyWith<$Res>  {
  factory $QuestCopyWith(Quest value, $Res Function(Quest) _then) = _$QuestCopyWithImpl;
@useResult
$Res call({
 String id, Map<String, String> text, List<String> focusAreas, bool premium
});




}
/// @nodoc
class _$QuestCopyWithImpl<$Res>
    implements $QuestCopyWith<$Res> {
  _$QuestCopyWithImpl(this._self, this._then);

  final Quest _self;
  final $Res Function(Quest) _then;

/// Create a copy of Quest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? focusAreas = null,Object? premium = null,}) {
  return _then(Quest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as Map<String, String>,focusAreas: null == focusAreas ? _self.focusAreas : focusAreas // ignore: cast_nullable_to_non_nullable
as List<String>,premium: null == premium ? _self.premium : premium // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Quest].
extension QuestPatterns on Quest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Quest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Quest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Quest value)  $default,){
final _that = this;
switch (_that) {
case _Quest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Quest value)?  $default,){
final _that = this;
switch (_that) {
case _Quest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Map<String, String> text,  List<String> focusAreas,  bool premium)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Quest() when $default != null:
return $default(_that.id,_that.text,_that.focusAreas,_that.premium);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Map<String, String> text,  List<String> focusAreas,  bool premium)  $default,) {final _that = this;
switch (_that) {
case _Quest():
return $default(_that.id,_that.text,_that.focusAreas,_that.premium);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Map<String, String> text,  List<String> focusAreas,  bool premium)?  $default,) {final _that = this;
switch (_that) {
case _Quest() when $default != null:
return $default(_that.id,_that.text,_that.focusAreas,_that.premium);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Quest extends Quest {
  const _Quest({required this.id, required  Map<String, String> text,  List<String> focusAreas = const <String>[], this.premium = false}): _text = text,_focusAreas = focusAreas,super._();
  factory _Quest.fromJson(Map<String, dynamic> json) => _$QuestFromJson(json);

@override final  String id;
 final  Map<String, String> _text;
@override Map<String, String> get text {
  if (_text is EqualUnmodifiableMapView) return _text;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_text);
}

/// Focus area ids (`FocusArea.id`) this quest suits.
 final  List<String> _focusAreas;
/// Focus area ids (`FocusArea.id`) this quest suits.
@override@JsonKey() List<String> get focusAreas {
  if (_focusAreas is EqualUnmodifiableListView) return _focusAreas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_focusAreas);
}

@override@JsonKey() final  bool premium;

/// Create a copy of Quest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestCopyWith<_Quest> get copyWith => __$QuestCopyWithImpl<_Quest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Quest&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.text, _text)&&const DeepCollectionEquality().equals(other.focusAreas, _focusAreas)&&(identical(other.premium, premium) || other.premium == premium));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_text),const DeepCollectionEquality().hash(_focusAreas),premium);
}

@override
String toString() {
    return 'Quest(id: $id, text: $text, focusAreas: $focusAreas, premium: $premium)';
}


}

/// @nodoc
abstract mixin class _$QuestCopyWith<$Res> implements $QuestCopyWith<$Res> {
  factory _$QuestCopyWith(_Quest value, $Res Function(_Quest) _then) = __$QuestCopyWithImpl;
@override @useResult
$Res call({
 String id, Map<String, String> text, List<String> focusAreas, bool premium
});




}
/// @nodoc
class __$QuestCopyWithImpl<$Res>
    implements _$QuestCopyWith<$Res> {
  __$QuestCopyWithImpl(this._self, this._then);

  final _Quest _self;
  final $Res Function(_Quest) _then;

/// Create a copy of Quest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? focusAreas = null,Object? premium = null,}) {
  return _then(_Quest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self._text : text // ignore: cast_nullable_to_non_nullable
as Map<String, String>,focusAreas: null == focusAreas ? _self._focusAreas : focusAreas // ignore: cast_nullable_to_non_nullable
as List<String>,premium: null == premium ? _self.premium : premium // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
