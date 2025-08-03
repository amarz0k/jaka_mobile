import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:chat_app/utils/generate_random_id.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseDataSource {
  static bool initialized = false;

  Future<void> _initSignWithGoogle() async {
    if (!initialized) {
      await getIt<GoogleSignIn>().initialize(
        serverClientId:
            '40879973580-v13m75n2ijka42t0f6ogvbg3ooievkhc.apps.googleusercontent.com',
      );
    }
    initialized = true;
  }

  Future<void> signInWithGoogle() async {
    try {
      await _initSignWithGoogle();

      final GoogleSignInAccount account = await getIt<GoogleSignIn>()
          .authenticate();

      final idToken = account.authentication.idToken;
      final authClient = account.authorizationClient;

      GoogleSignInClientAuthorization? auth = await authClient
          .authorizationForScopes(['email']);

      final accessToken = auth?.accessToken;

      if (accessToken == null) {
        final auth2 = await authClient.authorizationForScopes(['email']);

        if (auth2?.accessToken == null) {
          throw FirebaseAuthException(
            code: 'No Acess Token',
            message: 'Fail to get access token',
          );
        }
        auth = auth2;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      UserCredential userCredential = await getIt<FirebaseAuth>()
          .signInWithCredential(credential);

      final name = userCredential.user!.displayName!;
      final uniqueId = await ensureUniqueId(name);

      final userData = UserModel(
        id: uniqueId,
        name: name,
        email: userCredential.user!.email!,
        photoUrl: userCredential.user!.photoURL!,
        isOnline: true,
        lastSeen: DateTime.now(),
      );

      getIt<UserRepository>().saveUserToRealtimeDatabase(userData);
      getIt<UserRepository>().saveUserToLocalStorage(userData.toEntity());
    } catch (e) {
      throw FirebaseAuthException(
        code: 'Signin Failed',
        message: 'Signin Failed',
      );
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await getIt<FirebaseAuth>()
          .signInWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'NULL_USER',
          message: 'Sign in failed',
        );
      }

      final token = await user.getIdToken();
      if (token == null) {
        throw FirebaseAuthException(
          code: 'TOKEN_ERROR',
          message: 'No ID token',
        );
      }

      final dbRef = await getIt<UserRepository>().getUserDatabaseReference();

      final DataSnapshot snapshot = await dbRef.get();

      final exsistingUser = UserModel.fromJson(
        Map<String, dynamic>.from(snapshot.value as Map),
      );

      getIt<UserRepository>().saveUserToLocalStorage(exsistingUser.toEntity());
    } catch (e) {
      throw FirebaseAuthException(code: 'SIGNIN_FAILED', message: e.toString());
    }
  }

  Future<UserModel> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final UserCredential userCredential = await getIt<FirebaseAuth>()
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'NULL_USER',
          message: 'Sign up failed',
        );
      }

      final uniqueId = await ensureUniqueId(name);

      // Save user in Realtime Database
      final userData = UserModel(
        id: uniqueId,
        name: name,
        email: email,
        password: password,
        photoUrl: null,
        isOnline: true,
        lastSeen: DateTime.now(),
      );

      final userRef = getIt<FirebaseDatabase>()
          .ref()
          .child('users')
          .child(user.uid);
      await userRef.set(userData.toJson());

      return userData;
    } catch (e) {
      throw FirebaseAuthException(code: 'SIGNUP_FAILED', message: e.toString());
    }
  }
}
