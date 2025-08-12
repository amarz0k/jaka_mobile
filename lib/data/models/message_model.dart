
import 'package:chat_app/domain/entities/message_entity.dart';
import 'package:chat_app/utils/entity_convertible.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'message_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 3)
class MessageModel  with EntityConvertible<MessageModel, MessageEntity> {

  @HiveField(0)
  @JsonKey(name: 'senderId')
  final String senderId;

  @HiveField(1)
  @JsonKey(name: 'receiverId')
  final String receiverId;

  @HiveField(2)
  @JsonKey(name: 'text')
  final String text;

  @HiveField(3)
  @JsonKey(name: 'sentAt')
  final String sentAt;

  const MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.sentAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  @override
  MessageEntity toEntity() => MessageEntity(
    senderId: senderId,
    receiverId: receiverId,
    text: text,
    sentAt: sentAt,
  );
}