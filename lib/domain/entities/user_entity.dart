import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String name,
    required String email,
    String? photoUrl,
    @Default(false) bool isOnline,
    required DateTime lastSeen,
  }) = _UserEntity;
}
