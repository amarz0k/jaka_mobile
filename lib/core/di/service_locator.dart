import 'package:chat_app/core/hive_service.dart';
import 'package:chat_app/data/datasources/remote/google_auth_data_source.dart';
import 'package:chat_app/data/repositories/auth_repository_impl.dart';
import 'package:chat_app/data/repositories/user_repository_impl.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:chat_app/domain/usecases/save_user.dart';
import 'package:chat_app/domain/usecases/sign_in_with_google.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

final getIt = GetIt.instance;

void setUpServiceLocator() {
  // Firebase services
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseDatabase.instance);
  getIt.registerLazySingleton(() => GoogleSignIn.instance);

  // Core services
  getIt.registerLazySingleton<HiveService>(() => HiveService());

  // Data sources
  getIt.registerLazySingleton<GoogleAuthDataSource>(
    () => GoogleAuthDataSource(),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<GoogleAuthDataSource>()),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt<HiveService>()),
  );

  // Use cases
  getIt.registerLazySingleton<SignInWithGoogle>(
    () => SignInWithGoogle(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SaveUser>(
    () => SaveUser(getIt<UserRepository>()),
  );
}
