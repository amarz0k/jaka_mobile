import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/utils/generate_random_id.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthDataSource {
  static bool initialized = false;

  Future<void> _initSign() async {
    if (!initialized) {
      await getIt<GoogleSignIn>().initialize(
        serverClientId:
            '40879973580-v13m75n2ijka42t0f6ogvbg3ooievkhc.apps.googleusercontent.com',
      );
    }
    initialized = true;
  }

  Future<UserModel> signInWithGoogle() async {
    try {
      _initSign();

      final GoogleSignInAccount account = await getIt<GoogleSignIn>()
          .authenticate();

      if (account == null) {
        // print('\x1B[35m${"SIGNIN ABORTED BY USER"}\x1B[0m');
        throw FirebaseAuthException(
          code: 'SIGNIN ABORTED BY USER',
          message: 'Signin Incomplete because user exsists',
        );
      }

      final idToken = account.authentication.idToken;
      final authClient = account.authorizationClient;

      GoogleSignInClientAuthorization? auth = await authClient
          .authorizationForScopes(['email']);

      final accessToken = auth?.accessToken;

      if (accessToken == null) {
        final auth2 = await authClient.authorizationForScopes(['email']);

        if (auth2?.accessToken == null) {
          // print('\x1B[35m${"No Acess Token"}\x1B[0m');

          throw FirebaseAuthException(
            code: 'No Acess Token',
            message: 'Fail to get access token',
          );
        }
        auth = auth2;
      }

      // print('\x1B[35m auth: ${auth}\x1B[0m');
      // print('\x1B[35m accessToken: ${accessToken}\x1B[0m');
      // print('\x1B[35m auth.accessToken: ${auth!.accessToken}\x1B[0m');
      // print('\x1B[35m idToken: ${idToken}\x1B[0m');

      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      UserCredential userCredential = await getIt<FirebaseAuth>()
          .signInWithCredential(credential);
      // print('\x1B[35m${userCredential.user}\x1B[0m');

      final uid = userCredential.user!.uid;
      final userRef = getIt<FirebaseDatabase>().ref().child('users').child(uid);

      final DataSnapshot snapshot = await userRef.get();

      if (!snapshot.exists) {
        final userData = UserModel(
          id: generateId(userCredential.user!.displayName!),
          name: userCredential.user!.displayName!,
          email: userCredential.user!.email!,
          photoUrl: userCredential.user!.photoURL!,
          isOnline: true,
          lastSeen: DateTime.now(),
        );

        await userRef.set(userData.toJson());
        return userData;
      }

      final existingUser = UserModel.fromJson(
        Map<String, dynamic>.from(snapshot.value as Map),
      );

      return existingUser;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'Signin Failed',
        message: 'Signin Failed',
      );
    }
  }
}
