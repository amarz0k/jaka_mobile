import 'package:chat_app/core/auto_route/auth_gaurd.dart';
import 'package:chat_app/core/hive_service.dart';
import 'package:chat_app/data/datasources/remote/firebase_auth_data_source.dart';
import 'package:chat_app/data/repositories/auth_repository_impl.dart';
import 'package:chat_app/data/repositories/user_repository_impl.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:chat_app/domain/usecases/get_incoming_requests_stream_usecase.dart';
import 'package:chat_app/domain/usecases/get_user_database_reference_usecase.dart';
import 'package:chat_app/domain/usecases/get_user_from_local_database_usecase.dart';
import 'package:chat_app/domain/usecases/get_user_from_realtime_database_usecase.dart';
import 'package:chat_app/domain/usecases/save_user_to_local_usecase.dart';
import 'package:chat_app/domain/usecases/save_user_to_realtime_database_usecase.dart';
import 'package:chat_app/domain/usecases/send_friend_request_usecase.dart';
import 'package:chat_app/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:chat_app/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:chat_app/domain/usecases/sign_out_usecase.dart';
import 'package:chat_app/domain/usecases/sign_up_with_email_usecase.dart';
import 'package:chat_app/domain/usecases/update_user_notifications_usecase.dart';
import 'package:chat_app/domain/usecases/update_user_password_uasecase.dart';
import 'package:chat_app/presentation/bloc/home/settings/settings_cubit.dart';
import 'package:chat_app/presentation/bloc/home/user_data/user_data_cubit.dart';
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
  getIt.registerLazySingleton<FirebaseDataSource>(() => FirebaseDataSource());

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () =>
        AuthRepositoryImpl(getIt<FirebaseDataSource>(), getIt<FirebaseAuth>()),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt<HiveService>()),
  );

  // Use cases
  getIt.registerLazySingleton<SignInWithGoogleUsecase>(
    () => SignInWithGoogleUsecase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SaveUserToLocalUsecase>(
    () => SaveUserToLocalUsecase(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<SaveUserToRealtimeDatabaseUsecase>(
    () => SaveUserToRealtimeDatabaseUsecase(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<GetUserFromLocalDatabaseUsecase>(
    () => GetUserFromLocalDatabaseUsecase(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<GetUserDatabaseReferenceUsecase>(
    () => GetUserDatabaseReferenceUsecase(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<SignOutUsecase>(
    () => SignOutUsecase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<AuthGuard>(() => AuthGuard());

  getIt.registerLazySingleton<SignInWithEmailUsecase>(
    () => SignInWithEmailUsecase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SignUpWithEmailUsecase>(
    () => SignUpWithEmailUsecase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<UpdateUserNotificationsUsecase>(
    () => UpdateUserNotificationsUsecase(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<UpdateUserPasswordUsecase>(
    () => UpdateUserPasswordUsecase(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<SendFriendRequestUsecase>(
    () => SendFriendRequestUsecase(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<GetUserFromRealtimeDatabaseUsecase>(
    () => GetUserFromRealtimeDatabaseUsecase(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<GetIncomingRequestsStreamUsecase>(
    () => GetIncomingRequestsStreamUsecase(getIt<UserRepository>()),
  );

  // others
  getIt.registerFactory<UserDataCubit>(
    () => UserDataCubit(userRepository: getIt<UserRepository>()),
  );

  getIt.registerFactory<SettingsCubit>(
    () => SettingsCubit(userRepository: getIt<UserRepository>()),
  );
}
