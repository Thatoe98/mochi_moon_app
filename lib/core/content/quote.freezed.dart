// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quote.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Quote {

 String get id; Map<String, String> get text; String get category; List<String> get moods; List<String> get signs; String? get author; String? get illustrationId; bool get premium;
/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuoteCopyWith<Quote> get copyWith => _$QuoteCopyWithImpl<Quote>(this as Quote, _$identity);

  /// Serializes this Quote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Quote;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Quote&&(identical(other.id, _this.id) || other.id == _this.id)&&const DeepCollectionEquality().equals(other.text, _this.text)&&(identical(other.category, _this.category) || other.category == _this.category)&&const DeepCollectionEquality().equals(other.moods, _this.moods)&&const DeepCollectionEquality().equals(other.signs, _this.signs)&&(identical(other.author, _this.author) || other.author == _this.author)&&(identical(other.illustrationId, _this.illustrationId) || other.illustrationId == _this.illustrationId)&&(identical(other.premium, _this.premium) || other.premium == _this.premium));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Quote;
  return Object.hash(runtimeType,_this.id,const DeepCollectionEquality().hash(_this.text),_this.category,const DeepCollectionEquality().hash(_this.moods),const DeepCollectionEquality().hash(_this.signs),_this.author,_this.illustrationId,_this.premium);
}

@override
String toString() {
  final _this = this as Quote;
  return 'Quote(id: ${_this.id}, text: ${_this.text}, category: ${_this.category}, moods: ${_this.moods}, signs: ${_this.signs}, author: ${_this.author}, illustrationId: ${_this.illustrationId}, premium: ${_this.premium})';
}


}

/// @nodoc
abstract mixin class $QuoteCopyWith<$Res>  {
  factory $QuoteCopyWith(Quote value, $Res Function(Quote) _then) = _$QuoteCopyWithImpl;
@useResult
$Res call({
 String id, Map<String, String> text, String category, List<String> moods, List<String> signs, String? author, String? illustrationId, bool premium
});




}
/// @nodoc
class _$QuoteCopyWithImpl<$Res>
    implements $QuoteCopyWith<$Res> {
  _$QuoteCopyWithImpl(this._self, this._then);

  final Quote _self;
  final $Res Function(Quote) _then;

/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? category = null,Object? moods = null,Object? signs = null,Object? author = freezed,Object? illustrationId = freezed,Object? premium = null,}) {
  return _then(Quote(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as Map<String, String>,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,moods: null == moods ? _self.moods : moods // ignore: cast_nullable_to_non_nullable
as List<String>,signs: null == signs ? _self.signs : signs // ignore: cast_nullable_to_non_nullable
as List<String>,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,illustrationId: freezed == illustrationId ? _self.illustrationId : illustrationId // ignore: cast_nullable_to_non_nullable
as String?,premium: null == premium ? _self.premium : premium // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Quote].
extension QuotePatterns on Quote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Quote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Quote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Quote value)  $default,){
final _that = this;
switch (_that) {
case _Quote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Quote value)?  $default,){
final _that = this;
switch (_that) {
case _Quote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Map<String, String> text,  String category,  List<String> moods,  List<String> signs,  String? author,  String? illustrationId,  bool premium)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Quote() when $default != null:
return $default(_that.id,_that.text,_that.category,_that.moods,_that.signs,_that.author,_that.illustrationId,_that.premium);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Map<String, String> text,  String category,  List<String> moods,  List<String> signs,  String? author,  String? illustrationId,  bool premium)  $default,) {final _that = this;
switch (_that) {
case _Quote():
return $default(_that.id,_that.text,_that.category,_that.moods,_that.signs,_that.author,_that.illustrationId,_that.premium);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Map<String, String> text,  String category,  List<String> moods,  List<String> signs,  String? author,  String? illustrationId,  bool premium)?  $default,) {final _that = this;
switch (_that) {
case _Quote() when $default != null:
return $default(_that.id,_that.text,_that.category,_that.moods,_that.signs,_that.author,_that.illustrationId,_that.premium);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Quote extends Quote {
  const _Quote({required this.id, required  Map<String, String> text, required this.category,  List<String> moods = const <String>[],  List<String> signs = const <String>['all'], this.author, this.illustrationId, this.premium = false}): _text = text,_moods = moods,_signs = signs,super._();
  factory _Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);

@override final  String id;
 final  Map<String, String> _text;
@override Map<String, String> get text {
  if (_text is EqualUnmodifiableMapView) return _text;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_text);
}

@override final  String category;
 final  List<String> _moods;
@override@JsonKey() List<String> get moods {
  if (_moods is EqualUnmodifiableListView) return _moods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_moods);
}

 final  List<String> _signs;
@override@JsonKey() List<String> get signs {
  if (_signs is EqualUnmodifiableListView) return _signs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_signs);
}

@override final  String? author;
@override final  String? illustrationId;
@override@JsonKey() final  bool premium;

/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuoteCopyWith<_Quote> get copyWith => __$QuoteCopyWithImpl<_Quote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuoteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Quote&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.text, _text)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.moods, _moods)&&const DeepCollectionEquality().equals(other.signs, _signs)&&(identical(other.author, author) || other.author == author)&&(identical(other.illustrationId, illustrationId) || other.illustrationId == illustrationId)&&(identical(other.premium, premium) || other.premium == premium));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_text),category,const DeepCollectionEquality().hash(_moods),const DeepCollectionEquality().hash(_signs),author,illustrationId,premium);
}

@override
String toString() {
    return 'Quote(id: $id, text: $text, category: $category, moods: $moods, signs: $signs, author: $author, illustrationId: $illustrationId, premium: $premium)';
}


}

/// @nodoc
abstract mixin class _$QuoteCopyWith<$Res> implements $QuoteCopyWith<$Res> {
  factory _$QuoteCopyWith(_Quote value, $Res Function(_Quote) _then) = __$QuoteCopyWithImpl;
@override @useResult
$Res call({
 String id, Map<String, String> text, String category, List<String> moods, List<String> signs, String? author, String? illustrationId, bool premium
});




}
/// @nodoc
class __$QuoteCopyWithImpl<$Res>
    implements _$QuoteCopyWith<$Res> {
  __$QuoteCopyWithImpl(this._self, this._then);

  final _Quote _self;
  final $Res Function(_Quote) _then;

/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? category = null,Object? moods = null,Object? signs = null,Object? author = freezed,Object? illustrationId = freezed,Object? premium = null,}) {
  return _then(_Quote(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self._text : text // ignore: cast_nullable_to_non_nullable
as Map<String, String>,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,moods: null == moods ? _self._moods : moods // ignore: cast_nullable_to_non_nullable
as List<String>,signs: null == signs ? _self._signs : signs // ignore: cast_nullable_to_non_nullable
as List<String>,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,illustrationId: freezed == illustrationId ? _self.illustrationId : illustrationId // ignore: cast_nullable_to_non_nullable
as String?,premium: null == premium ? _self.premium : premium // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
