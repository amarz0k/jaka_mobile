import 'package:chat_app/domain/entities/request_entity.dart';
import 'package:chat_app/utils/entity_convertible.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'request_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class RequestModel with EntityConvertible<RequestModel, RequestEntity> {
  @HiveField(0)
  @JsonKey(name: 'senderId')
  final String senderId;

  @HiveField(1)
  @JsonKey(name: 'receiverId')
  final String receiverId;

  @HiveField(2)
  @JsonKey(name: 'sentAt')
  final String sentAt;

  @HiveField(3)
  @JsonKey(name: 'status')
  final String status;


  const RequestModel({
    required this.senderId,
    required this.receiverId,
    required this.sentAt, 
    required this.status,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) =>
      _$RequestModelFromJson(json);

  @override
  RequestEntity toEntity() => RequestEntity(
    senderId: senderId,
    receiverId: receiverId,
    sentAt: sentAt,
    status: status,
  );

  Map<String, dynamic> toJson() => _$RequestModelToJson(this);
}
