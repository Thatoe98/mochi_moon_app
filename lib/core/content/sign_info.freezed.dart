// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NamedColor {

 String get name; String get hex;
/// Create a copy of NamedColor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NamedColorCopyWith<NamedColor> get copyWith => _$NamedColorCopyWithImpl<NamedColor>(this as NamedColor, _$identity);

  /// Serializes this NamedColor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NamedColor;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NamedColor&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.hex, _this.hex) || other.hex == _this.hex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NamedColor;
  return Object.hash(runtimeType,_this.name,_this.hex);
}

@override
String toString() {
  final _this = this as NamedColor;
  return 'NamedColor(name: ${_this.name}, hex: ${_this.hex})';
}


}

/// @nodoc
abstract mixin class $NamedColorCopyWith<$Res>  {
  factory $NamedColorCopyWith(NamedColor value, $Res Function(NamedColor) _then) = _$NamedColorCopyWithImpl;
@useResult
$Res call({
 String name, String hex
});




}
/// @nodoc
class _$NamedColorCopyWithImpl<$Res>
    implements $NamedColorCopyWith<$Res> {
  _$NamedColorCopyWithImpl(this._self, this._then);

  final NamedColor _self;
  final $Res Function(NamedColor) _then;

/// Create a copy of NamedColor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? hex = null,}) {
  return _then(NamedColor(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hex: null == hex ? _self.hex : hex // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NamedColor].
extension NamedColorPatterns on NamedColor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NamedColor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NamedColor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NamedColor value)  $default,){
final _that = this;
switch (_that) {
case _NamedColor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NamedColor value)?  $default,){
final _that = this;
switch (_that) {
case _NamedColor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String hex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NamedColor() when $default != null:
return $default(_that.name,_that.hex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String hex)  $default,) {final _that = this;
switch (_that) {
case _NamedColor():
return $default(_that.name,_that.hex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String hex)?  $default,) {final _that = this;
switch (_that) {
case _NamedColor() when $default != null:
return $default(_that.name,_that.hex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NamedColor implements NamedColor {
  const _NamedColor({required this.name, required this.hex});
  factory _NamedColor.fromJson(Map<String, dynamic> json) => _$NamedColorFromJson(json);

@override final  String name;
@override final  String hex;

/// Create a copy of NamedColor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NamedColorCopyWith<_NamedColor> get copyWith => __$NamedColorCopyWithImpl<_NamedColor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NamedColorToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NamedColor&&(identical(other.name, name) || other.name == name)&&(identical(other.hex, hex) || other.hex == hex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,hex);
}

@override
String toString() {
    return 'NamedColor(name: $name, hex: $hex)';
}


}

/// @nodoc
abstract mixin class _$NamedColorCopyWith<$Res> implements $NamedColorCopyWith<$Res> {
  factory _$NamedColorCopyWith(_NamedColor value, $Res Function(_NamedColor) _then) = __$NamedColorCopyWithImpl;
@override @useResult
$Res call({
 String name, String hex
});




}
/// @nodoc
class __$NamedColorCopyWithImpl<$Res>
    implements _$NamedColorCopyWith<$Res> {
  __$NamedColorCopyWithImpl(this._self, this._then);

  final _NamedColor _self;
  final $Res Function(_NamedColor) _then;

/// Create a copy of NamedColor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? hex = null,}) {
  return _then(_NamedColor(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hex: null == hex ? _self.hex : hex // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SignInfo {

 String get id; int get index; Element get element; List<NamedColor> get palette;
/// Create a copy of SignInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignInfoCopyWith<SignInfo> get copyWith => _$SignInfoCopyWithImpl<SignInfo>(this as SignInfo, _$identity);

  /// Serializes this SignInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SignInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignInfo&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.index, _this.index) || other.index == _this.index)&&(identical(other.element, _this.element) || other.element == _this.element)&&const DeepCollectionEquality().equals(other.palette, _this.palette));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SignInfo;
  return Object.hash(runtimeType,_this.id,_this.index,_this.element,const DeepCollectionEquality().hash(_this.palette));
}

@override
String toString() {
  final _this = this as SignInfo;
  return 'SignInfo(id: ${_this.id}, index: ${_this.index}, element: ${_this.element}, palette: ${_this.palette})';
}


}

/// @nodoc
abstract mixin class $SignInfoCopyWith<$Res>  {
  factory $SignInfoCopyWith(SignInfo value, $Res Function(SignInfo) _then) = _$SignInfoCopyWithImpl;
@useResult
$Res call({
 String id, int index, Element element, List<NamedColor> palette
});




}
/// @nodoc
class _$SignInfoCopyWithImpl<$Res>
    implements $SignInfoCopyWith<$Res> {
  _$SignInfoCopyWithImpl(this._self, this._then);

  final SignInfo _self;
  final $Res Function(SignInfo) _then;

/// Create a copy of SignInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? index = null,Object? element = null,Object? palette = null,}) {
  return _then(SignInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,element: null == element ? _self.element : element // ignore: cast_nullable_to_non_nullable
as Element,palette: null == palette ? _self.palette : palette // ignore: cast_nullable_to_non_nullable
as List<NamedColor>,
  ));
}

}


/// Adds pattern-matching-related methods to [SignInfo].
extension SignInfoPatterns on SignInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SignInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SignInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SignInfo value)  $default,){
final _that = this;
switch (_that) {
case _SignInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SignInfo value)?  $default,){
final _that = this;
switch (_that) {
case _SignInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int index,  Element element,  List<NamedColor> palette)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SignInfo() when $default != null:
return $default(_that.id,_that.index,_that.element,_that.palette);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int index,  Element element,  List<NamedColor> palette)  $default,) {final _that = this;
switch (_that) {
case _SignInfo():
return $default(_that.id,_that.index,_that.element,_that.palette);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int index,  Element element,  List<NamedColor> palette)?  $default,) {final _that = this;
switch (_that) {
case _SignInfo() when $default != null:
return $default(_that.id,_that.index,_that.element,_that.palette);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SignInfo implements SignInfo {
  const _SignInfo({required this.id, required this.index, required this.element, required  List<NamedColor> palette}): _palette = palette;
  factory _SignInfo.fromJson(Map<String, dynamic> json) => _$SignInfoFromJson(json);

@override final  String id;
@override final  int index;
@override final  Element element;
 final  List<NamedColor> _palette;
@override List<NamedColor> get palette {
  if (_palette is EqualUnmodifiableListView) return _palette;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_palette);
}


/// Create a copy of SignInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignInfoCopyWith<_SignInfo> get copyWith => __$SignInfoCopyWithImpl<_SignInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SignInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.element, element) || other.element == element)&&const DeepCollectionEquality().equals(other.palette, _palette));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,index,element,const DeepCollectionEquality().hash(_palette));
}

@override
String toString() {
    return 'SignInfo(id: $id, index: $index, element: $element, palette: $palette)';
}


}

/// @nodoc
abstract mixin class _$SignInfoCopyWith<$Res> implements $SignInfoCopyWith<$Res> {
  factory _$SignInfoCopyWith(_SignInfo value, $Res Function(_SignInfo) _then) = __$SignInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, int index, Element element, List<NamedColor> palette
});




}
/// @nodoc
class __$SignInfoCopyWithImpl<$Res>
    implements _$SignInfoCopyWith<$Res> {
  __$SignInfoCopyWithImpl(this._self, this._then);

  final _SignInfo _self;
  final $Res Function(_SignInfo) _then;

/// Create a copy of SignInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? index = null,Object? element = null,Object? palette = null,}) {
  return _then(_SignInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,element: null == element ? _self.element : element // ignore: cast_nullable_to_non_nullable
as Element,palette: null == palette ? _self._palette : palette // ignore: cast_nullable_to_non_nullable
as List<NamedColor>,
  ));
}


}

// dart format on
