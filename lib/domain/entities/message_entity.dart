
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_entity.freezed.dart';

@freezed
class MessageEntity with _$MessageEntity {
  const factory MessageEntity({
    required String senderId,
    required String receiverId,
    required String text,
    required String sentAt,
  }) = _MessageEntity;
}
