import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_entity.freezed.dart';

@freezed
class RequestEntity with _$RequestEntity {
  const factory RequestEntity({
    required String senderId,
    required String receiverId,
    required String sentAt,
    required String status,
  }) = _RequestEntity;
}
