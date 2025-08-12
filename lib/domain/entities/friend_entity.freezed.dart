// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FriendEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String? get lastMessage => throw _privateConstructorUsedError;
  DateTime? get lastMessageDate => throw _privateConstructorUsedError;

  /// Create a copy of FriendEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendEntityCopyWith<FriendEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendEntityCopyWith<$Res> {
  factory $FriendEntityCopyWith(
          FriendEntity value, $Res Function(FriendEntity) then) =
      _$FriendEntityCopyWithImpl<$Res, FriendEntity>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? photoUrl,
      String? lastMessage,
      DateTime? lastMessageDate});
}

/// @nodoc
class _$FriendEntityCopyWithImpl<$Res, $Val extends FriendEntity>
    implements $FriendEntityCopyWith<$Res> {
  _$FriendEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? photoUrl = freezed,
    Object? lastMessage = freezed,
    Object? lastMessageDate = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageDate: freezed == lastMessageDate
          ? _value.lastMessageDate
          : lastMessageDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FriendEntityImplCopyWith<$Res>
    implements $FriendEntityCopyWith<$Res> {
  factory _$$FriendEntityImplCopyWith(
          _$FriendEntityImpl value, $Res Function(_$FriendEntityImpl) then) =
      __$$FriendEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? photoUrl,
      String? lastMessage,
      DateTime? lastMessageDate});
}

/// @nodoc
class __$$FriendEntityImplCopyWithImpl<$Res>
    extends _$FriendEntityCopyWithImpl<$Res, _$FriendEntityImpl>
    implements _$$FriendEntityImplCopyWith<$Res> {
  __$$FriendEntityImplCopyWithImpl(
      _$FriendEntityImpl _value, $Res Function(_$FriendEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of FriendEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? photoUrl = freezed,
    Object? lastMessage = freezed,
    Object? lastMessageDate = freezed,
  }) {
    return _then(_$FriendEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageDate: freezed == lastMessageDate
          ? _value.lastMessageDate
          : lastMessageDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$FriendEntityImpl with DiagnosticableTreeMixin implements _FriendEntity {
  const _$FriendEntityImpl(
      {required this.id,
      required this.name,
      required this.photoUrl,
      this.lastMessage,
      this.lastMessageDate});

  @override
  final String id;
  @override
  final String name;
  @override
  final String? photoUrl;
  @override
  final String? lastMessage;
  @override
  final DateTime? lastMessageDate;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FriendEntity(id: $id, name: $name, photoUrl: $photoUrl, lastMessage: $lastMessage, lastMessageDate: $lastMessageDate)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'FriendEntity'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('photoUrl', photoUrl))
      ..add(DiagnosticsProperty('lastMessage', lastMessage))
      ..add(DiagnosticsProperty('lastMessageDate', lastMessageDate));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastMessageDate, lastMessageDate) ||
                other.lastMessageDate == lastMessageDate));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, photoUrl, lastMessage, lastMessageDate);

  /// Create a copy of FriendEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendEntityImplCopyWith<_$FriendEntityImpl> get copyWith =>
      __$$FriendEntityImplCopyWithImpl<_$FriendEntityImpl>(this, _$identity);
}

abstract class _FriendEntity implements FriendEntity {
  const factory _FriendEntity(
      {required final String id,
      required final String name,
      required final String? photoUrl,
      final String? lastMessage,
      final DateTime? lastMessageDate}) = _$FriendEntityImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get photoUrl;
  @override
  String? get lastMessage;
  @override
  DateTime? get lastMessageDate;

  /// Create a copy of FriendEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendEntityImplCopyWith<_$FriendEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
