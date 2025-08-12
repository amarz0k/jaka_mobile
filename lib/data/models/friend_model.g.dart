// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendModel _$FriendModelFromJson(Map<String, dynamic> json) => FriendModel(
      id: json['id'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
      lastMessage: json['lastMessage'] as String?,
      lastMessageDate: json['lastMessageDate'] == null
          ? null
          : DateTime.parse(json['lastMessageDate'] as String),
    );

Map<String, dynamic> _$FriendModelToJson(FriendModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'photoUrl': instance.photoUrl,
      'lastMessage': instance.lastMessage,
      'lastMessageDate': instance.lastMessageDate?.toIso8601String(),
    };
