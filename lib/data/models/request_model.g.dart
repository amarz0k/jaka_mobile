// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestModel _$RequestModelFromJson(Map<String, dynamic> json) => RequestModel(
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      sentAt: json['sentAt'] as String,
      status: json['status'] as String,
      lastMessage: json['lastMessage'] as String?,
      lastMessageDate: json['lastMessageDate'] as String?,
    );

Map<String, dynamic> _$RequestModelToJson(RequestModel instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'sentAt': instance.sentAt,
      'status': instance.status,
      'lastMessage': instance.lastMessage,
      'lastMessageDate': instance.lastMessageDate,
    };
