import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:firebase_database/firebase_database.dart';

class GetUserDatabaseReferenceUsecase {
  final UserRepository _userRepository;

  GetUserDatabaseReferenceUsecase(this._userRepository);

  Future<DatabaseReference> call() async {
    return await _userRepository.getUserDatabaseReference();
  }
}
