import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend_entity.freezed.dart';

@freezed
class FriendEntity with _$FriendEntity {
  const factory FriendEntity({
    required String id,
    required String name,
    required String? photoUrl,
    String? lastMessage,
    DateTime? lastMessageDate
  }) = _FriendEntity;
}
