import 'package:chat_app/domain/entities/friend_entity.dart';
import 'package:chat_app/utils/entity_convertible.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'friend_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 2)
class FriendModel with EntityConvertible<FriendModel, FriendEntity> {
  @HiveField(0)
  @JsonKey(name: 'id')
  final String id;

  @HiveField(1)
  @JsonKey(name: 'name')
  final String name;

  @HiveField(2)
  @JsonKey(name: 'photoUrl')
  final String? photoUrl;

  const FriendModel({
    required this.id,
    required this.name,
    required this.photoUrl,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) =>
      _$FriendModelFromJson(json);

  @override
  FriendEntity toEntity() =>
      FriendEntity(id: id, name: name, photoUrl: photoUrl);
}
