// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RequestEntity {
  String get senderId => throw _privateConstructorUsedError;
  String get receiverId => throw _privateConstructorUsedError;
  String get sentAt => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Create a copy of RequestEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RequestEntityCopyWith<RequestEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestEntityCopyWith<$Res> {
  factory $RequestEntityCopyWith(
          RequestEntity value, $Res Function(RequestEntity) then) =
      _$RequestEntityCopyWithImpl<$Res, RequestEntity>;
  @useResult
  $Res call({String senderId, String receiverId, String sentAt, String status});
}

/// @nodoc
class _$RequestEntityCopyWithImpl<$Res, $Val extends RequestEntity>
    implements $RequestEntityCopyWith<$Res> {
  _$RequestEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RequestEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? senderId = null,
    Object? receiverId = null,
    Object? sentAt = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      receiverId: null == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String,
      sentAt: null == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RequestEntityImplCopyWith<$Res>
    implements $RequestEntityCopyWith<$Res> {
  factory _$$RequestEntityImplCopyWith(
          _$RequestEntityImpl value, $Res Function(_$RequestEntityImpl) then) =
      __$$RequestEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String senderId, String receiverId, String sentAt, String status});
}

/// @nodoc
class __$$RequestEntityImplCopyWithImpl<$Res>
    extends _$RequestEntityCopyWithImpl<$Res, _$RequestEntityImpl>
    implements _$$RequestEntityImplCopyWith<$Res> {
  __$$RequestEntityImplCopyWithImpl(
      _$RequestEntityImpl _value, $Res Function(_$RequestEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? senderId = null,
    Object? receiverId = null,
    Object? sentAt = null,
    Object? status = null,
  }) {
    return _then(_$RequestEntityImpl(
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      receiverId: null == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String,
      sentAt: null == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$RequestEntityImpl implements _RequestEntity {
  const _$RequestEntityImpl(
      {required this.senderId,
      required this.receiverId,
      required this.sentAt,
      required this.status});

  @override
  final String senderId;
  @override
  final String receiverId;
  @override
  final String sentAt;
  @override
  final String status;

  @override
  String toString() {
    return 'RequestEntity(senderId: $senderId, receiverId: $receiverId, sentAt: $sentAt, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestEntityImpl &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.receiverId, receiverId) ||
                other.receiverId == receiverId) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, senderId, receiverId, sentAt, status);

  /// Create a copy of RequestEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestEntityImplCopyWith<_$RequestEntityImpl> get copyWith =>
      __$$RequestEntityImplCopyWithImpl<_$RequestEntityImpl>(this, _$identity);
}

abstract class _RequestEntity implements RequestEntity {
  const factory _RequestEntity(
      {required final String senderId,
      required final String receiverId,
      required final String sentAt,
      required final String status}) = _$RequestEntityImpl;

  @override
  String get senderId;
  @override
  String get receiverId;
  @override
  String get sentAt;
  @override
  String get status;

  /// Create a copy of RequestEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RequestEntityImplCopyWith<_$RequestEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
