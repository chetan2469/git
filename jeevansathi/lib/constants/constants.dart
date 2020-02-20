
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

// For firebase authentication.
final cFirebaseAuth = FirebaseAuth.instance;
// Google sign-in configuration.
final cGoogleSignIn = GoogleSignIn();
// A reference for uploading files to firebase storage.
//final cFirebaseStorageRef = FirebaseStorage.instance.ref();

// Animation duration for sending message.
const cAnimationDuration = 700;
// Route name of the login screen.
const cLoginScreenRouteName = 'LoginScreen';

class Constants {
  static bool mode;
  static int fontSize;

  
}
