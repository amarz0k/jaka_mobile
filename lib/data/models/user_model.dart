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
  @JsonKey(name: 'photoUrl')
  final String? photoUrl;

  @HiveField(4)
  @JsonKey(name: 'isOnline')
  final bool isOnline;

  @HiveField(5)
  @JsonKey(name: 'lastSeen')
  final DateTime lastSeen;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.isOnline = false,
    required this.lastSeen,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @override
  UserEntity toEntity() => UserEntity(
    id: id,
    name: name,
    email: email,
    photoUrl: photoUrl,
    isOnline: isOnline,
    lastSeen: lastSeen,
  );

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
