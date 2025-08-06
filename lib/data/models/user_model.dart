import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/utils/entity_convertible.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class UserModel with EntityConvertible<UserModel, UserEntity> {
  @HiveField(0)
  @JsonKey(name: 'id')
  final String id;

  @HiveField(1)
  @JsonKey(name: 'name')
  final String name;

  @HiveField(2)
  @JsonKey(name: 'email')
  final String email;

  @HiveField(3)
  @JsonKey(name: 'password')
  final String? password;

  @HiveField(4)
  @JsonKey(name: 'photoUrl')
  final String? photoUrl;

  @HiveField(5)
  @JsonKey(name: 'isOnline')
  final bool isOnline;

  @HiveField(6)
  @JsonKey(name: 'notifications')
  final bool notifications;

  @HiveField(7)
  @JsonKey(name: 'lastSeen')
  final DateTime lastSeen;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.photoUrl,
    this.isOnline = false,
    this.notifications = true,
    required this.lastSeen,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @override
  UserEntity toEntity() => UserEntity(
    id: id,
    name: name,
    email: email,
    password: password,
    photoUrl: photoUrl,
    isOnline: isOnline,
    notifications: notifications,
    lastSeen: lastSeen,
  );

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
